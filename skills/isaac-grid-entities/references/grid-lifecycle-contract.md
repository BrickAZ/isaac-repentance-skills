# Grid Lifecycle Contract Reference

## Carrier Decision

| Needed behavior | Route |
| --- | --- |
| Native rock/pit/spike/TNT/other proven grid behavior | Native grid API with verified type/state |
| Existing grid is damaged, destroyed, replaced, or inspected | Existing native grid mutation |
| Object needs HP, AI, targeting, callbacks, or custom collision logic | Normal registered entity/effect |
| Truly custom grid supported by declared dependency | Exact extension contract with absent-dependency branch |
| Visual decal with no collision or room persistence | Sprite/effect route, not a grid |

Do not choose a grid merely because the object looks stationary. Do not choose a
normal entity merely because custom grid registration is inconvenient; compare
the required collision, persistence, pathing, and destruction semantics.

## Coordinate Contract

Keep these domains distinct:

- screen coordinate for manual rendering;
- world coordinate for entities and room positions;
- room-local grid index for `GridEntity` access;
- room map/grid coordinate for room descriptors and adjacency;
- door slot or transition location.

Use discovered room APIs to convert world position to a grid index and back.
Verify the result belongs to the current room shape and is not a door/reserved
cell. Fixed offsets from room center are candidates only, never legality proof.

## Mutation Lifecycle

1. resolve current room identity and target cell;
2. inspect the live grid and ownership policy;
3. validate placement/replacement legality;
4. perform exactly one owned mutation;
5. wait for the proven lifecycle edge if state rebuild is deferred;
6. re-read the live grid and confirm type/state/collision;
7. apply only explicitly owned side effects;
8. reconcile persistence on revisit/continue.

Do not delete all doors or nearby grids to force one candidate to work. When no
legal cell exists, preserve the room and follow the user-approved failure path.

## Persistence Questions

- Does the engine remember this native mutation when the room is revisited?
- Can room generation rebuild or overwrite it?
- Does the mod need only current-visit behavior or serializable intent?
- How is the cell distinguished from a base-room or foreign-mod grid?
- What happens after destruction, reroll-like room effects, floor transition,
  continue, reload, or a different room with the same grid index?

Never key persistent grid state by cell index alone; include the project's
proven room identity and run/floor scope.

## Review Checklist

- Grid carrier versus normal entity is justified by behavior.
- Exact grid type/state/API or extension dependency is proven.
- Coordinate domains are named and converted explicitly.
- Candidate legality covers bounds, shape, doors, occupancy, and reservations.
- Visual, collision, pathfinding, destruction, drops, and room-clear behavior
  agree.
- Mutation timing and read-back edge are proven.
- Only owned/authorized grids are replaced or removed.
- Revisit/continue/reload behavior is explicit.
- Hot paths avoid unconditional full-room scans.
- Static, mock, and in-game evidence remain separate.

## Common Failures

- Using a world coordinate or room descriptor index as a grid index.
- Spawning on a door slot or invalid large-room cell.
- Assuming a sprite creates collision.
- Inventing a custom GridEntity type without a proven extension.
- Removing foreign grids during cleanup.
- Reading the new grid immediately when creation is deferred.
- Persisting only `{ gridIndex = ... }` without room identity.
- Using an always-legal mock that cannot catch real placement failures.
