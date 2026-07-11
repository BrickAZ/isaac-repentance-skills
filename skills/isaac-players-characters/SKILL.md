---
name: isaac-players-characters
description: Design, implement, review, or write handoff prompts for custom player characters and tainted variants in Binding of Isaac Repentance mods. Use this when a task mentions players.xml, player type, tainted character, birthright, starting inventory, character select, player costume, character-specific HUD, co-op player state, death/revive, or player-type checks. 中文触发：自定义角色、里角色、角色选择、players.xml、出生道具、出生卡、Birthright、角色服装、多人角色、角色 HUD、复活。
---

# Isaac Players And Characters

Use this skill for a playable character system, not for a one-off item effect
that happens to inspect a player.

## First Move

Use `isaac-mod-context` to discover `players.xml`, player id lookups,
bootstrap/load files, existing character modules, costumes, starting content,
and supported locale surfaces. Do not assume a player name, tainted variant,
`players.xml`, or character-select integration exists.

Before code, write a Character Contract. Read
`references/character-contract.md`.

## Route The Work

- **Registration**: player type, `players.xml`, display assets, and character
  identity. Use `isaac-anm2-visuals` for costumes or player visual assets.
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
- Birthright and user-locked decisions:
- Optional integrations:
- Locale and description surfaces:
- Required static and in-game checks:
```

## Final Review

Report the actual player ids, grant boundary, co-op behavior, reset/death
behavior, visual carrier, and in-game checks for new run, continue, and two
players when supported.
