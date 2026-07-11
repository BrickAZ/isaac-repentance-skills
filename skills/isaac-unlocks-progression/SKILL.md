---
name: isaac-unlocks-progression
description: Design, implement, review, or write handoff prompts for unlock conditions, achievements, persistent progression, content availability gates, and one-time rewards in Binding of Isaac Repentance mods. Use this when a task mentions unlock, achievement, completion mark, progression, persistent flag, SaveData, unlockable item, challenge completion, character unlock, one-time reward, or run-to-run availability. 中文触发：解锁、成就、完成印记、进度、永久标记、存档、可解锁道具、挑战完成、角色解锁、一次性奖励。
---

# Isaac Unlocks And Progression

Use this skill when content availability changes across runs. It does not
decide whether a reward is balanced; use `isaac-item-economy` or the user for
that decision.

## First Move

Use `isaac-mod-context` to find existing save/progression data, achievement or
challenge hooks, unlock XML/metadata, content gates, migration/versioning, and
test entrypoints. Then write the Progression Contract in
`references/progression-contract.md`.

## Route The Work

- **Condition semantics**: challenge, character, boss, run result, or event
  contract belongs to `isaac-mechanic-contracts` and `isaac-callback-contracts`.
- **Persistent storage**: use `isaac-state-lifecycle` for SaveData, load,
  migration, and reset details.
- **Content availability**: use `isaac-item-economy` for pool/availability
  effects and `isaac-rewards-pickups` for a concrete one-time reward.
- **Player/challenge completion**: use `isaac-players-characters` or
  `isaac-challenges` when those systems own the condition.

## Hard Rules

- Keep unlock condition, persistence key, grant action, and availability gate
  as separate fields. A saved flag alone is not an unlock implementation.
- Grant idempotently: repeated callbacks, continue, reload, and multiple
  players must not duplicate a one-time reward or corrupt progression.
- Save only durable progression. Room timers, temporary visuals, and ordinary
  combat state do not belong in unlock data.
- Define migration/default behavior for missing, malformed, or older save data.
- Distinguish a missing fresh-profile field from malformed or unrecognized
  existing data. For malformed data, do not save a default locked state over
  the raw data in the same session; preserve it for recovery, block permanent
  grants, and report the chosen recovery path.
- In an unknown project, describe persistence keys by purpose, not invented
  storage paths. Resolve concrete key names and schema from discovered save
  data; label any naming convention as `Suggestion`.
- Do not infer that a missing, legacy, or malformed grant marker means a
  one-time economic reward was never delivered. Keep the repair/regrant policy
  `TBD` until migration evidence or an explicit user decision makes it safe.
- Discover whether the availability gate is static XML metadata, a supported
  runtime query/filter, or a project-owned route. Do not promise that an item
  can enter or leave a pool at runtime before that path is verified.
- Do not unlock content merely because a similar reference mod did. The user
  owns unlock condition and reward intent; omitted decisions stay `TBD`.
- Prefer official API and project-owned persistence first. A third-party
  progression helper is required only when declared; otherwise it is optional.

## Handoff Prompt Template

```markdown
## Progression Contract

- User-locked unlock condition and reward:
- Trigger event and proof of completion:
- Persistence key, default, and migration:
- Idempotency / duplicate-grant guard:
- Content availability gate:
- One-time reward route:
- Co-op, continue, reload, and new-run behavior:
- Optional dependencies and official fallback:
- Required tests and in-game checks:
```

## Final Review

Report the condition, saved key, default/migration behavior, gate, and tests
for first completion, repeated completion, continue, malformed data, and a
fresh profile when applicable.
