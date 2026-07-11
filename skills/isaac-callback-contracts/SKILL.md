---
name: isaac-callback-contracts
description: Select, register, review, debug, or write handoff prompts for Binding of Isaac Repentance Lua callbacks. Use this whenever a mechanic is understood but Codex may choose the wrong callback, callback timing, registration filter, handler signature, return value, cache refresh, damage source filter, priority, duplicate registration, or callback test. Use isaac-mod-context first in an unfamiliar project. 中文触发：回调、callback、回调不触发、挂回调、注册、参数过滤、返回值、true false nil、缓存刷新、MC_EVALUATE_CACHE、MC_ENTITY_TAKE_DMG、MC_USE_ITEM、MC_GET_CARD、时机错误、重复注册。
---

# Isaac Callback Contracts

Use this skill after `isaac-mechanic-contracts` defines what a mechanic means and before implementation chooses a Lua callback.

The goal is to close the gap between a correct mechanic and a callback that silently never fires, fires too early, fires for unrelated content, returns the wrong control value, or is registered twice.

## First Move

Before changing callback code:

1. In an unfamiliar project, use `isaac-mod-context` to identify the mod object, bootstrap, behavior modules, and test entry points.
2. Read the Mechanic Contract if the behavior has conditions, failure paths, exclusions, or state transitions.
3. State the exact event the callback must observe or control.
4. Read the closest current-project callback and its behavior test.
4. Select the narrowest callback and filter that can express the intended event.
5. Define what every non-`nil` return means for that specific callback from a local known-good reference or the Isaac API reference; never generalize `true`/`false` across callbacks.

Read the relevant reference:

- Callback choice, timing, and filtering: `references/callback-choice-and-filters.md`.
- Registration, handler existence, return contracts, priority, and duplicates: `references/registration-and-return-contracts.md`.
- Review and test matrix: `references/callback-review-checklist.md`.

## Callback Families

- **Stats**: `MC_EVALUATE_CACHE`, cache flags, and `AddCacheFlags` refresh paths. Use the current project's item/stat implementation surface.
- **Active use**: `MC_USE_ITEM` / `MC_PRE_USE_ITEM`, item filter, active slot, and callback-specific charge/return behavior. Use `isaac-active-item-mechanics` only for shell details.
- **Damage**: `MC_ENTITY_TAKE_DMG`, entity filter, source/flag exclusions, cancellation/re-entry behavior. Use the current project's item/damage surface and `isaac-mechanic-contracts`.
- **Cards and generation**: `MC_USE_CARD`, `MC_USE_PILL`, `MC_GET_CARD`, and ownership gates. Use `isaac-cards-pockets`.
- **Rewards and pickups**: room-clear drops, spawn/replacement events, owned Morph paths, and reward repeat boundaries. Use `isaac-rewards-pickups` for candidate and fallback policy.
- **Entities**: fire/update/collision/kill/spawn callbacks, type/variant/subtype filters. Use `isaac-entities`; use `isaac-projectile-combat` when the entity is a player/familiar-owned tear, laser, knife, bomb, or attack projectile.
- **Lifecycle**: new room, new level, game start, update, render, input. Use `isaac-state-lifecycle` for state ownership and reset.

## Hard Rules

- A callback registration must name an existing handler and have one clear owner.
- Do not use `MC_POST_RENDER` to mutate core gameplay state unless the current repo has a documented reason.
- Do not use broad callbacks without an item/entity/card/challenge filter when a narrow filter exists.
- Do not infer a callback's return behavior from another callback. Record the exact return policy beside the handler or in the handoff.
- When a state changes outside cache evaluation, specify the `AddCacheFlags` / `EvaluateItems` refresh path.
- A pre-spawn or generation callback must gate only replacements owned by the current mechanic; do not globally affect unknown third-party content.
- Reward numbers, candidates, and replacement intent are design decisions. Do not invent them while selecting a callback.
- Add a behavior test that proves the callback was registered, accepts an eligible event, rejects an excluded event, and follows the intended return path.

## Required Output

```markdown
## Callback Contract

- Mechanic event:
- Selected callback:
- Why earlier/later callbacks are wrong:
- Registration filter:
- Handler and signature:
- Input fields used:
- Return policy for this callback:
- Cache refresh path, if any:
- State/owner dependency:
- Duplicate/priority policy:
- Excluded events:
- Existing example and test to read:
- Required callback tests:
```

## Final Review

Before saying callback work is complete, report the selected callback, registration line, filter, handler, return policy, cache refresh path, and the tests that prove both firing and non-firing cases.
