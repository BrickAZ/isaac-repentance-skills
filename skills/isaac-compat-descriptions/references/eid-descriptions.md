# EID Descriptions And Icons

Use this when adding or reviewing External Item Descriptions text, inline icons, or EID-only explanatory surfaces.

For custom card/rune/soul stone/pill registration or blank in-game card/HUD art, use `isaac-cards-pockets`. EID icons do not replace `content/pocketitems.xml` or in-game card art.

## Required Checks

- Identify the content type: collectible, trinket, card/rune/soul stone, pill, player, transformation, or custom icon.
- Resolve ids with the matching Isaac function.
- Keep description language files aligned with the user's intended languages.
- Register icon sprites before using icon tags that depend on them.
- If using `.anm2` EID icons, also use `isaac-anm2-visuals`.

## Hard Rules

- Do not add EID calls outside an `if EID then` guard unless the mod requires EID.
- Do not use collectible ids for cards or trinkets.
- Do not update only EID while leaving XML pickup text stale when both are player-facing.
- Do not invent icon names without checking current EID icon registration patterns.

## Review Checklist

- EID guard exists.
- Correct content id function is used.
- English and Chinese descriptions are separate.
- Any inline icons have registered sprites and animation/frame references.
