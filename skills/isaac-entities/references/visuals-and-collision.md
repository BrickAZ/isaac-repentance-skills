# Visuals And Collision

Entity visuals are not only anm2 wiring. The sprite and the physical entity must agree.

## ANM2 Checks

- Read the `.anm2` path referenced by XML or Lua.
- Use real animation names from the file.
- Confirm spritesheet PNG paths exist and match casing.
- Decide whether animation is one-shot, looping, or state-driven.

## Collision Checks

- Decide whether the entity needs collision at all.
- If it has contact damage, define target, damage amount, flags, cooldown, and source.
- If it blocks movement or interacts with grid, define grid collision.
- If it is decorative, collision should usually be absent and the task may belong to `isaac-anm2-visuals`.

## Screen Versus World

- World-space entity: follows room camera, can collide, can be spawned/removed.
- Screen-space UI: use render/UI handling, not entities.
- Player-body visual: use costume or player sprite route, not entities.
