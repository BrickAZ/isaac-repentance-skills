# Cache And Stack Policy

Use this reference for a passive item that changes player cache values.

## Cache Route

1. Discover the current project's item ID and cache callback pattern.
2. Name the one or more cache flags that the item actually changes.
3. In `MC_EVALUATE_CACHE`, check the current player's ownership and the active
   cache flag before applying the stat change.
4. When a condition changes outside cache evaluation, refresh only the affected
   flags through the discovered `AddCacheFlags` / `EvaluateItems` route.
5. Test the eligible player, a player without the item, a second player, and
   every intended copy count.

## Copy Policy

| Policy | Required proof |
| --- | --- |
| One copy is enough | A boolean ownership check is intentional and documented. |
| Linear stacking | A discovered copy-count API and a user-approved per-copy formula. |
| Capped stacking | The cap and behavior past the cap are explicit. |
| Conditional copies | The condition, refresh event, and co-op owner are explicit. |

Do not infer stacking from a similar item. Do not write a global multiplier
that accidentally combines different players' copies.

## Reject These Patterns

- Mutating a stat directly in an update callback without a cache route when the
  stat is cache-backed.
- Calling cache refresh every frame to compensate for unclear state ownership.
- Applying the effect to all players because one player owns the item.
- Rolling random values inside cache evaluation when the design did not define
  a stable stored roll and its lifetime.
