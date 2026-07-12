# Trinket Review Checklist

Before finalizing trinket work, verify:

- Trinket XML exists and parses.
- Lua id lookup uses trinket APIs.
- Held, smelted/gulped, and golden behavior is explicit.
- Co-op and per-player ownership are not accidentally global.
- Language/EID surfaces are updated.
- Each requested pickup, HUD/pocket, costume, and optional EID visual surface has its own discovered route; a file existing or another surface working is not proof.
- Static validator and relevant behavior tests were run when possible.
