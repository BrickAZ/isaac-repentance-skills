# Repentance Character Art Surface Matrix

These are official Repentance baselines for planning art. They are suggestions when the user has not supplied a project-owned route; they do not authorize an agent to overwrite official shared files or invent custom atlas coordinates.

| Surface | Official baseline | In-game purpose | Important boundary |
| --- | --- | --- | --- |
| In-run player skin | Official Isaac baseline: `Character_*.png`, `512x512`; actual crop sizes, offsets, blank slots, frame order, and any additional actor spritesheets come from the target player ANM2 | The playable body during movement, firing, pickup, hurt, and death animations | Do not assume a uniform cell grid. `001.000_player.anm2` mixes `32x32`, `64x64`, offset, overlapping, and blank crops, and also references a separate ghost sheet. Preserve the selected atlas, alpha, and discovered crop manifest; inspect every actor spritesheet before claiming full player coverage. |
| Player portrait | `PlayerPortrait_*.png`, `144x144` | Native player portrait selected by `players.xml` | Not the select, co-op, or death-screen art. |
| Player name image | `PlayerName_*.png`, `192x64` | Native player-name image selected by `players.xml` | Text image; do not replace it with a portrait. |
| Character select | `characterportraits.anm2`; `48x48` frame from the `512x1024` Repentance `CharacterMenu.png` atlas | Main character-selection portrait | Generate the one `48x48` source frame only when the target mapping is known. |
| Co-op menu | `coop menu.anm2`; `32x32` frame from the `192x224` Repentance atlas | Co-op selection portrait | Base-game atlases can differ; use the current project/Repentance route actually in use. |
| Death screen | `death screen.anm2`, `death portraits.png` (`512x256` in Repentance) plus an extra atlas | Death/Last Will portrait route | The atlas and animation select the frame; a standalone portrait needs a discovered mapping. |
| Costume or extra layer | Project/official costume ANM2 plus its referenced PNG | Hair, head, body, wings, masks, transformations, held layers | Do not infer its canvas or frame order from the base player skin. |

## Baseline Discovery

For a real project, discover the registered player entry and its `skin`, `portrait`, and `nameimage` fields; then read the associated ANM2 before editing assets. The official player actor has multiple visual layers, so a working PNG size alone does not prove every body/head/costume layer is correct.

## Minimal Checks

1. Measure output width/height and require exact equality with the selected source canvas or source-frame baseline.
2. Require alpha preservation when the source is transparent.
3. For a locked edit, compare the output with the input outside the approved change mask/cells.
4. For a complete in-run skin, inspect all required animation directions and actions in-game; a single idle crop is insufficient.
5. Check every requested native surface independently in-game.
## Coordinate Contract Versus Silhouette

For a pure recolor, preserve the source alpha exactly. For an original full skin, the source atlas remains the coordinate contract: canvas, crop rectangles, pivots, feet, direction, layer order, and animation coverage must remain compatible with the target ANM2. The visible silhouette may change only within approved owning crop regions. An external concept image may guide design but cannot be pasted or scaled into the atlas.