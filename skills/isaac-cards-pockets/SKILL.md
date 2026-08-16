---
name: isaac-cards-pockets
description: Add, fix, review, or write handoff prompts for custom cards, runes, soul stones, pills, and pocket item generation in Binding of Isaac Repentance mods. Use this whenever a task mentions pocketitems.xml, custom card, rune, soul stone, pill effect, blank card art, wrong card pickup, hud icon, cardfronts, MC_USE_CARD, MC_GET_CARD, Isaac.GetCardIdByName, startingcard, or cards generating as blank/abnormal. Use isaac-mod-context first in an unfamiliar project. This skill is strict because card registration, pickup art, HUD art, any enabled EID surface, and use callbacks must all line up. 中文触发：卡牌、塔罗牌、符文、魂石、药丸、空白卡、卡牌不正常、卡面、卡牌 HUD、起始卡牌、卡牌生成。
---

# Isaac Cards And Pocket Items

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill for custom card/rune/soul stone/pill registration and behavior.

Read `../isaac-mod-context/references/design-authority.md` before filling in card effect, generation policy, mimic interaction, or visual direction omitted by the user.

The goal is to prevent "blank" or abnormal cards: a card id exists in Lua, but the pickup/hud art, `pocketitems.xml`, optional EID surface, or use callback does not line up.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar project, use `isaac-mod-context` to confirm pocket XML, callback modules, language variants, and art conventions that actually exist.
2. Read the current project's pocket XML if it exists.
3. Read existing card/pocket callbacks in the current project.
4. If the task touches descriptions, also use `isaac-compat-descriptions`.
5. If the task touches card/hud/icon `.anm2`, also use `isaac-anm2-visuals`.
6. If a challenge grants a starting card, also use `isaac-challenges`.
7. For blank or wrong native art, read `../isaac-testing-debugging/references/native-surface-matrix.md` and name the requested surface before inspecting assets.
8. After file changes, use `isaac-validators` for XML/id/asset/path checks when possible.
9. For any generated or replaced pocket item, read `../isaac-validators/references/owned-spawn-safety.md` and prove it is current-project-owned before suppressing or replacing it.

When the current mod has no matching pocket item, use this skill's XML,
generation, art, and review references. Do not require a third-party mod
checkout to distinguish ids, pickup art, HUD art, and callbacks.

## High-Priority Official Cardfront Default

When a custom card face is requested and the project has no established cardfront route, read `../isaac-anm2-visuals/references/official-native-ui-baselines.md`.

- Start from the official `ui_cardfronts.anm2` baseline: 16x24 card-face frame crops, with 128x144 base or 256x144 Repentance-DLC sheet formats.
- This is separate from `pickup`, pocket/HUD, and optional EID surfaces.
- Preserve a user-selected or project-established alternative when it has a declared loader/mapping; record it as an override and verify the requested cardface surface in game.
- If no compatible cardface is supplied, recommend the 16x24 source frame. If generation is requested, generate a 16x24 cardface cell and integrate it into the discovered `ui_cardfronts` atlas rather than creating an unrelated card PNG.
## Route The Work

- **Pocket XML registration**: `card`, `rune`, `pilleffect`, ids, pickup art id, hud art key, mimiccharge, type/class. Read `references/pocketitems-xml.md`.
- **Blank or abnormal card prevention**: pickup/hud/icon mismatch, missing cardfront/hud art, duplicate id, wrong pickup id, wrong content type. Read `references/blank-card-prevention.md`.
- **Use callbacks**: `MC_USE_CARD`, `MC_USE_PILL`, effect routing, recursion guards, card/rune ids. Read `references/use-card-pill.md`.
- **Card generation and replacement**: `MC_GET_CARD`, challenge starting cards, random card pools, replacing generated cards. Read `references/card-generation.md`.
- **Descriptions and icons**: enabled EID entries, card icons, XML descriptions, language sync. Read `references/card-descriptions-icons.md`.
- **Final review**: before handing off or final answer, read `references/card-pocket-review-checklist.md`.

## Hard Rules

- Do not mix collectible id, card id, pill effect id, pickup art id, and HUD art key. They are different surfaces.
- Do not add `MC_USE_CARD` without a matching `content/pocketitems.xml` entry for a custom card/rune/soul stone.
- Do not assume `pickup` equals `id`; these are separate registration fields.
- Do not leave `hud` missing or mismatched for a custom card that should display in the pocket/HUD.
- Do not infer the cardfront, pickup, or pocket/HUD route from another working pocket surface. A valid `pickup` value, matching `hud` key, or optional EID icon proves only that one surface.
- Do not update EID or descriptions only; registration and art surfaces must be checked too.
- If a card generates blank/abnormal, inspect XML registration, cardfront/hud assets, and generation code before changing behavior logic. Check EID only after gameplay registration is correct and only when that integration exists.
- For blank or abnormal cards, prefer `isaac-testing-debugging` plus `isaac-validators` before guessing behavior changes.
- Never globally reject an unfamiliar card/pickup id. Another mod's custom pocket item remains outside the current project's ownership unless this mechanic explicitly integrates with it.

## Handoff Prompt Template

```markdown
## Card/Pocket Spec

- Content type: card | rune | soul stone | pill effect
- Display name:
- Internal name:
- pocketitems.xml id:
- pickup art id:
- hud key:
- mimiccharge / class:
- Use callback:
- Generation/replacement route:
- Optional description/EID surfaces:
- Art/anm2 surfaces:
- Existing examples to read:
- Blank-card prevention checks:
- Required tests/manual checks:
```

## Final Review

Before saying the work is complete, report:

- The `pocketitems.xml` entry.
- The card/rune/pill id lookup used in Lua.
- The use/generation callbacks touched.
- The pickup and HUD art keys.
- The separately verified pickup, cardfront, pocket/HUD, and optional EID visual surfaces.
- The optional EID/description surfaces touched.
- Any in-game card pickup/HUD visual checks still needed.
