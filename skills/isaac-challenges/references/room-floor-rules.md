# Room, Floor, Curse, And Spawn Rules

Use this when a challenge changes rooms, floors, curses, item generation, or entity spawning.

## XML Versus Lua

- Use XML for static `roomfilter`, `cursefilter`, `getcurse`, `endstage`, and path flags.
- Use Lua for forced stage commands, dynamic room behavior, replacing spawned pickups, or modifying entities after spawn.

## Common Callbacks

- `MC_POST_NEW_LEVEL`: forced floor/stage logic.
- `MC_POST_NEW_ROOM`: room-entry behavior.
- `MC_PRE_ENTITY_SPAWN`: replace pickups or entities.
- item-pool callbacks or helpers: replace collectible choices.

## Hard Rules

- Dynamic spawn replacement must be gated to the challenge.
- Avoid infinite replacement loops by allowing the intended replacement subtype through.
- Forced stage logic needs a guard so it does not execute every level transition forever.
- If using room filters, explain the room type ids.

## Review Checklist

- Static filters live in XML when possible.
- Dynamic rules live in Lua.
- Replacement loops are guarded.
- Floor and room reset behavior is explicit.

