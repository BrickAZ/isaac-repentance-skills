---
name: isaac-repentogon-dev
description: "Build, migrate, review, or debug Isaac mods targeting REPENTOGON. Entry for new REPENTOGON projects and tasks spanning callbacks, native XML stats, innate items, room APIs, RNG, ImGui, HUD and progression. Carries declared required-dependency intent into implementation and selects exact focused contracts. 中文触发：忏悔龙开发、忏悔龙模组、REPENTOGON mod、新建以撒模组、迁移忏悔龙、扩展 API 开发。"
---

# REPENTOGON Mod Development

## Decisions and Discovery

A `TBD` is a genuinely unresolved user design choice. Missing paths, API
signatures, callback owners, build identities, and tool commands are technical
facts: discover them, or report **Unverified — discovery required** with the
specific evidence gap. Do not turn research work into a request for user permission.
Existing project decisions and explicit standing user preferences remain binding.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active user choice.
- Give optional alternatives only as suggestions. Preserve user-owned balance, mechanics, assets, dependency policy, and persistence semantics; resolve routine technical implementation choices within the authorized scope.
- If safe discovery or validation can continue, continue it while keeping the decision visible. Stop only the mutation that would make an unresolved user choice.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Do not reopen an accepted choice.

Read `../isaac-mod-context/references/tbd-disclosure.md` for the shared policy.

## Start and Implement

1. Discover actual files and support policy with `isaac-mod-context`. Distinguish
   an empty new project, an existing vanilla/optional mod, and required REPENTOGON.
   Do not infer neverbrith paths, content, IDs or registration.
2. Carry explicit standing intent forward. When the user has chosen REPENTOGON
   for future new mods, new projects are **required**; proceed without asking
   again or building a duplicate vanilla mechanic. Do not silently migrate an
   existing explicitly optional mod.
3. Apply `isaac-repentogon-compat` for build, per-feature minimum/fixes, lazy
   loading and XML boundaries. Read `references/source-and-capability-map.md`
   to locate precise evidence.
4. Assign one owner to each effect/state, preserve the user's mechanic, then
   implement and verify the authorized work. A route list alone is not completion.

## Pick Focused Contracts

| Central extension surface | Skill | General mechanic companions |
| --- | --- | --- |
| Dependency, build gate, migration support | isaac-repentogon-compat | mod-context, architecture |
| Damage return chain, priority, inventory, loot, unload | isaac-repentogon-callbacks | callback-contracts, damage-health, rewards |
| XML stats/null/tags/cache/achievements/players | isaac-repentogon-content | registration, passives, characters, unlocks |
| Ambush, RoomConfig, map placement, preview RNG | isaac-repentogon-world | rooms-stages, room-networks, RNG |
| ImGui, HUD entry and native UI boundaries | isaac-repentogon-ui | hud-ui-state, audio-render-feedback |

One specialist is primary for a focused task; add only genuinely needed surfaces.
This entry is primary for new-project setup, migration or broad extension work.
Do not load every Isaac skill merely because the project requires REPENTOGON.

## Native Responsibilities

Prefer proven native XML/cache/innate/progression/world APIs when they match the
chosen behavior and supported build. Remove duplicate Lua contributions without
changing formula layer, timing, ownership or balance.

- XML damage and final Lua additions may occupy different formula layers.
- An inventory notification is not evidence of natural pedestal pickup or
  exclusive true-item ownership; account for wisps, innate and overlap.
- Previews can mutate RNG or shared weights. Verify exact side effects before
  using them in UI; never generate gameplay just to inspect it.
- Pinned ImGui is not a normal clickable HUD; honor requested location and devices.
- Native achievements own persistence; avoid a competing unlock authority or
  forced unlock as a shortcut around legitimate restrictions.

## Evidence and Completion

Read `references/development-workflow.md` for new/migration records and tests.
Use compat's inventory only as a heuristic aid. Technical unknowns call for
project/source discovery; only actual design choices call for user decisions.

Record exact signature, source tag, introduction/required fix, state/ready/reset
ownership, executed checks and remaining game verification. Refresh affected
evidence when the build changes. Finish authorized implementation; distinguish
syntax/static, pure tests, mocks and actual engine observations in the handoff.
