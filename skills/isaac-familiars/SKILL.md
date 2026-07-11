---
name: isaac-familiars
description: Design, implement, review, or write handoff prompts for custom Binding of Isaac Repentance familiars and companion behavior. Use this whenever a collectible, trinket, character, or mechanic owns a familiar; when `MC_EVALUATE_CACHE`, `CACHE_FAMILIARS`, `CheckFamiliar`, `MC_FAMILIAR_INIT`, `MC_FAMILIAR_UPDATE`, `Familiar.Player`, followers, orbit, familiar collision/damage, multi-copy familiars, wisps, or co-op familiar ownership are involved. Use isaac-mod-context first in an unfamiliar project. This skill separates cache-owned familiar counts from per-familiar behavior so agents do not manually respawn or globally control the wrong companion. 中文触发：使魔、跟班、宝宝、familiar、CACHE_FAMILIARS、CheckFamiliar、MC_FAMILIAR_UPDATE、跟随、环绕、使魔攻击、多使魔、合作模式使魔、魂火。
---

# Isaac Familiars

Use this skill when the primary gameplay object is a familiar or companion.

This skill owns the familiar-specific contract: how count reaches the engine,
which player owns each instance, how an instance moves and acts, and when it
must be refreshed, removed, or left for the engine to recreate. It does not
replace `isaac-entities` for XML allocation, `isaac-anm2-visuals` for assets,
or `isaac-state-lifecycle` for broader persistence.

## First Move

Before editing or writing a prompt:

1. Use `isaac-mod-context` in an unfamiliar mod. Discover the mod object, entity XML, item/character owner, module entrypoint, familiar examples, and test commands.
2. Read `../isaac-mod-context/references/design-authority.md`. Keep the intended count, attack, damage, persistence, and removal policy as `TBD` unless the user decided them.
3. Classify the familiar route with `references/familiar-contract.md`: cache-owned custom familiar, event-spawned temporary familiar, or a tightly owned change to an existing vanilla familiar/wisp.
4. Read the closest current-project cache handler and familiar update handler before choosing callbacks or state fields.
5. Use `isaac-entities` for type/variant/subtype and `entities2.xml`; use `isaac-anm2-visuals` for ANM2 and spritesheet facts.
6. Use `isaac-callback-contracts`, `isaac-state-lifecycle`, `isaac-testing-debugging`, and `isaac-validators` for the applicable secondary surfaces.

When the target project is available, perform this discovery before listing
facts as `TBD`. “Do not assume a path/name” requires searching for it; it does
not allow an Agent to skip the project and label every fact unknown.

Do not require any reference mod or library checkout. Reference patterns are
not runtime dependencies or default APIs.

## Choose One Spawn Authority

### Cache-Owned Familiar

Use this for a familiar that exists because the player currently owns an item,
effect, character condition, or another declared count source.

- Derive the target count in the discovered `MC_EVALUATE_CACHE` path only when the cache flag is `CACHE_FAMILIARS`.
- Use the engine's discovered `CheckFamiliar` convention with a verified
  variant, count source, RNG, item config, and subtype policy. Do not invent
  its arguments or a fallback variant.
- When the count source changes outside cache evaluation, use the project's
  verified cache-refresh route. Do not repeatedly manual-Spawn the same
  permanent familiar from `MC_POST_UPDATE`.
- State exactly whether duplicate collectible copies, temporary item effects,
  Box of Friends-like multipliers, and character grants affect count. Leave
  omitted policies as `TBD`.

### Event-Spawned Temporary Familiar

Use this only when a specific event deliberately creates a temporary companion
that is not the engine representation of a standing item count.

- Define the spawn event, owner, type/variant/subtype, duration/remove rule,
  and whether repeated events stack, refresh, or reject.
- Register and validate it as an owned entity. Do not use an unverified raw
  id and do not clean up unfamiliar third-party familiars.
- Do not also recreate it through `CheckFamiliar` unless the mechanic
  explicitly has two different, documented familiar types.

### Existing Vanilla Familiar Or Wisp

Use this only for an explicitly requested, narrowly identified existing
familiar/wisp behavior or presentation change.

- Filter by the intended variant and, when relevant, subtype/source item and
  owner. Variant alone is not proof that every matching familiar is yours.
- Never globally rewrite all familiars of a shared vanilla variant just because
  the current player owns one related item.
- Treat a wisp's subtype/item source and a custom familiar's XML variant as
  different identity contracts.

## Per-Familiar Behavior Contract

Read `references/familiar-contract.md` before implementation.

- In init, establish only instance-owned runtime state and confirm the live
  `familiar.Player`/owner route. Make init safe if the engine recreates an
  instance after a cache refresh.
- In update, filter the intended familiar identity first, resolve its live
  owner, then advance one explicit state machine: follow/orbit, idle, target,
  attack, detached return, cooldown, or another user-approved state.
- A following familiar and a detached attacker need deliberate follower
  membership transitions. Do not call follow/orbit movement while a charged
  or detached state owns velocity.
- Store instance state on the familiar's discovered runtime data surface. Do
  not key all instances only by variant, and do not serialize live entities,
  players, sprites, or targets.
- For collision or damage, specify target eligibility, source `EntityRef`,
  damage cadence/cooldown, repeat-hit behavior, and self-trigger protection.
  BFFS scaling or other synergies are design choices unless the project/user
  already defines them.
- When a familiar fires or modifies tears, lasers, knives, bombs, or another
  combat projectile, use `isaac-projectile-combat` for source proof,
  projectile state, collision, damage, and cleanup. Keep this skill focused on
  familiar count, owner, and behavior.
- Read the actual ANM2 before playing animation names. Update movement and
  animation from the chosen state, not from an unrelated global render loop.

## Owner, Copies, And Co-op

- Use `familiar.Player` or the project's proven equivalent as the primary
  owner. Do not infer owner from the first player, player index, or a global
  item holder.
- Test at least two players, one owner with multiple copies, and two owners
  with the same familiar variant. Each update, damage, and removal path must
  remain instance/owner scoped.
- If the familiar is sacrificed, transformed, or deliberately removed, decide
  whether the source item/count changes too. Removing only the entity from a
  cache-owned source normally lets the engine recreate it on the next refresh.
- Do not scan all room familiars and delete/select an instance until owner,
  temporary exclusions, and source eligibility are proven.

## Lifecycle And Compatibility

- Define what persists across room, floor, death, reload, item loss, and cache
  refresh. Runtime behavior state is not automatically SaveData.
- Keep room-only targets, damage cooldowns, and detached attack state from
  leaking into a recreated instance or another player.
- Use only official Isaac APIs by default. A declared third-party library may
  be used through its project convention; an undeclared library is optional,
  guarded, and must have an official-API fallback.
- Never spawn or delete an unknown familiar merely because it lacks a current
  mod mapping. Another mod may own it.

## Required Output

```markdown
## Familiar Contract

- Route: cache-owned | temporary event-spawned | owned vanilla/wisp change
- Source/count authority:
- Entity type / variant / subtype:
- XML and ANM2 facts to discover:
- Owner proof:
- Init and update callbacks:
- Movement/follower policy:
- Attack/collision/damage policy:
- Copy, synergy, and co-op policy:
- Remove/refresh/item-loss policy:
- Runtime state and reset conditions:
- Optional dependency boundary:
- Tests and in-game checks:
```

## Final Review

Read `references/familiar-review-checklist.md` before completion. Report the
actual cache/spawn authority, count source, registration facts, owner route,
callbacks, movement state, damage safeguards, lifecycle behavior, and the
automated versus in-game checks.
