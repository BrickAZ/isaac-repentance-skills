---
name: isaac-reskins-resource-overrides
description: Design, implement, review, or debug Binding of Isaac Repentance reskins and resource overrides for existing vanilla players or global game art. Use this when a mod is resource-only, replaces an exact native path, uses resources/resources-dlc3, swaps a player's actor or spritesheet at runtime, overlays a Null Costume, or has load-order conflicts with another visual mod. Use isaac-character-art-surfaces for drawing requirements, isaac-anm2-visuals for ANM2 contracts, and isaac-players-characters only when registering a genuinely new playable character. 中文触发：原版角色换皮、资源覆盖、纯资源模组、无 Lua 模组、resources-dlc3、替换原版贴图、全局换皮、加载顺序冲突、Null Costume 换皮。
---

# Isaac Reskins And Resource Overrides

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Boundary

This skill owns how an existing vanilla surface is replaced, loaded, isolated, and made compatible. It does not define the new artwork, register a new playable character, or prove ANM2 frame correctness.

- Use `isaac-character-art-surfaces` for the character-art brief and native-surface matrix.
- Use `isaac-anm2-visuals` for animation names, crops, layers, pivots, events, and spritesheet replacement.
- Use `isaac-players-characters` only when the result is a separately registered playable character.
- Use `isaac-performance-hotpaths` and `isaac-state-lifecycle` for runtime reload and per-player state.
- Use `isaac-validators` for conservative static checks. Static success is not load-order or in-game proof.

Reference mods may justify a rule during skill maintenance, but they are never a required file, layout, API, or dependency for users of this skill.

## First Move: Classify The Project And Requested Surface

Use `isaac-mod-context` before proposing files. A project may validly be:

1. a **resource-only exact-path override** with no Lua, `RegisterMod`, or `content/`;
2. a **runtime actor/spritesheet replacement** applied to existing player entities;
3. a **Null Costume overlay** for hair, hats, horns, clothing, wings, or another independently ordered layer;
4. a **registered custom player**, which belongs to `isaac-players-characters`;
5. a hybrid that intentionally combines these routes.

Discover every immediate resource root matching the project's conventions, including roots such as `resources/` and `resources-dlc3/`. The same relative path in two roots may be a version-specific override. Record it; do not call it duplicate garbage without target-version evidence.

Also name the requested native surface. An in-run player body, costume layer, character-select portrait, co-op portrait, death art, HUD surface, and global XML table are separate contracts.

For a vanilla replacement, discover the target from the actual Repentance resource tree for the supported game version. A tutorial, another mod, or memory can suggest where to look, but cannot establish the final path, filename, extension, dimensions, or atlas layout. If the native source or its consumer cannot be inspected, keep those facts visible as **`TBD — user decision required`** and stop before exporting a guessed override.

## Route Selection

Read `references/reskin-route-contract.md` before finalizing the carrier.

| Requirement | Preferred route | Main risk |
| --- | --- | --- |
| Replace an existing native file everywhere | Exact-path resource override | Global scope and load-order collision |
| Replace one actual player at runtime | Actor or spritesheet replacement | Per-player lifecycle and animation reset |
| Add independently layered hair/clothes/accessory | Null Costume overlay | Priority, occlusion, removal, and other costumes |
| Create a separately selectable character | Registered custom player | Registration/progression surface; route elsewhere |
| Support an optional mod's visual namespace | Guarded optional resource/compat route | Accidental hard dependency |

Choose the narrowest route that satisfies the requested surface. Do not copy a full native `players.xml` or `costumes2.xml` table for a one-character reskin by default. A broad table replacement is acceptable only when the intended global scope and collision policy are explicit.

## Exact-Path Override Contract

For every exact-path override, produce a manifest:

- native source evidence and supported game version:
- resource root:
- relative target path:
- exact filename, case, and extension:
- target native or project-owned surface:
- consumer and technical contract (standalone PNG, spritesheet/ANM2, XML table, or other):
- source canvas size, format, pixel density, atlas cells/crops, and indices that must remain stable:
- replacement scope:
- target game/version condition:
- other known copy of the same relative path:
- fallback when this override is not selected:
- load-order/conflict policy: **`TBD — user decision required`** unless already declared:

Rules:

- Absence of Lua is not a defect for a resource-only mod.
- Do not scaffold `main.lua`, `RegisterMod`, callbacks, or `content/` merely to make the layout look familiar.
- An exact-path override is keyed by the discovered resource root plus the complete native relative path, including the original filename and extension. Do not translate, normalize, rename, or invent any part of that key.
- Exact path and filename are necessary but not sufficient. Preserve the consumer contract: canvas dimensions, file format, pixel density, alpha behavior, spritesheet grid, crop rectangles, frame order, layer indices, and any other layout read by the native ANM2/XML consumer.
- Modify only the intended standalone surface or atlas cells unless the user explicitly requested a broader replacement. Do not resize the whole sheet, rearrange cells, pack images more tightly, or scale completed artwork into a differently structured atlas.
- Inspect the actual native source and its consumer before export. When an ANM2 or XML table defines the crop/layout, route that inspection to `isaac-anm2-visuals` or the owning registration skill instead of guessing from the PNG alone.
- Treat `players.xml`, `costumes2.xml`, and other native-named tables under a resource root as broad, load-order-sensitive surfaces.
- Metadata descriptions and folder names are hints, not proof of which file the game loaded. A game or tool may create `metadata.xml` in some workflows, but do not require, delete, or regenerate it from tutorial memory; discover the target project's actual metadata state.
- A resource in another mod's namespace is optional compatibility unless the project explicitly declares and guards a hard dependency.
- Never say which same-path file wins without target-version/load-order evidence or an in-game test.

## Resource-Only Replacement Workflow

Use this sequence when the requested behavior is a global replacement of an existing vanilla resource:

1. Confirm that global replacement is intended. If the artwork should affect only one player, item instance, room, or condition, choose a narrower runtime or registered route.
2. Locate the original Repentance resource for the supported game version and record its exact root, relative directory, filename, case, and extension. Keep unavailable facts as **`TBD — user decision required`**; do not fabricate a plausible path.
3. Discover the file's consumer. Decide whether it is a standalone image, one cell in a spritesheet, an ANM2-bound sheet, or a broad XML table.
4. Copy the native technical contract into the work plan. Preserve canvas size, format, alpha expectations, pixel density, cell rectangles, indices, and frame/layer order; change only the requested visual content.
5. Keep the implementation resource-only unless the requirement itself needs runtime state. Do not add Lua merely because code-based mods are more familiar.
6. Validate exact path and technical compatibility statically, then test in game that the intended asset actually won. Repeat with relevant load-order permutations when another mod can override the same native path.

This workflow is a default for exact native replacement, not a mandate to replace resources globally. A user-supplied valid runtime, Null Costume, or registered-entity design still takes priority.

## Runtime Replacement Contract

Runtime reskins must be owned by each actual player instance.

- Iterate or receive the actual callback player; do not use `Isaac.GetPlayer(0)` as the owner of all co-op players.
- Do not store one global applied flag for multiple players, twins, death/revive, or a player-type change.
- Load an actor or replace spritesheets on initialization, entity creation, or an explicit dirty edge such as player type, skin, or costume state changing.
- Do not call `Sprite:Load`, `ReplaceSpritesheet`, or `LoadGraphics` every update/render as a persistence mechanism.
- When replacing a live actor, preserve or explicitly restore the discovered animation, frame, overlay, playback speed, flip, and other required state. Do not assume a reload is visually neutral.
- Define cleanup/reconciliation for continue, reload, revive, co-op join/leave, and loss of eligibility.

If another costume or transformation can overwrite the same sheet, resolve that as a compatibility policy. Per-frame reloading is not a conflict strategy.

## Null Costume Compatibility Contract

Use a Null Costume only when the project proves its costume XML/path and Add/Remove lifecycle. Before choosing priority, output a compatibility matrix for:

- normal and tainted variants;
- supported skin colors or alternate skin routes;
- head, body, flying, and special-pose layers;
- representative item costumes and transformations;
- death/revive, continue, and co-op;
- whether the new layer should appear above, below, or be suppressed by each relevant visual.

Priority and occlusion are design policy. Do not default to a maximum value, `999`, or repeated room-entry reapplication. Apply once per eligibility edge, remove when ineligible, and verify that reload/revive does not duplicate the layer.

## Verification Matrix

Static checks:

- all resource roots and XML parse;
- every referenced PNG/ANM2 resolves in at least one discovered root;
- every exact-path replacement matches discovered native path, filename, case, and extension;
- replacement files preserve the discovered native canvas, format, atlas grid/crop, and consumer indices;
- broad exact-path overrides are listed as compatibility warnings;
- runtime code has no high-frequency asset reload and no first-player ownership assumption;
- ANM2 event names and spritesheet indices are checked by `isaac-anm2-visuals`.

In-game checks:

- normal and tainted target players;
- two players using different characters, then the same character;
- new run, continue, room transition, death/revive, and reload;
- item costumes, transformations, flying, and special animations;
- each supported resource-root/version route;
- relevant mod load-order permutations, including the other mod absent.

Report static proof and in-game proof separately. A valid XML file does not prove the intended override won at runtime.

## Required Output

Provide:

- project archetype and requested native surface;
- discovered resource roots;
- chosen route and rejected alternatives;
- exact-path override manifest or per-player runtime owner;
- compatibility and fallback policy;
- active `TBD — user decision required` items;
- static evidence;
- in-game verification still required.

When active decisions remain, finish with **User decisions required**.
