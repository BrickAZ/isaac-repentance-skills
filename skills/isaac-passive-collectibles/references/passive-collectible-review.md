# Passive Collectible Review

| Item fact | Held rule | Owner/count | Cache/stat rule | Refresh edge | Removal/reacquire | Owned state | Co-op proof |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Required Checks

- Registration/lookup is discovered; missing lookup does not fall back to a raw id.
- Cache contribution is recomputed, not repeatedly accumulated.
- A refresh is requested only at a defined cache-relevant state edge.
- One player losing/rerolling the item does not change another player's stats/state.
- Extra copies follow the approved stack rule and removal reverses only the owned
  contribution.
- Acquisition-once effects are not replayed accidentally on cache refresh/reload.

## Evidence Levels

- **Static:** ownership/count route, cache calculation, invalidation edges, and
  cleanup/reacquire branches.
- **Controlled runtime:** single copy, multiple copies, two-player split ownership,
  loss/reroll, and reacquire traces.
- **In game:** stat UI/behavior, item loss/reacquire, room/run boundaries, and any
  visible owned state.

A clean item XML or a successful cache callback registration alone does not prove
the passive effect has the correct stacking or removal behavior.
