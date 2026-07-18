# Deferred Reward Entitlements

Use this when a mechanic earns a reward now but may only spawn it after a
future room, floor, target, or other context becomes real. A pending
entitlement is not a spawned pickup.

## Contract

- Earning trigger and owner:
- Entitlement key and repeat boundary:
- Target context required for fulfillment:
- Candidate selection and validation:
- Spawn point and ownership at fulfillment:
- Success evidence and clearing rule:
- Target-never-occurs / expiry / carry-over policy: approved | TBD
- Save/reload behavior:

## Rules

1. Record the entitlement only after its earning trigger succeeds. Keep owner,
   repeat boundary, and target context explicit.
2. At the target lifecycle callback, first prove the target context exists,
   then select and validate the reward candidate before spawning.
3. Clear the pending entitlement only after the owned spawn/settlement succeeds.
   A failed context check is not a successful fulfillment.
4. Do not invent whether an unrealized entitlement expires on room, floor,
   death, reload, or run transition. Keep that policy `TBD` until approved.
5. Use `isaac-state-lifecycle` for owner, reset, and serialization boundaries.
   Persist only if the user requires reload survival; never serialize live room,
   player, pickup, or sprite references.
6. Test immediate target availability, delayed availability, no target before
   the chosen expiry boundary, repeated target entry, invalid candidate, and
   co-op ownership.
