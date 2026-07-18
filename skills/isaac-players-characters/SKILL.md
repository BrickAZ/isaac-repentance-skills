---
name: isaac-players-characters
description: Design, implement, review, or write handoff prompts for custom player characters and tainted variants in Binding of Isaac Repentance mods. Use this when a task mentions players.xml, player type, tainted character, birthright, starting inventory, character select, player costume, character-specific HUD, co-op player state, death/revive, or player-type checks. 中文触发：自定义角色、里角色、角色选择、players.xml、出生道具、出生卡、Birthright、角色服装、多人角色、角色 HUD、复活。
---

# Isaac Players And Characters

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill for a playable character system, not for a one-off item effect
that happens to inspect a player.

## First Move

Use `isaac-mod-context` to discover `players.xml`, player id lookups,
bootstrap/load files, existing character modules, costumes, starting content,
and supported locale surfaces. Do not assume a player name, tainted variant,
`players.xml`, or character-select integration exists.

Before code, write a Character Contract. Read
`references/character-contract.md`.

## High-Priority Official Native-UI Defaults

When a requested character-select or co-op visual surface has no established current-project route, read `../isaac-anm2-visuals/references/official-native-ui-baselines.md`.

- Character select: start from the official `characterportraits.anm2` baseline, using 48x48 portrait frame crops from a 512x1024 `CharacterMenu.png` sheet.
- Co-op menu: start from the official `coop menu.anm2` baseline, using 32x32 portrait frame crops from a 192x128 base or 192x224 Repentance-DLC sheet.
- These defaults do not prove boss, HUD, death, costume, or completion-mark routes. Preserve a user-selected or project-established alternative with a declared mapping and per-surface in-game proof.
- If a requested select or co-op image is absent, recommend the matching 48x48 or 32x32 source frame. If generation is requested, generate that frame and integrate it into the discovered character-select or co-op atlas, not as a loose replacement file.
## High-Priority Official Heart-HUD Suggestion

Use this only when the task explicitly requests a custom heart HUD surface. Read `../isaac-anm2-visuals/references/official-native-ui-baselines.md`.

- Recommend a 16x16 heart-HUD cell from the official `ui_hearts.anm2` route and its 112x64 sheet.
- If generation is requested, generate a 16x16 cell and integrate it into the discovered heart-HUD atlas/ANM2 mapping.
- Heart appearance is separate from player health mechanics. Do not change health logic merely to display custom art.
- A non-16x16 heart cell requires an explicit user decision or project-owned mapping; otherwise report the mismatch instead of guessing a render route.
## Route The Work

- **Registration**: player type, `players.xml`, and character identity.
- **Native character visuals**: character select, co-op menu, in-run HUD, boss portrait, death screen, costumes, and optional completion marks are separate surfaces. Discover each requested route; use `isaac-anm2-visuals` for ANM2/assets and do not assume one portrait supplies another.
- **Starting kit**: starting collectibles, trinkets, cards, pills, health, and
  active slots. Use `isaac-cards-pockets` or `isaac-rewards-pickups` for the
  owned content surfaces.
- **Character mechanic**: callback choice and gameplay semantics belong to
  `isaac-mechanic-contracts` and `isaac-callback-contracts`.
- **Per-player state**: co-op, twins, death, revive, and reset rules belong to
  `isaac-state-lifecycle`.
- **Birthright and descriptions**: user design choices stay locked; use
  `isaac-compat-descriptions` and `isaac-localization-runtime` only for
  actual text or runtime language surfaces.

## Hard Rules

- Resolve a player type from a registered project name; never invent a raw
  type id or assume a tainted variant exists.
- Keep character state per actual player. Do not use one global flag for a
  co-op character mechanic.
- State whether a starting grant happens on new run, continue, revive, or
  every player init. Prevent duplicate grants on reload and co-op joins.
- If the user did not decide the continue, revive, reinitialization, or
  mid-co-op-join boundary, list each as `TBD`. Do not turn a common character
  policy into final behavior; label any proposal as `Suggestion`.
- Do not use a costume as proof of character identity. Costumes are visual;
  player type and ownership drive gameplay.
- Do not use a working character-select, co-op, HUD, boss, death, or costume asset as proof another character surface is registered. Each requested surface needs its own source asset/ANM2/registration evidence and in-game check.
- Do not make a custom character require EID, CuerLib, StageAPI, or another
  third-party mod unless the project explicitly declares that dependency.
- Do not invent starting items, health, Birthright behavior, or a tainted
  counterpart when the user has not decided them.
- In an unknown project, use semantic state labels, not invented variable
  names, XML attributes, or implementation keys. Concrete field names come
  only from discovered code.

## Handoff Prompt Template

```markdown
## Character Contract

- Registered player type and source:
- Tainted/alternate variant:
- Starting-kit grant boundary:
- Character mechanic and sibling skills:
- Per-player state owner and reset points:
- Costume/visual route:
- Native character surface matrix:
- Birthright and user-locked decisions:
- Optional integrations:
- Locale and description surfaces:
- Required static and in-game checks:
```

## Final Review

Report the actual player ids, grant boundary, co-op behavior, reset/death
behavior, visual carrier, requested native character surfaces, and in-game
checks for new run, continue, and two players when supported.
