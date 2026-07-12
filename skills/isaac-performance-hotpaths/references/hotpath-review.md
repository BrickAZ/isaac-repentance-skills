# Hot Path Review

| Path | Callback/frequency | Scope | Work | Signal | Owner/invalidation | Evidence | Risk |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Verification Split

- **Static:** callback registration, unbounded loops/scans, resource construction,
  state cleanup paths, and duplicate spawn paths.
- **Controlled runtime:** debug counters or traces in an empty room and a dense room;
  verify owner isolation and room cleanup.
- **In game:** observe the feature under representative load. Record comparison
  conditions before claiming reduced stutter or frame time.

## Do Not Paper Over These Failures

- A cadence change that delays hit detection, reward settlement, or UI feedback.
- A global cache that makes co-op owners share state.
- Retained entity userdata after room transition or removal.
- A spawn budget that never resets or that deletes foreign entities.
