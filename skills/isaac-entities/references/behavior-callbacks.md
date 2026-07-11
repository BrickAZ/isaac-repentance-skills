# Entity Behavior Callbacks

Use this when the entity does anything after it spawns.

## Common Routes

- Spawn/init: create the entity and initialize `entity:GetData()` fields.
- Update/AI: movement, targeting, timers, animation transitions, lifetime.
- Collision: player collision, enemy collision, pickup collision, grid collision.
- Damage/death: HP changes, death effects, remove triggers, spawned rewards.
- Render: only for visual overlays that cannot be handled by the entity sprite itself.
- Familiar-specific: cache flags, orbit/follow logic, `MC_FAMILIAR_UPDATE`.

## Rules

- Keep one clear owner for behavior state.
- Avoid duplicate callbacks doing the same update work.
- Guard damage/collision effects with cooldowns when an entity overlaps for multiple frames.
- Remove temporary entities on room change unless the design explicitly persists them.
- Keep gameplay mutation out of pure render callbacks.

## Review Questions

- What spawns the entity?
- What updates it every frame?
- What removes it?
- What happens if the owner disappears?
- What happens on room transition?
- Can the collision/damage route fire every frame by accident?
