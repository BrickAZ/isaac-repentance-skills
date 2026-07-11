---
name: isaac-rooms-stages
description: Design, implement, review, or write handoff prompts for custom rooms, floors, stage transitions, room selection, doors, grids, and room-scoped rules in Binding of Isaac Repentance mods. Use this when a task mentions room XML, RoomConfig, MC_POST_NEW_ROOM, MC_POST_NEW_LEVEL, special room, floor rule, stage, door, transition, room replacement, room layout, or StageAPI. 中文触发：房间、房间 XML、特殊房、楼层、Stage、门、转场、房间替换、房间布局、房间规则、StageAPI。
---

# Isaac Rooms And Stages

Use this skill for world and level structure. A challenge-only room restriction
belongs to `isaac-challenges`; a single entity behavior belongs to
`isaac-entities` or `isaac-npc-boss-ai`.

## First Move

Use `isaac-mod-context` to discover actual room XML, room loaders, level
callbacks, room identifiers, grid/door conventions, and dependency facts. Read
`references/room-stage-contract.md` before implementing selection or
replacement behavior.

## Route The Work

- **Official room/floor route**: prefer existing room XML, official level and
  room APIs, and current project loaders.
- **StageAPI route**: use only when the project declares it required or when a
  guarded optional integration is specifically requested. It is never the
  default answer for a room problem.
- **Room-local state**: use `isaac-state-lifecycle` for once-per-room/floor
  flags, cleanup, and save boundaries.
- **Room content**: route NPC behavior to `isaac-npc-boss-ai`, rewards to
  `isaac-rewards-pickups`, and custom entities to `isaac-entities`.

## Hard Rules

- Do not assume room XML paths, stage ids, dimensions, doors, or layout names.
- Define selection separately from mutation: prove a room qualifies before
  replacing grids, doors, entities, or rewards.
- State the owner and reset boundary for every room/floor rule. Do not let a
  room-local flag leak into a new room, level, normal run, or unrelated stage.
- Preserve unknown third-party room content unless the mechanic explicitly
  owns and targets it.
- Do not make StageAPI, MinimapAPI, or another third-party library mandatory
  without a project declaration or explicit user decision.
- Use stable room/stage identity from the discovered project/API; do not use a
  display name as a persistent key.
- Separate an eligibility attempt from a committed once-per-floor/room success.
  Commit the success flag only after every owned target is valid and mutation
  completes. A failed target must preserve the original content and must not
  silently consume the success unless the user approves that policy.

## Handoff Prompt Template

```markdown
## Room/Stage Contract

- Discovered room/stage registration route:
- Selection conditions:
- Mutation targets and ownership:
- Official API path / optional library path:
- Room and floor state owner:
- Reset and save boundaries:
- Door/grid/entity/reward sibling skills:
- Third-party preservation policy:
- Required static and in-game checks:
```

## Final Review

Report the actual room/stage identifiers, selection gate, state reset points,
mutation ownership, optional dependencies, and tests across new room, new
floor, continue, and unrelated rooms.
