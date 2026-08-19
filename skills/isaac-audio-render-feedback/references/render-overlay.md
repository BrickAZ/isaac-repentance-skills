# Render And Overlay

Use this when drawing sprites, text, charge bars, panels, full-screen overlays, or world-space effects outside entity registration.

## Coordinate And Anchor Contract

- Screen-space: HUD, menus, prompts, black screens, and selection panels.
- World-following visual: charge bars, head prompts, and markers whose logical
  owner is in the room but whose manual `Sprite:Render` input is screen-space.
- Entity render callback: visuals tied to an entity draw pass.
- Player render callback: visuals tied to the player sprite layer.

Before writing math, list `owner.Position`, design offset, `PositionOffset`,
`SpriteOffset`, flying offset, callback `RenderOffset`, camera conversion, and
final render position in a coordinate ledger.

For a manually rendered Lua `Sprite`, select exactly one policy:

1. **Logical marker:** live `owner.Position + worldOffset`, exactly one
   `Isaac.WorldToScreen`, then `Sprite:Render`. This is the default for a
   charge bar or prompt that tracks logical player position.
2. **Rendered-body match:** use a discovered current-project helper that
   deliberately adapts visual offsets, scroll/shake, callback offset, and
   reflection. Name the owner of every term and prove each is applied once.

`PositionOffset`, `SpriteOffset`, flying offset, and callback `RenderOffset` are
not automatically world-space additions. Do not append callback `RenderOffset`
after an already-complete conversion merely because the callback supplied it.
If conversion is unavailable or fails, skip the owned render and report the
failure; do not return the world anchor as a screen fallback.

Do not cache converted screen coordinates across frames. Define allowed render
modes and filter duplicate reflection/refraction passes unless mirroring is
intentional. For an engine-managed `ENTITY_EFFECT`, let the entity occupy world
space, then validate its `PositionOffset` and `SpriteOffset` separately.

## Hard Rules

- State coordinate space before writing render math.
- State the owner, coordinate ledger, selected anchor policy, render modes, and
  conversion/entity-follow route before writing render math.
- Use a non-identity camera transform and distinct nonzero visual/callback
  offsets in behavior tests; all-zero identity stubs cannot prove placement.
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
- Screen/world conversion is correct for the chosen route, every offset is
  owned and applied exactly once, and conversion failure causes no draw.
- Allowed/excluded render modes prevent unintended duplicate passes.
- Above-owner visuals are checked while the camera moves and for every
  supported owner category, including co-op players and large Bosses.
- Visual stops rendering when state ends.
