# StageAPI Integration Contract Snapshot

This bundled note is an offline routing aid, not a substitute for the installed StageAPI documentation.

## Provenance

- Primary source: https://github.com/Meowlala/BOIStageAPI15
- Maintainer documentation: https://github.com/Meowlala/BOIStageAPI15/blob/master/doc.md
- Retrieved: 2026-08-01
- Scope: StageAPI 1.5 custom-room/stage integration and Basement Renovator workflow.

## Stable Contract

1. StageAPI is a third-party room/stage framework. Use it only when the project explicitly declares the dependency or the user explicitly approves an optional StageAPI enhancement.
2. Confirm the runtime object, installed version, bootstrap/load order, and exact method surface before calling anything. A reference mod is not runtime proof.
3. StageAPI room data and the tool-generated Lua/STB/XML workflow are version-sensitive. Preserve the target project's existing room authority and converter workflow.
4. Own only identifiers, rooms, callbacks, doors, and state registered by this mod. Never mutate unrelated StageAPI registries or vanilla rooms by broad scans.
5. Registration must be idempotent and lifecycle-aware. Do not rebuild room/stage registries on every room entry.
6. If StageAPI is optional, absence means an official-API fallback or explicit omission of the enhancement. Never fabricate a StageAPI-like fallback that claims equivalent behavior.

## Version-sensitive Surface

Global names, callbacks, custom-stage constructors, room loaders, door helpers, transition APIs, version fields, and test-hook layout must be read from the installed StageAPI copy. Do not freeze signatures from this snapshot.

## Branch Tests

- Dependency absent: official fallback or documented no-op; no crash or softlock.
- Dependency present but unsupported: no unsupported call; report required surface.
- Supported version: register each owned object once and verify transitions in game.
- Reload/re-entry: no duplicate rooms, callbacks, doors, or leaked state.
- Toolchain: converted room data and Basement Renovator hooks match the project's actual files.
