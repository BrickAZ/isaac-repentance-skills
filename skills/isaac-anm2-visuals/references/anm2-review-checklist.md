# ANM2 Review Checklist

Use this before final handoff.

## Route

- Visual carrier has been identified before route selection.
- Costume/player overlay
- Lua manual sprite effect
- UI/HUD sprite
- EID/inline icon
- Vanilla template reuse
- Skipped entity-registration route

## Asset Paths

- `.anm2` path exists.
- Referenced PNG paths exist.
- Lua path casing matches the working repo convention.
- XML path is relative to the declared root.

## ANM2 Contents

- `DefaultAnimation` exists.
- Every animation called by code exists.
- Frame count and loop setting match the intended behavior.
- Pivots are appropriate for the anchor point.
- Width/height crop values match the PNG.

## Integration

- Body-vs-effect decision is explicit: costume only when the visual is part of Isaac's body animation.
- Costume: `content/costumes2.xml` and `Isaac.GetCostumeIdByPath` agree.
- Lua effect: sprite is created once, updated, rendered, and removed.
- Manual Lua effect: world anchor is converted with `Isaac.WorldToScreen`
  before `Sprite:Render`; its anchor offset is validated for the intended
  owner category rather than copied as one universal fixed Y value.
- UI/HUD: render coordinates are screen-space and hide conditions exist.
- EID: icon shortcut, size, frame, and fallback are registered.
- Vanilla reuse: spritesheet index and `LoadGraphics()` are correct.

## Verification

- Add or update a behavior test when Lua references the asset.
- For generated assets, inspect the `.anm2` as XML after writing.
- Mention anything that still requires in-game visual verification.
- For above-owner visuals, verify camera movement, co-op, flying players when
  supported, ordinary enemies, and large Bosses.
