# REPENTOGON Compatibility Contract Snapshot

This bundled note is an offline routing aid, not proof that REPENTOGON exists or that a documented surface matches the installed build.

## Provenance

- Primary documentation: https://repentogon.com/
- Global/version API: https://repentogon.com/Repentogon.html
- Source repository: https://github.com/TeamREPENTOGON/REPENTOGON
- Retrieved: 2026-08-01
- Scope: capability discovery, version gates, and extension-only API/XML behavior.

## Stable Contract

1. Require explicit project/user intent before making REPENTOGON mandatory. Otherwise keep official Isaac APIs as the core route and make the extension optional.
2. Confirm that the runtime `REPENTOGON` global exists before reading fields or calling methods.
3. The official docs expose `REPENTOGON.Version` and static `REPENTOGON.MeetsVersion(version)`. Verify the installed build before relying on either.
4. Official docs warn that `MeetsVersion` always returned true through version 1.0.10b. A version gate is not trustworthy until this compatibility caveat is resolved for the installed build.
5. Extended callbacks, enums, classes, XML nodes/attributes, custom tags, and resource roots are REPENTOGON-only unless separately proven vanilla. Keep every such line identifiable in review.
6. REPENTOGON's Lua runtime differences do not justify Lua-version-specific code on a path intended to load without REPENTOGON.

## Version-sensitive Surface

REPENTOGON tracks specific game builds and changes quickly. The installed docs/source are authoritative for callback parameters, return contracts, XML spellings, resources folders, and version support. Do not infer support from the latest website alone.

## Branch Tests

- REPENTOGON absent: no extension symbol is evaluated; official route or explicit omitted enhancement works.
- Present but insufficient: unsupported API/XML path is not used.
- Present and sufficient: exact installed signature and return contract are exercised.
- Reload/re-registration: callbacks and registries remain single-owner/idempotent.
- Distribution review: every extension-only file/line and minimum version is listed.
