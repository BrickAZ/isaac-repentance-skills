---
name: isaac-projectile-combat
description: "Design, implement, review, or write handoff prompts for Binding of Isaac Repentance player- or familiar-owned combat projectiles: custom tears, lasers, knives, bombs, and projectile-like attack entities. Use this whenever a mechanic fires, spawns, converts, marks, updates, redirects, splits, reflects, destroys, or handles collision/damage for a player/familiar attack; when MC_POST_FIRE_TEAR, tear/laser/knife update, collision, SpawnerEntity, EntityRef, tear flags, projectile ownership, repeated hits, or attack cleanup are involved. Use isaac-mod-context first in an unfamiliar project. Boss/NPC attack AI remains isaac-npc-boss-ai. 中文触发：泪弹、子弹、激光、飞刀、投射物、发射、分裂、反弹、命中、弹幕、SpawnerEntity、EntityRef、泪弹旗标、使魔射击、玩家攻击。"
---

# Isaac Projectile Combat

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when the primary mechanic is a combat projectile owned by a
player or familiar.

This skill owns source proof, projectile lifetime, combat collision, and
damage attribution. Use `isaac-entities` for registration facts, `isaac-anm2-visuals`
for visuals, `isaac-familiars` when a familiar fires the attack, and
`isaac-npc-boss-ai` for NPC/Boss attacks.

## First Move

1. Use `isaac-mod-context` in an unfamiliar project. Discover the mod object, callback owner, entity XML, existing attack examples, test entrypoints, and dependency facts.
2. Read `../isaac-mod-context/references/design-authority.md`. Keep damage, count, chance, cooldown, target policy, flags, visual, and persistence as `TBD` unless the user decided them.
3. Choose exactly one creation route from `references/projectile-ownership.md`: augment a fired projectile, explicitly spawn an attack, or register a custom entity.
4. Identify how a projectile proves it is owned by the current mechanic before registering update, collision, remove, or damage logic.
5. Use `isaac-callback-contracts`, `isaac-state-lifecycle`, `isaac-testing-debugging`, and `isaac-validators` for their respective surfaces.

When a target project is available, discover actual paths, callbacks, and
entity facts first. “Do not assume” never permits skipping discovery and
marking everything `TBD`.

## Choose One Creation Authority

### Augment A Fired Projectile

Use this only when an existing player/familiar shot receives an additional,
user-approved behavior.

- Select the discovered fire callback and prove the source player/familiar and
  mechanic eligibility before marking the projectile.
- Store an owned runtime marker on the actual projectile data surface at
  creation. Later callbacks must check that marker or equally strong project
  evidence before changing it.
- Do not globally modify every tear/laser/knife with a shared vanilla variant
  or every projectile whose spawner happens to be a player.

### Explicitly Spawn An Attack

Use this when a defined event creates a separate tear, laser, knife, bomb, or
registered attack entity.

- Discover/verify the type, variant, subtype, spawn call shape, spawner, and
  initial state. Do not use raw fallback ids after a lookup fails.
- Record the ownership link and the source player/familiar at creation. A
  spawner chain may be needed to resolve credit later, but it is not a license
  to control unrelated entities with the same chain shape.
- Specify stacking, cooldown, lifetime, room transition, and failed-spawn
  behavior. Leave omitted gameplay values as `TBD`.

### Registered Custom Projectile

Use this when the attack needs a custom XML entity contract, unique visual,
collision class, HP, or bespoke lifetime.

- Route type/variant/subtype, `entities2.xml`, ANM2, and spritesheet facts to
  `isaac-entities` and `isaac-anm2-visuals`.
- Suppress only the current mod's owned spawn when registration/asset proof is
  missing. Never delete unknown tears/lasers/knives from another mod.

## Ownership And Source Contract

Read `references/projectile-ownership.md` before implementation.

- Prefer an explicit marker written at the moment this mechanic creates or
  modifies the projectile. Resolve the live source owner separately when a
  later callback needs player stats, item ownership, or co-op credit.
- Treat `SpawnerEntity`, `Parent`, type, variant, and subtype as evidence to
  verify, not universal ownership. A player-spawned vanilla tear can belong to
  a different item or mod mechanic.
- For a familiar-fired attack, prove both the familiar identity/owner and the
  spawned projectile marker. Do not infer the player from player zero or a
  global item holder.
- Store runtime-only cooldowns, hit sets, split counters, and delayed state on
  the owned projectile or another explicit owner. Do not serialize live
  entities, players, sprites, or targets.

## Update, Collision, And Damage

- Choose the narrowest discovered update/collision/remove callback and filter.
  A callback return value is callback-specific; do not borrow a `true`/`false`
  convention from another callback.
- Define target eligibility, friendly/enemy policy, damage source, cadence,
  repeat-hit guard, pierce behavior, death/remove settlement, and recursion
  boundary before writing collision code.
- Use an appropriate `EntityRef`/source route when the mechanic directly deals
  damage; do not fabricate player credit from an unrelated entity.
- Separate “a projectile hit this frame” from “the projectile later died or
  was removed” so collision and remove callbacks cannot settle the same effect
  twice.
- A split/reflect/replace mechanic must mark children and define whether they
  can recursively trigger the parent mechanic. Do not let every child re-enter
  an unbounded fire/update loop.
- Do not mutate gameplay from a pure render callback. Do not use screen-space
  coordinates for world projectile movement.

## Compatibility And Boundaries

- Official Isaac APIs and discovered project helpers come first. An undeclared
  third-party library is not a default dependency; if optionally supported,
  guard it and retain an official-API fallback.
- Do not treat every foreign projectile as invalid or clean it up globally.
- Boss/NPC projectile patterns, phases, and target selection belong to
  `isaac-npc-boss-ai`; use this skill only when the attack is player/familiar
  owned.
- Reward spawning after a projectile dies belongs to `isaac-rewards-pickups`.

## Required Output

```markdown
## Projectile Combat Contract

- Creation route:
- Source event and callback:
- Owned-projectile proof:
- Source player/familiar credit route:
- Type / variant / subtype and registration facts:
- Spawn/augment fields:
- Update and animation route:
- Collision/damage/return policy:
- Repeat-hit, split, and recursion policy:
- Remove/death/lifetime policy:
- Runtime state and reset conditions:
- Optional dependency boundary:
- Tests and in-game checks:
```

## Final Review

Read `references/projectile-review-checklist.md` before completion. Report the
creation authority, ownership proof, exact source route, callbacks, damage and
repeat-hit guard, cleanup behavior, compatibility boundary, and the automated
versus in-game checks.
