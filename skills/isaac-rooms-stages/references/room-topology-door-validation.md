# Room Topology And Door Validation

A coordinate inside the current room and a real map connection are different facts. A local debug room can be useful for isolated rendering or spawn tests, but it does not establish normal floor topology merely because the room can be reloaded.

## Before Mutation

Discover and record:

- current room descriptor or stable map identity;
- whether the context is a normal map-grid room, a special dimension, or a console/debug surface;
- the available door slots and their compatibility with the requested connection;
- neighbor availability or the official API preconditions that create one;
- local grid/collision legality for each door or portal candidate; and
- the mod-owned state flag that must not be consumed by a failed attempt.

Do not substitute a fixed offset for this discovery. Fixed positions can be candidates only after the current room proves them legal.

## Candidate Policy

1. Generate candidates from discovered slots/topology.
2. Validate map/topology eligibility and local position eligibility separately.
3. Apply an owned door/portal mutation only after both validations pass.
4. When no candidate remains, leave current content unchanged and return a clear no-candidate result.
5. Do not remove existing unknown doors or close a room to imitate a missing adjacent room.

## Required Proof

Use both a focused scripted test and an in-game normal-floor check.

| Case | Required result |
| --- | --- |
| Compatible normal room slot and neighbor | Owned connection appears and can be used/returned from as designed. |
| Invalid or blocked local position | Candidate is rejected without unrelated mutation. |
| No legal candidate | No owned connection, no success flag, no unrelated door removal. |
| Console/debug room | May exercise local handling only; it is not topology proof. |

Report the chosen API as a discovered implementation detail. Do not infer that an API name guarantees a valid adjacent room in every context.
