---
name: isaac-trinkets
description: Add, fix, review, or write handoff prompts for custom trinkets in Binding of Isaac Repentance mods. Use this whenever a task mentions trinkets.xml, custom trinket, smelted/gulped trinket behavior, golden trinkets, trinket multipliers, Isaac.GetTrinketIdByName, player:HasTrinket, trinket pools/drops, trinket descriptions, or trinket costumes/icons. Use isaac-mod-context first in an unfamiliar project. This skill keeps trinket registration and behavior separate from collectible item logic. 中文触发：饰品、吞下、吞噬、金饰品、饰品倍率、饰品池、饰品掉落、饰品外观。
---

# Isaac Trinkets

Use this skill for custom trinket work.

Read `../isaac-mod-context/references/design-authority.md` before filling in a trinket's effect, stacking behavior, reward implication, or visual direction that the user has not decided.

The goal is to prevent treating trinkets as smaller collectible items. Trinkets have different XML, id lookup, ownership, smelted behavior, golden trinket multipliers, and drop/pool surfaces.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar project, use `isaac-mod-context` to confirm trinket XML, language variants, asset conventions, and callback modules that actually exist.
2. Read the current project's trinket XML and language variants if they exist.
3. Search current code for `GetTrinketIdByName`, `HasTrinket`, `GetTrinketMultiplier`, `TRINKET`, `gulp`, and `smelt`.
3. If no local trinket exists, use this skill's registration, ownership/multiplier, and behavior references. Do not fall back to collectible-item behavior or require a third-party mod checkout.
5. If the trinket changes stats, use the current project's item/stat implementation surface and `isaac-callback-contracts` for cache wiring.
6. If the trinket has state, use `isaac-state-lifecycle`.
7. If the trinket has costume/icon visuals or EID text, use `isaac-anm2-visuals` and `isaac-compat-descriptions`. For a blank or wrong native visual, read `../isaac-testing-debugging/references/native-surface-matrix.md` first.

## High-Priority Official Trinket-Icon Suggestion

When a trinket icon is requested and no compatible user or project asset exists, read `../isaac-anm2-visuals/references/official-native-ui-baselines.md`.

- Recommend a 32x32 trinket PNG as the official default.
- If the user asks to generate the absent icon, generate a 32x32 trinket PNG and connect it through the discovered trinket XML/resource route.
- Preserve a user-provided or project-established non-default strip/animation asset. Report its dimensions and mapping instead of silently resizing it to 32x32.
- Trinket pickup art remains separate from HUD/pocket, costume, and optional EID surfaces.
## Route The Trinket

- **Registration and metadata**: `trinkets.xml`, internal name, display names, pickup text, description, tags, quality-like review if the repo uses one. Read `references/trinket-registration.md`.
- **Ownership and multipliers**: held, smelted/gulped, golden trinket, `player:HasTrinket`, `player:GetTrinketMultiplier`, per-player behavior. Read `references/ownership-multipliers.md`.
- **Behavior route**: stat cache, damage interception, room effects, drops, pickups, entity interaction, or active/passive style callbacks. Read `references/trinket-behavior.md`.
- **Descriptions and visuals**: localization, EID, icons, costumes. Use sibling skills as needed.
- **Final review**: read `references/trinket-review-checklist.md`.

## Hard Rules

- Do not register a trinket as a collectible item.
- Do not use collectible id lookup for trinket behavior.
- Do not ignore smelted/gulped behavior if the effect should still apply after the trinket is swallowed.
- Do not forget golden trinket multiplier behavior; state whether the effect scales or intentionally does not.
- Do not use one global boolean for a player-held trinket effect.
- Do not update only one language file when the repo has language variants.
- Do not infer a trinket pickup, HUD/pocket indicator, costume, or optional EID icon from another working visual surface. Discover the requested surface's own route.

## Handoff Prompt Template

```markdown
## Trinket Spec

- Display name:
- Internal name:
- XML registration:
- Lua id lookup:
- Held/smelted/golden behavior:
- Multiplier rule:
- Callback route:
- State owner:
- Visual/EID surfaces:
- Existing examples to read:
- Required tests/manual checks:
```

## Final Review

Before saying trinket work is complete, report:

- XML and language files touched.
- Lua id lookup used.
- Held, smelted, and golden behavior.
- Multiplier rule.
- Callbacks touched.
- Tests run and in-game checks still needed.
- Which requested native and optional visual surfaces were checked independently.
