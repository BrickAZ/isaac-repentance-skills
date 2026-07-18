# Collectible Death Portraits

Use this route for native item sketches shown in ESC My Stuff, the collection
page, or Last Will. It is not the colored `items.xml` `gfxroot + gfx` PNG route.

## High-Priority Default Recommendation

Use this as the default recommendation, not an unconditional requirement:

- For colored collectible art, start from a discovered `gfxroot + gfx` PNG; 32x32 is the common established starting format, but verify the target project instead of resizing an existing different format.
- For native ESC My Stuff, collection-page, and Last Will sketches, start from `items.xml` `deathanm2`, a spritesheet atlas, and the declared `items.xml` local-id-to-frame mapping. Every collectible registration must declare its stable local id under `isaac-collectible-registration`. If a target entry lacks it, do not infer frame order; keep both registration and mapping blocked/TBD until a user-approved append-only migration is completed. An existing loader may add a mapping key but cannot waive the local-id requirement. The common established sketch cell is 16x16 inside that atlas; read the actual ANM2 before editing.
- Do not propose a standalone same-name `_mystuff.png` copied from the colored icon as the default route.
- A user may explicitly choose another route, and a project may already have one. Preserve that choice when it has a declared loader/mapping; record it as an override and require a separate in-game check for every affected native surface.
## Discovery Contract

- Actual `items.xml` root `deathanm2` value or `TBD`.
- Resolved ANM2 and spritesheet paths, discovered from the current project.
- Whether every target entry declares the required stable local `<active|passive|familiar id="N">`; if so, the exact ANM2 frame N/reserved-frame mapping; otherwise a registration-and-mapping blocked/migration state.
- Requested native surfaces: ESC My Stuff, collection page, Last Will, or `TBD`.
- Whether the project already overrides or extends this route.

## Stable Native ID Rule

- When a target entry declares a stable local `items.xml` `id="N"`, map it to the discovered ANM2 frame N convention, including any explicit frame-0/reserved behavior.
- When target entries have no declared local id, both collectible registration and native mapping are blocked: do not use document order, a local ordinal, `Isaac.GetItemIdByName`, `ItemConfig`, console output, or logs as a substitute. Propose a user-approved, explicit, unique, append-only local-id migration. A project-declared loader/table may add a mapping key only after that local-id requirement is met.
- `Isaac.GetItemIdByName`, `ItemConfig`, console output, and logs expose runtime/global IDs for Lua. They are not native death-portrait frame indices and may change when installed mods or load order change. Never move art to global slots such as `733..763` because of a current log.
- A project-declared custom loader/table may add to the native mapping only after its stable key, loading order, and mapping are discovered; it cannot override the declared-local-id registration rule. Verify native and custom surfaces separately.

## Hard Checks

- Do not infer an animation name from an item name or id; read the ANM2.
- Do not assume a colored `gfx` PNG creates or fixes a death portrait.
- Do not draw a manual HUD overlay to imitate a missing native death portrait.
- Keep native verification separate: inspect every requested surface in game.
## My Stuff Format Boundary

- `deathanm2` points to an ANM2-based item-sketch route. It is not a filename convention for one standalone PNG per collectible.
- Do not assume `<item>_mystuff.png` is a native default route. It is acceptable only when the user explicitly chooses it or the project already declares a loader/mapping; otherwise discover the existing ANM2, spritesheet, and declared-`items.xml`-local-id-to-frame mapping, or a blocked/migration state.
- Do not derive the My Stuff format from the colored collectible `gfx` image. A colored image may be 32x32 while a death-portrait spritesheet is a larger atlas; neither 32x32 nor 64x64 is a universal My Stuff requirement.
- Read the target ANM2 and its spritesheet to obtain actual sheet dimensions, cell/frame geometry, pivot, and animation names. Keep all unknown values as `TBD`.
- Do not edit the pause-menu My Stuff panel/background asset to add a collectible sketch. It is a UI panel asset, not the per-item portrait route.