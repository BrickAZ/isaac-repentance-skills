# HUD and UI State Review

| Element | Carrier | Owner | World/screen domain | Conversion | Anchor/layout | Cleanup | Verification |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Required Questions

1. Is the display screen-fixed, world-following, an entity visual, or a costume?
2. Is every manual render position in screen coordinates?
3. Does a world-following marker use a discovered owner-relative anchor rather than
   one global offset?
4. What separates player one, player two, twins, and relevant NPC owners?
5. What happens on pause, room transition, owner death/removal, and reload?

## Evidence Levels

- **Static:** carrier selection, coordinate conversion, callback/state separation,
  resource discovery, and cleanup branches.
- **Controlled runtime:** marker lifetime, owner isolation, and stale-state removal.
- **In game:** placement for real player/NPC classes, camera movement, Boss size,
  flying offset, pause, and room transitions.

Do not promote static or stub evidence to visual proof.
