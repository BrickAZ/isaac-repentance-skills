---
name: isaac-npc-boss-ai
description: Design, implement, review, or write handoff prompts for custom NPC and Boss AI in Binding of Isaac Repentance mods. Use this when a task mentions boss phases, MC_NPC_UPDATE, NPC state machine, attack selection, projectile patterns, pathfinding, boss death, minions, invulnerability, room-clear timing, or custom enemy behavior. 中文触发：Boss、NPC AI、敌人行为、阶段转换、攻击状态机、弹幕、追踪、无敌、召唤小怪、Boss 死亡、房间清理。
---

# Isaac NPC And Boss AI

Use this skill when a registered enemy needs behavior, not merely an
`entities2.xml` entry or visual asset.

## First Move

Use `isaac-mod-context` to find the entity registration, existing NPC module,
callback conventions, projectile helpers, room-clear behavior, and dependency
facts. Then write the state and phase contract in
`references/npc-state-machine.md` before selecting callbacks.

## High-Priority Official Boss-Portrait Suggestion

When a custom Boss needs a native portrait and the user has not supplied a compatible asset, read `../isaac-anm2-visuals/references/official-native-ui-baselines.md`.

- Recommend a 192x192 single-Boss portrait and discover the project's portrait XML/resource mapping before registering it.
- If generation is requested, generate a 192x192 portrait and connect it through that discovered mapping.
- A wider multi-Boss portrait is only a user-explicit or project-established override. Do not invent a combined layout from an arbitrary image size.
- Boss portrait art is separate from Boss AI, Boss Bars, versus screens, and a normal NPC animation.
## Route The Work

- **Registration and visuals**: use `isaac-entities` and `isaac-anm2-visuals`.
- **State and callbacks**: use `isaac-callback-contracts` for callback timing
  and return contracts; this skill owns NPC state/phase design.
- **Projectiles, minions, and rewards**: use `isaac-rewards-pickups` for
  reward selection and owned-spawn failure behavior.
- **Room/floor cleanup**: use `isaac-state-lifecycle` for lifetime outside the
  NPC's own `GetData()`.
- **StageAPI or other helpers**: use them only when declared required or as a
  guarded optional integration. Official NPC APIs remain the default.

## Hard Rules

- Keep state on the NPC instance or a verified per-entity owner; never share a
  phase variable across all bosses unless the encounter explicitly owns it.
- Define phase entry once: health threshold, trigger, animation transition,
  invulnerability policy, and exit condition.
- Validate every spawned minion/projectile target before spawning. A missing
  custom variant must skip the owned attack, not use `0`, `-1`, or an arbitrary
  raw fallback.
- Do not use render callbacks to advance AI, damage, phase, or spawn state.
- Do not treat an animation name as an AI state until the ANM2 confirms it.
- Define death/reward/room-clear ordering so repeated death callbacks cannot
  duplicate rewards or leave the room permanently uncleared.
- Keep user-provided phase thresholds locked. Only unspecified edge-case
  policy, such as scaling or interruption behavior, remains `TBD`.
- In an unknown project, label phases by semantic purpose. Do not present
  placeholder state fields, callback names, or `InitSeed` as a universal
  persistence/entity-key solution; discover the project's per-entity owner.

## Handoff Prompt Template

```markdown
## NPC/Boss State Contract

- Registered type/variant/subtype:
- State owner and initial state:
- States, entry guards, and exit guards:
- Health/phase thresholds:
- Animation names (verified):
- Projectile/minion owned targets:
- Damage and invulnerability policy:
- Death, reward, and room-clear order:
- Optional dependencies and official fallback:
- Required static and in-game checks:
```

## Final Review

Report every state transition, spawned target, phase threshold, death gate,
and checks for two instances, interrupted attacks, room exit, and reload when
those paths exist.
