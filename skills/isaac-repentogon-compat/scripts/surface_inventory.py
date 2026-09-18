"""Read-only REPENTOGON review inventory. A heuristic, never a compatibility gate.

Usage: python -B surface_inventory.py MOD_ROOT [--lua-dir custom_modules]
Prints JSON. Does not execute Lua, modify XML, follow directory symlinks, install
anything, or certify control flow. Sources are linked per finding.
"""
import argparse
import json
from pathlib import Path, PureWindowsPath
import re
import sys
import xml.etree.ElementTree as ET

DOC = "https://repentogon.com/"
CLASSES = {"REPENTOGON", "Ambush", "ImGui", "XMLData", "PlayerManager", "EntityConfig", "MenuManager", "PersistentGameData", "LevelGenerator", "BossPoolManager", "WeightedOutcomePicker"}
CHANGED = {"MC_ENTITY_TAKE_DMG", "MC_PRE_MOD_UNLOAD", "MC_GET_PILL_EFFECT", "MC_POST_ENTITY_KILL", "MC_PRE_NPC_COLLISION", "MC_PRE_PICKUP_COLLISION", "MC_PRE_PLAYER_COLLISION"}
NEW = {"MC_POST_MODS_LOADED", "MC_PRE_ADD_COLLECTIBLE", "MC_POST_ADD_COLLECTIBLE", "MC_POST_TRIGGER_COLLECTIBLE_ADDED", "MC_POST_TRIGGER_COLLECTIBLE_REMOVED", "MC_PRE_PICKUP_GET_LOOT_LIST", "MC_POST_PICKUP_GET_LOOT_LIST", "MC_EVALUATE_CUSTOM_CACHE", "MC_EVALUATE_FAMILIAR_MULTIPLIER", "MC_PRE_TRIGGER_PLAYER_DEATH", "MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES", "MC_PRE_PLAYER_TAKE_DMG", "MC_POST_ENTITY_TAKE_DMG"}
METHODS = {"AddCustomCacheTag", "GetCustomCacheValue", "GetNullItemIdByName", "GetAchievementIdByName", "AddInnateCollectible", "GetInnateCollectibleCount", "GetLootList", "TryPlaceRoom", "TryPlaceRoomAtDoor", "CanPlaceRoom", "GetGenerationRNG", "PhantomInt", "PhantomFloat"}
STATS = {"tears", "flattears", "tearsmult", "damage", "flatdamage", "damagemult", "shotspeed", "speed", "range", "luck"}
STATS |= {"effect" + stat for stat in list(STATS)}
EXCLUDED = {".git", ".codex", ".agents", "node_modules", "__pycache__", "reports", "release", "worktrees", "tests", "_backups"}


def mask_lua(text):
    """Mask comments/strings while preserving offsets and line numbers."""
    out = list(text)
    index = 0
    while index < len(text):
        start = index
        is_comment = text.startswith("--", index)
        bracket_start = index + 2 if is_comment else index
        bracket = re.match(r"\[(=*)\[", text[bracket_start:])
        if bracket:
            close = "]" + bracket[1] + "]"
            end = text.find(close, bracket_start + len(bracket[0]))
            index = len(text) if end < 0 else end + len(close)
        elif is_comment:
            end = text.find("\n", index)
            index = len(text) if end < 0 else end
        elif text[index] in "\"'":
            quote = text[index]
            index += 1
            while index < len(text):
                if text[index] == "\\":
                    index += 2
                elif text[index] == quote:
                    index += 1
                    break
                else:
                    index += 1
        else:
            index += 1
            continue
        for position in range(start, min(index, len(text))):
            if text[position] not in "\r\n":
                out[position] = " "
    return "".join(out)


def project_files(root, lua_dirs):
    resolved_root = root.resolve()

    def allowed(path):
        try:
            relative = path.relative_to(root)
        except ValueError:
            return False
        if any(part in EXCLUDED for part in relative.parts):
            return False
        current = path
        while current != root:
            if current.is_symlink():
                return False
            current = current.parent
        return path.resolve().is_relative_to(resolved_root)

    candidates = []
    main = root / "main.lua"
    if allowed(main) and main.is_file():
        candidates.append(main)
    roots = [root / name for name in lua_dirs] + [root / "content"]
    roots += [p for p in root.iterdir() if p.name == "resources" or p.name.startswith("resources-")]
    for base in roots:
        # Validate roots before traversal, and apply the same checks to main.lua.
        if not allowed(base) or not base.is_dir():
            continue
        for path in base.rglob("*"):
            if path.suffix.lower() not in {".lua", ".xml"} or not allowed(path) or not path.is_file():
                continue
            candidates.append(path)
    return sorted(set(candidates), key=lambda p: p.as_posix())


def inspect(root, lua_dirs=("scripts", "src", "modules")):
    root = Path(root).resolve()
    if not root.is_dir():
        raise ValueError("MOD_ROOT must be an existing directory")
    for directory in lua_dirs:
        local_path, windows_path = Path(directory), PureWindowsPath(directory)
        # Windows rooted and drive-relative paths are not necessarily absolute.
        # Recognize them on every host before joining or discovering directories.
        if local_path.anchor or windows_path.anchor or ".." in local_path.parts or ".." in windows_path.parts:
            raise ValueError("Lua directories must be relative descendants of MOD_ROOT")
    result = {"schema_version": 1, "reference_release": "1.1.2g", "checked_on": "2026-09-05", "runtime_verified": False, "guards_proven": False, "scanned_files": [], "symbols": [], "findings": [], "limitations": ["Heuristic inventory; neither a full Lua parser nor data-flow or version proof.", "Indirect/table-indexed/dynamic symbols and unlisted extensions may be missed.", "Only main.lua, requested Lua directories, content and immediate resources* roots are scanned.", "No finding means only no listed candidate was found; no runtime compatibility claim."]}

    def finding(path, line, code, note, source):
        entry = {"file": path, "line": line, "code": code, "review": note, "source": source}
        if entry not in result["findings"]:
            result["findings"].append(entry)

    for path in project_files(root, lua_dirs):
        relative = path.relative_to(root).as_posix()
        result["scanned_files"].append(relative)
        try:
            text = path.read_text(encoding="utf-8-sig")
        except (OSError, UnicodeError) as error:
            finding(relative, None, "READ_ERROR", str(error), "")
            continue
        if path.suffix.lower() == ".lua":
            masked = mask_lua(text)
            for match in re.finditer(r"\b([A-Za-z_]\w*)\s*([.:])\s*([A-Za-z_]\w*)", masked):
                owner, _, member = match.groups()
                line = masked.count("\n", 0, match.start()) + 1
                symbol = owner + match[2] + member
                recognized = owner in CLASSES or member in METHODS or (owner == "ModCallbacks" and member in CHANGED | NEW)
                if not recognized:
                    continue
                result["symbols"].append({"file": relative, "line": line, "symbol": symbol})
                if owner == "Ambush":
                    finding(relative, line, "AMBUSH_CONTEXT", "Check room/mode/stage, nullable result, shared maxima and preview side effects; a presence guard does not prove these.", DOC + "Ambush.html")
                elif owner == "ModCallbacks" and member in CHANGED:
                    finding(relative, line, "CHANGED_VANILLA_CALLBACK", "Original callback name also has extension semantics; verify signature and return propagation for the target build.", DOC + "enums/ModCallbacks.html#" + member.lower())
                elif owner == "ModCallbacks":
                    finding(relative, line, "EXTENDED_CALLBACK", "Verify capability, exact arguments, filter and ready phase before registration.", DOC + "enums/ModCallbacks.html#" + member.lower())
                elif owner == "REPENTOGON" and member == "MeetsVersion":
                    finding(relative, line, "VERSION_COMPARATOR", "Known old always-true defect; 1.1.2g ignores suffixes and admits dev build. Full release/fix proof is required.", "https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua#L75")
                else:
                    finding(relative, line, "SURFACE_REVIEW", "Verify the target build, lifecycle, owner and signature; object/method name matching may be a false positive.", DOC + "docs.html")
            class_pattern = "|".join(sorted(CLASSES | {"ModCallbacks"}))
            for match in re.finditer(r"\blocal\s+\w+\s*=\s*(?:" + class_pattern + r")\b", masked):
                finding(relative, masked.count("\n", 0, match.start()) + 1, "ALIAS_REVIEW", "Alias detected; trace indirect uses manually. This inventory does not resolve aliases or guards.", DOC + "docs.html")
        else:
            try:
                xml = ET.fromstring(text)
            except ET.ParseError as error:
                finding(relative, error.position[0], "XML_PARSE_ERROR", str(error), DOC + "xml/overview.html")
                continue
            filename = path.name.lower()
            if relative.split("/")[0].startswith("resources"):
                finding(relative, 1, "RESOURCE_XML_OVERRIDE", "Verify replacement versus append semantics for this exact XML; Lua return cannot undo static content loading.", DOC + "xml/overview.html")
            if filename == "ambush.xml":
                finding(relative, 1, "AMBUSH_XML_BOSSRUSH", "Only Boss Rush entries are read; ordinary challenge waves are not added through this XML.", DOC + "xml/ambush.html")
            if filename == "achievements.xml":
                finding(relative, 1, "ACHIEVEMENT_IDENTITY", "Use engine-assigned achievement IDs resolved by name and native persistence; authored numeric id is not runtime authority.", DOC + "xml/achievements.html")
            # Language/region variants share item semantics; backup suffixes do not.
            if not re.fullmatch(r"items(?:\.[a-z]{2,3}(?:[-_][a-z0-9]+)*)?\.xml", filename):
                continue
            for element in xml.iter():
                attributes = {k.lower(): v for k, v in element.attrib.items()}
                if STATS & attributes.keys():
                    finding(relative, None, "XML_NATIVE_STATS", "Native XML stat contribution must not be added again by Lua; distinguish base, flat, multiplier and effect ownership.", DOC + "xml/items.html#item-stats")
                if element.tag.lower() == "null":
                    finding(relative, None, "NULL_IDENTITY", "Null XML id associates costume, not runtime effect; resolve by name and define room/persistent/cooldown lifetime.", DOC + "xml/items.html")
                if "customcache" in attributes:
                    finding(relative, None, "CUSTOM_CACHE", "Check dirty triggers and built-in special cache semantics; defaults are not universally zero.", DOC + "xml/items.html#customcache")
                if {"revive", "reviveeffect"} & set(attributes.get("customtags", "").lower().split()):
                    finding(relative, None, "REVIVE_OWNERSHIP", "Tag protects/counts revival availability; code still owns consumption and revival timing.", DOC + "xml/items.html#customtags")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path)
    parser.add_argument("--lua-dir", action="append", dest="lua_dirs")
    args = parser.parse_args()
    try:
        result = inspect(args.root, args.lua_dirs or ("scripts", "src", "modules"))
    except (ValueError, OSError) as error:
        parser.error(str(error))
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
