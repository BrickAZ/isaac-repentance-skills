# REPENTOGON Compatibility Contract Snapshot

This bundled note is an offline routing aid, not proof that REPENTOGON exists or that a documented surface matches the installed build.

## Provenance

- Primary documentation: https://repentogon.com/
- Global/version API: https://repentogon.com/Repentogon.html
- Source repository: https://github.com/TeamREPENTOGON/REPENTOGON
- Retrieved: 2026-08-01
- Scope: capability discovery, version gates, and extension-only API/XML behavior.

## Stable Contract

1. Classify REPENTOGON as required, optional enhancement, or undeclared. Only an explicit project/user decision may make it required; undeclared means optional and official APIs remain the core route.
2. Confirm that the runtime `REPENTOGON` global exists before reading fields or calling methods.
3. The official docs expose `REPENTOGON.Version` and static `REPENTOGON.MeetsVersion(version)`. Verify the installed build before relying on either.
4. Official docs warn that `MeetsVersion` always returned true through version 1.0.10b. A version gate is not trustworthy until this compatibility caveat is resolved for the installed build.
5. Extended callbacks, enums, classes, XML nodes/attributes, custom tags, and resource roots are REPENTOGON-only unless separately proven vanilla. Keep every such line identifiable in review.
6. REPENTOGON's Lua runtime differences do not justify Lua-version-specific code on a path intended to load without REPENTOGON.

## Required Versus Optional Failure

- Required dependency: a missing or insufficient build must stop this mod before
  extension-only registration or state mutation, with a clear dependency/version
  report. A different vanilla behavior is not an equivalent fallback.
- Optional enhancement: absence or insufficiency skips only the enhancement;
  official core behavior remains usable.
- In both modes, decide the gate before registering callbacks or mutating shared
  registries so a failure cannot leave a half-initialized mod.

Benighted Soul is positive evidence for an explicit required-dependency guard,
but its presence-only check is not version authority and must not be copied as
a complete gate.

## Version-sensitive Surface

REPENTOGON tracks specific game builds and changes quickly. The installed docs/source are authoritative for callback parameters, return contracts, XML spellings, resources folders, and version support. Do not infer support from the latest website alone.

## Branch Tests

- Required REPENTOGON absent/insufficient: initialization stops before partial registration and reports the requirement.
- Optional REPENTOGON absent: no extension symbol is evaluated; official route or explicit omitted enhancement works.
- Present but insufficient: unsupported API/XML path is not used.
- Present and sufficient: exact installed signature and return contract are exercised.
- Reload/re-registration: callbacks and registries remain single-owner/idempotent.
- Distribution review: every extension-only file/line and minimum version is listed.
