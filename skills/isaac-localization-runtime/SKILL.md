---
name: isaac-localization-runtime
description: Design, implement, review, or write handoff prompts for runtime localization in Binding of Isaac Repentance mods. Use this when a task includes Options.Language, runtime text tables, language-code mapping, localized fonts, language-specific PNG/ANM2 assets, CuerLib translation registries, fallback text, or choosing between official API, a declared library, and an optional integration. Use isaac-compat-descriptions for simple XML/EID description synchronization. 中文触发：多语言、运行时文本、语言切换、Options.Language、翻译表、字体切换、日文贴图、中文贴图、语言回退、CuerLib 翻译。
---

# Isaac Localization Runtime

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when text or visual assets must change with the active game
language at runtime. It does not choose translations the user did not supply.

## First Move

Use `isaac-mod-context` to discover actual locale files, language codes,
runtime text callers, fonts, localized assets, and dependency declarations.
Then classify the route before adding code:

1. **Official API / current project table**: default for simple runtime text.
2. **Declared translation library**: use its registry only after the project
   confirms it is required and loaded.
3. **Optional library integration**: guard it in a compatibility module; core
   text and gameplay must still work without it.

Do not introduce CuerLib, EID, or another library merely because a reference
mod uses it. Do not assume `en`, `zh`, `jp`, `en_us`, or `zh_cn` are the
project's codes.

## Localization Surfaces

- **Runtime text**: popup text, HUD labels, menus, dialogue, or dynamic item
  names. Read `references/runtime-localization-architecture.md`.
- **Text fonts**: choose a discovered font per locale and define a usable
  fallback font.
- **Localized visual assets**: language-specific PNG/ANM2 text textures need
  a resolver and a fallback asset.
- **Description integrations**: EID, MCM, Encyclopedia, and wiki text remain
  optional surfaces. Use `isaac-compat-descriptions` for their guards and
  registration.
- **Static XML text**: use `isaac-compat-descriptions` for discovered XML
  locale synchronization rather than treating runtime tables as a replacement.

## Hard Rules

- Keep game language codes, internal translation-table codes, and optional
  integration language codes in an explicit mapping when they differ.
- Every runtime lookup must have a documented fallback: requested locale,
  default locale, then safe literal or existing project fallback.
- Keep language selection in a resolver or project-owned helper. Do not scatter
  `Options.Language` checks through unrelated item mechanics.
- A missing optional integration may skip only its own descriptions or UI;
  never disable the core item, entity, card, or challenge mechanic.
- A declared required library may be used directly only after the project
  context records where it is loaded and how missing-library failure is shown.
- Do not invent a translation, font, locale, or localized texture. Mark it
  `TBD` when the user or project has not supplied it.

## Handoff Prompt Template

```markdown
## Runtime Localization Spec

- Discovered game language codes:
- Internal table / integration code mapping:
- Default locale and fallback chain:
- Runtime text keys:
- Font per locale and fallback:
- Localized PNG/ANM2 assets and fallback:
- Dependency classification: official | project-owned | required | optional
- Optional integration guards:
- XML/EID/MCM surfaces delegated to:
- Missing translations or assets (TBD):
- Required static and in-game checks:
```

## Final Review

Before saying localization work is complete, report the observed language
mapping, every fallback path, dependency classification, touched surfaces, and
which language changes still need in-game verification.
