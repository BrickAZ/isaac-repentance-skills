# Lua Sprite Effects Reference

Use this when a visual is not an Isaac entity and is controlled manually by Lua.

## When To Use

Use manual `Sprite` loading for:

- One-shot hit flashes or reward bursts.
- Floating labels or icons near a player.
- Rings, halos, pulses, slash effects, warning marks, and temporary overlays.
- Visuals that do not need entity collision or an `entities2.xml` registration.

If the visual needs collision, AI, entity update callbacks, or an `EntityType/Variant`, this becomes the skipped entity-registration route.

## Files To Check

- The `.anm2` file.
- Its spritesheet PNGs.
- `main.lua` for `Sprite:Load`, `:Play`, `:Update`, `:Render`, `:IsFinished`.
- Tests that stub `Sprite`.

Use a current-project effect when one exists. Otherwise follow the basic
runtime pattern and lifetime rules below; no third-party asset is required.

## Coordinate And Anchor Contract

Manual `Sprite:Render` is screen-space even when the visual is anchored in the
room. Keep these values separate:

- `worldAnchor`: recompute from the live owner during render. For an owner
  entity, begin with its position and applicable visual position offset.
- `headOffset`: a discovered, owner-category-specific offset. Do not use one
  fixed value for players, normal enemies, and Bosses; account for player
  flying/position offsets and enemy size or an explicit tested size band.
- `screenPosition`: `Isaac.WorldToScreen(worldAnchor)`, passed to
  `Sprite:Render`.

Do not cache `screenPosition`: the camera can move. Do not use the ANM2 pivot
or a `SpriteOffset` as a substitute for choosing the correct owner anchor.
If the effect needs engine-managed world tracking, evaluate the registered
`ENTITY_EFFECT` route with `isaac-entities`; then separately verify entity
`PositionOffset` and `SpriteOffset`.

## Basic Runtime Pattern

```lua
local effect = {
    sprite = Sprite(),
    timer = 30,
}

effect.sprite:Load("gfx/Effects/ItemName/ItemNameEffect.anm2", true)
effect.sprite:Play("Idle", true)
```

In update/render logic, after confirming the owner still exists:

```lua
effect.sprite:Update()

-- Resolve headOffset from the discovered owner category and tested visual
-- convention. It is not one global fixed Vector.
local worldAnchor = owner.Position + owner.PositionOffset + headOffset
local screenPosition = Isaac.WorldToScreen(worldAnchor)
effect.sprite:Render(screenPosition)

effect.timer = effect.timer - 1
```

Use `:IsFinished("AnimationName")` for one-shot animations when the `.anm2` is non-looping.

## ANM2 Shape

For first versions, prefer:

- One spritesheet.
- One layer.
- `Idle` for looped effects.
- `Appear`, `Idle`, `Disappear` only if code actually transitions between them.
- Pivots centered on the visual's intended anchor.

Read the `.anm2` before coding. If the file only has `Idle`, do not call `Play("Pulse")`.

## Lifetime Rules

- Store active effects in a table.
- Remove expired effects from the table.
- Keep state per player when the visual follows a player.
- Do not create a new `Sprite()` every render frame.
- For paused or room-transition behavior, decide whether the effect should freeze, vanish, or persist.
- Recompute the owner anchor and world-to-screen conversion while rendering;
  remove the effect when its owner no longer qualifies or exists.

## Checklist

- Lua path matches the real resource path.
- All animation names used by code exist in the `.anm2`.
- Looped and one-shot animations are handled differently.
- Sprites are updated before render when animation should advance.
- Expired sprites are removed.
- Manual `Sprite:Render` receives `Isaac.WorldToScreen(worldAnchor)`, never a
  raw entity world position.
- Head/above-owner placement is checked for the intended player state,
  ordinary enemy, large Boss, camera movement, and co-op owner separation.
- Tests assert `Load`, `Play`, `Render`, and expiration behavior when practical.
