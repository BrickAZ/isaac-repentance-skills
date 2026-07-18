---
name: isaac-rooms-stages
description: Design, implement, review, or write handoff prompts for custom rooms, floors, stage transitions, room selection, doors, grids, and room-scoped rules in Binding of Isaac Repentance mods. Use this when a task mentions room XML, RoomConfig, MC_POST_NEW_ROOM, MC_POST_NEW_LEVEL, special room, floor rule, stage, door, transition, room replacement, room layout, or StageAPI. 中文触发：房间、房间 XML、特殊房、楼层、Stage、门、转场、房间替换、房间布局、房间规则、StageAPI。
---

# Isaac Rooms And Stages

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill for world and level structure. A challenge-only room restriction
belongs to `isaac-challenges`; a single entity behavior belongs to
`isaac-entities` or `isaac-npc-boss-ai`.

## First Move

Use `isaac-mod-context` to discover actual room XML, room loaders, level
callbacks, room identifiers, grid/door conventions, and dependency facts. Read
`references/room-stage-contract.md` and `references/room-topology-door-validation.md` before implementing selection or
replacement behavior.

## Route The Work

- **Official room/floor route**: prefer existing room XML, official level and
  room APIs, and current project loaders.
- **StageAPI route**: use only when the project declares it required or when a
  guarded optional integration is specifically requested. It is never the
  default answer for a room problem.
- **Room-local state**: use `isaac-state-lifecycle` for once-per-room/floor
  flags, cleanup, and save boundaries.
- **Topology and doors**: prove actual room-map identity, available neighboring slots, and each candidate door/portal position before choosing an official API or mutation.
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

- Treat a console/debug/goto room as an isolated test surface unless discovered runtime facts prove normal map-grid identity and adjacency. Reloading that room does not create a second real room.
- Before creating a door, portal, or neighboring-room transition, discover the current room descriptor/grid position, applicable door slots, neighboring-room availability, and collision or grid legality. Generate candidates from those facts; do not rely on fixed coordinates alone.
- If no legal candidate exists, skip only the owned addition, preserve existing doors/content, and do not commit a success flag. Do not close or delete unrelated doors to make a topology appear valid.
- Do not promise that an official-looking door API creates a valid adjacent room until its preconditions and observed result are proven for the discovered room context.
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
- Room topology, legal candidate source, and no-candidate policy:
- Third-party preservation policy:
- Required static and in-game checks:
```

## Final Review

Report the actual room/stage identifiers, selection gate, state reset points,
mutation ownership, optional dependencies, and tests across new room, new
floor, continue, unrelated rooms, legal door candidates, no-candidate behavior,
and a real normal-floor topology check separate from any debug room.
