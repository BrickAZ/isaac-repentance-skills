# Projectile Ownership

Use this reference before mutating a tear, laser, knife, bomb, or attack entity.

## Ownership Evidence

| Evidence | What it proves | What it does not prove alone |
| --- | --- | --- |
| Runtime marker written when this mechanic creates/augments it | The current mechanic owns this projectile behavior | Which player should receive later credit if source must be resolved live |
| Verified type + variant + subtype allocated to this mod | This is the current mod's registered entity family | That all subtypes/states share the requested behavior |
| Verified source/spawner chain plus current item/character eligibility | A candidate source for this mechanic | That every projectile from that source should be altered |
| Shared vanilla variant or entity type | A filter candidate | Ownership; another item/mod can use it |

Use the strongest available combination. For any later update/collision/remove
handler, reject entities that lack the chosen proof.

## Creation Routes

| Route | Creation authority | Required boundary |
| --- | --- | --- |
| Modify a fired shot | Discovered fire callback | Mark only eligible shots once; reject re-entry |
| Spawn a new shot | Defined mechanic event | Verified entity facts, source/spawner, marker, lifetime |
| Replace/split a shot | Owned parent condition | Child marker, count/cooldown, recursion policy |
| Direct damage without a new shot | Defined collision/damage event | Source attribution, target filter, cadence, return policy |

## Failure Patterns To Reject

- A broad tear update changes every tear of a vanilla variant.
- A collision callback damages an overlapping enemy every frame with no
  deliberate cadence.
- A child projectile inherits parent logic but lacks a marker or recursion cap.
- `SpawnerEntity:ToPlayer()` is called without proving that the spawner exists
  and is a player; familiar/effect/projectile chains are ignored.
- A missing entity lookup falls back to a guessed raw type/variant/subtype.
- Remove and collision callbacks each spawn the same settlement effect.
- A third-party helper is copied from a reference mod without a declared
  dependency and official-API fallback.
