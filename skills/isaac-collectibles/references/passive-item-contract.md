# Passive Item Contract

Use this reference before choosing a passive item's Lua shape.

## Facts To Discover

- The item metadata/XML source, item ID lookup, and declared item type.
- The closest passive item that reads the same kind of ownership or copies.
- The existing player iteration and co-op-safe owner/key convention.
- The project's cache refresh helper or direct cache-refresh pattern.
- The lifecycle events that rebuild or clear item-owned state.
- The existing test runner and the boundaries that require actual in-game work.

## Contract Fields

| Field | Decide explicitly |
| --- | --- |
| Holder | Which player owns the effect, and can another player trigger it? |
| Copy policy | One effect while held, linear copies, capped copies, or another user-approved formula? |
| Trigger | Continuous cache evaluation, an event, a room/run transition, or a combination? |
| State | Does the item need runtime counters, cooldowns, targets, or a timed window? |
| Loss | What must refresh or clear after reroll, removal, transformation, death, or restart? |
| Presentation | Is feedback required, and does it belong to a Lua Sprite, Effect entity, sound, shader, or HUD route? |

Keep omitted behavior as `TBD`. A skill may recommend a route, but must not
invent the item's power, duration, chance, cap, or stack formula.

## Route Boundaries

- Passive item registration and holder semantics belong here.
- Pool, quality, tags, weight, depletion, and unlock availability belong to
  `isaac-item-economy`.
- Exact callback timing, filters, handler signatures, and returns belong to
  `isaac-callback-contracts`.
- State keys, SaveData, and reset ownership belong to `isaac-state-lifecycle`.
- Spawned entities, rewards, and visuals belong to their respective skills.
