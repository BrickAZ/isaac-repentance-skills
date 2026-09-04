# Identity Translation Workflow

Use this reference when one source design must remain coherent across multiple Isaac art surfaces.

## 1. Source Evidence Dossier

Record only approved evidence:

| Field | Evidence |
| --- | --- |
| Source views | Front, back, side, action, or written description actually supplied |
| User-locked traits | Features, colors, mood, materials, or exclusions explicitly chosen |
| Unresolved design facts | Label each as `TBD — user decision required` |
| Target Isaac surfaces | Each requested display purpose, not guessed adjacent surfaces |
| Technical sources | Official or target-project template/consumer for each surface |

Do not infer hidden sides of an asymmetric design, turn a mood word into a fixed palette, or treat fan art as source authority without user approval.

## 2. Identity Feature Ledger

Build a ranked ledger before pixel work:

| Feature | Type | Priority | Relationship | Minimum readable signal | Allowed simplification | Surfaces |
| --- | --- | --- | --- | --- | --- | --- |
| Example: forked antlers | silhouette | must survive | emerges above hair | two separated upward branches | omit minor twigs | player, head layer, portrait |
| Example: red scarf | color/local mark | must survive | crosses neck below hair | controlled red neck accent | omit fabric pattern | player, icon, portrait |
| Example: long dark coat | mass/material | surface-dependent | extends below torso | dark vertical body mass with leg separation | shorten in small frames | player, Boss, portrait |

Types:

- **Silhouette anchor:** changes the outer contour or major negative space.
- **Color anchor:** a stable hue/value relationship used for recognition.
- **Material/structure cue:** metal, cloth, hair, bone, glass, flesh, machinery, or another readable construction.
- **Local mark:** emblem, scarf, eye patch, weapon notch, or other small but placed signal.

Priorities:

- **Must survive:** removing it breaks identity.
- **Surface-dependent:** useful only where scale and purpose support it.
- **Omit at this scale:** source detail that would become noise or false texture.

Do not assign a universal number of required features. The ledger must justify why each surface remains recognizable with the signals it keeps.

## 3. Surface Translation Matrix

Create a separate row for every actual output:

| Surface | Native purpose | Main identity carrier | Secondary signal | Removed detail | Main readability risk |
| --- | --- | --- | --- | --- | --- |
| Player gameplay frame | moving actor | head/body silhouette | accent color | fine costume motifs | animation-direction drift |
| Independent costume layer | occluding decoration | hair/hat/horn contour | small material contrast | body detail | helmet shell/face occlusion |
| 32x32 collectible | object icon | one object-like silhouette | one accent/material cue | full character anatomy | person-thumbnail clutter |
| Familiar | moving companion | compact body profile | eye/accent color | costume microdetail | ownership confused by shape |
| Enemy or Boss | attack-readable actor | body/weapon silhouette | palette/material family | nonessential source ornament | hidden telegraph/contact point |
| Character-select portrait | menu identification | head/shoulder profile | face and accent | full-body detail | concept-art rendering mismatch |

These are reasoning examples, not fixed dimensions or required surfaces. Use actual project/native evidence for technical values.

## 4. Shape Pass Before Detail

1. Draw or isolate the largest masses in flat values.
2. Check silhouette and negative space at native `1x`.
3. Check orientation and frame-to-frame anchor stability.
4. Add identity accent and material separation.
5. Add only internal details that remain useful at native scale.

A feature that appears only at `4x` is pixel craft, not necessarily gameplay identity.

## 5. Palette Roles

Define roles instead of copying every source color:

- identity primary;
- identity accent;
- material light;
- material midtone;
- material shadow;
- deepest attached outline;
- optional effect/emission color.

Different surfaces may use different exact colors because their backgrounds and pixel densities differ. Preserve the relationships and explain deviations.

## 6. Cross-Surface Review Questions

- Can a reviewer connect the surfaces without filenames or text labels?
- Which identity anchor does each surface carry?
- Are any two surfaces contradictory rather than merely simplified differently?
- Did a small surface become a scaled character portrait instead of its own design?
- Did an attractive detail erase gameplay direction, face, feet, or attack telegraph?
- Does the result still use Isaac's target surface language rather than imported high-resolution rendering?

Record unresolved art choices as user decisions. Do not let a model silently choose which emblem, object, costume split, or Boss should represent the source.
