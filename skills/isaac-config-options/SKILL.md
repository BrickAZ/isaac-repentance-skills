---
name: isaac-config-options
description: Design, implement, review, or write handoff prompts for Binding of Isaac Repentance mod configuration options, including optional Mod Config Menu settings, defaults, SaveData-backed preferences, malformed-data recovery, runtime gates, and setting localization. Use when a task mentions a toggle, setting, option, config menu, MCM, enable/disable behavior, saved preference, reset to default, or making a feature optional. This skill does not decide gameplay semantics or user choices. 中文触发：设置、开关、选项、配置、MCM、Mod Config Menu、启用、禁用、默认值、存档设置、损坏存档、配置菜单。
---

# Isaac Config Options

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when the hard part is a player-controlled setting and its safe
integration, not the gameplay mechanic the setting happens to gate.

Read `../isaac-mod-context/references/design-authority.md` first. A user-specified
default, label, persistence rule, or toggle effect is locked. If the user did
not choose a default or an in-flight behavior, keep it `TBD`; do not invent a
"reasonable" value.

## Boundaries

- This skill owns the configuration contract: schema, default authority,
  optional UI dependency, plain-data persistence, malformed-data recovery, and
  test matrix.
- `isaac-mechanic-contracts` owns what an already-created tear, entity, effect,
  timer, or reward does when a setting changes.
- `isaac-state-lifecycle` owns the concrete saved-data owner, version/migration,
  runtime state, and reset lifecycle.
- `isaac-compat-descriptions` owns localization surfaces and optional-library
  load guards. Use it as a sibling, not a replacement.
- The content skill owns the actual item, card, familiar, challenge, entity, or
  projectile behavior. A config skill must not become a broad global hook.

## First Move

Before editing or writing a prompt:

1. Use `isaac-mod-context` to discover the mod object, existing SaveData shape,
   optional-library convention, locales, and the closest setting/menu pattern.
2. State the setting's player-facing promise and identify its owner: mod-wide
   preference, per-save preference, per-run option, or runtime-only debug mode.
3. Separate three questions: chosen default, persistence/recovery, and gameplay
   effect after the value changes. Keep any unstated answer `TBD`.
4. Classify every dependency: official API/project code first; a declared MCM
   integration may be required; an undeclared MCM is optional and guarded.
5. Read `references/config-contract.md` and the review checklist before code.
   For a Mod Config Menu integration, also read `references/mcm-integration.md`
   before inventing a registration table or a localized title field.

## Configuration Contract

Write this block before implementation:

```markdown
## Config Option Contract

- Setting key and owner:
- Player-facing label and discovered locales:
- Chosen default / authority / TBD:
- Persistence scope:
- Serialized plain-data schema and version:
- Missing or malformed-data recovery:
- Optional UI dependency and official fallback:
- Runtime read point:
- Existing in-flight state behavior / mechanic-contract owner:
- Dependencies intentionally not required:
- Tests and in-game checks:
```

## Hard Rules

- Do not make MCM, EID, CuerLib, or another library a required dependency
  unless the project or user explicitly declares it required.
- Guard optional UI registration. Missing UI support must not prevent the core
  mod from loading or silently choose a new gameplay default.
- Do not use `GetData()` on a projectile/entity as the source of truth for a
  mod-wide preference, and do not serialize live Entity, Player, Sprite, RNG,
  or other userdata.
- Do not let a menu callback mutate unrelated gameplay state directly. It may
  update the preference; the owning mechanic decides how and when to consume it.
- Do not use a global "disabled" check to alter foreign tears, familiars,
  pickups, or entities. Gate only the creation or handling paths the mechanism
  demonstrably owns.
- Do not treat a test stub as proof of a third-party API. For MCM, use only
  documented `AddSetting` arguments and fields; keep unsupported localization
  behavior as an in-game verification item.
- Do not infer one locale or one text surface from another. Discover actual
  localization files and route wording to `isaac-compat-descriptions`.
- Do not claim malformed-data recovery works without testing missing, wrong-type,
  and outdated-schema inputs against the discovered save convention.
- When reporting executable tests, delegate runner discovery to
  `isaac-testing-debugging`. Absence from `PATH` alone is not evidence that a
  Lua behavior test cannot run.

## Route After The Contract

- Toggle changes a mechanic's eligibility, settlement, or existing in-flight
  content: use `isaac-mechanic-contracts` first, then the owning content skill.
- SaveData shape, version migration, reload, room/run reset, or player keying:
  use `isaac-state-lifecycle`.
- MCM/EID/translation/load guard: use `isaac-compat-descriptions`.
- Fired tears, lasers, knives, bombs, ownership markers, or collision behavior:
  use `isaac-projectile-combat`.
- Validation and proof: use `isaac-validators` and `isaac-testing-debugging`.

## Final Review

Before saying configuration work is complete, report:

- Which setting decisions came from the user and which remain `TBD`.
- Whether the UI dependency is required or guarded optional, with evidence.
- Exact saved-data owner/schema/recovery behavior, or why it remains `TBD`.
- The mechanism that consumes the setting and the explicit in-flight policy.
- Tests for missing UI, both setting values, reload, malformed data, locales,
  and third-party isolation.
