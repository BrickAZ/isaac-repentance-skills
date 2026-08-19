# Isaac Repentance Skills

English | [简体中文](README.zh-CN.md)

A Codex skill suite built specifically for *The Binding of Isaac: Repentance*
mod development. It helps AI inspect the real project before handling mechanics,
callbacks, entities, assets, state, compatibility, and validation, reducing the
chance of code that looks plausible but uses the wrong API, coordinate space,
resource pipeline, or lifecycle.

This repository is not an Isaac mod and does not force every project into one
template. After installation, describe your task normally. Codex can select the
relevant skills while treating the target mod and the official Isaac API as the
primary sources of truth.

> [!IMPORTANT]
> **English-language validation status**
>
> This skill suite was created alongside a Chinese-first Isaac mod project. It
> has **not** been validated as a completely English-only development workflow
> from project discovery through implementation, debugging, and handoff.
>
> The verified scope is narrower: mod content implemented with guidance from
> these skills has run correctly when *The Binding of Isaac: Repentance* is set
> to English. That demonstrates English in-game runtime and localization
> compatibility for the tested content; it does not prove 100% equivalence for
> every English prompt, generated description, diagnostic exchange, project
> convention, or optional third-party integration.

## What It Helps With

- **Discover before implementing:** locate real entrypoints, modules, XML, resource paths, registration patterns, and test commands instead of inventing project facts.
- **Separate high-risk mechanics:** use focused contracts for collectibles, cards, trinkets, characters, familiars, entities, bosses, rooms, dimensions, unlocks, damage, and RNG.
- **Keep visual surfaces distinct:** separate colored item art, ESC My Stuff icons, Pickups, card fronts, HUD elements, player skins, accessories, portraits, and ANM2 pipelines instead of reusing one PNG everywhere.
- **Constrain callbacks and state:** define callback filters, return semantics, ownership, co-op isolation, SaveData, and cleanup across rooms, floors, deaths, and restarts.
- **Preserve compatibility by default:** mutate only entities, replacements, and state owned by the current mod rather than globally deleting unknown third-party content.
- **Report evidence honestly:** keep static inspection, isolated tests, simulated runtime behavior, and in-game verification separate. A silent test double is not proof that the game works.

## Scope

This repository is only for *The Binding of Isaac: Repentance* mod development.
It is not a general programming toolkit and does not apply to other games,
engines, or application development.

The skills are self-contained. Users do not need YSD, Reverie, Samael, Reimu,
neverbrith, or any other reference mod. Reference mods were used to build and
validate guidance; they are not runtime dependencies.

The default authority order is:

1. confirmed code and resources in the target mod;
2. the official Isaac API;
3. third-party libraries explicitly declared by the project or requested by the user.

CuerLib, EID, MCM, StageAPI, REPENTOGON, and similar libraries are never assumed
dependencies.

## Installation

The installation method directly verified by this repository is to install the
individual skill directories under `skills/`. The repository also includes
`.codex-plugin/plugin.json`, but this guide does not claim that a GitHub URL or
plugin-store button can perform one-click installation without a verified public
installation route.

### Global Installation

Global installation makes the skills available to Codex projects on the current
machine.

Windows PowerShell:

```powershell
git clone https://github.com/BrickAZ/isaac-repentance-skills.git
cd isaac-repentance-skills
$target = Join-Path $HOME ".codex\skills"
New-Item -ItemType Directory -Force $target | Out-Null
Copy-Item -Recurse -Force ".\skills\isaac-*" $target
```

macOS or Linux:

```bash
git clone https://github.com/BrickAZ/isaac-repentance-skills.git
cd isaac-repentance-skills
mkdir -p ~/.codex/skills
cp -R skills/isaac-* ~/.codex/skills/
```

If matching skill directories already exist, these commands update their files.
Back up any important local customizations first. After installing or updating,
open a new Codex task so the skills can be discovered again.

### Project-Local Installation

You can instead copy the required directories from `skills/` into the target
mod's project-local skill directory:

```text
<mod-root>/.codex/skills/
```

This limits the installation to that project and is useful for isolated testing.
Do not copy only `SKILL.md`; the accompanying `references/`, `scripts/`, `evals/`,
and other files are part of the skill contract.

### Verify an Installation

From the repository root, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests/test-installed-skill-parity.ps1
```

This compares the repository with the default global skill directory. It proves
file parity, not that a particular Isaac mod has passed in-game testing.

## Quick Start

You usually do not need to memorize skill names. Open the target mod project and
describe the feature normally:

```text
Add a passive collectible to this Binding of Isaac: Repentance mod that grants
+1 damage while held. Discover the real project entrypoint, collectible
registration pattern, and existing stat implementation first. Do not assume any
third-party dependency. Keep quality, pools, and unlock conditions as TBD and
ask me to decide them.
```

For stricter routing, name the skills explicitly:

```text
Use isaac-mod-context, isaac-collectible-registration,
isaac-passive-collectibles, and isaac-callback-contracts. Report discovered
project facts before implementing, then separate static checks from remaining
in-game validation.
```

When the task is review-only, state the edit boundary directly:

```text
This is a read-only review. Do not modify files.
Check whether this world-following Sprite mixes world coordinates, screen
coordinates, PositionOffset, and callback RenderOffset. Keep unknown project
facts as TBD.
```

When an unresolved fact blocks a reliable implementation, the skills identify it
as:

```text
TBD — user decision required
```

They should also explain what the decision affects. Skills must not silently
choose balance values, pools, weights, unlock conditions, art direction, or
mechanic design on the user's behalf.

## How It Works

A task normally needs one primary skill and only a few supporting skills:

1. `isaac-repentance-router` identifies the primary domain;
2. `isaac-mod-context` discovers the target mod's real structure;
3. domain skills define mechanic, resource, state, and compatibility boundaries;
4. `isaac-testing-debugging` and `isaac-validators` separate what can be proven automatically from what still requires in-game verification.

These skills provide decision contracts, not fixed code templates. Correct
patterns already present in the target project and explicit user decisions always
take priority over general guidance.

## Capability Overview

| Area | Coverage |
| --- | --- |
| Project and reliable implementation | Project discovery, architecture, mechanic contracts, callbacks, state, performance, testing, and static validation |
| Entities and combat | Registered entities, familiars, wisps, NPCs/bosses, projectiles, status effects, and custom characters |
| World and space | Rooms, stages, GridEntity logic, multi-room regions, and engine-level Dimensions |
| Items and progression | Active/passive items, registration, cards, trinkets, economy, shops, synergies, rewards, challenges, and unlocks |
| Run rules | Damage, health, curses, rerolls, removal, RNG, and transformations/forms |
| Assets and compatibility | ANM2, character art, reskins, audio, HUD, localization, and optional third-party APIs |

## Complete Skill Map

### Project Discovery and Reliable Implementation

| Skill | Purpose |
| --- | --- |
| `isaac-mod-context` | Discovers real entrypoints, resources, XML, dependencies, and validation commands. |
| `isaac-mod-architecture` | Defines module boundaries and integration points while preventing duplicate registration. |
| `isaac-repentance-router` | Selects one primary skill for an unfamiliar request and limits supporting skills. |
| `isaac-mechanic-contracts` | Defines a mechanic's inputs, outcomes, and boundaries before choosing an implementation. |
| `isaac-callback-contracts` | Selects callbacks, filters, registration timing, and return-value semantics. |
| `isaac-state-lifecycle` | Manages runtime state, SaveData, and cleanup across rooms, restarts, and deaths. |
| `isaac-performance-hotpaths` | Reviews per-frame scans, repeated Spawn calls, and other performance hot paths. |
| `isaac-testing-debugging` | Reproduces, debugs, and validates issues in layers, including separate checks for native UI surfaces. |
| `isaac-validators` | Checks XML, resource references, duplicate IDs, callback mistakes, and entity-generation chains owned by the current mod. |

### Entities and Combat

| Skill | Purpose |
| --- | --- |
| `isaac-entities` | Handles registered entities, collision, lifecycle, and visual carriers. |
| `isaac-familiars` | Handles familiar spawning, ownership, multiplayer behavior, and respawning. |
| `isaac-wisps-virtues` | Handles Book of Virtues, `wisps.xml`, wisp sources, repeated use, capacity, death, and resource mappings. |
| `isaac-npc-boss-ai` | Designs NPC/Boss state machines and attack pacing. |
| `isaac-projectile-combat` | Manages projectile ownership, damage, hits, and cleanup. |
| `isaac-status-effects` | Manages target eligibility, sources, duration, stacking/refresh, immunity, periodic damage, and cleanup. |
| `isaac-players-characters` | Develops custom characters and Tainted variants. |

### World and Space

| Skill | Purpose |
| --- | --- |
| `isaac-rooms-stages` | Handles individual rooms, floors, doors, room topology, and stage transitions. |
| `isaac-grid-entities` | Handles GridEntity indices, legal positions, collision, destruction, ownership, and room revisits. |
| `isaac-room-networks` | Handles independent multi-room regions, including entry, routing, return paths, and local failure. |
| `isaac-dimensions` | Handles engine-level Dimensions, cross-dimension entry/return, isolation, and lifecycle. |

### Items, Rewards, and Progression

| Skill | Purpose |
| --- | --- |
| `isaac-active-item-mechanics` | Provides a routing shell for active-item charge, input, UI, and related mechanisms. |
| `isaac-passive-collectibles` | Manages passive collectible ownership, Cache evaluation, loss, rerolls, and reacquisition. |
| `isaac-collectible-registration` | Handles active/passive collectible XML and separates colored art from the ESC My Stuff icon pipeline. |
| `isaac-cards-pockets` | Handles cards, runes, pills, and pocket items while separating card fronts, Pickups, and HUD/EID surfaces. |
| `isaac-trinkets` | Handles trinket registration, ownership checks, stacking, and independent visual surfaces. |
| `isaac-item-economy` | Reviews quality, pools, weights, tags, and post-unlock economic impact. |
| `isaac-shops-deals-pricing` | Handles runtime prices, purchasers, payment, delivery, restocking, and reroll recalculation. |
| `isaac-item-synergies` | Defines ownership, stacking, and invalidation boundaries for item, trinket, and character synergies. |
| `isaac-transformations-forms` | Handles vanilla PlayerForm queries, custom transformations, contribution counts, activation, reversibility, and display routing. |
| `isaac-reroll-removal-contracts` | Manages idempotent reconciliation after rerolls, removal, and replacement. |
| `isaac-rng-determinism` | Manages random sources, draw boundaries, seed scope, and multiplayer reproducibility. |
| `isaac-rewards-pickups` | Handles reward selection, owned-target Spawn/Morph paths, world Pickup resource chains, and preserving the original on failure. |
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
| `isaac-character-art-surfaces` | Separates character art surfaces and constrains vanilla-reference editing, accessory scale, 1x previews, costume occlusion, and helmet-like failures. |
| `isaac-reskins-resource-overrides` | Handles vanilla reskins, resource-only mods, exact-path overrides, multiple resource roots, runtime replacement, and load-order conflicts. |
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

## Core Constraints

- Do not invent paths, IDs, Variants, SubTypes, ANM2 animation names, callback registration locations, or third-party APIs.
- Do not treat a reference mod's architecture, dependencies, or local tools as defaults for a new project.
- Do not substitute fixed runtime IDs for XML-local IDs and runtime name resolution.
- Do not pass Lua tables to APIs that require `Vector`, `RNG`, or other Isaac engine values.
- Do not mix world coordinates, visual offsets, callback offsets, and screen coordinates in one render calculation.
- Do not use one working visual surface as proof that another surface's resource pipeline is correct.
- Do not clean up cards, Pickups, entities, rooms, doors, or state that may belong to another mod.
- Explicit user values and design choices take priority; provide recommendations only where the user has not decided.

## Validation and Evidence Boundaries

Repository checks validate frontmatter, internal references, TBD contracts, router
coverage, eval schemas, offline third-party API references, evidence matrices, and
installed-file parity for all 48 skills.

```powershell
powershell -ExecutionPolicy Bypass -File tests/test-skill-repository.ps1
```

On Windows, the validation script enables UTF-8 for `quick_validate.py` so the
system GBK code page does not misclassify valid Chinese text as an encoding error.

Evidence is separated into four layers:

1. **Static audit:** files, XML, paths, registration, references, and code structure;
2. **Isolated behavior test:** mechanic branches, engine-type boundaries, and state changes under test doubles;
3. **Simulated or controlled runtime:** behavior closer to engine calls;
4. **In-game verification:** real loading, visuals, audio, collision, multiplayer behavior, and compatibility.

Passing an earlier layer never proves a later one. If a check was not run, the
result must remain explicitly unverified rather than being filled in by inference.

## Repository Structure

```text
.codex-plugin/plugin.json  Codex plugin manifest
skills/                    48 general Isaac skills
docs/                      Eval schema and evidence matrix
tests/                     Repository audit and installation-parity checks
AGENTS.md                  AI maintenance boundaries for this repository
README.md                  English documentation
README.zh-CN.md            Simplified Chinese documentation
```

## Reporting Problems

When a skill gives misleading guidance during real development, include as much
of the following as possible:

- the original request;
- the response Codex actually produced;
- relevant target-mod files or a minimal reproduction;
- the latest game log;
- completed static, scripted, and in-game checks;
- the behavior boundary you believe is correct.

This evidence helps distinguish a skill gap from missing project facts, an
unrealistic test double, or an implementation agent that did not follow an
existing contract. Report problems through
[GitHub Issues](https://github.com/BrickAZ/isaac-repentance-skills/issues).
