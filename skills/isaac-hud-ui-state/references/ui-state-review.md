# HUD and UI State Review

| Element | Carrier | Owner | World/screen domain | Conversion | Anchor/layout | Cleanup | Verification |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Required Questions

1. Is the display screen-fixed, world-following, an entity visual, or a costume?
2. Is every manual render position in screen coordinates?
3. Is there a coordinate ledger for world, visual/render, callback offset, and
   screen values?
4. Which anchor policy is selected: logical owner anchor, or a proven
   body-visual adapter? Does every offset have one owner and one application?
5. Does conversion failure suppress the owned draw rather than leak a world
   position into `Sprite:Render`?
6. Which render modes are allowed, and are reflection/refraction duplicates
   intentional or filtered?
7. Does a world-following marker use a discovered owner-relative anchor rather
   than one global offset?
8. What separates player one, player two, twins, and relevant NPC owners?
9. What happens on pause, room transition, owner death/removal, and reload?

## Evidence Levels

- **Static:** carrier selection, coordinate conversion, callback/state separation,
  resource discovery, and cleanup branches.
- **Controlled runtime:** marker lifetime, owner isolation, stale-state removal,
  non-identity world-to-screen conversion, exact-once offset application,
  conversion-failure suppression, and render-pass filtering.
- **In game:** placement for real player/NPC classes, camera movement, Boss size,
  riding/flying visuals, reflection/refraction behavior, pause, and room transitions.

Do not promote static or stub evidence to visual proof.
