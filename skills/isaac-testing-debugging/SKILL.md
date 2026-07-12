---
name: isaac-testing-debugging
description: Debug and verify Binding of Isaac Repentance mod changes. Use this whenever the user asks how to test, prove, debug, reproduce, diagnose, or verify an Isaac mod bug or change, including blank cards, blank/meaningless entities, items not triggering, callbacks not firing, missing visuals, challenge leakage, state persisting between rooms/runs, failing Lua tests, debug-console checks, or deciding what must be tested in-game versus statically. 中文触发：测试、验证、证明、排错、复现、没反应、回调不触发、空白卡、空白实体、无效实体、贴图不显示、挑战泄漏、状态残留、Lua 测试失败。
---

# Isaac Testing And Debugging

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
- Visual missing: first name the exact surface, then use `isaac-anm2-visuals` for that surface's asset path, animation name, load owner, and render/update path. Do not use a working adjacent surface as proof.
- Entity not behaving: `isaac-entities`, callback route, type/variant/subtype, `GetData()`, spawn/remove logic.
- Blank/meaningless entity or pickup: prove the spawn owner first, then check current-project registration, id/variant/subtype, ANM2/spritesheet/HUD chain, and invalid-target fallback. Do not test by globally deleting unknown entities.
- Challenge leaking: `isaac-challenges`, `Isaac.GetChallenge()` gate, state lifecycle cleanup.
- State persists or vanishes incorrectly: `isaac-state-lifecycle`, reset/save/reload plan.

## Final Review

Before saying debugging is complete, report:

- Symptom and suspected surface.
- Checks run and outputs summarized.
- Files inspected.
- Fix applied or recommended.
- Tests run.
- Manual in-game checks still required.
- For native visuals, the surface matrix and every still-unverified surface.
