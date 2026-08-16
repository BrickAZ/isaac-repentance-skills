# Dimension Contract

A game-level Dimension is a distinct runtime context, not a name for a group of rooms. Treat its identity and entry capability as discovered facts.

## Capability Decision

Choose exactly one proven route:

1. A project/official API identifies and enters the required Dimension.
2. A user-approved optional dependency exposes the needed capability after an installed-version check.
3. No such capability is proven. Keep custom Dimension registration blocked/TBD and consider only user-approved alternatives such as a room network in an existing context.

Do not fabricate a numeric Dimension id or infer capability from a reference mod's implementation.

## Isolation Contract

Record origin and target context separately. Define who owns each state field, what persists across the boundary, and how return, death, reload, run end, and interrupted transition clean up. Preserve vanilla and unknown third-party Dimension resources unless the mechanic explicitly owns them.

## Room Network Handoff

When the target Dimension hosts multiple rooms, provide `isaac-room-networks` with a confirmed plain Dimension identity/context and the discovered transition facts. Do not create room nodes or infer door topology in this skill.
