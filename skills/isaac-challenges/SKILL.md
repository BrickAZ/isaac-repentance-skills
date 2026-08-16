---
name: isaac-challenges
description: Add, implement, review, or write handoff prompts for custom challenges in Binding of Isaac Repentance mods. Use this whenever the user mentions challenges, challenge id, content/challenges.xml, starting items, starting trinkets, challenge-only rules, roomfilter, cursefilter, endstage, canshoot, forced floors, challenge scripts, or Isaac.GetChallenge(). Use isaac-mod-context first in an unfamiliar project. Also use isaac-state-lifecycle for once-per-room/floor challenge rules or any state that must not leak into normal runs. 中文触发：挑战、挑战开局、挑战规则、挑战限定、起始道具、起始饰品、起始卡牌、普通局泄漏、禁用房间、终点层。
---

# Isaac Custom Challenges

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill for custom challenge work in Isaac Repentance mods.

Read `../isaac-mod-context/references/design-authority.md` before deciding a challenge's starting kit, restrictions, reward, or intended difficulty. Explicit design choices are locked; omissions stay `TBD`.

The goal is to stop a common failure: Codex adds `content/challenges.xml` metadata but forgets the Lua module, load entry, challenge-id lookup, or `Isaac.GetChallenge()` guard, causing rules to leak into normal runs.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar project, use `isaac-mod-context` to confirm challenge XML, bootstrap/load files, module roots, and language variants that actually exist.
2. Read the current project's challenge XML if it exists.
3. Read the current project's challenge loading pattern in its discovered bootstrap/load file or content registry.
4. Read the closest challenge Lua script in the current project. If none exists, use this skill's XML, Lua-gate, inventory, and no-leak references instead of requiring another mod.
4. If the challenge gives custom items, cards, visuals, sounds, stateful rules, or descriptions, use the relevant sibling skill for those surfaces. Use `isaac-cards-pockets` for custom starting cards, runes, soul stones, pills, or blank-card generation issues. Use `isaac-state-lifecycle` for once-per-room/floor/run rules and no-leak cleanup.
6. After file changes, use `isaac-validators` for XML/path checks and `isaac-testing-debugging` for challenge leakage verification.

## Route The Challenge

Classify the challenge into one or more routes:

- **Challenge XML registration**: name, id, starting items/trinkets/card/pill, player type, endstage, filters, curses, health, coins, difficulty, shooting rules. Read `references/challenge-xml.md`.
- **Challenge Lua gate and loading**: challenge id lookup, `Isaac.GetChallenge()` guard, module include, callback registration, no-leak rules. Read `references/lua-gate-loading.md`.
- **Starting inventory and item pools**: scripted starting collectibles, smelted trinkets, pocket active, item-pool removal, first-run-only logic. Read `references/starting-inventory.md`.
- **Room, floor, curse, and spawn rules**: forced stage, room filters, curse filters, entity/item spawn replacement, once-per-room/floor logic. Read `references/room-floor-rules.md` and use `isaac-state-lifecycle` for state owner/reset details.
- **Challenge behavior restrictions**: no shooting, replacement card drops, boss/NPC modifications, damage rules, completion conditions, and interaction with other skills. Read `references/challenge-behavior.md`.
- **Final challenge review**: before handoff or final answer, read `references/challenge-review-checklist.md`.

## Hard Rules

- Every challenge-only Lua behavior must be gated by `Isaac.GetChallenge() == <challenge id>`.
- Do not guess `challenge id`; preserve existing ids and choose an unused id only after reading `content/challenges.xml`.
- Do not use display name, XML id, and Lua variable name interchangeably. Keep all three explicit.
- Do not put all restrictions in XML if they need runtime Lua callbacks.
- Do not let callback behavior leak into normal runs, other challenges, continued saves, or non-first-run starts.
- If using `MC_POST_GAME_STARTED`, decide whether behavior runs on continued saves.
- If a challenge removes items from the item pool, state why and when it happens.

## Handoff Prompt Template

```markdown
## Challenge Spec

- Display name:
- Internal Lua name:
- XML id:
- Challenge id lookup:
- Player type:
- Starting items/trinkets/card/pill:
- Starting health/coins/stats:
- End stage / path:
- Room filters:
- Curse filters / forced curses:
- Shooting or input restrictions:
- Runtime Lua rules:
- Reset/lifetime:
- Load entry:
- Related sibling skills:
- Existing examples to read:
- Required tests:
```

## Final Review

Before saying the challenge work is complete, report:

- The XML challenge entry and id.
- The Lua module and load entry.
- Every callback used and its `Isaac.GetChallenge()` gate.
- Whether start logic runs on continued saves.
- Any item-pool removals, forced floors, spawn replacements, or restrictions.
- Tests run or manual in-game checks still needed.
