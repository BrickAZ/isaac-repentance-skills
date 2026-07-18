---
name: isaac-state-lifecycle
description: Design, implement, review, or write handoff prompts for state lifecycle in Binding of Isaac Repentance mechanics. Use this whenever a task mentions temporary state, GetData(), local tables, per-player data, room/floor/run reset, challenge-only state, active-item mode, cooldowns, timers, delayed effects, SaveData/LoadData, reload safety, seeded keys, or bugs that persist/leak between rooms, floors, runs, players, or game reloads. Use isaac-mod-context first in an unfamiliar project. 中文触发：状态、临时状态、计时、冷却、换房、换层、重开、死亡、道具丢失、挑战泄漏、存档、读档、延迟结算。
---

# Isaac State Lifecycle

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill whenever a mechanic needs memory.

Keep a user-specified lifecycle boundary unchanged. Treat omitted persistence and reset behavior as `TBD` rather than silently selecting a design rule.

The goal is to make state ownership explicit. Isaac mods often look correct for one room and then break after a room transition, save/reload, second player, item loss, challenge exit, or repeated callback.

This skill owns storage and reset, not the meaning of the mechanic. When trigger, success/failure, exclusion, or settlement is still ambiguous, use `isaac-mechanic-contracts` first.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar project, use `isaac-mod-context` to identify module owners, supported test entry points, and existing state conventions.
2. Identify every piece of state the mechanic needs.
3. Assign each state piece an owner: player, entity, room, floor, run, challenge, item instance, UI mode, or saved mod data.
4. Define when the state is created, updated, read, reset, and destroyed.
5. Record whether the state must survive save/reload. If the user did not specify it, keep save/reload behavior as `TBD`; do not decide it merely from storage convenience.

Read `references/state-ownership.md`, then choose the reset/save references as needed.

## Route The State

- **Runtime owner**: discovered per-player data or a verified player key,
  entity `GetData()`, room-local tables, UI state, active-item mode,
  cooldowns, timers. Read `references/state-ownership.md`.
- **Reset lifecycle**: new room, new level, new run, challenge start/end, player death, item loss, entity remove, game exit. Read `references/reset-lifecycle.md`.
- **Saved data**: `SaveData`, `LoadData`, JSON/plain table serialization, versioning, reload reconstruction. Read `references/savedata.md`.
- **Pending entitlement**: a reward earned now but settled only in a later target context. Define its owner, target, settlement, expiry/carry-over policy, and reset boundary; use `isaac-rewards-pickups` for reward selection/spawn.
- **Final review**: read `references/state-review-checklist.md`.

## Hard Rules

- Do not store live `Entity`, `Player`, `Sprite`, `Room`, or other userdata in saved data.
- Do not key player state by player index alone when twins/co-op or reordering
  can matter. Reuse the current project's per-player data or verified stable
  key; do not recommend a particular seed field without project evidence.
- In an unknown project, name state by purpose and owner, not invented Lua
  field names. Resolve the actual key and field names from discovered code.
- Do not leave room-only effects in run-level tables without room cleanup.
- Do not reset persistent run state on every frame or every render callback.
- Do not mutate gameplay state in pure render callbacks unless the existing repo already uses that exact pattern for a reason.
- If a state can leak into normal runs from a challenge or into other players, add an explicit gate and cleanup rule.
- If the user did not specify persistence, keep save/reload behavior as `TBD`. Temporary runtime state may support the current session, but do not add `SaveData` or describe reload loss as intended design until it is approved.
- A pending reward entitlement must have an owner, target context, settlement condition, and clear/expiry policy. Do not represent it as an unowned global boolean or clear it merely because a target callback fired.

## Handoff Prompt Template

```markdown
## State Lifecycle Spec

- Mechanic:
- State fields:
- State owner:
- Keying strategy:
- Create/update/read callbacks:
- Reset conditions:
- Save/reload behavior:
- Userdata that must not be serialized:
- Leak-prevention gates:
- Pending entitlement target / settlement / expiry policy, if applicable:
- Tests/manual checks:
```

## Final Review

Before saying the stateful mechanic is complete, report:

- Every state owner and key.
- The callbacks that create/update/reset it.
- Whether it is runtime-only or saved.
- How reload, room transition, floor transition, death, and challenge exit behave.
- Any manual in-game lifecycle checks still needed.
