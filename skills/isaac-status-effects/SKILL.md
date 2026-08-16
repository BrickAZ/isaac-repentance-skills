---
name: isaac-status-effects
description: "Use when designing, implementing, reviewing, debugging, or writing handoff prompts for Binding of Isaac: Repentance status effects and debuffs, including poison, burn, slow, freeze, fear, charm, confusion, shrink, Midas, bleeding, custom marks, status flags, duration, stacking, refresh, immunity, source attribution, periodic damage, and removal. This skill separates status application from projectile ownership and damage replacement so agents do not double-damage targets, affect ineligible entities, or erase foreign-mod status. 中文触发：状态效果、异常状态、中毒、燃烧、减速、冻结、恐惧、魅惑、混乱、石化、流血、标记、持续时间、叠加、刷新、免疫、状态来源、清除状态。"
---

# Isaac Status Effects

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Core Principle

A status effect is a timed contract among an applicator, a target, an engine or
custom status carrier, and an expiry rule. A visible tint, entity flag, or
callable method alone does not prove the target is eligible, the source is
credited correctly, the duration unit is known, or repeated applications are
safe.

Use official Isaac APIs and the target project's proven code by default. Treat
all third-party helpers as optional until the project declares and guards them.

## Boundary

This skill owns eligibility, application, duration, stacking/refresh,
source attribution, immunity, removal, and status-owned runtime state.

- Use `isaac-projectile-combat` for the tear, laser, bomb, knife, or projectile
  that carries the proc and for hit ownership.
- Use `isaac-damage-health-contracts` when status application cancels, replaces,
  adds, or recursively causes damage or changes player health.
- Use `isaac-npc-boss-ai` when the status changes a custom NPC state machine.
- Use `isaac-anm2-visuals` or `isaac-audio-render-feedback` only for a separately
  stated visual or audio carrier.
- Use `isaac-state-lifecycle` for custom status persistence beyond a simple
  engine-owned duration.

Do not use this skill merely because an attack happens to have a color. Route by
gameplay behavior, not appearance.

## First Move

1. Use `isaac-mod-context` in an unfamiliar mod. Discover the actual source item,
   player/familiar/projectile owner, target callback path, API surface, helpers,
   entity filters, state owner, and tests.
2. Classify the status as engine-owned built-in status, entity-flag state,
   custom timed state, or presentation-only feedback.
3. Read `references/status-effect-contract.md` and write the complete contract
   before selecting callbacks or API methods.
4. Keep chance, duration, tick damage, stacking, caps, immunities, Boss policy,
   and friendly-target policy as user decisions unless already specified.

## Required Contract

For every status route, define:

| Field | Required proof or decision |
| --- | --- |
| Applicator | Actual player, familiar, entity, projectile, environment, or no owner |
| Target | Exact entity classes, vulnerable/alive state, friendly/charmed exclusions |
| Trigger | Hit, damage accepted, room event, use, proximity, timer, or another proven edge |
| Carrier | Verified built-in API/flag or project-owned runtime state |
| Duration | Unit, start tick, refresh point, pause behavior, and expiry |
| Repeat policy | Reject, refresh, extend, replace, stack magnitude, or independent stacks |
| Effect | Movement/AI change, periodic damage, control, tint, mark, or another result |
| Source credit | Damage/kill/RNG/synergy owner and fallback for invalid sources |
| Immunity | Boss, champion, friendly, invulnerable, segmented, player, and special entities |
| Removal | Expiry, death, morph, room exit, source loss, cleanse, reload, and mod unload |

## Hard Rules

- Verify the exact callable method, flag, parameter meaning, and duration unit
  from the target API/project. Never infer one status method's signature from
  another or pass a plain Lua table where engine userdata is required.
- Filter target eligibility before application. A numeric entity type or
  `IsActiveEnemy`-like test alone may still include friendly, charmed,
  invulnerable, dead, segmented, or foreign special entities.
- Decide whether the status begins on collision, on attempted damage, or only
  after accepted damage. These edges are not interchangeable.
- Do not add manual periodic damage when the chosen engine status already owns
  damage ticks unless the mechanic explicitly defines an additional hit.
- Keep source attribution live and target-scoped. Do not credit player zero,
  the first player, or the nearest entity when the actual source is unavailable.
- Never use one global boolean or timer for all targets. Co-op players, multiple
  enemies, segmented entities, and simultaneous applications must remain
  isolated.
- Do not remove every matching vanilla flag or status from the room. Clear only
  state this mod owns and only when the contract requires early removal.
- Treat color/tint, particles, icons, and ANM2 as feedback rather than proof
  that gameplay state exists. Likewise, an invisible state can still be active.
- Do not serialize live entities, players, `EntityRef`, sprites, or userdata.
  Reconcile serializable custom state against live targets after load if the
  approved design requires persistence.
- Use seeded/project-owned RNG for gameplay proc chance. Cosmetic variation may
  use a separate stream but must not advance gameplay selection.

## Verification

Cover at least one eligible application, one excluded target, one repeat
application, expiry, invalid/dead source, target removal or morph, two sources
or co-op players, and room/reload cleanup when applicable. Add focused cases for
Bosses, friendly/charmed enemies, segmented entities, and periodic-damage
recursion if they are in scope.

Static proof can confirm filters, references, and state shape. A mock can confirm
branching only if it enforces real userdata and call signatures. Duration,
immunity, tick cadence, movement/AI effects, and engine status visuals require
in-game verification.

## Required Output

```markdown
## Status Effect Contract

- Status route and verified carrier:
- Applicator and source proof:
- Eligible targets and exclusions:
- Trigger edge:
- Duration unit and expiry:
- Repeat/stack/refresh policy:
- Gameplay effect and periodic-damage ownership:
- Immunity and Boss policy:
- Custom runtime state owner/key:
- Removal and lifecycle boundaries:
- Companion skills and callback/API facts to discover:
- Static, isolated, and in-game verification:
- User decisions required:
```

Do not present a built-in status call as a complete implementation until every
field above is either confirmed or visibly unresolved.
