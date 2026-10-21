# Character Switch Contract

Use this reference to turn an in-run identity change into a staged protocol.

## Phase Matrix

| Phase | Required facts/actions | Failure behavior |
| --- | --- | --- |
| Preflight | Source/target types, actual owner, partner topology, health policy, required APIs, persistence decision | Stop before mutation; report the unavailable technical fact or active user decision |
| Capture | Plain-data health, resources, owned inventory/slots/pockets, partner identity, mechanism-owned effects | Do not mutate if required recovery data cannot be captured |
| Detach | Remove only switching-mechanism-owned temporary grants and visuals | Preserve foreign/native grants; record partial cleanup |
| Identity mutation | Invoke the discovered API once for the normalized main owner | Verify actual resulting type; a successful Lua call is not enough |
| Reacquire | Enumerate current live players and rediscover main/partner objects | Do not use pre-switch userdata for destructive cleanup |
| Topology reconciliation | Remove only a proven former native partner; verify or create the expected target partner through the supported route | Compensate or fail closed; never delete unrelated co-op players |
| State projection | Apply only target-supported health/resources and restore approved owned content | Verify readable postconditions; zero survivability or missing required partner is failure |
| Commit | Make current live state authoritative, invalidate consumed snapshots, persist stable approved data | Commit only after all required postconditions pass |
| Compensation | Attempt switch-back and topology/state restoration using retained recovery data | Describe it as best effort; retain data and diagnostics if restoration cannot be proved |

## Required Postconditions

Choose only those relevant to the mechanic, but make each explicit:

- the normalized main player has the intended actual type;
- exactly the expected native partner topology exists;
- no unrelated co-op player was removed or rewritten;
- the current identity has nonzero valid survivability unless zero/death is the approved outcome;
- switching-mechanism grants exist exactly once and foreign/native grants remain intact;
- active slots, pockets, trinkets, smelted trinkets, charges, and partner inventory match the approved ownership policy;
- spent health, charges, consumables, and removed items are not resurrected from a stale snapshot;
- runtime state and saved state name one authority for the next switch/continue;
- no live userdata entered SaveData.

## Commit Authority

Do not clear recovery records merely because the identity API returned. Clear or
supersede them only after the corresponding live owner/partner and state have
been rediscovered and verified. If postconditions fail, preserve enough plain
data to diagnose or retry the approved recovery path.

## No Universal Rollback Claim

Identity changes may immediately trigger engine behavior, callbacks, starting
content, native partner creation, and other mods. A compensating switch-back can
reduce damage but cannot prove atomic rollback. Report exactly which original
postconditions were restored.
