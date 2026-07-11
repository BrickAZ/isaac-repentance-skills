# Passive Item Review Checklist

Before completion, verify:

- The item ID, metadata files, and item type came from project discovery.
- Holder and copy policy are explicit for every player.
- Each cache effect has a narrow flag and a refresh trigger.
- Event effects have a separate Callback Contract with filters and return
  policy.
- Item loss and lifecycle cleanup do not leave stale per-player state or owned
  effects behind.
- Pools, quality, weights, tags, and unlocks are either user decisions, `TBD`,
  or a separate `isaac-item-economy` review.
- Static checks, isolated behavior checks, and required in-game checks are
  reported separately.
