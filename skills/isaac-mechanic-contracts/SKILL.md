---
name: isaac-mechanic-contracts
description: Define, implement, review, or write handoff prompts for Binding of Isaac Repentance gameplay mechanics before choosing callbacks. Use this whenever a request describes what should happen "when", "if", "after", "until", "instead of", "only if", "with a chance", "for each", "the first time", or "at the end"; especially for damage rewriting, delayed resolution, conditional rewards, transformations, repeated triggers, item/card/entity/challenge interactions, or mechanics that Codex might implement plausibly but misunderstand semantically. Use isaac-mod-context first in an unfamiliar project. 中文触发：机制、触发条件、如果、当、之后、直到、失败、成功使用、延迟结算、概率、替代、第一次、每次、不能触发、递归、漏洞、边界情况。
---

# Isaac Mechanic Contracts

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill before implementation when the difficult part is understanding the mechanic, not registering the content type.

Read `../isaac-mod-context/references/design-authority.md` first. User-defined triggers, exclusions, settlement, rewards, restrictions, and presentation are locked; only missing fields may receive labeled suggestions.

The goal is to turn a vague sentence into a behavior contract that cannot silently confuse an attempted action with a successful action, a visual with gameplay, a one-shot with a repeatable effect, or an excluded event with an eligible event.

This skill does not choose every callback by itself. First make the behavior unambiguous; then hand the contract to the item, card, entity, challenge, state, visual, or active-shell skill that owns the implementation surface.

## First Move

Before writing code or a code prompt:

1. In an unfamiliar project, use `isaac-mod-context` to identify content owners and project profiles before assigning implementation files.
2. State the player-facing promise in one sentence.
3. Split the promise into trigger, eligibility guards, immediate result, continuing state, end result, and failure/no-op result.
4. Separate gameplay changes from visual feedback and from content registration.
5. Identify every event that must be excluded, including self-triggering/re-entry and other-mod compatibility when relevant.
6. Mark unstated design choices as `TBD`; do not silently decide them from a familiar callback pattern.

Read the relevant reference before writing the contract:

- Event versus outcome, including attempted use versus successful use: `references/event-outcome-boundaries.md`.
- Delayed, conditional, repeated, and exclusion-heavy mechanics: `references/state-machine-and-exclusions.md`.
- Gameplay carrier versus visual carrier, ownership, and compatibility: `references/surface-ownership-and-compat.md`.
- Review and test requirements: `references/mechanic-review-checklist.md`.
- Vanilla-like presentation versus actual vanilla-mechanism reuse: `references/native-mechanism-isolation.md`.

## Route After The Contract

- Collectible registration, stats, or damage callback: use the current project's item implementation surface.
- Callback choice, registration, filter, return policy, or cache refresh: use `isaac-callback-contracts` after the mechanic contract is explicit.
- Trinket ownership or golden/smelted rules: use `isaac-trinkets`.
- Card/rune/pill generation or use: use `isaac-cards-pockets`.
- Registered entity, collision, HP, or AI: use `isaac-entities`.
- Challenge-only gating: use `isaac-challenges`.
- Custom room, stage, dimension, or vanilla-like room flow: use `isaac-rooms-stages` after deciding independent replica versus proven native reuse.
- State storage, keying, reset, or save/reload: use `isaac-state-lifecycle` after the contract defines the states.
- Active-item charge, slot, held input, or temporary UI: use `isaac-active-item-mechanics` as a shell helper after the mechanic is clear.
- Costume, Lua sprite, ANM2, sound, shader, or render: use the visual/audio skills as secondary surfaces.

## Hard Rules

- Do not write "on use" until you distinguish attempted use, failed attempt, successful use, and any later settlement.
- Do not write "on damage" until you name eligible sources, excluded sources, cancellation behavior, recursion guard, and whether the original hit still lands.
- Do not turn a gameplay request into a decorative effect, or a decorative request into an entity/state mechanic, without naming that choice.
- A repeated effect needs a re-entry rule: stack, refresh, ignore, replace, queue, or settle first.
- A delayed effect needs an interruption rule: player death, room/floor/run change, item loss, reload, and relevant co-op behavior.
- Preserve third-party behavior by limiting gates and replacements to targets this mechanic owns. Unknown mod content is not an error by itself.
- Do not let a generic active-item shell decide the mechanic's semantics.
- When a request says “like vanilla” and also requires later vanilla behavior to remain untouched, do not directly invoke the vanilla mechanism as a shortcut and then clean, close, or reset its observed internal resources. Reuse requires a discovered isolated entrypoint plus the in-game same-run non-interference proof in `references/native-mechanism-isolation.md`; otherwise use an owned independent replica or mark the combination `blocked`/`TBD`.

## Required Output

Before code, write this block for a non-trivial mechanic:

```markdown
## Mechanic Contract

- Player-facing promise:
- Content identity and owner:
- Trigger event:
- Eligibility guards:
- Explicit exclusions:
- Immediate result:
- Continuing state and transitions:
- Re-entry / recursion policy:
- End, settlement, and interruption behavior:
- Failure or no-op behavior:
- Gameplay carrier:
- Visual/audio carrier:
- Compatibility boundary:
- Vanilla-like presentation / explicit native-reuse choice:
- Vanilla-owned touchpoints and isolation proof, if reuse is requested:
- Unknown decisions kept as TBD:
- Implementation skills and files to inspect:
- Test matrix:
```

## Final Review

Before saying a mechanic is complete, report:

- The final trigger/guard/result sequence.
- Every excluded event and why it is excluded.
- The recursion and repeated-trigger policy.
- What is gameplay versus presentation.
- Whether vanilla behavior was independently replicated, explicitly reused, or blocked; for reuse, the isolation proof and same-run non-interference result.
- Which content skill implemented the contract.
- Tests for success, failure, exclusion, repeated use, and interruption.
