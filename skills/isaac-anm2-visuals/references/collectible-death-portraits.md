# Collectible Death Portraits

Use this route for native item sketches shown in ESC My Stuff, the collection
page, or Last Will. It is not the colored `items.xml` `gfxroot + gfx` PNG route.

## High-Priority Default Recommendation

Use this as the default recommendation, not an unconditional requirement:

- For colored collectible art, start from a discovered `gfxroot + gfx` PNG; 32x32 is the common established starting format, but verify the target project instead of resizing an existing different format.
- For native ESC My Stuff, collection-page, and Last Will sketches, start from `items.xml` `deathanm2`, a spritesheet atlas, and its item-id animation/frame mapping. The common established sketch cell is 16x16 inside that atlas; read the actual ANM2 before editing.
- Do not propose a standalone same-name `_mystuff.png` copied from the colored icon as the default route.
- A user may explicitly choose another route, and a project may already have one. Preserve that choice when it has a declared loader/mapping; record it as an override and require a separate in-game check for every affected native surface.
## Discovery Contract

- Actual `items.xml` root `deathanm2` value or `TBD`.
- Resolved ANM2 and spritesheet paths, discovered from the current project.
- Item id and the exact animation/frame mapping expected by the current ANM2.
- Requested native surfaces: ESC My Stuff, collection page, Last Will, or `TBD`.
- Whether the project already overrides or extends this route.

## Hard Checks

- Do not infer an animation name from an item name or id; read the ANM2.
- Do not assume a colored `gfx` PNG creates or fixes a death portrait.
- Do not draw a manual HUD overlay to imitate a missing native death portrait.
- Keep native verification separate: inspect every requested surface in game.
## My Stuff Format Boundary

- `deathanm2` points to an ANM2-based item-sketch route. It is not a filename convention for one standalone PNG per collectible.
- Do not assume `<item>_mystuff.png` is a native default route. It is acceptable only when the user explicitly chooses it or the project already declares a loader/mapping; otherwise discover the existing ANM2, spritesheet, and item-id animation/frame mapping.
- Do not derive the My Stuff format from the colored collectible `gfx` image. A colored image may be 32x32 while a death-portrait spritesheet is a larger atlas; neither 32x32 nor 64x64 is a universal My Stuff requirement.
- Read the target ANM2 and its spritesheet to obtain actual sheet dimensions, cell/frame geometry, pivot, and animation names. Keep all unknown values as `TBD`.
- Do not edit the pause-menu My Stuff panel/background asset to add a collectible sketch. It is a UI panel asset, not the per-item portrait route.