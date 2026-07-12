# Curse Modifier Review

| Condition | Requested bits | Operation | Unrelated-bit policy | Re-evaluate edge | Reset | Callback evidence | In-game proof |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | preserve | TBD | TBD | TBD | TBD |

## Hard Checks

- Challenge XML curse filters remain owned by `isaac-challenges`.
- Only approved curse bits are changed; unrelated bits are preserved.
- No per-frame curse re-evaluation without an explicit design reason.
- Loss/reroll/floor/run transitions clear or recompute owned modifier state.
- Optional curse helpers are guarded and have an official/discovered fallback.
