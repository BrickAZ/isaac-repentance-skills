# Source Pixel Fact Gate

Do not turn a preview interpretation into an exact pixel instruction. Before naming a palette value, outline thickness, Alpha value, antialiasing rule, visible bounds, or padding contract, decode the actual original PNG used by that surface.

## Required Measurements

Record:

- canvas width, height, and pixel format;
- visible RGB and RGBA palettes with counts;
- Alpha histogram and semi-transparent pixel count;
- visible bounding box and padding;
- connected visible islands and dirty transparent RGB;
- whether dark pixels belong to the subject, an outline, transparent storage, or only the preview background;
- the actual consumer and display scale.

Use `isaac-character-art-surfaces/scripts/inspect-png-surface.ps1` when available. The file measurement is evidence; a screenshot on black, white, or checkerboard is only a preview.

## Prompt Fact Provenance

Classify every exact prompt or reconstruction constraint as one of:

| Class | Meaning | May become a hard instruction? |
| --- | --- | --- |
| User decision | Explicitly approved identity or presentation choice | Yes |
| Observed source fact | Measured from the decoded native/project file | Yes, for that surface/version |
| Consumer contract | Proven path, canvas, crop, pivot, frame, or display rule | Yes |
| Translation strategy | A reasoned simplification for native scale | Yes, but label it as a design choice |
| Unverified interpretation | Guessed from a preview or memory | No |
| Tool capability claim | Promise that a generator will return an exact file property | No |
| Completion claim | Statement that evidence stages have passed | Only after those stages actually pass |

If a sentence cannot be classified, keep it out of the hard prompt until its authority is known.

## Preview Traps

- A black preview background does not prove a dark outline exists.
- A checkerboard does not prove those squares are stored in the PNG.
- Having an Alpha channel does not prove the background geometry is transparent.
- A smooth-looking edge does not prove multicolor antialiasing; inspect RGB and Alpha separately.
- A one-pixel-looking enlarged edge does not prove a fixed one-pixel outline at native scale.
- Transparent pixels may retain RGB values; they are not visible subject pixels.

After measurements, write the prompt from observed facts plus explicit user decisions. Keep recommendations, target-identity interpretation, and generator limitations visibly separate.
