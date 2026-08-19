# Isaac Repentance Skills

English | [简体中文](README.zh-CN.md)

A Codex skill suite for developing mods for *The Binding of Isaac: Repentance*.
It does not provide a "universal template." Instead, it separates the decisions
that commonly go wrong: discover project facts first, then choose the mechanism,
callbacks, resources, state ownership, and validation path.

This repository is the source for a Codex plugin. The plugin manifest is located
at `.codex-plugin/plugin.json`, and the general-purpose skills are under `skills/`.

## Scope

This plugin is exclusively for developing supporting mods for *The Binding of
Isaac: Repentance*. It is not a general-purpose programming toolkit and is not
intended for other games, engines, or application development.

## Core Principles

- Read the target mod before writing an implementation.
- Prefer the official Isaac API and the target mod's existing code by default.
- CuerLib, EID, MCM, StageAPI, and similar libraries are never assumed dependencies.
- Keep values, pools, weights, art direction, and mechanic details that the user has not decided as `TBD`; label them "user decision required" in every response where they matter.
- Never invent paths, entity Variants, ANM2 animation names, callback registration locations, or third-party APIs.
- Report static validation, isolated behavioral tests, and actual in-game verification separately; do not collapse them into a single "verified" claim.
- Native UI surfaces are independent: colored item art, ESC My Stuff icons, card fronts, HUD elements, character select, co-op menu portraits, achievements, and Boss portraits must each be discovered and validated separately.
- When the user has not supplied art, official dimensions are only overridable source-frame recommendations. Generated assets must still be wired into discovered XML, ANM2, spritesheets, and mappings; never assume that a loose PNG loads automatically.

## Current Release Improvements

- Adds overridable official resource baselines for native visual surfaces and explicit routing among colored item art, ESC My Stuff icons, card fronts, HUD elements, and world Pickups.
- Strengthens the boundary among world coordinates, visual/render offsets, callback offsets, and screen coordinates: logical markers default to exactly one `owner.Position + world offset -> Isaac.WorldToScreen` conversion. Other offsets may be consumed only by a discovered project adapter, and each offset may be applied at most once. If conversion fails, rendering must not continue with world coordinates.
- Strengthens blank or meaningless entity safeguards: validate, replace, or clean up only Spawn/Morph paths explicitly owned by the current mod, without interfering with other mods.
- Adds missing-dependency and duplicate-registration evals for EID, MCM, StageAPI, and REPENTOGON while preserving official-API fallbacks.
- Re-audits the structure, evaluations, references, and plugin manifest for all 48 skills. Static validation passes; actual in-game verification remains the responsibility of the target mod and runtime environment.

## New Capabilities in This Release

- **Global TBD reminders:** all 48 skills label unknowns that affect the current work as "user decision required," explain their impact, and summarize unresolved decisions at the end of the response.
- **Five independent runtime contracts:** dedicated skills for status effects, shop/deal pricing, GridEntity logic, Book of Virtues wisps, and transformations/forms now handle source ownership, timing, payment, grid coordinates, wisp mappings, and form activation without overloading damage, economy, room, or ordinary familiar skills.
- **Engine value-type boundaries:** `isaac-entities` and `isaac-testing-debugging` prevent Lua tables from being passed to APIs that require engine values such as `Vector`, and require test doubles to enforce real call boundaries.
- **Room topology and door-slot validation:** `isaac-rooms-stages` and the testing skill distinguish debug rooms, real map connectivity, legal door slots, and local coordinates. When no candidate exists, implementations must not silently consume state or remove unrelated doors.
- **Vanilla mechanic isolation:** `isaac-mechanic-contracts` prevents cleanup code from deleting vanilla-owned rooms, dimensions, or entities after borrowing a vanilla mechanic, and requires same-run isolation checks.
- **Reward, text, and registration consistency:** covers reward confirmation and delayed settlement, static XML localization, runtime local-ID resolution, optional dependencies appearing late, and stable local IDs for collectible registration.
- **Colored item transparency contract:** colored `gfx` must use a subject alpha mask instead of making every non-key-color pixel opaque. Review on a light-gray checkerboard, white, and a room-like background, then inspect every ANM2 crop frame. `isaac-validators -CheckPngTransparency` warns about missing alpha, uniform outer backgrounds, or suspected embedded dark plates, but native in-game surface review is still required.
- **Character art surface routing:** strictly separates in-game skins, hair/head accessories, portraits, names, character select, co-op, and death-screen assets. A spritesheet crop is coordinate capacity, not a visual fill target; ordinary hair should be sized against the vanilla head and native 1x compositing.
- **Vanilla reskin and resource override contracts:** recognizes Lua-free resource-only mods, discovers `resources/` and versioned resource roots, distinguishes exact-path overrides, runtime spritesheet replacement, and Null Costumes, and keeps load order and occlusion strategy as explicit compatibility decisions.
- **Sound and music evidence contracts:** separates `sounds.xml`/`SFXManager` from `music.xml`/`MusicManager`. Ordinary short sound effects should prefer PCM WAV unless the target project has already proven another loading route. A successful `pcall` or silent test double proves only that the Lua call completed; the latest game log and audible in-game playback remain required evidence.

## Skill Map

### Project Discovery and Reliable Implementation

| Skill | Purpose |
| --- | --- |
| `isaac-mod-context` | Discovers real entrypoints, resources, XML, dependencies, and validation commands. |
| `isaac-mod-architecture` | Defines module boundaries and integration points while preventing duplicate registration. |
| `isaac-repentance-router` | Selects one primary skill for an unfamiliar request and limits the number of supporting skills. |
| `isaac-mechanic-contracts` | Defines a mechanic's inputs, outcomes, and boundaries before selecting an implementation. |
| `isaac-callback-contracts` | Selects callbacks, filters, registration timing, and return-value semantics. |
| `isaac-state-lifecycle` | Manages runtime state, SaveData, and cleanup across rooms, restarts, and deaths. |
| `isaac-performance-hotpaths` | Reviews per-frame scans, repeated Spawn calls, and other performance hot paths. |
| `isaac-testing-debugging` | Reproduces, debugs, and validates issues in layers, with separate checks for each native UI surface. |
| `isaac-validators` | Checks XML, resource references, duplicate IDs, common callback mistakes, and entity-generation chains owned by the current mod. |

### Entities and Combat

| Skill | Purpose |
| --- | --- |
| `isaac-entities` | Handles registered entities, collision, lifecycle, and visual carriers. |
| `isaac-familiars` | Handles familiar spawning, ownership, multiplayer behavior, and respawning. |
| `isaac-wisps-virtues` | Handles Book of Virtues, `wisps.xml`, wisp sources, repeated use, capacity, death, and resource mappings. |
| `isaac-npc-boss-ai` | Designs NPC/Boss state machines and attack pacing. |
| `isaac-projectile-combat` | Manages projectile ownership, damage, hits, and cleanup. |
| `isaac-status-effects` | Manages target eligibility, sources, duration, stacking/refresh, immunity, periodic damage, and cleanup for status effects. |
| `isaac-players-characters` | Develops custom characters and Tainted variants. |

### World and Space

| Skill | Purpose |
| --- | --- |
| `isaac-rooms-stages` | Handles individual rooms, floors, doors, room topology, and stage transitions. |
| `isaac-grid-entities` | Handles GridEntity indices, legal positions, collision, destruction, ownership, and room revisits. |
| `isaac-room-networks` | Handles independent areas made of multiple custom rooms, including entry, routing, return paths, and local failure. |
| `isaac-dimensions` | Handles engine-level Dimensions, cross-dimension entry/return, isolation, and lifecycle. |

### Items, Rewards, and Progression

| Skill | Purpose |
| --- | --- |
| `isaac-active-item-mechanics` | Provides a routing shell for active-item charge, input, UI, and related mechanisms. |
| `isaac-passive-collectibles` | Manages passive collectible ownership, Cache evaluation, loss, rerolls, and reacquisition. |
| `isaac-collectible-registration` | Handles active/passive collectible XML and separates colored art from the native ESC My Stuff icon pipeline. |
| `isaac-cards-pockets` | Handles cards, runes, pills, and pocket items; separates card fronts, Pickups, and HUD/EID surfaces while preventing blank entities. |
| `isaac-trinkets` | Handles trinket registration, ownership checks, stacking, and independent visual surfaces. |
| `isaac-item-economy` | Reviews quality, pools, weights, tags, and post-unlock economic impact. |
| `isaac-shops-deals-pricing` | Handles runtime prices, purchasers, payment, delivery, restocking, and reroll recalculation for shops and deals. |
| `isaac-item-synergies` | Defines ownership, stacking, and invalidation boundaries for collectible, trinket, and character synergies. |
| `isaac-transformations-forms` | Handles vanilla PlayerForm queries, custom transformations, contribution counts, activation, reversibility, and display routing. |
| `isaac-reroll-removal-contracts` | Manages idempotent reconciliation after rerolls, removal, and replacement. |
| `isaac-rng-determinism` | Manages random sources, draw boundaries, seed scope, and multiplayer reproducibility. |
| `isaac-rewards-pickups` | Handles reward selection, Spawn/Morph behavior for already-owned targets, world Pickup resource chains, and preserving the original on failure. |
| `isaac-challenges` | Handles challenge XML, starting items, and run rules. |
| `isaac-unlocks-progression` | Handles permanent unlocks, achievements, saves, availability gates, and independent display surfaces. |

### Damage, Curses, and Run Rules

| Skill | Purpose |
| --- | --- |
| `isaac-damage-health-contracts` | Handles damage semantics, invulnerability frames, source ownership, recursion, and lethal/revival boundaries. |
| `isaac-curses-run-modifiers` | Manages runtime addition, suppression, recalculation, and cleanup for existing curse bits. |

### Assets, Text, and Optional Integrations

| Skill | Purpose |
| --- | --- |
| `isaac-character-art-surfaces` | Separates character art surfaces and constrains vanilla-reference editing, hair/accessory scale, 1x composite previews, costume occlusion matrices, and helmet-like failures. |
| `isaac-reskins-resource-overrides` | Handles vanilla character reskins, resource-only mods, exact-path overrides, multiple resource roots, runtime replacement, and load-order conflicts. |
| `isaac-anm2-visuals` | Handles ANM2, Sprite usage, coordinate spaces, visual carriers, and overridable native UI resource baselines. |
| `isaac-audio-render-feedback` | Handles SFX/music registration and formats, manager responsibilities, decoding evidence, shaders, rendering, and input interception. |
| `isaac-hud-ui-state` | Manages HUD/UI display, world-to-screen conversion, and short-lived state cleanup. |
| `isaac-localization-runtime` | Handles runtime localization and dependency routing. |
| `isaac-compat-descriptions` | Handles EID/encyclopedia descriptions and optional-dependency compatibility. |
| `isaac-config-options` | Handles configuration, SaveData, and optional MCM integration. |
| `isaac-eid-compat` | Handles optional EID descriptions, icons, and language registration. |
| `isaac-mcm-compat` | Handles optional Mod Config Menu integration and duplicate registration. |
| `isaac-stageapi-compat` | Handles optional StageAPI rooms, stages, and version compatibility. |
| `isaac-repentogon-compat` | Handles optional REPENTOGON APIs, version gates, and official-API fallbacks. |

## Validation and Evidence Boundaries

Repository checks validate frontmatter, internal references, TBD contracts, router
coverage, eval schemas, offline third-party API references, and evidence matrices for
all 48 skills. On Windows, the scripts explicitly run `quick_validate.py` in UTF-8
so the system GBK code page does not misclassify valid Chinese text as an encoding
error.

```powershell
powershell -ExecutionPolicy Bypass -File tests/test-skill-repository.ps1
```

In `evals.json`, `files` are real repository context and `fixture_files` are
fictional project files supplied by the scenario. See `docs/eval-schema.md` for the
full contract. Static audits, blind-test answers, simulated runtime tests, and
in-game verification are four different kinds of evidence; passing an earlier
layer must never be reported as passing a later one.

## What This Repository Does Not Do

These skills do not decide balance values, visual style, or mechanic design for the
user, and they do not claim that unexecuted code has passed in-game verification.
Project facts and user decisions always take priority over general patterns.

## Repository Structure

```text
.codex-plugin/plugin.json  Codex plugin manifest
skills/                    48 general Isaac skills
AGENTS.md                  Scope contract for AI agents maintaining this repository
```
