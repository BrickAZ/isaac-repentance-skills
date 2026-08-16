# Engine Value Boundaries

Some Isaac Lua APIs accept values that must be constructed in a way the engine recognizes. Matching field names in a normal Lua table is not enough.

## Scope

Apply this check to `Isaac.Spawn`, `game:Spawn`, and any discovered API whose arguments include values such as `Vector`, `Color`, `KColor`, `EntityRef`, or another engine-owned type.

## Required Decision

1. Identify the exact call and argument positions that require engine-compatible values.
2. Discover the constructor exposed by the actual project/runtime. Do not assume its representation from `type(Constructor)`: it can be a regular function, a callable object, or a project adapter.
3. Attempt construction safely through that discovered route.
4. If construction fails, do not call the engine API with a table fallback. Skip or abort only the current mod-owned operation, and expose a focused error for debugging.
5. Keep any test-only substitute behind a test adapter; it must not silently flow into a real game API.

## Test Contract

A useful test double does more than count a Spawn call:

- it accepts the intended constructor shape;
- it rejects `{ X = x, Y = y }` and other table lookalikes at typed argument positions;
- it reaches the same helper/call path as production; and
- it reports whether the test was actually run against the current source.

The test double can model a callable `Vector` object, but that model alone is not proof of the game's implementation. Keep the real runtime contract separately marked as project, official, or in-game evidence.

## Review Questions

- Can a failed constructor result reach an engine call?
- Does a `type(...) == "function"` guard accidentally reject a valid callable constructor?
- Does any fallback table cross the engine boundary?
- Does the behavior test execute the changed spawn call and assert every typed argument?
- What remains to be confirmed in the actual game?
