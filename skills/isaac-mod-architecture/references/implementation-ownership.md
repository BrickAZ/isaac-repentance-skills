# Implementation Ownership

Use this reference whenever a task says "where should this code go?" or a content skill mentions `main.lua`.

## Rule

Treat `main.lua` as the starting point for discovering the load path. It is not automatically the destination for new behavior.

For every change, name these separately:

- **Bootstrap owner**: the file that loads modules or creates the mod object.
- **Behavior owner**: the file that owns the item, card, entity, challenge, or callback behavior.
- **Shared owner**: a deliberately shared helper only when real duplication justifies it.
- **Verification owner**: the closest behavior test and the static validator command.

## Decision Order

1. Read `main.lua` to find the current include/require/load pattern.
2. Locate the nearest existing behavior of the same content type.
3. Add local behavior beside that owner.
4. Move code to a shared helper only when two or more owners need the same stable rule.
5. Change the bootstrap/load order only when a new module needs it; report that separately from the feature change.

## Handoff Requirement

Every architecture or content handoff that touches Lua must state:

```markdown
- Bootstrap owner:
- Behavior owner:
- Shared owner, if any:
- Load-order change, if any:
```

This keeps future item work compatible with both the current monolithic layout and a later modular layout.
