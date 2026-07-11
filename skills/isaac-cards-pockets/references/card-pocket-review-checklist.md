# Card And Pocket Review Checklist

Use this before handing off card/rune/soul stone/pill work.

## Checklist

- `content/pocketitems.xml` entry exists when custom content is involved.
- `id`, `pickup`, and `hud` are intentionally chosen and not confused.
- Lua uses the correct id lookup for card/rune/pill.
- `MC_USE_CARD`, `MC_USE_PILL`, or generation callbacks use the correct ids.
- Generation/replacement callbacks are gated to the owning item/challenge.
- EID/description surfaces are updated and guarded.
- Art and icon surfaces are checked; EID icons are not mistaken for in-game HUD art.
- Blank-card prevention checks are listed.
- Manual in-game checks include pickup appearance and pocket/HUD appearance.

