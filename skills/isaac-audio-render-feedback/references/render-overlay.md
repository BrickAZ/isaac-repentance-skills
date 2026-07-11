# Render And Overlay

Use this when drawing sprites, text, charge bars, panels, full-screen overlays, or world-space effects outside entity registration.

## Coordinate And Anchor Contract

- Screen-space: HUD, menus, prompts, charge bars, black screens, selection panels.
- World-space anchor: a player/entity/room position used to locate a visual in
  the room. It is not automatically a manual `Sprite:Render` argument.
- Entity render callback: visuals tied to an entity draw pass.
- Player render callback: visuals tied to the player sprite layer.

For a manually rendered Lua `Sprite`:

1. Recompute `worldAnchor` from the live owner position, applicable visual
   position offset, and a discovered category-specific anchor offset.
2. Convert it during render with `Isaac.WorldToScreen(worldAnchor)`.
3. Pass only that screen position to `Sprite:Render`.

Do not cache converted screen coordinates across frames. For an engine-managed
`ENTITY_EFFECT`, let the entity occupy world space, then validate its
`PositionOffset` and `SpriteOffset` separately. Do not switch routes merely to
avoid checking the anchor.

## Hard Rules

- State coordinate space before writing render math.
- State the owner, world anchor formula, and conversion/entity-follow route
  before writing render math.
- Do not use one fixed head offset for all players, normal enemies, and Bosses.
  Resolve player visual/flying offsets and test enemy size bands or an explicit
  project-owned classification.
- Do not instantiate `Sprite()` every frame.
- Keep gameplay mutation out of render callbacks.
- Use actual `.anm2` animation names when a sprite is involved.
- Report in-game verification needs for scale, layer order, and overlap.

## Review Checklist

- Render callback is appropriate.
- Sprite ownership is explicit.
- Screen/world conversion is correct for the chosen route.
- Above-owner visuals are checked while the camera moves and for every
  supported owner category, including co-op players and large Bosses.
- Visual stops rendering when state ends.
