import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest
from unittest import mock

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "surface_inventory.py"
spec = importlib.util.spec_from_file_location("surface_inventory", SCRIPT)
inventory = importlib.util.module_from_spec(spec)
spec.loader.exec_module(inventory)


class SurfaceInventoryTests(unittest.TestCase):
    def scan(self, files):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name, content in files.items():
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(content, encoding="utf-8")
            before = {p.relative_to(root): p.read_bytes() for p in root.rglob("*") if p.is_file()}
            result = inventory.inspect(root)
            after = {p.relative_to(root): p.read_bytes() for p in root.rglob("*") if p.is_file()}
            self.assertEqual(before, after, "inventory must not write project files")
            return result

    def codes(self, result):
        return {f["code"] for f in result["findings"]}

    def test_real_symbols_and_comments_are_separated(self):
        result = self.scan({"main.lua": '-- Ambush.SpawnWave()\nlocal s="ImGui.CreateWindow"\n--[=[ ModCallbacks.MC_POST_MODS_LOADED ]=]\nAmbush.StartChallenge()\n'})
        self.assertEqual([s["symbol"] for s in result["symbols"]], ["Ambush.StartChallenge"])
        self.assertEqual(result["symbols"][0]["line"], 4)
        self.assertIn("AMBUSH_CONTEXT", self.codes(result))

    def test_changed_vanilla_callback_is_inventoried(self):
        result = self.scan({"scripts/damage.lua": "mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, OnDamage)"})
        self.assertIn("CHANGED_VANILLA_CALLBACK", self.codes(result))

    def test_alias_is_reported_as_unresolved_indirection(self):
        result = self.scan({"main.lua": "local A = Ambush\nlocal C = ModCallbacks\nA.StartChallenge()\nC.MC_POST_MODS_LOADED"})
        self.assertIn("ALIAS_REVIEW", self.codes(result))
        self.assertFalse(result["runtime_verified"])
        self.assertFalse(result["guards_proven"])

    def test_guarded_call_is_not_certified_as_safe(self):
        result = self.scan({"main.lua": "if REPENTOGON then Ambush.StartChallenge() end"})
        self.assertIn("AMBUSH_CONTEXT", self.codes(result))
        self.assertFalse(result["guards_proven"])

    def test_resource_roots_and_content_are_distinct(self):
        result = self.scan({"resources-dlc3/items.xml": '<items><passive name="a" damage="1"/></items>', "content/ambush.xml": "<ambush/>"})
        self.assertIn("RESOURCE_XML_OVERRIDE", self.codes(result))
        self.assertIn("XML_NATIVE_STATS", self.codes(result))
        self.assertIn("AMBUSH_XML_BOSSRUSH", self.codes(result))

    def test_null_achievement_cache_and_revive_are_reported(self):
        result = self.scan({"content/items.xml": '<items><null id="7" name="n" CUSTOMTAGS="revive" customcache="maxcoins"/></items>', "content/achievements.xml": '<achievements><achievement id="1" name="a"/></achievements>'})
        self.assertTrue({"NULL_IDENTITY", "REVIVE_OWNERSHIP", "CUSTOM_CACHE", "ACHIEVEMENT_IDENTITY"} <= self.codes(result))

    def test_malformed_xml_is_explicit(self):
        result = self.scan({"content/items.xml": '<items><null id="1" id="2"/></items>'})
        self.assertIn("XML_PARSE_ERROR", self.codes(result))

    def test_localized_items_xml_reports_stats_and_revive(self):
        for filename in ("items.zh.xml", "items.zh-CN.xml", "items.pt_br.xml"):
            with self.subTest(filename=filename):
                result = self.scan({"content/" + filename: '<items><passive damage="1" customtags="revive"/></items>'})
                self.assertEqual(result["scanned_files"], ["content/" + filename])
                self.assertTrue({"XML_NATIVE_STATS", "REVIVE_OWNERSHIP"} <= self.codes(result))

    def test_non_locale_items_copy_is_not_classified_as_native_items(self):
        result = self.scan({"content/items.backup.xml": '<items><passive damage="1" customtags="revive"/></items>'})
        self.assertNotIn("XML_NATIVE_STATS", self.codes(result))
        self.assertNotIn("REVIVE_OWNERSHIP", self.codes(result))

    def test_verified_innate_count_method_is_inventoried(self):
        result = self.scan({"main.lua": "player:GetInnateCollectibleCount(1)\nplayer:GetInnateCollectibleNum(1)"})
        self.assertEqual([s["symbol"] for s in result["symbols"]], ["player:GetInnateCollectibleCount"])

    def test_main_symlink_is_filtered_before_reading_mocked_metadata(self):
        # Simulated metadata verifies filtering without Windows symlink
        # privileges. This is not an OS-level symlink test.
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            main = root / "main.lua"
            main.write_text("Ambush.StartChallenge()", encoding="utf-8")
            original_is_symlink = Path.is_symlink
            original_read_text = Path.read_text
            reads = []

            def is_symlink(path):
                return path == main or original_is_symlink(path)

            def read_text(path, *args, **kwargs):
                reads.append(path)
                return original_read_text(path, *args, **kwargs)

            with mock.patch.object(Path, "is_symlink", is_symlink), mock.patch.object(Path, "read_text", read_text):
                result = inventory.inspect(root)
            self.assertEqual(reads, [], "linked main.lua must not be read")
            self.assertEqual(result["scanned_files"], [])

    def test_main_resolving_outside_root_is_filtered_mocked_metadata(self):
        # Simulate resolution only; no real external target is read or linked.
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "mod"
            root.mkdir()
            main = root / "main.lua"
            main.write_text("Ambush.StartChallenge()", encoding="utf-8")
            outside = Path(directory) / "outside.lua"
            original_resolve = Path.resolve

            def resolve(path, *args, **kwargs):
                return outside if path == main else original_resolve(path, *args, **kwargs)

            with mock.patch.object(Path, "resolve", resolve):
                result = inventory.inspect(root)
            self.assertEqual(result["scanned_files"], [])
            self.assertEqual(result["symbols"], [])

    def test_rooted_drive_and_parent_lua_paths_fail_before_discovery(self):
        invalid_paths = (r"\modules", "/modules", r"C:\modules", "C:modules", r"\\server\share\modules", r"\\?\C:\modules", "../modules", r"scripts\..\modules")
        with tempfile.TemporaryDirectory() as directory:
            with mock.patch.object(inventory, "project_files", side_effect=AssertionError("invalid paths must fail before directory discovery")) as discover:
                for lua_dir in invalid_paths:
                    with self.subTest(lua_dir=lua_dir), self.assertRaisesRegex(ValueError, "relative descendants"):
                        inventory.inspect(Path(directory), (lua_dir,))
                discover.assert_not_called()

    def test_relative_custom_lua_directory_remains_supported(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            custom = root / "custom" / "nested"
            custom.mkdir(parents=True)
            (custom / "feature.lua").write_text("Ambush.StartChallenge()", encoding="utf-8")
            result = inventory.inspect(root, ("custom/nested",))
            self.assertEqual(result["scanned_files"], ["custom/nested/feature.lua"])
            self.assertIn("AMBUSH_CONTEXT", self.codes(result))

    def test_external_resolved_scan_root_is_not_traversed_mocked_metadata(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "mod"
            modules = root / "scripts"
            modules.mkdir(parents=True)
            (modules / "feature.lua").write_text("Ambush.StartChallenge()", encoding="utf-8")
            outside = Path(directory) / "outside"
            original_resolve = Path.resolve
            original_rglob = Path.rglob
            traversed = []

            def resolve(path, *args, **kwargs):
                if path.is_relative_to(modules):
                    return outside / path.relative_to(modules)
                return original_resolve(path, *args, **kwargs)

            def rglob(path, *args, **kwargs):
                traversed.append(path)
                return original_rglob(path, *args, **kwargs)

            with mock.patch.object(Path, "resolve", resolve), mock.patch.object(Path, "rglob", rglob):
                result = inventory.inspect(root)
            self.assertNotIn(modules, traversed, "check the resolved scan root before traversing it")
            self.assertEqual(result["scanned_files"], [])

    def test_untrusted_report_and_vcs_directories_are_not_scanned(self):
        result = self.scan({"reports/old.lua": "Ambush.StartChallenge()", ".git/demo.lua": "Ambush.SpawnWave()", "worktrees/x/main.lua": "ImGui.CreateWindow()", "release/x/main.lua": "REPENTOGON.MeetsVersion()", "main.lua": "local n=1"})
        self.assertEqual(result["symbols"], [])
        self.assertEqual(result["scanned_files"], ["main.lua"])

    def test_newline_and_escaped_string_masking(self):
        code = 'local s = "a\\\" Ambush.SpawnWave()"\nlocal b=[==[ImGui.CreateWindow\nfoo]==]\nAmbush.GetNextWave()'
        result = self.scan({"main.lua": code})
        self.assertEqual(result["symbols"][0]["line"], 4)
        self.assertEqual(len(result["symbols"]), 1)

    def test_missing_root_fails(self):
        with self.assertRaises(ValueError):
            inventory.inspect(Path("/this/path/is/not/an/isaac/project"))


if __name__ == "__main__":
    unittest.main()
