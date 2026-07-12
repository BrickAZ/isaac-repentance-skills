---
name: isaac-item-synergies
description: Design, implement, review, or write handoff prompts for Binding of Isaac Repentance content synergies that require two or more qualifying inputs, such as collectibles, trinkets, cards, player forms, familiars, or explicitly supported mod content. Use this when a combined effect needs eligibility, per-player ownership, precedence, duplicate prevention, loss/reroll retraction, or third-party compatibility boundaries. Use isaac-mod-context first in an unfamiliar project. 中文触发：道具联动、组合效果、同时拥有、A 加 B、协同、套装、联动优先级、联动失效、失去其中一个、重掷后联动、合作联动。
---

# Isaac Item Synergies

Use this skill for an effect that exists only because a defined combination is
currently true. It owns the combination contract, not either input's base
behavior, callback signature, state storage, economy, or assets.

## First Move

1. In an unfamiliar project, use `isaac-mod-context` to discover the mod
   object, behavior owner, content registration, existing compatibility
   policy, and tests.
2. Write the inputs, required quantities, holder scope, and result as a
   sentence before choosing callbacks: "When [owner] has [inputs], [result]
   applies until [exit condition]."
3. Mark every unspecified input id, count, value, priority, target, and
   supported external mod as `TBD`. Do not invent a synergy because two names
   sound related.
4. Read `references/synergy-contract.md`; use
   `references/synergy-review-checklist.md` before completion.

## Choose The Boundary

- **Single-content base behavior**: route to `isaac-collectibles`,
  `isaac-trinkets`, `isaac-cards-pockets`, or `isaac-familiars`. Do not put
  its ordinary effect in a synergy handler.
- **Combination qualification and precedence**: keep it here.
- **Callback selection, filter, and return policy**: use
  `isaac-callback-contracts` after the contract is settled.
- **Runtime state, reset, SaveData, or removal cleanup**: use
  `isaac-state-lifecycle`; when a content change is the exit event, also use
  `isaac-reroll-removal-contracts`.
- **A spawned attack, pickup, or visual**: route the implementation surface to
  `isaac-projectile-combat`, `isaac-rewards-pickups`, or
  `isaac-anm2-visuals`.

## Qualification And Ownership

- Evaluate the full input set for the actual player or entity that will
  receive the result. Never use player zero, a global "any holder" flag, or a
  shared count as a substitute for co-op ownership.
- Record whether each input is a boolean, count, state, form, room condition,
  or explicit external compatibility condition. A golden/stacked copy only
  changes the result if the design explicitly says how.
- Resolve a player/familiar/projectile source from project evidence. Similar
  type, variant, `SpawnerEntity`, or a shared collectible id is not enough to
  claim ownership of foreign content.
- Use one named eligibility predicate or equivalent contract. Do not scatter
  partially different `HasCollectible` checks across update, damage, and
  render handlers.

## Effect, Priority, And Retraction

- Define whether the result is a cache modifier, event response, marker,
  owned spawn, temporary state, or replacement. Choose one primary authority;
  do not apply the same synergy from both a cache callback and frame update.
- State its precedence relative to other effects only when the user or project
  establishes one. Otherwise leave priority as `TBD`; do not silently cancel
  unrelated vanilla or mod behavior.
- Make repeat behavior explicit: once per copy, once per room, once per
  target, every qualified event, or another user-approved rule.
- Define the exit path before implementation. Losing, rerolling, morphing,
  copying, transforming, or replacing an input must retract only state,
  entities, and markers owned by this synergy. Re-check qualification after
  reconciliation instead of deleting all matching vanilla entities.

## Compatibility Rules

- Official Isaac APIs and discovered project helpers come first. An undeclared
  third-party library or another mod's item is optional, guarded, and cannot
  be a required default path.
- Do not globally intercept all tears, pickups, damage, or item changes just
  to find a synergy. Filter to the discovered owner and explicit inputs.
- Keep unknown content neutral. Absence of a known marker, id, or optional mod
  means this synergy does nothing to it.
- Do not use a low chance, a late cleanup pass, or a broad cancellation return
  as a substitute for a clear ownership boundary.

## Required Output

```markdown
## Synergy Contract

- Inputs and quantities:
- Owner scope and source proof:
- Eligibility predicate:
- User decisions locked as-is:
- Missing design decisions (`TBD`):
- Result and primary authority:
- Callback/filter/return policy:
- Stacking and repeat boundary:
- Precedence and incompatibilities:
- Content-change/retraction path:
- State and persistence boundary:
- Optional dependency policy:
- Automated tests and in-game checks:
```

## Final Review

Report the exact inputs, eligible owner, result authority, callback route,
repeat guard, retraction behavior, and what remains to verify in game. Never
claim a synergy is compatible with another mod unless its presence and API
were discovered and tested.
