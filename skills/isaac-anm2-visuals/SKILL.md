---
name: isaac-anm2-visuals
description: Work with `.anm2` visual assets for Binding of Isaac Repentance mods. Use this whenever the user asks to create, fix, review, or write a prompt for Isaac `.anm2` visuals, costumes, Lua-loaded Sprite effects, UI/HUD sprites, EID inline icons, or vanilla animation-template reuse. If the visual needs collision, AI, HP, pickup behavior, contact damage, or entities2.xml registration, also use isaac-entities; use isaac-familiars first when the registered entity is a custom familiar. 中文触发：anm2、贴图、外观、服装、变身、以撒身上、头上特效、光环、HUD、图标、动画不显示。
---

# Isaac ANM2 Visuals

Use this skill for `.anm2` visual work in Isaac Repentance mods.

Read `../isaac-mod-context/references/design-authority.md` before filling in visual carrier, style, animation intent, or presentation direction. Follow local technical conventions, but do not invent artistic intent.

The goal is to stop plausible-looking but broken visual hookups: confusing player-body changes with effects, wrong paths, wrong animation names, missing XML registration, bad sprite lifetime, EID icons that do not render, or hand-built `.anm2` files that should have reused a vanilla template.

## First Move

Before editing or writing a prompt, first translate the user's visual request into a carrier. Read `references/visual-carrier-decision.md` when the request says things like "on Isaac", "on the player's head", "around the player", "effect", "body", "appearance", "halo", "mark", or "UI".

In an unfamiliar mod, use `isaac-mod-context` first to discover the asset root, XML files, bootstrap/load files, and any existing visual route. Do not assume `resources/`, `content/costumes2.xml`, or `main.lua`.

If the user supplies no project file tree, choose only the visual carrier. Leave asset paths, animation names, callback owners, and registration files as discovery requirements or `TBD`; do not invent source-like paths in an implementation prompt.

Answer these questions before choosing a route:

1. Where does the visual attach: player body, near the player, room/world, screen UI, or EID text?
2. Does it need to follow player body animation and facing direction?
3. Does it need collision, damage, AI, or entity variant/subtype?
4. How long does it live: permanent, conditional, timed, or one-shot?
5. Who owns it: costume XML, Lua `Sprite`, EID, vanilla template, or entity XML?

Then identify the visual route:

- **Costume / player overlay**: player head/body/wing/mask/held visual tied to costumes. Read `references/costumes.md`.
- **Lua Sprite effect**: visual feedback loaded and rendered by Lua with `Sprite:Load`, `:Play`, `:Update`, `:Render`. Read `references/lua-sprite-effects.md`.
- **UI / HUD sprite**: screen-space sprite, button guide, meter, counter, choice panel, or overlay. Read `references/ui-hud-sprites.md`.
- **EID / inline icon**: EID icon, transformation icon, card/pill icon, or text inline visual. Read `references/eid-icons.md`.
- **Vanilla template reuse**: reusing an existing Isaac `.anm2` skeleton and replacing spritesheets or animation/frame. Read `references/vanilla-template-reuse.md`.

If the request is actually about `content/entities2.xml`, entity type/variant/subtype, collision radius, grid collision, NPCs, tears, lasers, knives, or effects with entity registration, use `isaac-entities` for behavior and registration. If it is a custom familiar, use `isaac-familiars` for count, owner, and behavior plus `isaac-entities` for registration. Keep this skill only for the `.anm2`, spritesheet, animation-name, and visual-carrier checks.

## Self-Contained Fallback

Prefer the current mod's closest asset. If it has no matching asset, use the
bundled costume, Lua-sprite, UI, EID, and vanilla-template references. They
describe the file and runtime contracts directly; no third-party mod checkout
is required.

## Implementation Rules

- Always connect `.anm2` path, spritesheet PNG path, animation name, and Lua/XML reference as one unit.
- Do not invent animation names. Read the `.anm2` and use its `DefaultAnimation` or named `Animation`.
- Do not assume case-insensitive paths. Match existing repo casing and Isaac's resource-root conventions.
- For generated `.anm2`, keep the first version simple: one spritesheet, one layer, clear pivot, explicit width/height, and one or two animation names.
- For a manual Lua `Sprite`, keep world anchor and screen render position separate:
  calculate the owner-relative world anchor, then pass
  `Isaac.WorldToScreen(worldAnchor)` to `Sprite:Render`. Never pass
  `entity.Position` or another world coordinate directly to manual `Render`.
- Do not use one fixed vertical `Vector` as a universal “head” anchor. Resolve
  player offsets, flying behavior, entity size, Boss/normal-enemy differences,
  and ANM2 pivot from the actual owner and project convention; verify each
  supported category in game.
- If writing a code prompt, include exact files to read, expected asset paths, expected animation names, and the route checklist.
- After file changes, use `isaac-validators` for static path checks when possible, then list in-game render checks separately.
- When an `.anm2` belongs to a registered custom entity, treat its XML registration, ANM2, spritesheet, and default animation as one spawn-safety contract. A broken contract must suppress only the current project's owned spawn, never prompt a global unknown-entity cleanup.

## Current Project Examples

- Inspect a current-project EID icon and its optional registration guard when one exists.
- Inspect a current-project Lua `Sprite` effect for load, update, render, and cleanup ownership.
- Inspect a current-project UI sprite for screen-space coordinates and cached lifetime.
- Inspect a current-project costume XML and matching `.anm2` only when the project actually uses costumes.

## Final Review

Before saying the visual work is complete, report:

- The selected route.
- Every `.anm2` path and PNG spritesheet path touched.
- Every XML or Lua file that references the `.anm2`.
- The animation names used.
- Whether the asset is loaded by XML, `Isaac.GetCostumeIdByPath`, EID, or manual `Sprite:Load`.
- Any rendering behavior that still needs in-game verification.
