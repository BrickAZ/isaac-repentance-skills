---
name: isaac-active-item-mechanics
description: "Support the active-item shell for Binding of Isaac Repentance mods: charge policy, active slots, held input, option selection UI, render callbacks, and use-callback boundaries. Use this when those shell details are concretely involved. Keep it available for less capable agents, but use isaac-mechanic-contracts first when the difficult part is gameplay semantics rather than charge/input/UI. 中文触发：主动道具、充能、槽位、按住、长按、松开、选项、选择界面、使用失败不消耗、临时 UI。"
---

# Isaac Active Item Mechanics

Use this skill when an active item needs more than a simple `MC_USE_ITEM` shell. It is intentionally a shell skill: it keeps charge, slot, input, and UI work correct, while `isaac-mechanic-contracts` decides what the mechanic means.

Read `../isaac-mod-context/references/design-authority.md` before suggesting charge policy, slot behavior, input semantics, or presentation direction. These are locked when the user has specified them.

The goal is to stop a common failure: Codex sees "active item" and writes only XML plus `MC_USE_ITEM`, while the real design depends on input state, charge slots, temporary UI, room or floor state, card/pill callbacks, render callbacks, or a failure path that must not consume charge.

## First Move

Before editing or writing a prompt:

1. If trigger, success/failure, delay, exclusions, or repeated effects are not already explicit, use `isaac-mechanic-contracts` first and carry its Mechanic Contract into this work.
2. In an unfamiliar mod, use `isaac-mod-context` to discover the mod object, bootstrap files, item metadata, and active-item examples. Do not assume `main.lua`, `content/`, or a module layout.
3. If the item is new, read the current project's item-registration and metadata conventions before adding it.
4. Read the closest current-project active item before copying a callback shape.
5. If no local active item covers the route, use this skill's charge, input, UI, and state references. Do not require a third-party mod checkout.

Do not treat the active item callback as the whole mechanic. `MC_USE_ITEM` decides whether use begins and whether charge is consumed; the effect may live elsewhere.

## Route The Active Mechanic

Classify the design into one or more routes:

- **Use boundary and charge policy**: conditional use, failed use, zero-charge active, charge refund, or slot-specific charge. Read `references/use-callback-charge.md`.
- **Held input or option selection**: long press, two-button combo, directional input, menu selection, or keyboard/controller interception. Read `references/input-selection.md`.
- **Temporary UI or render feedback**: charge meter, choice panel, screen overlay, text prompt, highlight, or custom render while the item is active. Read `references/ui-render-active.md`.
- **Room/floor/run state**: once per room, once per floor, reset on new room, reset on new level, persistent unlock/knowledge state, or rollback. Read `references/room-floor-state.md` and use `isaac-state-lifecycle` for ownership, keying, reset, or SaveData details.
- **Card/pill/pocket interaction**: active item triggers a card/pill-like effect, reads pocket slots, consumes pocket items, or reacts to `MC_USE_CARD` / `MC_USE_PILL`. Read `references/card-pill-active.md` and use `isaac-cards-pockets` for custom card/rune/pill registration, generation, or blank-card issues.

If the active item also changes stats, intercepts damage, spawns registered entities, uses anm2 visuals, plays sound/shader feedback, or stores state beyond one callback, use the relevant sibling skill for that part.

## Hard Rules

- Separate "pressing the active item" from "the continuing mechanic after use".
- State whether failed use consumes charge. If not, specify the callback return boundary and any manual charge restoration.
- State which active slot matters. Do not assume pocket active, primary slot, or all slots.
- State lifetime: one frame, timed, until room clear, until new room, until new level, or persistent.
- For input-based mechanics, specify whether input is checked in `MC_INPUT_ACTION`, `MC_POST_PLAYER_UPDATE`, `MC_POST_RENDER`, or a helper already used by the repo.
- For render-based mechanics, specify screen-space versus world-space and hand off SFX/shader/render details to `isaac-audio-render-feedback` when needed.
- For new item metadata, do not invent missing quality, pools, text, or art. Keep `TBD` fields explicit.
- For debugging an active item that does not trigger or consumes charge incorrectly, use `isaac-testing-debugging` before guessing a fix.

## Self-Contained Fallback

When the current mod has no matching active item, use the route references in
this skill: define the use/charge boundary first, then input/UI, then state.
Do not fetch or copy a third-party mod merely to obtain a pattern.

## Handoff Prompt Template

When writing a prompt for another Codex agent, include:

```markdown
## Active Mechanic Spec

- Item:
- Active slot policy:
- Use trigger:
- Failed-use charge policy:
- Continuing callbacks after use:
- Input route:
- UI/render route:
- Room/floor/reset route:
- Card/pill/pocket interaction:
- State owner and lifetime:
- Related sibling skills:
- Existing examples to read:
- Required tests:
```

## Final Review

Before saying the active mechanic is complete, report:

- Which active routes were used.
- The exact charge-consumption rule.
- The callbacks involved after `MC_USE_ITEM`.
- The state keys and when they reset.
- Any UI/render/input behavior that still needs in-game verification.
