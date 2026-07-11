---
name: isaac-entities
description: Add, fix, review, or write handoff prompts for registered Binding of Isaac Repentance entities. Use this whenever a task mentions entities2.xml, entity type/variant/subtype, custom effect entities, tears, lasers, knives, pickups, NPCs, bosses, collision, entity HP, AI, targeting, contact damage, spawn callbacks, entity:GetData(), or an anm2 visual that needs gameplay behavior. For player/familiar-owned tear, laser, knife, bomb, or projectile combat behavior, use isaac-projectile-combat as the primary skill and this skill for registration facts; for custom familiar count, ownership, follow/orbit, co-op, cache, or familiar update work, use isaac-familiars as primary. Use isaac-mod-context first in an unfamiliar project. This skill exists because entity work is not the same as a loose Sprite visual. 中文触发：实体、跟班、使魔、敌人、Boss、子弹、激光、飞刀、掉落物、碰撞、血量、AI、接触伤害、生成特效、空白实体、无效实体。
---

# Isaac Entities

Use this skill for registered or behavior-owning entities.

Read `../isaac-mod-context/references/design-authority.md` before choosing entity kind, gameplay behavior, collision intent, reward behavior, or visual direction. Registration details remain technical choices; design intent does not.

The goal is to avoid a common category error: implementing a visual-only `Sprite` when the design needs an entity with variant/subtype, collision, lifetime, callbacks, and data.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar project, use `isaac-mod-context` to confirm entity XML, module owners, and asset roots that actually exist.
2. Decide whether the request needs a registered entity or only a visual carrier.
3. If it is visual-only, use `isaac-anm2-visuals` instead.
4. If it has collision, AI, HP, pickup behavior, targeting, contact damage, projectile behavior, familiar behavior, or entity lifetime, continue here.
5. If its primary identity is a custom familiar, route count, owner, co-op, follow/orbit, and familiar callbacks through `isaac-familiars`; keep this skill for XML/variant/collision registration facts.
6. If it is a player/familiar-owned combat projectile, route source proof, collision, damage, update, and lifetime through `isaac-projectile-combat`; keep this skill for XML/variant/asset registration facts.
7. Read the current project's entity XML if present, existing entity callbacks, and the closest local entity example before adding a new one.
8. If the entity owns state beyond a single callback, also use `isaac-state-lifecycle`.
9. After file changes, use `isaac-validators` for XML/path checks and `isaac-testing-debugging` for spawn/collision/update verification planning.

When local entity examples are not enough, use this skill's registration,
behavior, visual/collision, and owned-spawn references. Do not require a
third-party mod checkout.

## Route The Entity

- **Entity registration**: XML type/variant/subtype, name, anm2 path, collision fields, shadow, boss/familiar/pickup distinctions. Read `references/entity-registration.md`.
- **Behavior callbacks**: spawn, init, update, render, collision, damage, death/remove, familiar cache, pickup behavior. Read `references/behavior-callbacks.md`.
- **Visuals and collision**: anm2 animation names, sprite lifetime, collision radius, grid collision, contact damage, world-space versus screen-space visuals. Read `references/visuals-and-collision.md`.
- **State lifecycle**: entity `GetData()`, owner player links, saved plain data, room cleanup, reload safety. Use `isaac-state-lifecycle`.
- **Final review**: read `references/entity-review-checklist.md`.

For every spawn, morph, or variant lookup, also read `../isaac-validators/references/owned-spawn-safety.md`.

## Hard Rules

- Do not implement collision or AI with a loose Lua `Sprite`.
- Do not invent type/variant/subtype values. Read current XML and use an explicit `TBD` when allocation is not yet decided.
- Do not assume anm2 animation names. Read the `.anm2` before calling `sprite:Play(...)`.
- Do not store live `Entity`, `Player`, `Sprite`, or callback userdata in persistent save data.
- If the entity is tied to a player, specify the owner key and what happens when the player dies, leaves, or the room changes.
- If the entity can damage enemies or players, specify damage source, collision route, flags, cooldown, and whether it can self-trigger loops.
- If this is only a decorative effect, say so and route back to `isaac-anm2-visuals`.
- Do not spawn a custom entity after a failed name/variant lookup, and do not delete unknown third-party entities to compensate.

## Handoff Prompt Template

```markdown
## Entity Spec

- Entity kind: effect | familiar | tear | laser | knife | pickup | NPC | boss | other
- XML registration:
- Type / variant / subtype:
- ANM2 path and animation names:
- Spawn route:
- Update/AI route:
- Collision and damage route:
- Owner and state lifetime:
- Reset/remove conditions:
- SFX/render/description surfaces:
- Existing examples to read:
- Required tests/manual checks:
```

## Final Review

Before saying entity work is complete, report:

- The entity route and why it is not only a visual sprite.
- The XML registration or existing entity id used.
- Every callback touched.
- The state owner and cleanup path.
- The anm2 path and animation names.
- Any collision, damage, or remove behavior that still needs in-game verification.
