---
name: isaac-wisps-virtues
description: "Use when designing, implementing, reviewing, debugging, or writing handoff prompts for Binding of Isaac: Repentance Book of Virtues and wisp integration, including `wisps.xml`, item-wisp mapping, `AddWisp`, item-wisp subtype identity, active-use flags, Car Battery or duplicate uses, owner player, wisp count/capacity, HP, damage, tear behavior, death/removal effects, sprites, co-op, and reroll or item-loss reconciliation. This skill owns Virtues-specific contracts; ordinary custom familiars remain under isaac-familiars. 中文触发：美德书、魂火、灵火、wisp、wisps.xml、AddWisp、ITEM_WISP、主动道具魂火、Car Battery、魂火数量、魂火死亡、魂火贴图、合作模式魂火。"
---

# Isaac Wisps And Virtues

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Core Principle

A Virtues wisp is not merely a familiar-shaped sprite. Its runtime identity must
remain tied to the correct collectible/use event and player, while its XML or
code-defined behavior, count, damage, death, and resource surfaces agree.

Use official Isaac APIs and discovered project conventions by default. Do not
assume CuerLib or another active-item helper is installed.

## Boundary

This skill owns Book of Virtues eligibility, item-to-wisp mapping, active-use
semantics, wisp subtype/source identity, count/capacity, wisp-specific behavior,
death/removal, and `wisps.xml`/resource synchronization.

- Use `isaac-active-item-mechanics` for the active item's ordinary success,
  charge, slot, input, animation, and consumption contract.
- Use `isaac-familiars` for a normal custom familiar, cache-owned companion, or
  non-Virtues follower/orbiter.
- Use `isaac-projectile-combat` for wisp-fired tears, lasers, knives, bombs, or
  collision damage and source attribution.
- Use `isaac-collectible-registration` for the collectible's XML/local ID and
  runtime lookup.
- Use `isaac-anm2-visuals` for the proven wisp ANM2/spritesheet/crop chain.
- Use `isaac-reroll-removal-contracts` when item loss, reroll, duplication, or
  replacement must remove or rebuild owned wisps.

## First Move

1. Use `isaac-mod-context` in an unfamiliar mod. Discover collectible
   registration, active use handlers, wisp XML/resource roots, existing wisp
   helpers, item-wisp callbacks, owner resolution, and tests.
2. Read `references/wisp-virtues-contract.md` and classify the route: native
   Virtues integration, custom `wisps.xml` definition, explicit event-spawned
   item wisp, or ordinary familiar.
3. Keep spawn count, HP, damage, tear flags, orbit behavior, duplicate-use
   policy, capacity/eviction, death effect, and item-loss behavior as user
   decisions unless explicitly defined.
4. Prove the exact active-use and wisp APIs before writing callbacks, flags, XML
   attributes, or subtype values.

## Wisp Contract

| Field | Required fact or decision |
| --- | --- |
| Source item | Stable XML-local ID plus discovered runtime collectible ID |
| Creation edge | Successful active use, duplicate use, explicit event, room/start state |
| Owner | Exact player and active slot/use context |
| Identity | Verified item-wisp variant/subtype or project-owned custom identity |
| Definition | Native default, discovered `wisps.xml`, or project-owned runtime behavior |
| Count | Wisps per successful use, duplicate-use treatment, capacity/eviction |
| Combat | HP, contact behavior, shots, damage, flags, target and source credit |
| Lifecycle | Damage/death, item loss, reroll, room/floor, player death, continue/reload |
| Resources | Exact XML/ANM2/PNG paths, animation names, and load root |

## Hard Rules

- Resolve the wisp's source through the registered collectible identity. Never
  hard-code a post-vanilla global ItemConfig number or substitute XML-local ID
  for runtime ID.
- Decide whether the wisp is created by native Book of Virtues behavior,
  `wisps.xml`, an explicit API call, or project code. Do not let two authorities
  spawn the same wisp for one use.
- Determine whether the active use actually succeeded before creating a wisp.
  Failure/no-consume/no-animation flags and charge behavior do not automatically
  mean “successful Virtues use.”
- Treat normal use, Car Battery-like repeated invocation, queued/secondary use,
  no-animation calls, and scripted uses as separate events until the exact
  callback flag contract is proven. Do not double-spawn accidentally.
- Bind every wisp to the actual using player. Do not infer owner from player zero
  or scan for any player holding Book of Virtues.
- Filter item-wisp identity by the proven variant plus subtype/source item and
  owner. Variant alone can capture vanilla or foreign-mod wisps.
- Do not promise “inherits all player tears” or “copies every active effect.”
  Enumerate HP, damage, cadence, tear flags/variant, targeting, and unsupported
  interactions explicitly.
- Respect engine/project capacity and eviction behavior. Never solve a limit by
  deleting unknown wisps or repeatedly respawning owned wisps every update.
- Define whether owned wisps survive source-item loss, reroll, room/floor change,
  player death, or continue. Removal must target only proven owned instances.
- Read actual `wisps.xml`, ANM2, and PNG paths. Do not invent a loose image,
  animation name, or XML root and assume the game auto-loads it.
- Keep runtime entity/sprite references out of SaveData. Persist only approved
  serializable intent, then reconcile against live player/wisp state.

## Verification

Test successful and failed active use, ordinary and repeated-use flags, two
players using the same active, multiple copies/uses, capacity behavior, wisp
damage/death, source-item loss/reroll, room/floor transition, player death, and
continue/reload. Verify exact item-wisp subtype and resources in game.

Static inspection can prove XML/ID/resource references and flag branches. A mock
can prove duplicate suppression only if it models the real callback sequence.
Native Virtues creation, capacity, wisp combat, death, orbit, and rendering
require in-game verification.

## Required Output

```markdown
## Book of Virtues / Wisp Contract

- Route and creation authority:
- Source collectible local/runtime identity:
- Successful-use and duplicate-use semantics:
- Owner player/slot proof:
- Wisp variant/subtype/definition:
- Count, capacity, and eviction policy:
- HP/combat/inheritance policy:
- Death, item-loss, reroll, and lifecycle behavior:
- XML/ANM2/PNG facts to discover:
- Companion skills and exact callback/API facts:
- Static, isolated, and in-game verification:
- User decisions required:
```
