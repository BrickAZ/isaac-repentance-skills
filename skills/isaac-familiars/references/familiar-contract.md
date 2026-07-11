# Familiar Contract

Use this reference before selecting familiar callbacks or writing Lua.

## Route Decision

| Situation | Authority | Do not do |
| --- | --- | --- |
| Standing item/effect/character count owns the companion | `CACHE_FAMILIARS` plus the project's `CheckFamiliar` pattern | Spawn one again every frame or use an unverified raw variant |
| One event creates a short-lived helper | The explicit event spawn and lifetime contract | Also register the same helper as a permanent cache familiar |
| Change one known vanilla familiar or wisp | Variant plus subtype/source and owner filters | Modify every familiar sharing a vanilla variant |
| Pure visual near a player with no familiar gameplay | Lua Sprite or visual route | Register a familiar only to display an icon |

## Facts To Discover

- The declared entity type, variant, subtype, ANM2 path, and animation names.
- The current project's `CheckFamiliar` call shape and RNG/item-config source.
- The authoritative count formula, including every user-approved multiplier or temporary effect.
- The live owner field and an existing co-op-safe owner comparison.
- The existing follower/orbit helper, if one exists.
- The exact collision/damage callback and its return policy.
- Whether item loss, room transition, death, or reload should remove, refresh, preserve, or rebuild the familiar.

## State Boundaries

| State | Owner | Typical reset question |
| --- | --- | --- |
| Target count | Player/cache evaluation | Which item/effect changes request a cache refresh? |
| Cooldown, target, detached phase, animation phase | Familiar instance runtime data | Does a recreated instance begin fresh? |
| Room target list or room-clear progress | Room/familiar instance | Must it reset when the room changes? |
| Permanent evolution or user-approved progression | Saved/player/run state | Is save/reload explicitly required? |

Keep live entity/player references runtime-only. If a target is stored, clear it
when it is gone or no longer eligible.

## Failure Patterns To Reject

- `MC_POST_UPDATE` spawns a new permanent familiar while its item is held.
- A global `FindByType` loop controls or removes matching variants without owner/source checks.
- `familiar:Remove()` is used to sacrifice an item-backed familiar, but the count source stays unchanged.
- A following and charging state both assign velocity in the same update.
- Collision damage fires every overlapping frame with no stated cadence.
- `InitSeed`, player index, CuerLib helper, entity path, animation name, or cache formula is invented without project evidence.
- A shared vanilla wisp/familiar is treated as current-mod-owned solely from its variant.
