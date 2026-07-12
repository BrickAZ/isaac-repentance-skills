---
name: isaac-curses-run-modifiers
description: "Design, implement, review, debug, or write handoff prompts for Binding of Isaac: Repentance vanilla curse-mask evaluation and run/floor modifiers: adding, removing, preserving, re-evaluating, or reacting to LevelCurse bits. Use whenever a mechanic changes curses, evaluates curse flags, reacts to CURSE_OF_ values, uses curse evaluation callbacks, re-evaluates curses after item/state changes, or leaks a curse rule between floors/runs. 中文触发：诅咒、curse、LevelCurse、CURSE_OF、诅咒旗标、加诅咒、移除诅咒、重新计算诅咒、楼层诅咒。"
---

# Isaac Curses and Run Modifiers

Use `isaac-mod-context` first in an unfamiliar project. This skill owns runtime
evaluation of existing curse-mask behavior, not challenge XML or a new custom
curse system assumed to exist.

## Boundary

Use this skill when an item, character, room rule, or run modifier adds/removes/
preserves existing `LevelCurse` bits or reacts to them. Use `isaac-challenges`
for static challenge `cursefilter`/forced-curse XML; use `isaac-rooms-stages` for
room/floor transitions; use `isaac-state-lifecycle` for modifier state and reset;
use `isaac-callback-contracts` to prove the actual evaluation callback/signature.

Default to official Isaac APIs. A project library may offer a curse helper, but
it is optional only after explicit declaration and usable API discovery. Never
make CuerLib or any reference-mod helper a requirement.

## Curse Contract

Before implementation, state:

- requested existing curse bit(s), target stage/floor scope, and whether the
  rule adds, removes, suppresses, or merely observes them;
- activation owner/condition and precedence with other owned modifiers;
- preservation policy for unrelated vanilla and third-party curse bits;
- re-evaluation edge after condition changes;
- room/floor/run/death/reload cleanup and player/co-op behavior;
- user-approved versus `TBD` curse policy.

Do not call every curse bit “yours.” Modify only the approved bitwise portion and
preserve unrelated bits unless the user explicitly requests a global replacement.
Do not assume a curse-evaluation callback, helper, or return policy; discover and
prove it with `isaac-callback-contracts`.

## Re-evaluation and Lifecycle

- Re-evaluate only at a defined condition/floor edge, not every frame.
- If an item loss, reroll, room rule, or temporary state changes curse eligibility,
  define when the mask is recomputed and when temporary state clears.
- Do not apply a runtime curse mutation to normal runs because it was intended for
  a challenge; challenge-only gates belong to `isaac-challenges`.
- Treat UI/map/visibility consequences as runtime verification, not proof from a
  returned mask alone.

## Verification

Read `references/curse-review.md`. Cover the active condition, inactive
condition, unrelated curse preservation, floor transition, condition removal,
and any declared challenge/co-op boundary. Static callback wiring does not prove
the actual floor curse behavior.
