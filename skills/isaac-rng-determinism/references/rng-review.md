# RNG Review

| Event | Owner | Stability scope | RNG/seed evidence | Draw boundary | Stored outcome | Retry rule | Verification |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Hard Checks

- No global stream accidentally couples co-op owners.
- An update loop does not redraw an outcome that should persist.
- Retry/fallback behavior does not silently change probability.
- Live RNG userdata is not stored in SaveData.
- Deterministic claims are separated from actual repeat-run evidence.
