# StageAPI Integration Contract Snapshot

This bundled note is an offline routing aid, not a substitute for the installed StageAPI documentation.

## Provenance

- Primary source: https://github.com/Meowlala/BOIStageAPI15
- Maintainer documentation: https://github.com/Meowlala/BOIStageAPI15/blob/master/doc.md
- Retrieved: 2026-08-01
- Scope: StageAPI 1.5 custom-room/stage integration and Basement Renovator workflow.

## Stable Contract

1. StageAPI is a third-party room/stage framework. Use it only when the project explicitly declares the dependency or the user explicitly approves an optional StageAPI enhancement.
2. Confirm the runtime object, installed version, bootstrap/load order, ready/loaded state, and exact method surface before calling anything. A non-nil global is not sufficient readiness proof, and a reference mod is not runtime proof.
3. StageAPI room data and the tool-generated Lua/STB/XML workflow are version-sensitive. Preserve the target project's existing room authority and converter workflow.
4. Own only identifiers, rooms, callbacks, doors, and state registered by this mod. Never mutate unrelated StageAPI registries or vanilla rooms by broad scans.
5. Registration must be idempotent and lifecycle-aware. Immediate-ready and deferred-ready paths must converge on one registration; do not rebuild room/stage registries on every room entry.
6. If StageAPI is optional, absence means an official-API fallback or explicit omission of the enhancement. Never fabricate a StageAPI-like fallback that claims equivalent behavior.

## Ready-State Contract

StageAPI 1.5 source exposes loaded-mod bookkeeping and a
`RunWhenMarkedLoaded(name, fn)` route that either runs immediately after a
named component is marked loaded or queues the callback. This is evidence that
object existence and readiness are separate. Use that function only when the
installed StageAPI copy proves the exact name/signature; otherwise follow the
target project's discovered post-load route.

Registration must remain single-owner whether StageAPI was already ready,
became ready later, or the bootstrap path was invoked repeatedly. A required
dependency that never becomes ready must stop before partial room/stage
registration; an optional path omits only the enhancement.

## Version-sensitive Surface

Global names, callbacks, custom-stage constructors, room loaders, door helpers, transition APIs, version fields, and test-hook layout must be read from the installed StageAPI copy. Do not freeze signatures from this snapshot.

## Branch Tests

- Optional dependency absent: official fallback or documented no-op; no crash or softlock.
- Required dependency absent/unsupported/not ready: stop before partial registration and report the required surface.
- Object present but not marked ready: defer through the installed ready contract; do not call early.
- Supported and ready: register each owned object exactly once and verify transitions in game.
- Reload/re-entry: no duplicate rooms, callbacks, doors, or leaked state.
- Toolchain: converted room data and Basement Renovator hooks match the project's actual files.
