# Reset Lifecycle

Use this when a mechanic should stop, clear, or roll over.

## Common Reset Points

- New room: clear room-only entities, room cooldowns, temporary hazards, selection previews.
- New level/floor: clear floor-limited active item modes, once-per-floor flags, temporary curses.
- New run: clear all runtime run state and challenge state.
- Player death: clear or settle player-owned delayed effects.
- Item loss: stop item-granted modes and visuals when the player no longer has the item.
- Entity remove/death: clear entity-owned links and owner references.
- Challenge exit or non-challenge run: gate and clear challenge-only behavior.
- Game reload: reconstruct only what was deliberately saved.

## Callback Planning

Name the callbacks or existing helpers that perform each reset. If the current repo has a reset helper, use it instead of creating a parallel lifecycle system.

## Review Questions

- Can the state survive entering a new room by accident?
- Can it survive starting a normal run after a challenge?
- Can it affect a different player?
- Can it become stale when an entity is removed?
- Does reload create duplicate state?
