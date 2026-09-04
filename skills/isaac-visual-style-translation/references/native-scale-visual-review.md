# Native-Scale Visual Review

Use this reference after a draft exists. It separates deterministic technical checks from visual judgment.

## Review Board

For each surface, prepare:

1. raw RGBA asset or atlas;
2. native `1x` contextual composite;
3. `4x` nearest-neighbor pixel view;
4. checkerboard, white, and representative room/UI background composites;
5. animation/direction contact sheet when applicable;
6. cross-surface board with every output shown at its own native display scale.

Do not enlarge each surface to equal visual size on the cross-surface board. Equal display size hides the actual readability problem.

## Automated Checks

Automation can prove or flag:

- PNG dimensions, mode, bit depth, and Alpha presence;
- crop bounds, atlas-cell ownership, and reference resolution;
- transparent pixels outside an approved subject mask;
- accidental nontransparent rectangles or large low-variance backing regions;
- isolated Alpha islands and semitransparent edge contamination;
- frame coverage, direction coverage, and unexpectedly empty frames;
- pivot/anchor deltas when a trusted baseline exists;
- bounding-box, center, or feature-mask jumps as warnings;
- presence of approved palette-role or identity-feature masks;
- technical parity with the discovered template.

Automation cannot prove beauty, identity, material clarity, silhouette quality, attack readability, menu composition, or in-game loading.

## Human Native-1x Checks

Review without filenames or explanatory captions where possible:

- Does the subject read against actual room/UI colors?
- Can the main silhouette be understood before internal detail?
- Are face, feet, direction, and gameplay contact points still readable?
- Do all directions and actions depict the same design?
- Does a dark subject contain enough internal structure to avoid becoming a block?
- Is the identity accent visible but controlled?
- Do portraits, icons, characters, and enemies share an explainable visual family?
- Does the asset look native to its Isaac surface instead of like a shrunken illustration?

## Outline And Backing-Plate Diagnosis

Classify dark pixels by geometry, not color alone:

- **Attached outline:** follows the subject contour and supports separation.
- **Internal structure:** belongs to clothing, eye, shadow, cavity, or material detail.
- **Cast or contact shadow:** allowed only when the target surface and user-approved design call for it.
- **Accidental backing plate:** rectangular, low-variance, detached, or unrelated to the subject silhouette.

If the user or project already confirms a backing plate is accidental, reject the export. Do not reopen the decision. If the geometry is genuinely unresolved and blocks progress, ask the user once and keep it `TBD — user decision required`.

## Pass States

Report two independent states:

- **Technical:** blocked, failed, static pass, or in-game technical pass.
- **Visual:** blocked, failed, provisional native-1x pass, or user-approved in-game pass.

Examples:

- `technical: static pass / visual: failed` when every file contract is valid but the identity is unreadable;
- `technical: static pass / visual: provisional` when contextual previews pass but no game capture exists;
- `technical: in-game pass / visual: user-approved in-game pass` only after the requested surface actually rendered and the visual result was accepted.

Never collapse these into one word such as “validated.”
