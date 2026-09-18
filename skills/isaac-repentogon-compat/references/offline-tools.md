# Offline Tools

Resolve runners from the actual environment; neither tool needs the game/network.

```text
lua <skill-dir>/tests/test-version-gate.lua
python -B <skill-dir>/tests/test_surface_inventory.py
python -B <skill-dir>/scripts/surface_inventory.py <actual-mod-root>
python -B <skill-dir>/scripts/surface_inventory.py <actual-mod-root> --lua-dir custom_modules
```

Inventory writes JSON to stdout, never changes the mod. Redirect only to an
authorized report location. Review scanned_files first: defaults include main.lua,
scripts/src/modules, content XML and recognized resource roots; additional Lua
folders need explicit --lua-dir. Reporting/release/VCS and linked paths are skipped.

Comments and quoted/long-bracket strings are masked with line locations retained.
Known direct classes, changed vanilla callbacks and selected methods are review
candidates. Aliases are flagged unresolved. This is a limited heuristic vocabulary,
not a complete API index or Lua parser. Computed access, dynamic include paths,
inter-module flows and metatables are not resolved. Guarded calls and same-name
user methods can still be candidates, not confirmed bugs.

XML parsing flags candidate native stats, customcache, null/revive, achievements,
ambush and resource overrides. It cannot prove schema, runtime IDs, registration,
load order, complete root discovery or engine semantics. Malformed XML is reported.

Output explicitly says runtime_verified=false and guards_proven=false.
Zero findings only means no known candidates found in listed files. Manually
trace the real guard and matching API source; never report this scan as an
availability test, complete compatibility validator or game pass.
