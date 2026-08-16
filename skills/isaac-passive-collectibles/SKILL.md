---
name: isaac-passive-collectibles
description: "Design, implement, review, debug, or write handoff prompts for Binding of Isaac: Repentance passive collectible behavior, ownership/count checks, stat cache evaluation, acquisition/loss, reroll removal, duplicate copies, and co-op isolation. Use whenever a passive item changes player stats or behavior while held, uses MC_EVALUATE_CACHE, AddCacheFlags/EvaluateItems, HasCollectible/GetCollectibleNum, item loss/reacquire, copies, transformations, or passive-owned runtime state. 中文触发：被动道具、被动物品、属性、缓存、MC_EVALUATE_CACHE、AddCacheFlags、EvaluateItems、HasCollectible、GetCollectibleNum、拿到道具、失去道具、重掷、道具数量、多人属性。"
---

# Isaac Passive Collectibles

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use `isaac-mod-context` first in an unfamiliar mod. Discover the actual item
registry, behavior modules, cache conventions, and test entrypoints before
assuming an item id, lookup, or entry file.

## Boundary

This skill owns held-passive behavior: player ownership/count, cache/stat
calculation, acquisition/loss/reacquire, duplicate copies, and per-player
runtime state. `isaac-item-economy` owns quality, pools, weights, tags, and
unlock availability. `isaac-active-item-mechanics` owns active-item shells.
Use `isaac-mechanic-contracts` for nontrivial effect semantics and
`isaac-callback-contracts` for the concrete callback registration contract.

Default to official Isaac APIs. Undeclared third-party helpers remain optional
and must be guarded after project/runtime discovery; do not make them a default
requirement for a passive item.

## Classify the Passive Before Coding

State whether the held item is:

- a pure stat/cache modifier;
- a possession-gated event mechanic;
- an acquisition-once effect;
- a passive that owns a familiar, visual, projectile, or temporary state; or
- a combination, with each part routed to its specialist skill.

Do not implement “on pickup” when the intent is “while held”. A reroll, removal,
duplicate copy, co-op player, or reload can separate those meanings.

## Ownership, Counts, and Cache

Use the discovered item lookup and player ownership/count route. Never use a
hardcoded id after lookup failure, player zero, or a global “item owned” flag.

For every cache/stat change define:

- eligible player and item count semantics;
- cache flag(s), calculation from the current cache value, and stack rule;
- trigger(s) that request a cache refresh; and
- loss/reacquire/duplicate behavior.

Cache evaluation must recompute the intended contribution from current live
ownership/state. Do not accumulate a permanent bonus every cache pass or use
`EvaluateItems` every frame as a substitute for invalidation design. Request a
refresh only when a cache-relevant owned state actually changes.

## Acquisition, Loss, and Runtime State

Separate acquisition edge effects from held effects. Define the repeat boundary
for every grant, transformation, resource change, or notification: once per
pickup event, copy-count increase, player, room, floor, or run.

On removal, reroll, transformation, player death, room/run transition, and
reacquire, decide what reverts, persists, refreshes, or is reconstructed. A
passive-owned familiar, visual, projectile, or timer needs its own owner and
lifecycle contract; do not serialize live entities, players, sprites, or targets.

Do not remove an unfamiliar entity/pickup merely because a player lost this item.
Only clean up objects whose ownership is proven.

## Co-op and Review

Keep ownership, cache contribution, edge state, and cleanup scoped to the actual
player. Test two players with different ownership, both owning the item, multiple
copies, removal for one player, and reacquire after removal.

Read `references/passive-collectible-review.md` before implementation. Do not
claim a stat is correct solely because it appears once; verify cache refresh,
duplicate stacking, loss, and relevant in-game UI/behavior separately.
