# External ANM2 Editor Workflow

Use this only when the user or target project chooses a graphical ANM2 editor.
The skill package and produced mod must remain usable without that editor.

## Boundary

- ANM2ed and similar programs are authoring tools, not Isaac APIs, runtime
  libraries, reference-mod prerequisites, or proof that the game can load the
  result.
- Do not execute an editor binary or install FFmpeg without explicit user
  authorization. Video/GIF/PNG export is presentation evidence only.
- Preserve the target project's existing ANM2 and resource conventions. An
  editor's preferred layout must not replace discovered project paths.

## Before Editing

1. Identify the exact ANM2, PNG sheets, XML/Lua callers, and animations/events
   in scope.
2. Preserve a recoverable source through version control or a user-approved
   backup route.
3. Record the existing spritesheet indices, layers, nulls, crop rectangles,
   pivots, animation names, frame order, events, sounds, and default animation.
4. Keep any unresolved path, animation, carrier, or visual choice explicit.

## After Saving

1. Parse the saved ANM2 as XML outside the editor.
2. Resolve every spritesheet path with exact casing.
3. Compare the recorded contract: indices, crops, pivots, layers, nulls,
   animations, frame order, events, sounds, loop flags, and default animation.
4. Cross-check Lua/XML event and animation names against the saved file.
5. Render each changed crop/composite at native 1x; use enlarged nearest-neighbor
   views only for pixel inspection.
6. Run static validators and behavior tests, then keep game placement, timing,
   layering, shader/sound behavior, and interaction as explicit in-game checks.

## Failure Meaning

- Editor refuses to open/save: authoring-tool failure, not proof the mod is bad.
- XML/path/crop/event contract changes unexpectedly: static integration failure.
- Static checks pass but the game renders incorrectly: unresolved runtime/visual
  failure; do not rewrite the result as verified.
