# Collectible Color Gfx Review

| Entry kind | Item name/id source | gfxroot | gfx | Resolved PNG | Colored surface | Static proof | In-game proof |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Hard Checks

- The item entry is an active, passive, or familiar as intended.
- `gfxroot`, `gfx`, and the actual colored collectible PNG agree exactly, including case.
- A colored image issue is investigated in XML/resource registration before Lua
  HUD/render code.
- ESC My Stuff, collection-page, and Last Will sketch issues are delegated to
  `isaac-anm2-visuals`; `gfx` is not their assumed fix.
- Pool/quality/weight and held/use behavior are delegated to their owner skills.
- Requested native visual confirmation remains an in-game check.