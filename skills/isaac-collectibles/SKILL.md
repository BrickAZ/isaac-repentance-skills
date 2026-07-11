---
name: isaac-collectibles
description: "Design, implement, review, or write handoff prompts for passive collectible items in Binding of Isaac: Repentance mods: registration, player ownership, copy/stack policy, cache-driven stats, reactive effects, state cleanup after loss or reroll, and co-op boundaries. Use when a request concerns a passive collectible, item ownership, HasCollectible, GetCollectibleNum, MC_EVALUATE_CACHE, cache refresh, item loss, reroll, or a passive item's damage-triggered effect. Use isaac-active-item-mechanics for active-item shell details and isaac-callback-contracts for exact callback contracts. 中文触发：被动道具、收集品、collectible、属性道具、持有道具、叠加道具、复制道具、缓存属性、MC_EVALUATE_CACHE、道具移除、重掷道具、受伤触发道具。"
---

# Isaac Collectibles

Use this skill for a passive collectible item. Its job is to establish the
item's ownership, stacking, cache, state, and cleanup contract before the
implementation is spread across callbacks.

It does not decide item quality, pools, weights, art, names, or balance. It
does not replace the callback, entity, reward, or active-item specialist
skills.

## First Move

Before editing or writing a handoff prompt:

1. In an unfamiliar mod, use `isaac-mod-context` to discover the real mod
   object, item metadata, load path, passive-item examples, and validation
   entry points. Do not assume `main.lua`, `items.xml`, or a fixed layout.
2. Read the closest current-project passive collectible. Confirm how the
   project gets its item ID, checks ownership, handles copies, and refreshes
   cache values.
3. Read `references/passive-item-contract.md` and make the item contract
   explicit before selecting callbacks.
4. Read the route reference that applies: cache/stacking, reactive behavior,
   or final review.

When no local passive item exists, use this skill's references as the generic
fallback. Do not require YSD, Reverie, CuerLib, EID, MCM, StageAPI, or another
mod checkout.

## Route The Item

Classify the item into one or more routes. A single item can use more than one,
but each route keeps one authority.

| Route | Use it for | Primary authority |
| --- | --- | --- |
| Registration and ownership | New collectible metadata, item ID lookup, holder scope, copies, item loss, or reroll | This skill plus discovered project metadata |
| Cache stats | Damage, fire delay, speed, tears, range, luck, shots, familiars, or other cache-backed values | `MC_EVALUATE_CACHE` and the project's cache-refresh pattern |
| Reactive behavior | Damage reactions, room events, kills, firing, pickups, timers, or conditional effects | `isaac-mechanic-contracts` then `isaac-callback-contracts` |
| Runtime state | Cooldowns, charges internal to a passive, counters, per-room flags, timed windows, or saved progression | `isaac-state-lifecycle` |
| Entities, rewards, visuals | Spawned gameplay entities, pickups, ANM2/Sprite feedback, SFX, shaders, or render effects | The matching sibling skill |

Read `references/cache-and-stack-policy.md` for cache-backed stats and copy
policy. Read `references/reactive-effects-and-cleanup.md` before a passive
item reacts to damage or another event.

## Hard Rules

- State whether one copy is enough or every copy changes the effect. Do not use
  a boolean ownership check where the item is intentionally stackable, and do
  not multiply an effect merely because the player can own copies.
- Treat every player as a separate potential owner. Do not use the first player
  or a global item count as authority for a co-op effect.
- Keep `MC_EVALUATE_CACHE` deterministic: derive the stat from current player
  ownership, copy count, and explicit state. Do not create entities, roll RNG,
  consume pickups, or mutate unrelated state there.
- When a state change affects a cache-backed stat, use the discovered
  `AddCacheFlags` / `EvaluateItems` refresh pattern. State which flag changes
  and why; do not refresh every cache flag by habit.
- Define what happens after item loss, reroll, transformation, player death,
  room transition, run restart, and reload when each can affect the item. Clear
  runtime state that no longer has an eligible owner.
- A reactive passive item must have a Mechanic Contract before choosing a
  callback. For damage interception, use `isaac-callback-contracts` to confirm
  the exact `MC_ENTITY_TAKE_DMG` filter, signature, return policy, source and
  flag exclusions, and re-entry behavior. Never globally cancel damage merely
  because any player owns the item.
- Do not use this skill to choose pools, weight, quality, `DecreaseBy`,
  `RemoveOn`, tags, or unlock values. Route those decisions to
  `isaac-item-economy`.
- Do not invent item IDs, XML fields, asset paths, cache formulas, callback
  signatures, or third-party helpers. Keep missing facts as `TBD`.

## Required Output

```markdown
## Passive Collectible Contract

- Item identity and discovered metadata source:
- Behavior summary:
- User decisions (locked):
- Missing design fields (TBD):
- Holder scope and co-op policy:
- Copy / stack policy:
- Cache routes and refresh triggers:
- Reactive routes and sibling callback skills:
- Runtime state owner, key, and lifetime:
- Item loss / reroll / death / room / run cleanup:
- Entity, reward, visual, economy, or active-item handoffs:
- Existing examples to read:
- Static, isolated, and in-game checks:
```

## Final Review

Before saying a passive collectible is complete, report:

- How ownership and copy count are determined for each player.
- Every cache flag and the condition that refreshes it.
- The exact cleanup behavior when the item is lost or the owner is no longer
  eligible.
- Every reactive callback as a separate Callback Contract.
- Which fields remain design decisions or still require in-game testing.
