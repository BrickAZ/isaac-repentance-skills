# Verification Layers

Use the cheapest reliable proof first.

## Static

Run validators for XML, paths, ids, language shape, and skill metadata.

For audio, static inspection may also prove the resolved XML/path, extension, container, and codec metadata. It cannot prove that Isaac's target loader accepts or audibly plays the file.

## Scripted

Use tests under `tests/` for logic that can be isolated from Isaac runtime. Add a focused test when a bug is likely to regress.

For render coordinates, use a non-identity camera transform and distinct
nonzero sentinels for owner visual offsets and callback render offsets. Assert
the exact input to world-to-screen conversion, exact final screen position,
no draw on conversion failure, and allowed/excluded render modes. Identity
conversion plus zero offsets cannot expose a double-add bug.

For audio, a stub or `pcall` can prove runtime-id lookup, manager selection, argument shape, and no-throw dispatch only. It cannot prove file opening, decoding, mixing, or speaker output.

## Instrumented

Use temporary logs or debug flags only when the symptom cannot be reproduced by static or local tests. Remove temporary instrumentation before final handoff.

For audio, inspect the latest game log from a reproduction using the current file. Record missing-resource, open, and decode messages separately from the Lua-call result.

## In-Game

Required for:

- Render order, real camera conversion, visual offsets, callback offsets, and
  reflection/refraction render passes.
- Shader behavior.
- Input interception.
- Collision and physics.
- Pickup visuals.
- Challenge start conditions.
- Save/reload behavior.
- Audible custom-audio playback, including target trigger, volume/pitch, overlap, and repeated-use behavior.

Report in-game checks as concrete steps, not vague advice.
