# Official Native UI Baselines

Use these as high-priority defaults when a Binding of Isaac: Repentance project has no established route for the requested native surface. They are recommendations, not requirements: preserve an explicit user choice or a current-project route when it has a declared mapping and an in-game check.

| Native surface | Official route and format baseline |
| --- | --- |
| Colored collectible | `gfxroot + gfx` PNG, 32x32. |
| Card face | `gfx/ui/ui_cardfronts.anm2`; frame crop 16x24. Official base sheet is 128x144 and the Repentance DLC sheet is 256x144. |
| Trinket icon | 32x32 PNG is the official default. Preserve a discovered non-default strip or animation asset rather than forcing it into one 32x32 cell. |
| Boss portrait | 192x192 PNG is the official single-Boss default. Use a wider portrait only for an explicitly multi-Boss or project-mapped route. |
| Unlock achievement art | 263x176 PNG, displayed by the discovered achievement popup/ANM2 route. It is not the full popup frame. |
| Heart HUD cell | `ui_hearts.anm2` frame crop 16x16 from a 112x64 `ui_hearts.png` sheet. |
| ESC My Stuff item sketch | Official `death items.png` atlas is 320x640. Discover the active project's `deathanm2` and declared-`items.xml`-local-id-to-frame mapping; if no local id exists, keep the mapping blocked until a declared loader or approved migration is found. Do not infer a standalone same-name PNG route or use runtime/global ItemConfig IDs. |
| Character-select portrait | `gfx/ui/main menu/characterportraits.anm2`; frame crop 48x48 from a 512x1024 `CharacterMenu.png` sheet. |
| Co-op character menu portrait | `gfx/ui/coop menu.anm2`; frame crop 32x32. Official base sheet is 192x128 and the Repentance DLC sheet is 192x224. |
| Pause-menu My Stuff panel | `menu_mystuff.png`, 128x128, is a panel asset rather than a per-item portrait. |
| Pause-screen background | `pausescreen.png`, 400x256. It is separate from My Stuff and item portraits. |

## Asset Decision Gate

Apply the following decision order for every listed native surface:

1. If the user supplies or approves a compatible asset, preserve that choice and verify its route, frame dimensions, and in-game surface.
2. If the user has not supplied a compatible asset, report the recommended source-frame and atlas format from the table before implementation. Treat it as a suggestion, not a replacement for a user decision.
3. If the user asks to generate the asset, generate it at the table's source-frame size: collectible 32x32, trinket icon 32x32, card face 16x24, character-select portrait 48x48, co-op portrait 32x32, My Stuff sketch 16x16, Boss portrait 192x192, unlock achievement art 263x176, or heart HUD cell 16x16.
4. For an atlas-backed route, place the generated frame into the discovered target atlas and ANM2/XML mapping. Do not create a standalone PNG merely because its filename resembles the item or character name.
5. Generate a full 128x128 My Stuff panel or 400x256 pause-screen background only when the user explicitly requests that panel/background surface, not for an individual collectible.
## Override Contract

- An explicit user decision or current-project route may override a baseline.
- Record the override's loader, XML/ANM2 mapping, asset dimensions, and affected native surfaces.
- Do not use one successful surface as evidence that another surface works.
- Validate every affected native surface in game.