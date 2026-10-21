# Player Topology And Ownership

Use this reference when either identity may own a native partner/subplayer, or
when a secondary body can hold the switching item.

## Classify Every Live Player

Do not collapse these roles into one list position:

- independent co-op player;
- normalized main player for the switch;
- native partner/twin/subplayer belonging to that main player;
- transient wrapper or stale pre-switch userdata;
- unrelated player created by another mechanic or mod.

Prove relationships with the matching project/API surface: main/other/subplayer
accessors, controller ownership, expected registered types, stable runtime keys,
and current live enumeration. One signal alone is not deletion authority.

## Normalize Before Mutation

If the callback arrives on a secondary body, resolve the actual main owner before
capturing or switching. If no valid main can be proved, fail closed rather than
changing an orphan body independently.

When two bodies can both hold the switching item, define whether the mechanic
switches the pair once, each independent co-op player once, or another explicit
user rule. A per-body callback must not accidentally perform the same pair switch
twice.

## Safe Partner Removal

Before mutation, record plain identifying facts and the exact state that must be
recoverable. After mutation:

1. enumerate current live players again;
2. find the exact former partner from current wrappers and multiple proven facts;
3. verify it is not the normalized main player or an independent co-op player;
4. invoke only a discovered supported removal route;
5. re-enumerate and verify the intended former partner is gone.

If identity is ambiguous, do not remove anything. Log/report the unresolved
topology and retain recovery data.

## Ownership While A Partner Is Parked

Snapshots may include project-approved portions of:

- collectibles and copy counts;
- active slots, charges, and batteries;
- cards, pills, and other pocket content;
- trinkets and smelted trinkets;
- health/resources;
- this switching mechanic's ownership marker.

If the disappearing partner owns the switching item, use an explicit proxy or
transfer ledger only when the mechanic requires continued switching. Track the
exact copied count. On restoration, return only still-authorized copies and
invalidate the proxy if the item was consumed, removed, rerolled, or the switch
mechanic ended.

Once a live restored partner exists, it becomes authoritative. Do not repeatedly
reapply the parked snapshot after the partner spends resources or takes damage.
