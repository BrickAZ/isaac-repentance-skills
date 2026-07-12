# Blank Or Abnormal Card Prevention

Use this when a custom card/rune/soul stone appears blank, has the wrong art, shows strange HUD, or spawns as an invalid pickup.

## Likely Causes

- Missing or malformed `content/pocketitems.xml` entry.
- `id`, `pickup`, and `hud` are confused.
- Lua uses `Isaac.GetItemIdByName` instead of `Isaac.GetCardIdByName`.
- Card generation returns a collectible id or pickup subtype instead of a card id.
- HUD/cardfront art key has no matching asset or icon registration.
- An optional EID icon exists but the actual pickup/HUD art was never registered.
- Duplicate ids or names collide with another card/rune.

## Debug Order

1. Confirm the `pocketitems.xml` entry exists and uses the intended content type.
2. Confirm Lua resolves the card/rune with `Isaac.GetCardIdByName`.
3. Confirm `MC_USE_CARD` is registered with the card id.
4. Confirm any `MC_GET_CARD` or challenge `startingcard` returns a card id, not a pickup/collectible id.
5. Confirm `pickup` and `hud` point to existing art conventions.
6. When an EID integration exists, confirm its icon registration is separate from gameplay registration.

## Hard Rules

- Do not fix blank art by changing the use callback first. Registration and art mapping come first.
- Do not assume EID icon registration fixes the in-game pocket/HUD art.
- Do not infer a missing cardfront from a working pickup or HUD key. Record pickup, cardfront, pocket/HUD, and optional EID as separate native or optional surfaces; the actual route for each remains project-discovered.
- Do not let a generation callback return custom card ids outside the challenge/item condition that owns them.
