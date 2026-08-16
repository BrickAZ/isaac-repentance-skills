---
name: isaac-active-item-mechanics
description: "Support the active-item shell for Binding of Isaac Repentance mods: charge policy, active slots, held input, option selection UI, render callbacks, and use-callback boundaries. Use this when those shell details are concretely involved. Keep it available for less capable agents, but use isaac-mechanic-contracts first when the difficult part is gameplay semantics rather than charge/input/UI. 中文触发：主动道具、充能、槽位、按住、长按、松开、选项、选择界面、使用失败不消耗、临时 UI。"
---

# Isaac Active Item Mechanics

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

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
- **Multi-stage continuation**: armed/waiting/selection/success/failure/cancelled phases, delayed settlement, or a use that remains active across callbacks. Define the transition table below and use `isaac-state-lifecycle` for storage and cleanup.
- **Room/floor/run state**: once per room, once per floor, reset on new room, reset on new level, persistent unlock/knowledge state, or rollback. Read `references/room-floor-state.md` and use `isaac-state-lifecycle` for ownership, keying, reset, or SaveData details.
- **Area or Dimension entry**: an active item opens a multi-room owned area or crosses a game-level Dimension. Use `isaac-room-networks` or `isaac-dimensions`; define capability preflight, visible failed-use UX, and the user-approved no-capability policy before `MC_USE_ITEM` decides charge consumption.
- **Card/pill/pocket interaction**: active item triggers a card/pill-like effect, reads pocket slots, consumes pocket items, or reacts to `MC_USE_CARD` / `MC_USE_PILL`. Read `references/card-pill-active.md` and use `isaac-cards-pockets` for custom card/rune/pill registration, generation, or blank-card issues.
- **Book of Virtues / item wisp**: this skill owns use success, charge, slot,
  and repeated invocation; use `isaac-wisps-virtues` for item-to-wisp mapping,
  native versus manual creation authority, owner, count/capacity, death, and
  `wisps.xml`/resource behavior.

If the active item also changes stats, intercepts damage, spawns registered entities, uses anm2 visuals, plays sound/shader feedback, or stores state beyond one callback, use the relevant sibling skill for that part.

## Hard Rules

- Separate "pressing the active item" from "the continuing mechanic after use".
- State whether failed use consumes charge. If not, specify the callback return boundary and any manual charge restoration.
- State which active slot matters. Do not assume pocket active, primary slot, or all slots.
- State lifetime: one frame, timed, until room clear, until new room, until new level, or persistent.
- For input-based mechanics, specify whether input is checked in `MC_INPUT_ACTION`, `MC_POST_PLAYER_UPDATE`, `MC_POST_RENDER`, or a helper already used by the repo.
- Bind input to the player/controller that owns the active state. Specify press, hold, release, repeat, and cancellation semantics; never let one global input read advance every player's copy.
- State the timing basis for every duration: game/update frames, room frames, animation events, or another discovered clock. Do not assume a callback runs 60 times per second, and define pause/slow-motion behavior.
- For render-based mechanics, specify screen-space versus world-space and hand off SFX/shader/render details to `isaac-audio-render-feedback` when needed.
- For new item metadata, do not invent missing quality, pools, text, or art. Keep `TBD` fields explicit.
- Do not make an active item silently unusable because an unproven room-network or Dimension allocation route fails. State the visible failure behavior and keep fallback/blocked policy as a user decision.
- For debugging an active item that does not trigger or consumes charge incorrectly, use `isaac-testing-debugging` before guessing a fix.

## Continuation State Machine Contract

For an active item that continues after `MC_USE_ITEM`, write a transition table before code. Semantic names may differ, but every non-terminal phase must name:

- owner player and active slot;
- entry trigger and allowed source phase;
- update/input callback and clock;
- one-shot or re-entry policy;
- charge commitment/refund boundary;
- gameplay mutation and separate UI/animation/SFX action;
- exit to success, failure, cancellation, or cleanup.

Cover interruption by item loss or slot replacement, owner death/removal, room/level transition, pause, continue/reload, and co-op join/leave when relevant. Cleanup must be idempotent, and failure before the committed success boundary must follow the declared no-consume/refund policy rather than silently leaving the item active.

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
- Continuation phases and transition table:
- Timer unit / clock / pause behavior:
- Input route:
- Input owner and press/hold/release semantics:
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
