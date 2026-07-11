# Callback Registration

Isaac callbacks are the spine of the mod. Keep registration explicit.

## Rules

- Register callbacks near the behavior owner or through a clear module loader.
- Avoid duplicate callbacks that scan the same entities or players for the same purpose.
- Keep callback filters explicit when the API supports them.
- Document load order when modules depend on shared ids or helpers.
- If a callback is challenge-only, card-only, or item-only, gate it early.

## Red Flags

- A callback has branches for many unrelated content types.
- A helper registers callbacks as a side effect that is not obvious from the loader.
- New code assumes an id table is initialized before it is loaded.
