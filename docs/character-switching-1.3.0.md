# Character Switching Update - 1.3.0

This release expands the public suite from **54 to 55 skills**.

It adds `isaac-character-switching` for mechanics that change or restore a live
player's actual `PlayerType`. The skill coordinates:

- source/target identity discovery and capability preflight;
- health projection across incompatible character health models;
- native partner/twin/subplayer topology and co-op isolation;
- switching-item ownership when a secondary body disappears;
- stale-wrapper avoidance, postconditions and best-effort compensation;
- SaveData authority, continue behavior and layered verification.

The guidance is generic. It does not ship a fixed health-exchange ratio, require
neverbrith or any reference mod, or claim that isolated tests prove native partner
creation/removal and Lost-like survival in game.

The previous REPENTOGON expansion remains documented in
[`repentogon-1.2.0.md`](repentogon-1.2.0.md).
