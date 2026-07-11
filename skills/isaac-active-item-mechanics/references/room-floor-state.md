# Room, Floor, And Run State

Use this when an active item tracks once-per-room, once-per-floor, temporary buffs, known choices, rollback, or persistent progress.

## State Lifetimes

- Frame/timer state: keep in player/entity `GetData()` or a local table keyed by player/entity identity.
- Room state: reset on `MC_POST_NEW_ROOM`.
- Floor state: reset on `MC_POST_NEW_LEVEL`.
- Run state: initialize on `MC_POST_GAME_STARTED` and clear on new run.
- Persistent state across saves: use the mod's SaveData/LoadData pattern, not raw entity references.

## Hard Rules

- Do not save live entity userdata in persistent data.
- Do not use one global state value when multiplayer or multiple active copies matter.
- If a state affects stats, call `AddCacheFlags` and `EvaluateItems` at the state transition, not every render frame.
- Document exactly when state resets.

## Review Checklist

- State owner is player, entity, room, floor, run, or save data.
- Reset callback is explicit.
- Multiplayer and co-op edge cases are considered.
- Tests or handoff cover reset behavior.

