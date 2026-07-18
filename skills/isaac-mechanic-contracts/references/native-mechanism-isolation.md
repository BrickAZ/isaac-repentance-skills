# Native Mechanism Reuse And Isolation

Use this when a request says “like vanilla”, “use the original mechanism”, or
requires a custom feature to leave a later vanilla use unchanged. Similar
player-facing presentation and actual vanilla-mechanism reuse are separate
choices.

## Decision

1. **Independent replica**: choose this when the promise is a similar room,
   selection flow, presentation, or result, especially when the mod must own
   cleanup and guarantee that later vanilla behavior is untouched.
2. **Explicit native reuse**: choose this only when the user explicitly requires
   the real vanilla mechanism and the project discovers an official or
   project-proven isolated entrypoint.
3. **Blocked / TBD**: use this when the request requires both real native reuse
   and a no-interference guarantee, but no isolated entrypoint or proof exists.
   Do not claim that cleanup of a currently observed vanilla room, dimension,
   entity, or state makes it isolated.

## Ownership Rules

- Do not invoke a vanilla item/mechanic merely as a shortcut for a similar
  effect, then remove, close, reset, or repurpose its internal resources.
- A custom implementation may create and clean only its own registered room,
  entity, UI, state, and reward resources.
- Treat vanilla-owned dimensions, rooms, transitions, global state, and cleanup
  as unknown unless an official API or project evidence documents ownership and
  isolation.
- Do not infer isolation from a single successful use, an empty room, a `pcall`,
  or a lack of an immediate crash.

## Required Proof For Native Reuse

Before approving explicit native reuse under a no-interference requirement:

- Record the discovered official/project entrypoint and every vanilla-owned
  resource it may touch.
- Define the custom cleanup boundary without mutating unknown vanilla resources.
- Run an in-game same-run sequence: custom invocation, its cleanup/exit, then a
  real vanilla invocation of the same mechanic.
- Verify the later vanilla invocation opens, behaves, and settles normally,
  including relevant room, dimension, selection, reward, and return paths.
- Report this as in-game proof, not a static conclusion.

If that proof cannot be performed or fails, use the independent replica route
or keep the native-reuse request blocked.
