# Reactive Effects And Cleanup

Use this reference when a passive item reacts to an event rather than only
changing stats.

## Event Route

1. Define the trigger, eligible holder, outcome, failure path, exclusions, and
   repeat boundary with `isaac-mechanic-contracts`.
2. Select and document the callback with `isaac-callback-contracts`.
3. Keep the item's ownership/copy policy in the Passive Collectible Contract.
4. Route entity spawning, pickups, and audiovisual feedback to the matching
   specialist skill.

## Damage Interception

Damage interception is not a generic "return false" recipe. The Callback
Contract must identify the damaged entity, current item owner, damage source,
flags, repeated-hit policy, cancellation semantics, and re-entry prevention.
An item must not suppress unrelated players', enemies', vanilla, or other
mods' damage paths.

## Cleanup Questions

For each state or spawned effect, state what happens when:

- the item is removed, rerolled, or transformed;
- the player dies, respawns, disappears, or loses eligibility;
- the room or level changes;
- the run restarts, continues, reloads, or ends.

Runtime references remain runtime-only. Persist only user-approved progression
or configuration through the project's established SaveData route.
