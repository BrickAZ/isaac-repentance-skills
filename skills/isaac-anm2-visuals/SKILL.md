---
name: isaac-anm2-visuals
description: Work with `.anm2` visual assets for Binding of Isaac Repentance mods. Use this whenever the user asks to create, fix, review, or write a prompt for Isaac `.anm2` visuals, costumes, Lua-loaded Sprite effects, UI/HUD sprites, collectible death portraits, ESC My Stuff sketches, collection-page or Last Will item sketches, EID inline icons, weapon appearances, weapon icons, or vanilla animation-template reuse. If the visual needs collision, AI, HP, pickup behavior, contact damage, or entities2.xml registration, also use isaac-entities; use isaac-familiars first when the registered entity is a custom familiar. 中文触发：anm2、贴图、外观、服装、变身、以撒身上、头上特效、光环、HUD、ESC 草图、死亡遗嘱道具图、收藏页道具草图、图标、动画不显示。
---

# Isaac ANM2 Visuals

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

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
5. Who owns it: costume XML, Lua `Sprite`, `deathanm2`, EID, vanilla template, or entity XML? For a collectible registration, require an explicit stable local `items.xml` id under `isaac-collectible-registration`; for `deathanm2`, prove how that id and any project-declared custom loader supply the frame key, and distinguish both from a runtime global ItemConfig id.

## Asset Purpose Gate

Before generating, commissioning, replacing, or naming an art asset, output this resource-purpose card. Do not infer it from the art theme or a word such as "weapon".

| Field | Required decision |
| --- | --- |
| Asset purpose | One primary purpose: world/combat appearance, player-body appearance, UI/menu icon, EID inline icon, colored collectible art, death portrait, card face, or another named native surface. |
| Display surface | The exact requested in-game surface; keep it `TBD` when the user only says "icon". |
| Carrier / mapping | The discovered costume, Lua Sprite, registered entity, XML, ANM2, atlas, or UI mapping route. |
| Animation need | Required, not required, or `TBD`; a world appearance may need animation while a UI icon usually does not. |
| Not for | Name the adjacent surfaces this asset must not silently replace. |

A weapon is a theme, not a resource route:

- **Weapon appearance** means a world/combat or player-body visual. Its carrier remains `TBD` until the project proves costume, familiar, Lua Sprite, or registered-entity ownership. It is not a HUD, EID, colored-collectible, or ESC icon by default.
- **Weapon icon** means a UI/native-surface asset. HUD, EID, colored collectible art, ESC My Stuff, and other menus are separate surfaces; if the user does not name one, keep the display surface `TBD` rather than defaulting to `32x32` or a world appearance.
- If one design needs both an animated weapon appearance and an icon, create two resource-purpose cards. They may share art direction or be derived from one source illustration, but they need separate export sizes and discovered loading/mapping routes.
- If any card field is `TBD`, do project discovery before generating pixels or proposing a file path.



When the task targets a native menu or HUD surface, read `references/official-native-ui-baselines.md` for the asset decision gate and overrideable official size/ANM2 baselines. If the user asks to generate an absent asset, generate the listed source frame and integrate it into the discovered atlas/mapping.

Then identify the visual route:

- **Costume / player overlay**: player head/body/wing/mask/held visual tied to costumes. Read `references/costumes.md`.
- **Lua Sprite effect**: visual feedback loaded and rendered by Lua with `Sprite:Load`, `:Play`, `:Update`, `:Render`. Read `references/lua-sprite-effects.md`.
- **UI / HUD sprite**: screen-space sprite, button guide, meter, counter, choice panel, or overlay. Read `references/ui-hud-sprites.md`.
- **Collectible death portrait**: native item sketch for ESC My Stuff, the collection page, or Last Will. Discover `items.xml` root `deathanm2`, the ANM2/spritesheet, and its declared local-id-to-frame mapping. If any target entry lacks its required declared local id, keep both registration and mapping blocked/TBD until a user-approved append-only migration is completed; an existing loader may add a mapping key but cannot waive the registration requirement. Never use a Lua/runtime global ItemConfig id as the frame key. Read `references/collectible-death-portraits.md`. This is separate from the colored `gfxroot + gfx` PNG route owned by `isaac-collectible-registration`.
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
- Native `deathanm2` ID rule: when the target entry declares a stable local `<active|passive|familiar id="N">` in `items.xml`, use that declared local id as the ANM2 frame key. If it lacks that required declared local id, do not infer a key from document order, `Isaac.GetItemIdByName`, a debug log, or a runtime/global ItemConfig number such as `733`; block registration and propose a user-approved append-only migration. A declared custom loader may add a mapping key but cannot substitute for the local id. Read the actual ANM2 to preserve any frame-0 or reserved-frame convention.
- For a native collectible death portrait, do not use `MC_POST_RENDER` or a manual HUD sprite as a substitute. Discover the `deathanm2` root, source ANM2/spritesheet, required declared-local-id-to-frame mapping, or an explicitly blocked/migration state, and the exact native surface before editing.
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
- Inspect a current-project `items.xml` root `deathanm2` and its matching item-sketch ANM2 only when ESC, collection-page, or Last Will art is requested.

## Final Review

Before saying the visual work is complete, report:

- The selected route.
- For a death portrait, the `items.xml` root `deathanm2`, ANM2/spritesheet, declared-local-id-to-frame mapping or blocked/migration state, confirmation that no runtime/global ItemConfig ID was used, and requested native surfaces.
- Every `.anm2` path and PNG spritesheet path touched.
- Every XML or Lua file that references the `.anm2`.
- The animation names used.
- Whether the asset is loaded by XML, `Isaac.GetCostumeIdByPath`, EID, or manual `Sprite:Load`.
- Any rendering behavior that still needs in-game verification.
