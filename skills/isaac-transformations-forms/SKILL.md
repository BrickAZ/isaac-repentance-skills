---
name: isaac-transformations-forms
description: "Use when designing, implementing, reviewing, debugging, or writing handoff prompts for Binding of Isaac: Repentance transformations and player forms, including vanilla `PlayerForm` queries, custom item-set transformations, contributor counting, thresholds, duplicate copies, activation edges, reversible versus permanent forms, granted effects, costumes, hidden effects, EID transformation display, co-op ownership, reroll/item-loss reconciliation, and save/continue behavior. This skill distinguishes engine forms, mod-owned gameplay forms, display-only groups, and actual custom characters. 中文触发：变身、套装变身、形态、PlayerForm、GetPlayerForm、收集若干道具触发、套装计数、变身阈值、永久变身、可逆变身、变身外观、EID transformation、重掷后取消变身。"
---

# Isaac Transformations And Forms

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Core Principle

A transformation is a qualification transition, not a recurring possession
check. Define which inputs contribute, how qualification is counted, what
happens on the false-to-true edge, whether the form can deactivate, and which
gameplay and visual effects belong to it.

An EID transformation group or icon is presentation only. It does not register
a new engine `PlayerForm` or prove gameplay activation.

## Boundary

This skill owns form classification, contributors, threshold, activation/
deactivation edges, transformation-owned effects and visuals, per-player state,
and persistence/reconciliation.

- Use `isaac-item-synergies` for a combination effect that does not create a
  named/thresholded form contract.
- Use `isaac-passive-collectibles` for each contributor item's ordinary behavior.
- Use `isaac-reroll-removal-contracts` when inventory changes must retract or
  rebuild the form.
- Use `isaac-players-characters` when the mechanic actually registers or changes
  a custom `PlayerType`, Tainted character, pocket active, or character start.
- Use `isaac-anm2-visuals` and `isaac-character-art-surfaces` for transformation
  costumes, layers, spritesheets, and surface-specific art.
- Use `isaac-eid-compat` only for optional transformation progress/icons/text.
- Use `isaac-state-lifecycle` for permanent or saved form state.

## First Move

1. Use `isaac-mod-context` in an unfamiliar mod. Discover registered
   collectibles/trinkets, runtime ID lookup, existing form helpers, inventory
   change detection, costume/effect owners, save data, EID integration, and tests.
2. Read `references/transformation-contract.md` and classify the route as a
   vanilla engine form query, mod-owned reversible transformation, mod-owned
   permanent transformation, display-only group, or actual custom character.
3. Keep contributor set, threshold, duplicate-copy weight, temporary-effect
   contribution, activation reward, gameplay bonuses, reversibility, visuals,
   and persistence as user decisions unless already specified.
4. Prove the exact API/helper semantics before using `PlayerForm`,
   `GetPlayerForm`, a custom transformation registry, or EID calls.

## Transformation Contract

| Field | Required fact or decision |
| --- | --- |
| Route | Vanilla engine form, custom reversible/permanent form, display group, character |
| Contributors | Stable registered identities and whether each can count |
| Count | Unique items, copies, temporary effects, trinkets, forms, or weighted points |
| Threshold | Exact user/project value and cap/overflow behavior |
| Owner | Per-player qualification, twins/subplayers, co-op sharing or isolation |
| Activation | Authoritative false-to-true edge and one-time/repeat behavior |
| Deactivation | Never, immediate on loss, delayed, room/floor boundary, or another rule |
| Effects | Stats, abilities, hidden collectibles/effects, costumes, feedback, unlocks |
| Presentation | EID progress/icon/text and game art surfaces, all optional adapters |
| Persistence | Inventory-derived only or saved stable form key/version |

## Hard Rules

- Resolve every custom contributor through its stable XML-local identity and
  discovered runtime ID. Do not hard-code post-vanilla global ItemConfig numbers
  or count items by atlas frame order.
- Do not invent a new `PlayerForm` enum or assume a custom EID transformation is
  visible to `GetPlayerForm`. Implement custom gameplay state explicitly unless
  the discovered API/project proves a registration surface.
- Count per actual player. Do not merge all co-op inventories or assign the form
  to player zero unless the approved design explicitly shares progression.
- Define whether duplicate copies and temporary item effects count. “Owns three
  transformation items” is ambiguous until unique-versus-copy semantics are set.
- Trigger activation effects only on a proven qualification edge. Re-evaluation,
  room entry, cache update, continue, or reload must not replay one-time rewards,
  sounds, achievements, or item grants.
- Reversible and permanent forms need different state models. A reversible form
  derives from current qualification; a permanent form persists an idempotent
  stable key and must not silently deactivate after item loss.
- Keep gameplay effects and presentation adapters separate. Missing EID, icon,
  costume, sound, or optional library must not erase core form state.
- If the form grants hidden collectibles/effects or Null Costumes, record exact
  ownership and remove only transformation-owned grants. Do not remove the same
  effect granted independently by another source.
- Reconcile on proven inventory/form dirty edges rather than scanning and
  replaying every effect each frame. Make reconciliation idempotent.
- Do not serialize players, item config userdata, sprites, or costumes. Persist
  only approved stable keys/versioned data and rebuild runtime presentation.
- Treat actual `PlayerType` conversion as a separate character mechanic with
  health, pocket, completion marks, co-op/twins, and continue implications; do
  not use it as a shortcut for a cosmetic or item-set form.

## Verification

Test below threshold, exact threshold, duplicate-copy policy, temporary effects,
two co-op players, activation replay, item loss/reroll, reacquisition, room/floor,
death, continue/reload, missing EID, and costume/effect ownership. For permanent
forms, verify one-time activation and save migration/version behavior.

Static inspection can prove contributor lists, stable IDs, edge guards, and
optional adapters. Mocks can prove reconciliation only if they model inventory
loss, temporary effects, and repeated callbacks. Native `PlayerForm`, costumes,
visual layers, hidden effects, and continue behavior require in-game verification.

## Required Output

```markdown
## Transformation / Form Contract

- Route and authority:
- Contributor identities and count semantics:
- Threshold:
- Per-player/co-op ownership:
- Activation edge and replay guard:
- Reversible/permanent deactivation policy:
- Gameplay grants and exact ownership:
- Visual/EID presentation adapters:
- Reroll/loss/reacquisition reconciliation:
- Save/continue/version behavior:
- Companion skills and exact API facts to discover:
- Static, isolated, and in-game verification:
- User decisions required:
```
