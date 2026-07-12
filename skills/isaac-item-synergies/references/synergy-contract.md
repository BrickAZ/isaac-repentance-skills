# Synergy Contract

Use this worksheet before selecting an implementation route:

| Field | Record |
| --- | --- |
| Inputs | Exact content/state requirements and quantities; unresolved ids stay `TBD`. |
| Owner | The player, entity, or room that owns qualification and receives the result. |
| Eligibility | One complete predicate, including mode, room, target, and source exclusions. |
| Result | Cache modifier, event response, marker, owned entity, visual, or replacement. |
| Repeat boundary | Per copy, room, target, event, or another explicit rule. |
| Precedence | User/project rule, or `TBD`; never infer cancellation authority. |
| Exit | Loss, reroll, morph, replacement, room/run reset, or a named lifecycle event. |
| Retraction | Only synergy-owned state/entities/markers are removed or recalculated. |

## Ownership Questions

- Does each co-op player qualify independently?
- Is a familiar/projectile result credited to the qualifying player?
- Can a result remain after an input disappears? If yes, why and for how long?
- Does an external input require an explicit guarded compatibility branch?

## Do Not Use These Shortcuts

- One global `hasSynergy` flag for all players.
- A broad callback that changes every matching vanilla entity.
- Two independent handlers that both apply the same bonus.
- An assumed item id, optional library, or partner-mod API.
