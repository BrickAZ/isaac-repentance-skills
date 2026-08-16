---
name: isaac-grid-entities
description: "Use when designing, implementing, reviewing, debugging, or writing handoff prompts for Binding of Isaac: Repentance room grid entities and obstacles, including `GridEntity`, `GridEntityType`, grid index/position conversion, rocks, pits, spikes, TNT, poop, pressure plates, doors as grid surfaces, collision, pathfinding, destruction, replacement, room revisit persistence, and custom-grid extension boundaries. This skill distinguishes engine grids from normal entities and room topology so agents do not place illegal grids, use world coordinates as grid indexes, or erase foreign room state. 中文触发：GridEntity、网格实体、格子、岩石、坑、地刺、TNT、障碍、网格索引、格子坐标、网格碰撞、破坏网格、重进房间恢复、自定义网格。"
---

# Isaac Grid Entities

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Core Principle

A grid entity is room-owned spatial state. Its identity is not just a visible
sprite or world position: room grid index, legal placement, type/variant/state,
collision, destruction, and room persistence must agree.

Use official Isaac APIs and the target project's proven room lifecycle by
default. Treat StageAPI, REPENTOGON, CuerLib, or another custom-grid framework
as optional until the project explicitly declares and guards it.

## Boundary

This skill owns engine grid identity, grid coordinates, legal placement,
collision/pathing, mutation, destruction, and revisit reconciliation.

- Use `isaac-rooms-stages` for room data, map topology, room replacement, stage
  selection, door adjacency, and transition authority.
- Use `isaac-room-networks` for connections among multiple owned rooms.
- Use `isaac-entities` when the obstacle is actually a normal entity/effect with
  HP, AI, callbacks, collision classes, or `entities2.xml` registration.
- Use `isaac-stageapi-compat` or `isaac-repentogon-compat` only after the target
  project proves that extension owns a custom-grid route.
- Use `isaac-state-lifecycle` when custom serializable grid state must survive
  beyond the engine's native room persistence.

## First Move

1. Use `isaac-mod-context` in an unfamiliar mod. Discover room creation/entry
   callbacks, grid helpers, extension dependencies, room data, mutation owners,
   persistence state, and tests.
2. Read `references/grid-lifecycle-contract.md` and classify the requested
   surface: existing native grid mutation, newly spawned native grid, normal
   entity pretending to be an obstacle, or extension-backed custom grid.
3. Keep grid type/variant/state, count, placement policy, collision behavior,
   destructibility, drops, persistence, and room-clear effect as user decisions
   unless the request or project already fixes them.
4. Prove coordinate conversion and lifecycle timing before mutating the room.

## Grid Contract

| Field | Required fact or decision |
| --- | --- |
| Room identity | Current descriptor/room seed/context and ownership |
| Grid identity | Verified type, variant/state, extension identity, or normal-entity route |
| Location | Grid index derived by room API and corresponding world position |
| Legality | Bounds, shape, door slots, pits/walls, occupied cells, reserved positions |
| Collision | Player, NPC, projectile, bomb, pathfinding, flying, and spectral behavior |
| Mutation | Spawn, replace, damage, destroy, remove, repair, or visual-only change |
| Persistence | Current visit, room revisit, floor, continue, reload, and room regeneration |
| Side effects | Drops, room clear, secret access, door state, sounds, particles, achievements |
| Ownership | How the mod recognizes only the grid cells it may later modify or remove |

## Hard Rules

- Never pass a world `Vector`, room map coordinate, room descriptor index, or
  arbitrary number where the API expects a room grid index. Use the discovered
  room conversion methods and verify the round trip.
- Generate placement candidates from the live room shape and grid facts. Reject
  out-of-bounds cells, invalid shape cells, door/transition slots, occupied or
  reserved cells, and any project-specific exclusion before mutation.
- Do not treat a debug/goto room, negative room index, or mock “always legal”
  room as proof that normal map rooms support the placement.
- Do not invent a new `GridEntityType`, custom grid registration API, or XML
  surface. If official APIs cannot express the requested custom grid, report the
  normal-entity or declared-extension alternatives as separate routes.
- Mutate only grids this mod explicitly owns or cells the mechanic explicitly
  authorizes. Unknown grids can belong to the room, base game, or another mod.
- Preserve native destruction, collision, pathfinding, room-clear, door, and
  drop behavior unless the approved mechanic deliberately replaces each
  affected result.
- A visual sprite placed over a cell does not change grid collision. A collision
  change without matching visuals can still create an invisible wall or pit.
- Do not rely on immediate read-after-write if the discovered engine/extension
  creates or rebuilds grid state on a later lifecycle edge. Verify after the
  correct room/update callback.
- Keep runtime references short-lived. Do not serialize `GridEntity`, room,
  level, sprite, or other userdata; persist only approved serializable cell/state
  data and reconcile it against the live room.
- Use the room/project RNG stream for gameplay placement and drops. Do not use
  cosmetic randomness or global unseeded randomness for grid selection.
- Avoid full-room grid scans in every update. Build/reconcile on room lifecycle
  or a proven dirty event, and cache only facts that remain valid.

## Verification

Test valid and invalid cells, every relevant room shape, door/reserved cells,
occupied-cell conflict, collision/pathfinding, destruction and drops, room
clear, revisit, floor transition, continue/reload, and another mod/base room grid
remaining untouched. Include co-op/flying/spectral behavior when relevant.

Static checks can prove API calls, ownership markers, and conversion flow. Mocks
must model real room bounds, occupied cells, and delayed mutation timing rather
than accepting every candidate. Collision, pathfinding, destruction, native
room persistence, and rendering require in-game verification.

## Required Output

```markdown
## Grid Entity Contract

- Route: native existing | native spawn | normal entity | declared extension
- Room identity and lifecycle edge:
- Grid type/variant/state or entity identity:
- Grid index/world-position conversion:
- Candidate generation and legality checks:
- Collision/pathfinding behavior:
- Mutation, destruction, and side effects:
- Ownership marker and foreign-grid boundary:
- Revisit/continue persistence and reconciliation:
- Companion skills and API/dependency facts to discover:
- Static, isolated, and in-game verification:
- User decisions required:
```
