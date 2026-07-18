---
name: isaac-unlocks-progression
description: Design, implement, review, or write handoff prompts for unlock conditions, achievements, persistent progression, content availability gates, and one-time rewards in Binding of Isaac Repentance mods. Use this when a task mentions unlock, achievement, completion mark, progression, persistent flag, SaveData, unlockable item, challenge completion, character unlock, one-time reward, or run-to-run availability. 中文触发：解锁、成就、完成印记、进度、永久标记、存档、可解锁道具、挑战完成、角色解锁、一次性奖励。
---

# Isaac Unlocks And Progression

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when content availability changes across runs. It does not
decide whether a reward is balanced; use `isaac-item-economy` or the user for
that decision.

## First Move

Use `isaac-mod-context` to find existing save/progression data, achievement or
challenge hooks, unlock XML/metadata, content gates, migration/versioning, and
test entrypoints. Then write the Progression Contract in
`references/progression-contract.md`.

## High-Priority Official Unlock-Art Suggestion

When an unlock achievement image is requested and the user has not supplied a compatible asset, read `../isaac-anm2-visuals/references/official-native-ui-baselines.md`.

- Recommend a 263x176 achievement-art PNG, then discover the current project's achievement popup/ANM2 registration route.
- If generation is requested, generate a 263x176 achievement image and connect it through that discovered route.
- Do not generate the full 480x270 popup frame for a normal achievement image, and do not confuse achievement art with a completion mark.
- A different format requires an explicit user decision or project-owned mapping; otherwise report the mismatch rather than inventing a route.
## Route The Work

- **Condition semantics**: challenge, character, boss, run result, or event
  contract belongs to `isaac-mechanic-contracts` and `isaac-callback-contracts`.
- **Persistent storage**: use `isaac-state-lifecycle` for SaveData, load,
  migration, and reset details.
- **Content availability**: use `isaac-item-economy` for pool/availability
  effects and `isaac-rewards-pickups` for a concrete one-time reward.
- **Player/challenge completion**: use `isaac-players-characters` or
  `isaac-challenges` when those systems own the condition.
- **Optional presentation**: achievement popup, completion mark, pause/menu indicator, and unlock text are separate from the unlock itself. Discover each requested UI/resource route; use `isaac-audio-render-feedback`, `isaac-hud-ui-state`, or `isaac-anm2-visuals` only when that specific surface is requested.

## Hard Rules

- Keep unlock condition, persistence key, grant action, and availability gate
  as separate fields. A saved flag alone is not an unlock implementation.
- Keep unlock condition, persistence, grant, availability gate, achievement notification, completion mark, and pause/menu display as separate fields. A working saved flag or popup does not prove the other surfaces are correct.
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
- Optional achievement/popup/completion-mark/pause-menu surfaces:
- Co-op, continue, reload, and new-run behavior:
- Optional dependencies and official fallback:
- Required tests and in-game checks:
```

## Final Review

Report the condition, saved key, default/migration behavior, gate, requested
presentation surfaces, and tests for first completion, repeated completion,
continue, malformed data, and a fresh profile when applicable.
