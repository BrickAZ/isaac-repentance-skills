---
name: isaac-cards-pockets
description: Add, fix, review, or write handoff prompts for custom cards, runes, soul stones, pills, and pocket item generation in Binding of Isaac Repentance mods. Use this whenever a task mentions pocketitems.xml, custom card, rune, soul stone, pill effect, blank card art, wrong card pickup, hud icon, cardfronts, MC_USE_CARD, MC_GET_CARD, Isaac.GetCardIdByName, startingcard, or cards generating as blank/abnormal. Use isaac-mod-context first in an unfamiliar project. This skill is strict because card registration, pickup art, HUD art, any enabled EID surface, and use callbacks must all line up. 中文触发：卡牌、塔罗牌、符文、魂石、药丸、空白卡、卡牌不正常、卡面、卡牌 HUD、起始卡牌、卡牌生成。
---

# Isaac Cards And Pocket Items

Use this skill for custom card/rune/soul stone/pill registration and behavior.

Read `../isaac-mod-context/references/design-authority.md` before filling in card effect, generation policy, mimic interaction, or visual direction omitted by the user.

The goal is to prevent "blank" or abnormal cards: a card id exists in Lua, but the pickup/hud art, `pocketitems.xml`, optional EID surface, or use callback does not line up.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar project, use `isaac-mod-context` to confirm pocket XML, callback modules, language variants, and art conventions that actually exist.
2. Read the current project's pocket XML if it exists.
3. Read existing card/pocket callbacks in the current project.
3. If the task touches descriptions, also use `isaac-compat-descriptions`.
4. If the task touches card/hud/icon `.anm2`, also use `isaac-anm2-visuals`.
5. If a challenge grants a starting card, also use `isaac-challenges`.
6. After file changes, use `isaac-validators` for XML/id/asset/path checks when possible.
8. For any generated or replaced pocket item, read `../isaac-validators/references/owned-spawn-safety.md` and prove it is current-project-owned before suppressing or replacing it.

When the current mod has no matching pocket item, use this skill's XML,
generation, art, and review references. Do not require a third-party mod
checkout to distinguish ids, pickup art, HUD art, and callbacks.

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
- The optional EID/description surfaces touched.
- Any in-game card pickup/HUD visual checks still needed.
