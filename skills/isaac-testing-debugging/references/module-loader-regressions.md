# Module Loader Regressions

Use the actual module/installer or a documentation example extracted by its test.
The [architecture contract](../../isaac-mod-architecture/references/module-loading-and-exports.md)
owns loader semantics; this reference owns observable checks and proof limits.
Select cases affected by the change rather than retesting every mod subsystem.

| Case | Observable assertion |
| --- | --- |
| Two consumers, one authority | Both reach the bootstrap-owned stateful instance; updating approved state is visible through both. |
| Repeated execution | `include` double runs the file again; a registering fixture reveals duplicate counts and separate local tables. |
| Cached import | `require` double caches by name; a second bootstrap can retain old dependencies instead of silently returning fresh code. |
| Two mod roots | Same include path resolves per root; identical require cache key exposes modeled collision; explicit namespaces separate it. |
| Dependency not ready | Module-table construction/cycle does not silently read nil or an old generation; delayed lookup has a defined not-ready result. |
| Query versus commit | Repeated description/preview queries leave gameplay RNG, pool/resources and effect counters unchanged; explicit execution matches the approved preview context. |
| Result ownership | Sorting/mutating an output does not corrupt private state or another consumer; include nested objects when that is the actual result shape. |
| Invalidation | Changing relevant player/seed/eligibility input or explicit invalidation rebuilds the correct cache; unchanged context is stable. |
| Teardown and replacement | Old methods cannot affect replacement resources; repeated cleanup is safe; a new live owner can register after the old one is detached. |
| External API lifecycle | Cover absent/late API, same-ID behavior from its source, replacement API object, current language and UI cleared independently of the loader cache. |

Do not manufacture atomic engine behavior in a stub. If the engine removes a
Mod's callbacks, model that only with matching-build evidence; keep external UI
and description registrations separate. The mock should expose retained closures
and missing registrations instead of clearing every store for convenience.

Run the bundled example checks when those references change:

```text
lua <skills-root>/isaac-mod-architecture/tests/test-module-contracts.lua
lua <skills-root>/isaac-repentogon-ui/tests/test-developer-panel.lua
```

These tests execute documented pure Lua patterns and explicit engine doubles.
They are not an actual Isaac loader and cannot establish native file search,
`luamod`/`luareset` cache clearing, ImGui duplicate-ID behavior or unload order.

For native proof record target game/REPENTOGON/library build, operation performed,
before/after owner-generation and registration counts, current callback behavior,
and relevant fresh log output. Validate the specific supported operations; do
not label a duplicate bootstrap test as a complete hot-reload test. XML/resource
changes have their own reload/restart requirements. User-visible gameplay and UI
acceptance remain distinct from both scripted and instrumented engine evidence.
