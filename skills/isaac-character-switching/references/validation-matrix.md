# Character Switching Validation Matrix

## Static And Contract Checks

- source/target types resolve from discovered names/registration facts;
- one normalized main owner controls one switch;
- preflight occurs before destructive mutation;
- saved data contains no live userdata;
- partner cleanup requires multiple ownership proofs;
- stale pre-switch wrappers are not used after mutation;
- conversion ratios and persistence match user/project decisions;
- engine-owned starting content is not duplicated;
- recovery records clear only after verified commit.

## Isolated Behavior Matrix

Cover capability classes first, then representative characters available in the
target build:

| Source | Target | Required observation |
| --- | --- | --- |
| ordinary/mixed | ordinary/mixed | capacity and damage remain consistent |
| red-heart capable | soul-only | approved conversion yields valid survivability |
| soul-only | red/coin-only | approved conversion obeys target limit |
| any supported health | Lost-like | native survival remains valid without invented HP |
| Lost-like | ordinary/soul/coin | conversion does not produce zero life or free healing |
| ordinary | Forgotten/Soul-like pair | health lands on the correct body/partner |
| single | native pair | expected partner exists once and receives only native/approved state |
| native pair | single | exact former partner is removed; unrelated co-op remains |
| one native pair | another native pair | old partner cannot block or replace the new partner |

Also test:

- secondary partner alone holds the switching item;
- both bodies appear to hold it;
- repeated switch to the same identity;
- item loss, consumption, reroll, or restoration during a switch;
- spent health/charge/items after partner restoration;
- save/continue and malformed/older saved state;
- type-change failure, partner-removal failure, partner-creation failure, health
  projection failure, and compensation failure;
- dead/invalid player and orphan secondary-body input.

Test doubles must reject unsupported health and model wrapper invalidation or
partner persistence where those failures are under review. A permissive mock is
not useful evidence.

## In-Game Acceptance

Static and isolated checks cannot prove:

- native partner creation/removal and controller binding;
- Lost-like death timing or hidden survival;
- actual health API rejection/conversion side effects;
- starting-kit or pocket-active grants triggered by identity change;
- other-mod callback interaction;
- continue/reload reconstruction in the engine.

Run representative switches in game with at least two independent co-op players
when co-op is supported. Record source type, target type, actual holder, health
before/after, live player topology, inventory ownership, log diagnostics, and the
result after another room plus save/continue. Report any unrun row as unverified.
