# Pickup Confirmation Before Side Effects

Use this when a pickup collision should lead to a custom banner, statistic,
extra reward, replacement settlement, or other one-time side effect, but the
collision callback alone does not prove the player actually acquired it.

## Contract

- Candidate event and callback:
- Player owner and project-verified key:
- Pickup/source identity and project-verified key:
- Before-state snapshot:
- Confirming evidence:
- One-time side effect after confirmation:
- Stale-candidate cleanup:
- Save/reload behavior:

## Rules

1. Treat collision as a candidate only. Do not show the final banner, grant an
   extra reward, delete another pickup, or mark progress as complete yet.
2. Deduplicate candidates by the discovered player and source identities. Do
   not assume `InitSeed` is universal; use it only where the project already
   proves it is stable for that source.
3. Confirm acquisition with a discovered reliable signal, such as collectible
   count increase, an owned queued-item transition, or another documented
   post-acquisition event.
4. Perform the side effect once after confirmation, then remove the pending
   candidate.
5. Clear a candidate when its source disappears, its player becomes invalid, or
   the lifecycle boundary says it cannot survive. Do not keep live pickup or
   player userdata in SaveData.
6. Test repeated collision, co-op contenders, failed/no acquisition, source
   removal, and one confirmed acquisition separately.
