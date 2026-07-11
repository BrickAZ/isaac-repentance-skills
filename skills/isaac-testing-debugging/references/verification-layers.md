# Verification Layers

Use the cheapest reliable proof first.

## Static

Run validators for XML, paths, ids, language shape, and skill metadata.

## Scripted

Use tests under `tests/` for logic that can be isolated from Isaac runtime. Add a focused test when a bug is likely to regress.

## Instrumented

Use temporary logs or debug flags only when the symptom cannot be reproduced by static or local tests. Remove temporary instrumentation before final handoff.

## In-Game

Required for:

- Render order and screen/world coordinates.
- Shader behavior.
- Input interception.
- Collision and physics.
- Pickup visuals.
- Challenge start conditions.
- Save/reload behavior.

Report in-game checks as concrete steps, not vague advice.
