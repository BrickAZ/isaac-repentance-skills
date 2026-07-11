# Trinket Behavior

Route trinket behavior by what the trinket actually does.

## Routes

- Stat changes: cache flags and `MC_EVALUATE_CACHE`.
- Damage changes: damage interception rules.
- Drop or pickup changes: pickup/spawn callbacks.
- Room effects: room/floor/run state lifecycle.
- Entity interaction: entity skill plus state lifecycle.
- Visual/audio feedback: anm2 and audio/render skills.

## Caution

Trinket checks often run every frame. Avoid spawning, adding stats, or mutating state repeatedly without guards.
