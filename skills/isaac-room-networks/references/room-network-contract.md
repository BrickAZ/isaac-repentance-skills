# Room Network Contract

A room network is an owned relationship between multiple rooms. It is not merely a loop of room transitions and it is not a game-level Dimension by itself.

## Required Facts

- Stable network key and owner.
- Confirmed Dimension context supplied by the caller or current project.
- Node identities and the discovered registration/allocation route.
- Edge identities and the discovered door/transition route.
- Entry origin snapshot and return target.
- Area completion, interruption, and partial-network policy.

## Allocation Boundary

Validate room topology separately from local positions. A candidate needs both a legal local door/portal position and a real project-proven node/edge result. If either check fails, leave existing content untouched and report the owned allocation failure.

Do not use a debug-room reload or a fixed coordinate as evidence that a second room exists. Do not assume a door-creation API allocates a usable node synchronously; discover its project/runtime result before committing network state.

## Dimension Boundary

The network receives a confirmed Dimension context. It may store a plain stable dimension identity as part of its state, but it cannot create, select, or reinterpret dimensions. Route that work to `isaac-dimensions`.
