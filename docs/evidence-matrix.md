# Reference Evidence Matrix

This is a maintainer audit, not a runtime dependency list. YSD and Reverie are
evidence sources only. Every shipped skill must default to official Isaac APIs
and target-project discovery.

| Skill | Real evidence | Extractable invariant | Status |
| --- | --- | --- | --- |
| active-item-mechanics | `ysd/scripts/items/untuned_piano.lua`; Reverie item scripts | Input/charge/UI state must have an explicit owner and cleanup path. | Direct |
| anm2-visuals | Both mods contain shipped ANM2 assets in `resources*/gfx`. | Asset path and animation names must be read, never guessed. | Direct |
| audio-render-feedback | Both `content/sounds.xml`, `content/shaders.xml`; YSD renderer files. | Audio/render use declared resources and callback-specific coordinate space. | Direct |
| callback-contracts | YSD `main.lua`; Reverie `debug/callback_measuring.lua`. | Callback timing, filter, and return value are separate contracts. | Direct |
| cards-pockets | YSD `scripts/pockets/soul_of_ysd.lua`; Reverie `scripts/pockets/*`. | Pocket ownership and use routes are content-specific. | Direct |
| challenges | Both `content/challenges.xml`; YSD `scripts/challenges/endless_r.lua`. | Challenge gates need dedicated lifecycle cleanup. | Direct |
| compat-descriptions | YSD EID assets; Reverie compatibility modules. | Optional integrations must be guarded and never become defaults. | Direct |
| config-options | Reverie `compatilities/mod_config_menu.lua`. | Optional configuration needs a no-library fallback. | Direct, Reverie only |
| entities | Both `content/entities2.xml` and matching scripts/assets. | Registered identity and owned runtime markers must agree. | Direct |
| familiars | YSD familiar ANM2 assets; Reverie item/familiar scripts. | Familiar behavior needs owner proof and per-player counts. | Direct |
| item-economy | Both `content/itempools.xml` and items XML. | Pool membership, weight, tags, and quality are distinct decisions. | Direct |
| collectibles | Both extensive `scripts/items/*` trees. | Base passive behavior must be distinct from combined effects. | Direct |
| item-synergies | Reverie has cross-content item/trinket systems, but no audited exact passive-plus-trinket fixture yet. | Only the general combination contract is supported; do not claim a copied template. | Partial |
| localization-runtime | Both ship localized content/resource surfaces. | Discover actual languages and optional translation layers. | Direct |
| mechanic-contracts | Both contain items, challenges, player, and enemy mechanics. | Define trigger, exclusion, success, and cleanup before callback choice. | Direct |
| mod-architecture | YSD uses a compact scripts tree; Reverie uses a broad modular scripts tree. | Discover the local authority module; do not force either layout. | Direct |
| mod-context | Both prove layouts differ substantially. | Project discovery precedes specialist assumptions. | Direct |
| npc-boss-ai | Reverie `scripts/monsters/*` and custom monster ANM2 assets. | Per-instance phase/target state cannot be global. | Direct, Reverie only |
| players-characters | Both `players.xml` and `scripts/players/*`. | Character state must be player-owned and co-op-safe. | Direct |
| projectile-combat | YSD projectile assets/scripts; Reverie custom tear assets and item scripts. | Explicit marker/source proof beats type-only ownership guesses. | Direct |
| reroll-removal-contracts | Both have replacement/spawn-heavy mechanics; `skill-test` GoodGirl repair supplies executable proof. | Observe changes separately from idempotent owned-state reconciliation. | Direct plus test proof |
| rewards-pickups | Reverie `scripts/pickups/*`; both use item pools/spawn paths. | Candidate selection and safe spawn/replacement are separate. | Direct |
| rooms-stages | Reverie `scripts/rooms/*` and `shared/room_gen.lua`. | Selection attempt and committed room mutation need separate state. | Direct, Reverie only |
| state-lifecycle | Both use update/new-room/new-level callbacks. | State needs owner, reset boundary, and serialization decision. | Direct |
| testing-debugging | Reverie `debug/callback_measuring.lua`; neither mod has a formal tests tree. | Debug code is evidence of instrumentation only; automated tests need independent authority. | Partial |
| trinkets | Reverie `scripts/trinkets/*`; YSD has no trinket implementation surface. | Golden/count behavior and holder scope need explicit rules. | Direct, Reverie only |
| unlocks-progression | YSD unlock renderer; both content/progression surfaces. | Completion, grant, availability, and UI notification are separate. | Direct |
| validators | No reference-mod authority. Official XML/API rules and local validators are authoritative. | Static checks cannot prove gameplay behavior. | Official/test only |

## Maintenance Rule

Before adding a new hard rule, attach one of: a code-level YSD/Reverie example,
an official API contract, or an executable test. Do not upgrade a file inventory,
a similarly named asset, or an undeclared third-party helper into evidence.

## Benighted Soul And Samael Evidence Pass

These are additional learning/validation sources, never user dependencies.

| Skill family | Benighted Soul evidence | Samael evidence |
| --- | --- | --- |
| REPENTOGON compatibility | `main.lua`, `ibs_scripts/ibs_callback.lua`, `ibs_scripts/ibs_achiev.lua`, custom content XML | Use only as a contrast unless runtime proof shows REPENTOGON. |
| Players/characters | `content/players.xml`, `ibs_scripts/samson_skills/*` | `samaelscripts/chars/samael.lua`, `samael_birthright.lua`, `memento_mori.lua`, `content/players.xml` |
| Unlocks/progression | `ibs_scripts/ibs_achiev.lua` | `content_manager/unlock_management.lua`, `custom_achievements.lua`, `custom_completion_marks.lua`, `vanilla_completion_marks.lua` |
| Item synergies and EID | Item/callback modules supply mechanic-side evidence | `eid_samael_synergies.lua` supplies a direct optional-description synergy surface |
| Entities/projectiles/combat | `content/entities2.xml`, `ibs_scripts/ibs_entity.lua`, callback modules | `fragment/*`, `items/*`, `content/entities2.xml`, dedicated scythe/laser assets |
| Rooms/stages/rewards | Challenge, pickup, grid, and curse callback modules | `content/rooms/*.stb`, `fragment/ferryman_room.lua`, `extra_room_stuff.lua`, `death_pool.lua` |
| ANM2/audio/render | `content/sounds.xml`, `content/shaders.xml`, UI/entity ANM2 | `active_item_rendering.lua`, `renderActive.lua`, `content/sounds.xml`, `content/shaders.xml`, UI/entity ANM2 |
| Optional compatibility/config | `ibs_scripts/ibs_compat.lua` is a compatibility discovery source | `eid_samael_synergies.lua`, `dss/*`, and compatibility helpers are optional-layer examples |

### Interpretation

- `isaac-repentogon-compat` may use Benighted Soul as a strong code example,
  but must still obtain user opt-in, runtime global proof, and version proof.
- `isaac-item-synergies`, `isaac-eid-compat`, `isaac-players-characters`, and
  `isaac-unlocks-progression` now each have a stronger real validation source
  in Samael.
- A module name or an asset alone is not a rule source. During a skill revision,
  read the relevant implementation and record the extracted invariant, not the
  reference mod's API, paths, IDs, or dependencies.
