---
name: isaac-testing-debugging
description: Debug and verify Binding of Isaac Repentance mod changes. Use this whenever the user asks how to test, prove, debug, reproduce, diagnose, or verify an Isaac mod bug or change, including blank cards, blank/meaningless entities, items not triggering, callbacks not firing, missing visuals, silent or undecodable custom audio, pcall/test-stub false positives, challenge leakage, state persisting between rooms/runs, failing Lua tests, debug-console checks, or deciding what must be tested in-game versus statically. 中文触发：测试、验证、证明、排错、复现、没反应、回调不触发、空白卡、空白实体、无效实体、贴图不显示、音效无声、音频解码、pcall 假通过、挑战泄漏、状态残留、Lua 测试失败。
---

# Isaac Testing And Debugging

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when the task is about proof, diagnosis, or verification.

The goal is to stop guessing. Isaac mod work needs a layered verification story: static checks, local behavior tests where possible, targeted logs or debug-console reproduction, then in-game checks for runtime-only surfaces.

## First Move

Before proposing a fix:

1. In an unfamiliar mod, use `isaac-mod-context` to discover the bootstrap files, test entrypoints, validation commands, and asset/XML roots. Do not assume `tests/`, `main.lua`, or a Lua test runner.
2. Classify the symptom using `references/symptom-triage.md`.
3. Decide which checks are static, scripted, or in-game.
4. Run `isaac-validators` for static surfaces when possible.
5. Discover the actual runner before declaring a local behavior test unavailable: inspect project scripts and documented tool paths, query the current shell, then query any environment-provided or bundled runtime. Record the exact executable path and version when found.
6. Read the closest existing project test before writing a new test; if none exists, choose the smallest available scripted or in-game reproduction.
7. If the issue is stateful, also use `isaac-state-lifecycle`.
8. If the intended mechanic itself is ambiguous, reconstruct its trigger/guard/result contract with `isaac-mechanic-contracts` before judging a callback as broken.
9. If a visual, icon, portrait, menu, or native UI surface is involved, create a surface matrix before proposing a fix. Read `references/native-surface-matrix.md`.
10. If the failure crosses an Isaac API boundary that expects `Vector`, `Color`, `KColor`, `EntityRef`, or another engine-owned value, read **Engine Value Boundary Tests** before trusting a Lua stub.
11. If custom audio is silent or logs a load/decode failure, use `isaac-audio-render-feedback` and read **Audio Decode And Playback Proof** before treating a successful API call as playback.

## Verification Layers

- **Static validation**: XML parse, missing assets, duplicate ids, language shape. Use `isaac-validators`.
- **Local behavior tests**: discovered Lua or project test files; use these for pure logic, callback helper behavior, state transitions, and localization scripts.
- **Targeted instrumentation**: temporary debug output, debug console steps, or narrow reproduction commands.
- **In-game verification**: visuals, render order, input handling, shader safety, entity collision, pickup behavior, challenge starts, save/reload behavior.

Read `references/verification-layers.md` before planning verification. Read `references/debug-report-template.md` before final reporting.

## Hard Rules

- Do not claim an Isaac runtime behavior is fixed only because code looks right.
- Do not infer that a resource chain proven on one native surface also fixes another. A colored collectible PNG, pocket HUD image, death portrait, character-select portrait, achievement popup, and completion mark each need their own discovered route and requested in-game check.
- Do not run broad refactors while debugging a specific symptom.
- Do not patch before identifying the most likely failing surface.
- Do not leave temporary debug prints or forced spawn hooks in final code unless the user asked for a debug mode.
- When a test cannot run in the current environment, say exactly what was not run and provide the shortest in-game check.
- Do not conclude that Lua behavior tests are unavailable merely because `lua` is absent from `PATH`. Complete runner discovery first; do not install a runtime, alter global `PATH`, or change machine configuration unless the user explicitly asks.
- Separate “runner found but test failed”, “test was not run”, and “no compatible runner was found after discovery”.
- Do not treat a test stub that only records an engine call as proof that its argument types are valid. For a tested engine boundary, the stub must reject plain Lua-table lookalikes and exercise the exact changed path.
- Do not accept an identity `WorldToScreen` stub plus all-zero `PositionOffset`
  and callback `RenderOffset` as proof of render-coordinate correctness. Such a
  fixture collapses distinct domains and lets duplicated or missing offsets pass.
- Do not treat `pcall`, a no-throw SFX stub, or a recorded `SFXManager:Play` invocation as proof that Isaac opened, decoded, or audibly played an audio asset.
- Do not state the runtime representation of a constructor from a test fixture alone. Record whether the current test uses a function, callable object, or another adapter, then verify the real construction route from project/official/runtime evidence.
- Do not let a room/door test declare every coordinate legal. Model discovered room topology separately from local position legality, and include a no-candidate case that proves no owned mutation or success consumption occurs.
- Do not treat a console/debug/goto room as proof that normal map adjacency, neighboring-room creation, or door transitions work. Require a separate normal-floor in-game check.

## Render Coordinate Boundary Tests

For a manually rendered world-following sprite, scripted tests must keep the
domains observably different:

1. Use a non-identity `WorldToScreen`, such as adding a known camera delta, and
   assert the exact world argument passed into it.
2. Give owner `PositionOffset`, `SpriteOffset`/flying offset, and callback
   `RenderOffset` distinct nonzero sentinel values. Assert the selected anchor
   policy consumes each intended value exactly once and ignores the others.
3. Exercise the real changed callback path, not only a detached helper. Assert
   the final `Sprite:Render` position and explicit clamp arguments when used.
4. Make missing/failed conversion observable and assert no owned `Render` call
   occurs; a raw world-coordinate fallback is a failure.
5. Invoke allowed and excluded render modes to prove one-pass versus
   reflection/refraction behavior.
6. Keep camera movement, riding/flying animation offsets, co-op ownership, and
   native-scale placement as separate in-game proof.

These tests prove arithmetic and routing, not final visual quality.

## Audio Decode And Playback Proof

When a registered custom sound is silent, keep these evidence layers separate:

1. **Static asset contract**: confirm the exact requested surface, discovered XML entry, resolved asset path, extension, container, and codec. For ordinary Repentance custom SFX, `isaac-audio-render-feedback` uses PCM WAV as the high-priority default unless the project proves another SFX loader.
2. **Scripted dispatch**: verify runtime id lookup, playback manager, argument order, and trigger ownership. `pcall` or a stub may prove only that this Lua path returned without throwing.
3. **Game-log loading**: reproduce with the current asset and inspect the latest game log for missing-resource, open, or decode errors. An old log or a log from a previous conversion is not evidence.
4. **Audible in-game playback**: trigger the exact event and check volume, pitch, overlap/restart behavior, repeated use, pause, and relevant co-op ownership.

Do not repair a one-shot SFX by moving it to `music.xml`/`MusicManager` merely because its OGG plays there. That changes the audio role and can occupy or interrupt global music. Convert or replace the SFX asset only within the discovered SFX route, or preserve a project-proven alternate loader with its dependency gate.

## Engine Value Boundary Tests

An Isaac API can require an engine-compatible value even when a Lua table has matching fields. Treat `Vector`, `Color`, `KColor`, `EntityRef`, and comparable values as a boundary contract, not as structural Lua data.

1. Identify the exact engine call and every typed argument it receives.
2. Discover how the project/runtime constructs that value. Do not branch only on `type(Constructor) == "function"`; a callable object is possible.
3. Let construction fail explicitly. The caller must skip or abort only its owned operation rather than passing a table fallback into the engine.
4. Make the test double accept the same constructor shape needed by production and reject an ordinary lookalike at the engine-call boundary.
5. Prove the current source and current test actually execute the changed path. A report about an older fixture is not test evidence.
6. Mark the real-game type contract as in-game/runtime evidence unless the project or official API proves it directly.
## Room Topology And Door Tests

Room-local coordinates are not proof of world topology. A door or portal feature needs two independent facts: a legal local position and a real neighboring room/door slot in the current map context.

For any custom door, portal, gallery connection, or room-to-room transition test:

1. Record the discovered current room identity and whether it is a normal map-grid room or a debug/console surface.
2. Test at least one valid normal-floor candidate with a discovered compatible slot and neighbor.
3. Test a blocked or invalid candidate.
4. Test the no-candidate result: no owned portal/door appears, existing unrelated doors remain, and no once-per-room/floor success is consumed.
5. Keep a debug-room test as a focused local reproduction only; it cannot prove map adjacency merely because it reloads or pages.
6. Run the shortest real normal-floor in-game check for connection, return route, cleanup, and repeat behavior.
## PNG Alpha And Pedestal Tests

When a custom colored collectible appears with a black square, black rectangle, or unexpected matte behind it, triage the PNG alpha contract before changing Lua, item pools, or pedestal code.

1. Confirm the exact display surface is the native colored collectible `gfx`, not ESC My Stuff, collection art, EID, or a manual HUD sprite.
2. Decode the final delivered PNG and inspect alpha, not the preview RGB. Verify that the intended border and the four corners are alpha-zero unless the user explicitly selected full-frame art.
3. Separate an outline that follows the object silhouette from a uniform opaque rectangular backdrop. The former can be valid; the latter is a failure by default.
4. Check that the final file is PNG with alpha rather than JPEG or an RGB/flattened export. Also check that the resolved `gfxroot + gfx` path is the file that was inspected.
5. Spawn or acquire the owned collectible on a normal pedestal in game and capture the result. Static alpha proof does not prove the correct resource chain; the pedestal check does not replace alpha inspection.
6. If a full-frame opaque design is intentional, mark it as a user decision and verify it at native size. Never infer that intention from an accidental black square.

## Mask, Matte, And Frame Acceptance

For generated or edited cut-out art, run this visual acceptance sequence before calling the asset usable:

1. Decode alpha and identify the intended subject mask. Do not accept a color-key result simply because an alpha channel exists.
2. Check low-luminance regions of every color family, including deep grey and brown. Judge their geometry: attached outline/internal detail can be valid; detached or filled rectangular plates outside the subject are not.
3. Composite the finished PNG on light-grey checkerboard, solid white, and a room-like background. Do not use a black background as the only preview.
4. For ANM2 spritesheets, use the discovered crop manifest and perform steps 1-3 per unique crop/frame, naming the animation and layer for any failure.
5. Finish with the native in-game surface check: pedestal, HUD, character animation, or other requested surface. Static inspection and a generic preview do not prove the game route.

## Character Decoration Visual Acceptance

When hair, a hat, horns, leaves, or another creator/player head decoration is under review, use `isaac-character-art-surfaces` as the visual authority and keep two verdicts separate:

- **Technical verdict**: canvas/RGBA/crop contract, maximum visible bounds, center/anchor tolerance, protected-face coverage, direction/frame size jumps, alpha fringe, and cross-crop pixels.
- **Visual verdict**: native `1x` front/back/left/right overlays against the matching vanilla head, compared with the approved design and any measured validated references.

Never require pixels on both side edges, a high minimum visible-pixel count, or silhouette expansion beyond the vanilla head as proof that a decoration is complete. A lower pixel threshold may catch only blank or missing required content. A technically valid asset still fails when the native `1x` overlay is visibly oversized, board-like, or a closed head shell instead of the requested ordinary hair. Use `4x` nearest-neighbor output only to inspect pixels, not to approve proportion. An intentional helmet, hood, or oversized transformation remains a separate explicit design decision.
## Static-Pass Runtime Failures

A clean validator run can still leave a callback unregistered, a valid entity
without update behavior, a wrong callback return, or a render/input path that
never occurs in game. For these cases, add a behavior test or focused in-game
reproduction. Static success proves structure, not event delivery or gameplay.

## Full-Entry Lua Load Check

When changing a large, monolithic Lua entry file, include a check that parses or loads the full discovered entry file with the closest compatible Lua runner. This catches compile-time failures such as exceeding Lua's local-variable limit, which XML/static validators and isolated helper tests cannot see.

- Prefer a lightweight Isaac stub that executes the real entry file when the game cannot be launched.
- Keep callback and asset stubs minimal; the goal is to prove the entry chunk loads and the changed handler is registered.
- Report separately if only an isolated helper was tested, or if no compatible Lua runner is available.

## Common Debug Routes

- Blank card or abnormal pickup: `isaac-cards-pockets` plus `isaac-validators`.
- Wrong, duplicated, blank, or lost reward: `isaac-rewards-pickups`, then check candidate validation, owner, repeat boundary, spawn/Morph fallback, and third-party preservation.
- Item does not trigger: item id lookup, callback registration, item ownership, active slot, charge/use return.
- Callback fires incorrectly or not at all: `isaac-callback-contracts`, registration line, handler existence, filter, callback-specific return policy, and a behavior test that invokes the registered handler.
- World-following sprite drifts or jumps: `isaac-anm2-visuals` plus
  `isaac-hud-ui-state`; audit world/visual/callback/screen domains, exact-once
  offset ownership, conversion failure, render modes, and the non-identity
  coordinate test before changing art or ANM2 pivots.
- Visual missing or a colored collectible with a black rectangular backing: first name the exact surface, then use `isaac-anm2-visuals` for that surface's asset path, animation name, load owner, and render/update path. For a native colored collectible, use `isaac-collectible-registration` to decode its PNG alpha and inspect it on a normal pedestal. Do not use a working adjacent surface as proof.
- Entity not behaving: `isaac-entities`, callback route, type/variant/subtype, `GetData()`, spawn/remove logic.
- Blank/meaningless entity or pickup: prove the spawn owner first, then check current-project registration, id/variant/subtype, ANM2/spritesheet/HUD chain, and invalid-target fallback. Do not test by globally deleting unknown entities.
- Challenge leaking: `isaac-challenges`, `Isaac.GetChallenge()` gate, state lifecycle cleanup.
- Door, portal, or rooms that are not truly connected: `isaac-rooms-stages`; verify map topology separately from local coordinates, then run valid/blocked/no-candidate tests and a normal-floor check.
- State persists or vanishes incorrectly: `isaac-state-lifecycle`, reset/save/reload plan.
- Custom SFX call succeeds but remains silent: `isaac-audio-render-feedback`; separate XML/path/container/codec inspection, scripted dispatch, latest-log decode result, and audible in-game playback. Do not reroute a one-shot through the music manager as a decoder workaround.

## Final Review

Before saying debugging is complete, report:

- Symptom and suspected surface.
- Checks run and outputs summarized.
- Files inspected.
- Fix applied or recommended.
- Tests run.
- Manual in-game checks still required.
- For native visuals, the surface matrix and every still-unverified surface.
- For engine-valued API boundaries, the current code path, test-double assertion, and the remaining runtime/in-game proof.
- For room topology, the current room context, candidate matrix, no-candidate result, and separate normal-floor proof.
- For silent custom audio, the XML/manager route, container/codec evidence, scripted-call result, latest-log load/decode result, and separate audible in-game result.


When any active `TBD` remains, the **last section** of the response must be
`**User decisions required**`. Repeat every unresolved project fact, expected
behavior, or required evidence there; do not end on a test plan or matrix.
