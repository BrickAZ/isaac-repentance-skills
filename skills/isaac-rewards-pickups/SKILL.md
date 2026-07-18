---
name: isaac-rewards-pickups
description: 设计、实现、审查或编写《以撒的结合：忏悔》模组的奖励、掉落、Pickup 生成、Morph/替换与失败保留逻辑。适用于奖励、掉落、生成奖励、道具底座、卡牌奖励、心、硬币、钥匙、炸弹、宝箱、Spawn、Morph、替换、重掷、奖励去重、奖励失败、保留原物等请求。陌生项目先使用 isaac-mod-context。
---

# Isaac Rewards and Pickups

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when the question is what a reward should be and how an owned
pickup should be selected, spawned, replaced, or preserved. It complements
`isaac-entities`: entity safety answers whether a target is registered and
safe to create; this skill answers which target is appropriate, whether it may
repeat, and what happens when selection or replacement fails.

## First Move

1. In an unfamiliar project, use `isaac-mod-context` to identify owned registries, module roots, and relevant content XML.
2. Read `../isaac-mod-context/references/design-authority.md`.
   Lock explicit reward type, count, source, and replacement intent; leave
   omissions as `TBD` or labeled suggestions.
3. Read the mechanic contract or write one with `isaac-mechanic-contracts`:
   trigger, reward owner, repeat boundary, and failure policy come before
   choosing `Isaac.Spawn` or `Pickup:Morph`.
4. Classify the reward source: fixed vanilla content, registered custom
   content, item/card pool, curated list, or an existing pickup to morph.
5. Inspect the closest current-project reward path before copying a pattern.
   If none exists, use this skill's selection and fallback references.
6. Read `../isaac-validators/references/owned-spawn-safety.md` before creating a
   custom target or handling a configurable card/pickup id.
7. If a custom world-pickup visual is requested, read `references/official-world-pickup-baselines.md`. Do not generate art for a normal official subtype spawn.

## Core Contract

Produce a short **Reward/Pickup Contract** before implementation:

```text
Trigger:
Reward owner:
Source and allowed candidates:
Selection rule:
Repeat and de-duplication boundary:
Spawn or Morph target:
Failure policy:
Pickup confirmation evidence, if collision starts the path:
Pending entitlement / fulfillment timing, if delayed:
Original-pickup preservation:
Third-party compatibility boundary:
Locked / approved / TBD / suggestions:
```

Use the decision block from the shared authority rule. A number or subtype
missing from the request is not permission to invent balance values.

## Selection Before Spawning

Read [reward-selection.md](references/reward-selection.md). In particular:

- Validate a candidate before it reaches `Isaac.Spawn`, `game:Spawn`,
  `GetCollectible`, `GetCard`, or `Pickup:Morph`.
- A number that is non-zero, a table field that exists, or a `pcall` that did
  not throw is not proof that a reward is usable.
- Never substitute `0`, `-1`, or an arbitrary random subtype for an invalid
  requested reward.
- Make the repeat boundary explicit: per event, room, floor, player, pickup,
  or run. Do not accidentally turn a retry loop into duplicate rewards.
- Do not treat unknown third-party cards or pickups as invalid merely because
  they are absent from the current project's registries.

## Spawn, Morph, and Failure

Read [spawn-morph-fallback.md](references/spawn-morph-fallback.md).

- Spawn only after the final candidate has passed its source-specific check.
- When a collision begins a one-time side effect, read [pickup-confirmation.md](references/pickup-confirmation.md); collision is not acquisition proof.
- When a reward is earned now but must spawn later, read [deferred-entitlements.md](references/deferred-entitlements.md); a pending entitlement is not an already-spawned reward.
- For Morph, keep the original pickup intact until the replacement candidate
  is proven usable. If selection or registration fails, preserve the original.
- Optional rewards fail closed: log or skip the owned reward instead of
  spawning an empty shell. Replacement rewards fail by preserving the source.
- Record the position, velocity, owner/spawner, seed policy, and price/options
  semantics when the pickup type requires them.

## Routes

| Need | Primary skill |
| --- | --- |
| Registered custom card, rune, pill, or soul stone | `isaac-cards-pockets` |
| A custom entity or familiar/effect target | `isaac-entities` |
| Normal run availability, pools, quality, and weights | `isaac-item-economy` |
| Callback timing/filter for a reward trigger | `isaac-callback-contracts` |
| Once-per-room/floor/player reward memory or pending entitlement lifecycle | `isaac-state-lifecycle` |
| Event semantics, exclusions, and ownership | `isaac-mechanic-contracts` |
| Custom world-pickup visual format | `references/official-world-pickup-baselines.md` plus `isaac-anm2-visuals` |

## Hard Rules

- The user decides reward intent and balance values. Suggestions are labeled
  and require approval before becoming behavior.
- Validate ids and registrations at the owning boundary; do not rely on a
  spawning API to make a blank or missing content type meaningful.
- Do not globally intercept unrelated pickups to enforce a local reward rule.
- Preserve third-party content unless the mechanic explicitly owns and targets
  it. Unknown external custom content is not a license to delete, morph, or
  replace it.
- `pcall`, a non-nil object, or a numeric subtype alone is not a reward
  validator.
- A pickup collision alone is not proof that the pickup was acquired or that a
  pending side effect may settle.
- Spawning an existing official subtype does not require new art. Generate pickup art only for a requested custom world-pickup visual, using the matching official frame baseline unless the user or project explicitly overrides it.

## Review and Test

Use [reward-review-checklist.md](references/reward-review-checklist.md).
For every reward path, cover the valid candidate, invalid/missing candidate,
repeat attempt, and an untouched third-party or unrelated pickup where that
boundary exists.
