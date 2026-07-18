---
name: isaac-damage-health-contracts
description: "Design, implement, review, debug, or write handoff prompts for Binding of Isaac: Repentance mod damage interception, damage replacement, health changes, invulnerability, lethal-hit, and re-entry behavior. Use whenever a mechanic observes, cancels, redirects, delays, adds, replaces, or reacts to damage; changes player/NPC health; depends on damage flags, EntityRef/source attribution, i-frames, death, revival, or repeat-hit guards. 中文触发：伤害、受伤、拦截伤害、免伤、无敌帧、扣血、回血、生命、红心、魂心、致死、复活、伤害来源、DamageFlag、EntityRef。"
---

# Isaac Damage and Health Contracts

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use `isaac-mod-context` in an unfamiliar project. Define the mechanic with
`isaac-mechanic-contracts` before selecting/registering a handler with
`isaac-callback-contracts`.

## Boundary

This skill defines damage and health semantics: eligible hits, original-hit
outcome, source attribution, re-entry, invulnerability, lethal behavior, and
health-side effects. It does not select callback signatures/returns, design an
item's pools or quality, or own projectile collision. Route those to
`isaac-callback-contracts`, `isaac-item-economy`, and `isaac-projectile-combat`.

Default to official Isaac APIs. An undeclared library is optional only after
project and runtime/API discovery. Its absence needs an official fallback or a
clearly stated unsupported branch.

## Write the Hit Contract First

For each damage route, lock or mark `TBD`:

- target class and ownership: player, NPC, familiar, or another entity;
- eligible source and attribution route; unknown sources are not automatically
  yours;
- amount, flags, countdown/invulnerability context, and exclusions;
- original-hit outcome: observe, let through, cancel, replace, defer, or add a
  separate side effect;
- health outcome, credit, feedback, death/revival policy, and repeat boundary.

Do not write “on damage” without specifying whether the original hit lands.
Do not infer one callback's `true`, `false`, or `nil` policy from another;
prove the exact handler contract from the discovered API or a local known-good
project pattern.

## Guard the Dangerous Cases

- A replacement or added hit needs an explicit recursion boundary. Mark an owned
  source/state at creation and reject only that owned re-entry, not every foreign
  damage event.
- Treat i-frames, damage cooldown, and contact cadence as engine/gameplay facts
  to discover. Do not emulate or reset them just to make a mechanic fire.
- Do not turn a player-specific guard into a run-global boolean; co-op players,
  twins, targets, and simultaneous hits must remain isolated.
- Do not cancel a lethal hit and reconstruct death/revival/health afterward
  unless the mechanic defines that entire outcome and has focused verification.
- Do not credit damage to player zero or a convenient global holder. Preserve or
  discover the actual `EntityRef`/source route.

## Health Is Not a Generic Number

Before changing health, discover the target's actual health surface and the
meaning of the requested operation. A player health change may involve distinct
heart containers, temporary health, soul/bone/other health types, or a resource
that is not equivalent to direct HP. An NPC's `HitPoints` and a player's health
state are not interchangeable.

Keep “prevent damage”, “heal after damage”, “replace damage with a cost”, and
“set health” as separate routes. Each needs its own failure, lethal, and
repeat-hit policy. Do not use a cancel-and-heal shortcut unless it is the
explicitly approved mechanic and preserves all required side effects.

## Lifecycle and Verification

Read `references/damage-health-review.md` before implementation. Define cleanup
for guards, delayed work, source markers, player death/revive, entity removal,
room/run boundaries, and reload. Runtime state must not serialize live entities,
players, or `EntityRef` userdata.

Never claim damage correctness from a static callback check. Cover an eligible
hit, excluded hit, repeated hit, simultaneous co-op hit, owned re-entry, and
lethal/invalid target case when relevant.
