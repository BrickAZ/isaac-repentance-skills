# Feedback Review Checklist

Use this before handing off audiovisual feedback code or a prompt.

## Checklist

- Feedback route is chosen: SFX, music, shader, render overlay, input interception, or anm2 sprite.
- SFX/music XML paths match real assets.
- Shader name and params match XML and cannot leak after the effect ends.
- Render callback owns cached sprites and uses the right coordinate space.
- Manual sprites convert live world anchors with `Isaac.WorldToScreen`; entity
  routes validate follow offsets separately.
- Above-owner anchors are verified for camera movement, player offsets/flying,
  co-op separation, normal enemies, and large Bosses where supported.
- Input interception has a release condition.
- Active item feedback is coordinated with `isaac-active-item-mechanics`.
- anm2 asset hookup is coordinated with `isaac-anm2-visuals`.
- In-game verification needs are listed.
