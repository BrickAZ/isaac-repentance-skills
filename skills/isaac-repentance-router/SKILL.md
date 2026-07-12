---
name: isaac-repentance-router
description: "Route Binding of Isaac: Repentance mod requests to the smallest correct combination of Isaac skills before implementation. Use when a request spans multiple Isaac surfaces, when an agent is unsure which Isaac skill should be primary, when planning a feature/review/debug task, or when a low-context agent needs a safe skill order. This skill only classifies and sequences work; it does not implement the feature. 中文触发：该用什么 skill、技能选择、skill 路由、开发顺序、多个 skill、以撒模组规划、先用哪个 skill。"
---

# Isaac Repentance Router

Use this skill to produce a small, ordered route. It dispatches work; it does
not discover a project or implement a feature.

## Boundary

- `isaac-mod-context` discovers actual project facts.
- This skill selects one primary specialist and necessary companions.
- Never list `isaac-repentance-router` itself anywhere in the route.

If a target project must be read, edited, reviewed, or tested and its facts are
unknown, put `isaac-mod-context` in **Project discovery** as a preflight. It is
primary only when discovery/adaptation is the user's whole request. A preflight
is not a companion or near-match: do not repeat `isaac-mod-context` in those
sections. For a feature, bug, or refactor, primary remains its specialist.

Do not inspect code merely to route. This skill is generic: do not assume a
layout, project profile, optional API, or third-party library.

## Confirmed Versus Conditional Surfaces

User wording confirms a semantic surface even when project facts are unknown:
“custom card is blank” confirms cards/pockets; “cancel damage” confirms
damage/health; “player head marker” confirms HUD/UI; “split `main.lua`” confirms
architecture. Route those as primary or immediate companions now.

Treat project-specific facts as unknown until discovery: callback names, paths,
IDs, resource formats, entity variants, existing modules, tests, and optional
libraries. Put a skill under **Conditional** only if its semantic surface is not
stated, such as ANM2 versus another visual carrier, EID/MCM/StageAPI/REPENTOGON,
or undeclared entity/audio/description work.

## Routing Rules

1. Classify the goal: discovery, design, implementation, review, debug, or
   verification.
2. Choose exactly one primary specialist. Discovery preflight cannot displace it.
3. Add immediate companions for separately stated semantic surfaces only.
4. Put optional/unproven surfaces under Conditional.
5. Put verification skills in **Verification route** by default. Include
   `isaac-testing-debugging` as an immediate companion only when debugging/proof
   itself is central; include `isaac-validators` immediately only when static
   XML/id/asset validation is already a stated surface.
6. Keep user values locked. Do not choose balance, assets, persistence, callback
   returns, or dependencies.
7. Exclude near-matches that would duplicate or conflict with the route.

## Primary Matrix

| Stated central behavior | Primary specialist |
| --- | --- |
| Project discovery/adaptation only | `isaac-mod-context` |
| Ambiguous gameplay contract | `isaac-mechanic-contracts` |
| Callback signature/registration/return | `isaac-callback-contracts` |
| Damage, healing, i-frames, lethal/re-entry | `isaac-damage-health-contracts` |
| Passive held ownership/count/cache/loss | `isaac-passive-collectibles` |
| Active-item use/charge/input/slot | `isaac-active-item-mechanics` |
| Pools, quality, weights, tags, availability | `isaac-item-economy` |
| Cards, runes, pills, blank pocket content | `isaac-cards-pockets` |
| Trinket behavior | `isaac-trinkets` |
| Player/familiar projectile combat | `isaac-projectile-combat` |
| Entity/effect lifecycle | `isaac-entities` |
| Familiar behavior | `isaac-familiars` |
| NPC/Boss AI | `isaac-npc-boss-ai` |
| Custom player/tainted character | `isaac-players-characters` |
| HUD/prompts/world-following marker/UI state | `isaac-hud-ui-state` |
| ANM2 load/animation/assets | `isaac-anm2-visuals` |
| Sound/shader/overlay/input blocking | `isaac-audio-render-feedback` |
| Reward/pickup Spawn/Morph/selection | `isaac-rewards-pickups` |
| Challenge rules | `isaac-challenges` |
| Unlock/progress/achievement | `isaac-unlocks-progression` |
| Rooms/stages/doors/grids | `isaac-rooms-stages` |
| Optional descriptions/dependency integration | `isaac-compat-descriptions` |
| Runtime translation | `isaac-localization-runtime` |
| Mod config/options | `isaac-config-options` |
| Stutter/per-frame scan/repeated Spawn/cache | `isaac-performance-hotpaths` |
| Module ownership/refactor | `isaac-mod-architecture` |
| Static checks | `isaac-validators` |
| Reproduction/debug/proof | `isaac-testing-debugging` |

## Common Routes

- Held passive that cancels damage and shows a head marker: primary
  `isaac-passive-collectibles`; companions damage-health, callback, state, HUD;
  project context is preflight; testing/validators go in verification.
- Projectile with damage rewriting: primary projectile-combat; add damage-health
  only for cancellation/replacement/health semantics.
- Blank card: primary cards-pockets; context is preflight; testing-debugging is
  immediate because the user asked for diagnosis; validators are verification;
  ANM2/descriptions/compatibility are conditional.
- Large entry-file split: primary mod-architecture; context is preflight; keep
  mechanism/entity/item/compat skills out unless discovery proves the refactor
  actually changes those surfaces.

## Required Output

Before implementation, output a clear route plan using these fields, in this
order: request classification; confirmed facts; project discovery and reason;
primary skill; companions in order; conditional skills; excluded near-matches;
locked/TBD user decisions; and verification route.

Do not write code, fabricate project facts, invoke project profiles, or route to
every related skill.
