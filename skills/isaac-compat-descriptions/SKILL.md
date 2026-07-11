---
name: isaac-compat-descriptions
description: Handle optional dependency compatibility and player-facing descriptions for Binding of Isaac Repentance mods. Use this whenever a task mentions EID, item descriptions, Chinese/English text, Encyclopedia, Mod Config Menu, StageAPI, Boss Bars, CuerLib, optional dependencies, load guards, translations, wiki text, or keeping XML/EID/compat descriptions synchronized. 中文触发：EID、道具描述、中文描述、英文描述、百科、MCM、兼容、可选依赖、翻译、文本不同步、图标描述。
---

# Isaac Compatibility And Descriptions

Use this skill for optional mod integrations and player-facing text surfaces.

Read `../isaac-mod-context/references/design-authority.md` before deciding wording, language tone, icon direction, or optional-integration behavior that the user has not specified.

The goal is to prevent two common mistakes: loading optional dependencies as if they always exist, and updating one text surface while leaving XML, EID, wiki, or translations inconsistent.

## Dependency Order

Use these choices in order:

1. Isaac's official API and existing project code.
2. A project-owned helper that the context contract confirms is already loaded.
3. A declared required library, with its requirement documented in the project.
4. An undeclared third-party library only as an optional integration: guard it, isolate it, and keep core behavior working without it.

Do not introduce CuerLib, EID, StageAPI, MCM, or another library merely because a reference mod uses it.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar mod, use `isaac-mod-context` to discover description XML, existing locales, bootstrap/compatibility modules, dependency declarations, and EID-related blocks. Do not assume `main.lua`, `content/items*.xml`, English/Chinese locale files, or a third-party library.
2. Inspect the current project's closest description and optional-dependency pattern.
3. Read the bundled optional-dependency, localization, and load-order references when the current mod has no matching compatibility path.
4. Decide which surfaces are involved: XML, EID, Encyclopedia/wiki, MCM, StageAPI, Boss Bars, CuerLib translations, or metadata.

## Route The Task

- **EID and inline icons**: item/card/trinket descriptions, icons, transformation icons, button icons, charge icons. Read `references/eid-descriptions.md`. For custom card/rune/soul stone/pill registration, generation, or blank card art, use `isaac-cards-pockets`.
- **Localization sync**: default XML, every discovered locale XML, EID language files, metadata, and translation tables. Read `references/localization-sync.md`.
- **Optional dependency gates**: `if EID then`, `if CuerLib then`, `if StageAPI then`, `if ModConfigMenu then`, or graceful fallback. Read `references/optional-dependency-gates.md`.
- **MCM / Encyclopedia / Boss Bars / StageAPI**: config pages, wiki entries, boss bar support, stage API hooks. Read `references/compat-modules.md`. For a setting's default authority, persistence, malformed-data recovery, runtime gate, or in-flight behavior boundary, add `isaac-config-options`.
- **Load order and module organization**: include/require order, descriptions folder, compatibility folder, and avoiding hard failure on missing optional mods. Read `references/load-order.md`.

## Hard Rules

- Optional dependencies must be guarded unless the mod intentionally requires them and the requirement is documented.
- Prefer an official API or current-project implementation before proposing a third-party helper.
- Do not call EID, Encyclopedia, MCM, StageAPI, or CuerLib APIs before confirming the object exists or the project declares it required.
- Do not mix Chinese text into English description surfaces or English-only text into Chinese surfaces unless the design explicitly wants bilingual text.
- Keep collectible/card/trinket ids distinct. Use the matching `Isaac.GetItemIdByName`, `Isaac.GetCardIdByName`, or `Isaac.GetTrinketIdByName`.
- When a mechanic changes, update descriptions in all relevant surfaces or report why a surface was intentionally left untouched.

## Handoff Prompt Template

```markdown
## Compatibility And Description Spec

- Content type:
- Text surfaces to update:
- Languages:
- Optional dependencies:
- Required dependency gates:
- Dependency classification and official fallback:
- Icon/inline icon assets:
- Config/wiki/boss-bar surfaces:
- Existing examples to read:
- Surfaces intentionally left unchanged:
- Required tests or manual checks:
```

## Final Review

Before saying the work is complete, report:

- Which text and compatibility surfaces were touched.
- Which optional dependency gates were used.
- Which ids were resolved as collectible/card/trinket/player/entity.
- Which languages were updated.
- Any compatibility behavior that still needs in-game verification.
