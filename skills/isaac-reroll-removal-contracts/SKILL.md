---
name: isaac-reroll-removal-contracts
description: Design, implement, review, or write handoff prompts for Binding of Isaac Repentance content changes that can invalidate or rebuild mechanics, including rerolls, removals, Morph/replacement, duplication, temporary grants, transformations, loss on death, and reacquisition. Use this when an effect persists after its input changed, fails to return after reacquisition, duplicates after a reroll, or needs an idempotent reconciliation boundary. Use isaac-mod-context first in an unfamiliar project. 中文触发：重掷、移除道具、道具替换、Morph、复制、吞噬、变身、临时获得、失去道具、重新获得、效果残留、重掷后失效、状态重建。
---

# Isaac Reroll And Removal Contracts

Use this skill when the important question is not what an item does, but what
must happen when the content that authorized an effect changes. It owns change
detection and reconciliation contracts, not the item's normal mechanic.

## First Move

1. In an unfamiliar project, use `isaac-mod-context` to discover actual item
   ownership patterns, callbacks, helpers, SaveData conventions, and tests.
2. Name the changed input, the old authorized effect, the desired new state,
   and every accepted change source. Keep omitted sources as `TBD`; do not
   assert that all rerolls, Morph calls, or removals share one callback.
3. Separate **observation** (how the project learns content changed) from
   **reconciliation** (how it safely rebuilds owned effects).
4. Read `references/content-change-matrix.md`, then
   `references/reconciliation-review.md` before implementation.

## Route The Work

- **Base item/card/trinket/familiar behavior**: route to its content skill.
  This skill adds only the change boundary.
- **A combination becoming invalid**: use `isaac-item-synergies` for the
  eligibility and result contract, then use this skill for change detection.
- **Runtime owner, resets, and persistence**: use `isaac-state-lifecycle`.
- **Actual callback/filter/return semantics**: use `isaac-callback-contracts`.
- **Replacement reward or pickup policy**: use `isaac-rewards-pickups`; do not
  use an inventory reconciliation loop to choose rewards.

## Observe A Change Without Guessing

- Prefer a discovered project callback or helper that explicitly reports the
  relevant change. Verify its timing and arguments before relying on it.
- When no direct signal exists, use a narrow, per-owner reconciliation point
  supported by project evidence. Compare the mechanic's explicit eligibility,
  not a global count or a guessed raw id.
- Do not poll every entity, mutate state from render, or assume a cache event
  proves all inventory changes. A fallback observation route must be
  documented as a fallback and tested for duplicate delivery.
- Treat duplication, removal, reroll, Morph/replacement, temporary grants,
  transformations, death, and reacquisition as separate sources until the
  project/API proves they are equivalent.

## Reconcile Idempotently

- Derive the desired owned state from current eligibility, then make the live
  state match it. Repeating reconciliation with unchanged inputs must not
  stack stats, spawn extra entities, or clear foreign state.
- Remove only markers, timers, visuals, spawned entities, cache contributions,
  and tables that the current mechanic can prove it owns.
- If a cache contribution changes, specify the discovered cache refresh route;
  do not add the bonus directly each frame or subtract an assumed previous
  value.
- If reacquisition is supported, define whether prior cooldowns, room gates,
  and pending effects resume, reset, or remain `TBD`. Do not accidentally
  resurrect stale state merely because a matching item returns.
- Keep live userdata out of SaveData. Save/reload semantics remain `TBD` unless
  the user and project establish persistence.

## Compatibility Rules

- Never delete every entity with a familiar variant, every pickup with a
  subtype, or every table entry that resembles the old effect. Other mods and
  vanilla content may use the same visible shape.
- Official APIs and declared project helpers come first. Undeclared libraries
  are optional and guarded; retain a no-op or official fallback.
- Do not let a missing optional mod, unknown change source, or malformed saved
  state turn into a broad cleanup of unrelated gameplay.

## Required Output

```markdown
## Content Change Contract

- Changed inputs and user-locked rules:
- Accepted change sources:
- Unknown sources (`TBD`):
- Observation route and timing:
- Owner/key and current eligibility predicate:
- Desired state after reconciliation:
- Owned state/entities/markers allowed to change:
- Cache refresh and callback return policy:
- Reacquisition policy:
- Room/run/death/save-reload boundary:
- Optional dependency policy:
- Automated tests and in-game checks:
```

## Final Review

Report which change sources are actually covered, how duplicates are avoided,
exactly what is cleaned or rebuilt, and which engine paths still need an
in-game check. Do not call an unobserved source "supported".
