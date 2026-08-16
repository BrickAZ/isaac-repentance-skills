---
name: isaac-character-art-surfaces
description: Plan, generate, review, or write a handoff prompt for Binding of Isaac Repentance custom-player art across its actual native surfaces, including player hair, head decorations, costume art proportions, and full skins. Use this whenever the user asks for character art, player sprites, hair or head accessories, an Isaac reskin, character skin, character portrait, player name image, character-select portrait, co-op portrait, death portrait, or wants generated player art to match a supplied vanilla sprite. Use isaac-anm2-visuals for ANM2/template hookup and isaac-players-characters for players.xml/character behavior. 中文触发：角色素材、角色美术、角色贴图、人物贴图、角色皮肤、头发、头饰、角色挂饰、costume美术、以撒换皮、人物立绘、角色头像、角色选择头像、合作头像、角色肖像、角色名称图。
---

# Isaac Character Art Surfaces

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

This skill owns the art brief and native-surface matrix for a playable character. It does not register a player, edit `players.xml`, select a gameplay mechanic, or wire an ANM2. Route those parts to `isaac-players-characters` and `isaac-anm2-visuals` after the art surfaces are defined.
## Default: Original-First, Not Concept Art

In an Isaac modding request, interpret vague wording such as "generate an Isaac wearing [feature]", "make a character with [feature]", or "change Isaac into [theme]" as a request to adapt an original game art surface, not a request for independent character illustration.

- When the requested surface is not named, treat an in-run player skin as the provisional primary surface. Do not silently add portraits, menus, death art, costumes, or HUD art.
- First discover the matching original surface in the local Repentance installation or the target project's existing override. Use that original PNG as the only edit input.
- Generate an asset only after the original input, target surface, and approved changed feature are available. The default operation is an in-place, reference-locked edit of that source.
- If the original source cannot be found or supplied, do **not** generate an "Isaac-like," "original-style," concept-art, 3D, painted, posed, or enlarged substitute. Report the missing source as **`TBD — user decision required`** and stop before image generation.
- A user may explicitly request a brand-new, non-original visual design. Treat that as an opt-in exception, label it as a new surface-specific asset, and still require an explicit target surface and canvas before generating pixels.

The reason is functional: a game mod needs a PNG that preserves the original carrier's grid, animation contract, and pixel language. A visually pleasing illustration cannot replace that game asset.

## First Move: Name The Surface

Do not interpret “draw a character” as permission to make a standalone illustration. Under Original-First mode, an unnamed “Isaac/character in game” request provisionally starts with the in-run player skin only; discover its original source before generating. Ask or discover every other in-game surface separately. A source image for one surface is not proof that it can substitute for another.

Read [references/character-surface-matrix.md](references/character-surface-matrix.md) before proposing a canvas size, source image, or generation prompt.

## Reference-Locked Sprite Editing

When the user supplies an official or project-owned sprite reference and asks to alter that character, the default task is a **reference-locked edit**, not concept art.

- Use the supplied or discovered original source PNG as the edit input; an external concept image is semantic reference only, never the output canvas or a compositing source.
- Preserve its exact canvas width and height, RGBA color mode and transparent-background semantics, pixel scale, actual ANM2 crop rectangles, crop order, pivots, and unmodified pixels outside the user-approved change region. Pixel-for-pixel alpha equality applies only when the selected art mode requires it.
- Decode alpha before interpreting the image. A pixel with `alpha=0` is transparent even if its stored RGB is black, white, or skin-colored; do not build masks from a screenshot's apparent background color.
- Preserve the source's in-game orientation, crop coordinates, pivots, foot contact, and attack direction. Choose the alpha/silhouette rule from the selected art mode; do not default an original character skin to source-alpha equality.
- Change only the requested visual feature. A blue hair/banana motif does not authorize a new body shape, dungeon background, pose, lighting, perspective, clothing design, or high-resolution redraw.
- Do not mistake one ANM2 crop for a full playable-character skin. Crop size is not universal: a `512x512` player atlas can mix `32x32`, `64x64`, offset, overlapping, and deliberately blank crop regions. Read the actual target ANM2 before deciding what must be edited.
- Do not fabricate missing directions or action frames from one crop. Request the complete sheet, the actual crop manifest, or the user's approval for an explicitly limited deliverable.

If no source reference exists, stop before generation and request or discover the matching original source. Do not convert that absence into an “original-style” new asset. A wholly new surface-specific asset is allowed only after the user explicitly opts out of Original-First mode; then use the official frame size only as a suggested export baseline and keep the target atlas/mapping as `TBD` until discovered.

## Player-Skin Crop Manifest And Delivery Scope

For an in-run player skin, read the target player ANM2 and produce a crop manifest before generating pixels. The manifest must list every spritesheet referenced by the actor, then for each requested sheet list source PNG, canvas size, spritesheet layer, every unique crop rectangle, every animation that uses it, alpha coverage, and whether the region is an intentional blank slot.

The official Isaac baseline proves why this discovery is necessary: `Character_001_Isaac.png` is `512x512`, but `001.000_player.anm2` uses a mixed crop layout rather than an 8 by 8 `64x64` grid. It has 38 animations, 81 crop records, five fully transparent `body0` placeholder regions, and 66 distinct visible source regions after overlapping crop records are collapsed: 14 head regions, 20 normal-body regions, and 32 `extra`/special-action regions. These numbers are evidence for this specific official template, not a universal custom-character requirement.

Offer an explicit delivery scope:

| Scope | What is edited | Completion claim |
| --- | --- | --- |
| Basic movement only | The official Isaac template's 6 normal head regions plus 20 normal body regions, or the target ANM2's equivalent discovered set | Only normal movement/firing is covered; pickup, death, teleport, glitch, and other special states may remain unchanged. |
| Full base-atlas reskin | Every nontransparent source region on the selected base PNG used by the target ANM2, including special-action regions | All discovered states on that one atlas are covered; separately report any other spritesheets referenced by the actor. |
| Full player visual | Every relevant spritesheet referenced by the target actor ANM2, including project-proven ghost, costume, or other state sheets | No full-player claim until every needed sheet is discovered, scoped, and verified. |
| New/extra layer | Only project-proven costume or other separate layer regions | Does not replace the base player skin. |

Do not paint intentionally blank slots such as the official template's empty `body0` regions unless a project-proven layer actually owns them. Do not call a 26-region basic pass a complete character reskin, and do not call a base-atlas pass a full player visual when the ANM2 references other spritesheets.

## Design Principles

A custom-player atlas has two separate contracts:

1. **Atlas-coordinate contract**: source canvas, pixel density, actor spritesheets, ANM2 animation names, layer names, crop rectangles, crop order, pivots, per-frame placement, foot contact, and attack direction. Preserve this contract for every custom player.
2. **Original-silhouette reference**: the visible alpha/outline of the vanilla template. Preserve it only when the user asks for a pure recolor or another explicitly silhouette-locked edit.

Do not confuse the two. A custom character may have hair, hats, stems, leaves, horns, hoods, collars, capes, or a different body shape. Those are valid when they remain controlled inside the owning crop region, preserve the actor's anchoring/foot contact, and are covered across the required animation states. The original PNG is still the coordinate template; it is not a prohibition on original silhouettes.

The crop or frame canvas is capacity, not a composition target. A `64x64` crop does not mean the visible art should approach `64x64`, touch its sides, or contain a minimum amount of ink. Design against the measured vanilla actor at native game scale first, then place the result inside the discovered crop contract.

## Pure Recolor Versus Original Full Skin

| Mode | Intended result | Alpha/silhouette rule | Required proof |
| --- | --- | --- | --- |
| Pure recolor skin | Same Isaac anatomy and silhouette; only colors or small internal pixels change | Source alpha and all protected pixels remain exactly equal | Pixel comparison outside the approved recolor mask, alpha equality, and normal in-game frame checks |
| Original full skin | New character identity drawn on the vanilla coordinate/animation contract | Alpha may change only inside the user-approved owning crop region; no cross-crop pixels, pivot drift, foot drift, or unapproved direction change | Crop-manifest validation, anchor/foot checks, per-state coverage, and visual identity review |
| Separate decoration | Hair, hat, horns, glasses, cloak, body clothing, or another layer that should survive independently | Base skin may remain stable; decoration owns its separate layer/ANM2 | Costume layer, priority/occlusion, lifecycle, and per-state checks |

Never apply a complete-alpha hash comparison to an original full skin. It would reduce every custom character to a recolored Isaac.

## Implementation Route Selection

| Need | Preferred route | Discovery and acceptance boundary |
| --- | --- | --- |
| Replace the base playable body | `players.xml` `skin` pointing at the discovered base atlas | Keep canvas, crop manifest, pivots, feet, directions, and required states compatible; the base art may be original within crop bounds. |
| Add removable or independently ordered hair, hat, horns, glasses, cloak, or clothing | Base skin plus a project-proven `type="none"` Null Costume and its own ANM2 layer | Discover costume XML, layer names, spritesheet, priority, and whether items cover it. Lua may use `AddNullCostume` / `TryRemoveNullCostume` only after project discovery proves that route. |
| Flying, unusual pose, changed animation structure, or a nonstandard body contract | Dedicated player ANM2 and matching sheets | Preserve the new ANM2's own crop/pivot contract; do not force it into a vanilla frame map. Verify every supported state. |
| Reusable visual transformation without a newly registered player | Complete Null Costume route, optionally with state-gated Lua refresh | It is not a new player registration. It may redraw inside each owned crop region, but must not cross its discovered coordinates or lose state cleanup. |

Do not invent `players.xml`, costume XML, Lua file paths, costume priority, or callback owners. Discover the target project's route first.

## Pixel-Edit Contract

A black/white screenshot is not an edit contract. Use decoded RGBA source data plus named masks aligned to the full atlas:

- `source_alpha_mask`: records which source pixels are visible; transparent RGB values are not drawable content.
- `protected_mask`: features explicitly locked by the selected brief, such as eyes, tears, mouth, outline, or untouched regions. It is not automatically the entire original silhouette.
- `face_protected_mask`: for ordinary head decorations, protects the eyes, tears, mouth, and the facial area that the approved design does not intentionally cover.
- `head_reference`: records the measured vanilla head bounds and anchor for each owning direction/frame; it is a proportion and placement baseline, not an alpha-equality requirement.
- `decoration_subject_mask`: owns only the approved hair, hat, horn, leaf, or other decoration pixels. It must not become a generic filled shell around the face.
- `recolor_mask`: a pure-recolor-only area; source alpha must remain equal here and everywhere else.
- Named original-skin masks such as `head`, `leaf`, `hoodie`, or `horn`: each identifies the owning crop region and permitted controlled silhouette expansion.
- `semantic_reference`: an external picture may guide color/shape vocabulary only. It may not be scaled, pasted, or composited into the atlas.

For every mode, enforce exact source canvas, RGBA mode, crop-manifest compatibility, no cross-crop pixels, and unchanged ANM2 pivots/foot contact unless an explicitly discovered custom ANM2 replaces them. For pure recolor, enforce source alpha equality and exact pixels outside `recolor_mask`. For an original full skin, allow alpha changes only inside approved owning crop masks; reject output that crosses a crop, collides with another owner, moves the feet, or changes an unapproved attack direction. Repeat the gate independently for every requested spritesheet; a passing base atlas does not prove an unexamined ghost, costume, or other sheet.

## Head Decoration Proportion Gate

Apply this gate to ordinary hair and creator/player head decorations that are meant to sit on an Isaac-scale head. Do not apply it unchanged to an explicitly requested helmet, sealed hood, giant afro, transformation shell, or another intentionally oversized design.

- Measure the actual vanilla head bounds and anchor in the target crop before drawing. Do not derive visible size from the crop dimensions.
- When the user has not supplied another approved proportion, use the following advisory starting band for standard hair: the vanilla head is about `32px` wide; ordinary hair is usually about `34-38px` wide and `29-38px` high; without a clear silhouette reason, keep the visible decoration within about `40x40px`. These are review baselines, not replacements for the discovered source or an explicit user design.
- Allow individual tips to extend locally. Reject uniform expansion that turns the whole decoration into a helmet-sized shell.
- Keep bangs, side hair, and back hair legible as separated or layered forms. Preserve intentional gaps and enough of the face outline to read at native scale.
- Classify a large closed blob with only a face-shaped hole as a head shell, not ordinary hair. Unless the brief explicitly requests a helmet/hood/shell, discard that outer contour and redraw it; do not approve it after only scaling it down or carving a larger hole.
- When reliable local or bundled examples are available, measure at least three validated examples and compare the new visible bounds with their normal range. A public skill must remain self-contained: never require the user to install those reference mods or copy their files.

For every generated or edited head decoration, require four review artifacts:

1. The transparent atlas or crop deliverable.
2. Front/back/left/right overlays on the matching vanilla head frames.
3. A native `1x` gameplay-size preview.
4. A `4x` nearest-neighbor preview for pixel inspection.

Use the `1x` overlay as the final proportion and silhouette authority. The `4x` view may reveal pixel defects, but it cannot prove that the decoration is correctly sized.

## Costume Compatibility And Occlusion Matrix

Before choosing a base skin, Null Costume, dedicated player ANM2, or costume priority, review:

| Axis | Required cases |
| --- | --- |
| Character | normal, tainted/alternate, twins when supported |
| Skin | supported skin colors and alternate-skin routes |
| Layer | head, body, held item, wings/flying, special poses |
| Other visuals | representative hats, hair, masks, transformations, body costumes |
| Lifecycle | spawn, continue, room transition, death/revive, co-op join/leave |
| Occlusion | above, below, hidden, or incompatible for each relevant visual |

Occlusion and priority are design decisions. If the user/project has not decided which features must cover one another, mark the policy **`TBD — user decision required`**. Do not default to a maximum priority such as `999`, do not repeatedly re-add a costume to force ordering, and do not use a passing isolated preview as proof of costume compatibility.

Use a base `players.xml skin` for the discovered base-player sheet, a Null Costume for an independently ordered feature, and a dedicated player ANM2 only when the animation structure requires it. The loading/override route belongs to `isaac-reskins-resource-overrides`; ANM2 and Add/Remove details still require their own discovered contracts.

## Visual Review Checklist

Before approval, review reduced game-size renders rather than only a zoomed atlas:

1. Can the player be recognized from silhouette alone at gameplay size?
2. Do signature features alter the intended outline only as much as the approved design requires? Do not force expansion merely to make the silhouette “more distinctive.”
3. Do front, side, back, movement, attack, hurt, pickup, death, and special frames keep the same identity?
4. Do head, clothes, and body use one coherent shape language?
5. Can item costumes hide the decoration? If so, should it become a separate higher/lower-priority layer?
6. Is the result still only a vanilla recolor when the user asked for an original full skin?

## Automated Test Suggestions

Automated checks should report pass/fail separately from visual review:

- Source/output canvas, RGBA mode, and pixel-density match.
- Every crop rectangle remains in atlas bounds; no approved expansion crosses its owning crop or collides with another protected owner.
- Pivot, actor placement, foot-contact point, and attack-direction metadata do not drift from the selected ANM2 contract.
- Enforce a maximum visible bounding box and center/anchor tolerance for each approved decoration. Compare direction/frame bounds and flag sudden size or position jumps.
- Use a lower visible-pixel threshold only to detect a blank frame or a missing required identity component. Never use it to require fullness, side-edge occupancy, or a visibly larger silhouette.
- For ordinary head decorations, verify that protected eyes/mouth regions remain visible unless the brief explicitly authorizes coverage.
- Decode final RGBA and flag unintended semi-transparent fringe pixels, dirty alpha islands, or cross-crop pixels.
- Required signature colors and identity components are present in their named masks.
- Every supported direction and required action has a corresponding nonblank source region.
- For pure recolor only: source alpha equality and protected-pixel equality.
- For an original full skin: allow controlled alpha expansion within approved crop masks; never use full-alpha hash equality as the universal test.

## Common Failure Cases

- Treating the original alpha silhouette as universal law: produces only recolored Isaac and blocks hats, horns, leaves, collars, hoods, and different proportions.
- Scaling an illustration into the atlas: keeps a file loadable but breaks crop coordinates, feet, direction, and animation identity.
- Treating crop capacity as a target size: creates oversized hair, helmets, or board-like silhouettes that pass file checks but fail at `1x`.
- Requiring pixels at both side edges or a high minimum visible-pixel count: rewards filling the crop and penalizes correctly small decorations.
- Repairing a failed head-shell silhouette only by uniform scaling or cutting a larger face hole instead of redesigning its outer contour and hair layers.
- Letting a feature cross into a neighboring crop: causes another animation or layer to inherit stray pixels.
- Editing only walking frames: the character reverts during pickup, hurt, death, teleport, or special states.
- Drawing into intentional transparent placeholder slots: creates artifacts or conflicts with a later costume layer.
- Adding a Null Costume without lifecycle/priority review: decorations duplicate, disappear after refresh, or are hidden by item costumes.
- Calling a base-atlas pass “complete” while another ANM2 spritesheet such as a ghost state remains unreviewed.
## Required Surface Matrix

Before generation, output this matrix. Mark non-requested rows as unchanged; do not silently generate them.

| Surface | Requested? | Source/reference | Output canvas | Carrier/mapping evidence | Acceptance check |
| --- | --- | --- | --- | --- | --- |
| In-run player skin | | | | | |
| Character portrait | | | | | |
| Character name image | | | | | |
| Character-select portrait | | | | | |
| Co-op portrait | | | | | |
| Death-screen portrait | | | | | |
| Costume / extra body layer | | | | | |
| Character-specific HUD or another named surface | | | | | |

## Generation Brief

For each requested row, state all of the following before pixels are generated:

- Exact surface and player/variant identity.
- Whether it is a reference-locked edit or a new surface-specific asset.
- Source image path and its measured dimensions; `TBD` when absent.
- Exact output canvas and whether it is a whole atlas or a single source cell.
- The approved changed feature and the protected regions/frame cells.
- Transparent-background requirement, if the source has transparency.
- Explicit exclusions: no scene background, no concept-art pose, no 3D/painted rendering, no upscaling, and no unrelated redesigned clothing/body unless separately approved.
- Mapping/ANM2 discovery work that remains after art generation.

Use wording like this for a locked in-run skin edit:

```markdown
Edit the supplied transparent Repentance player-skin atlas in place. Read its target player ANM2 first and preserve the discovered coordinate contract: canvas size, mixed crop rectangles, crop order, pivots, foot contact, attack direction, pixel density, and frame coverage. Select `pure recolor` or `original full skin` before pixels are changed. For pure recolor, keep source alpha identical and change only the approved recolor mask. For an original full skin, allow controlled new silhouette pixels only inside approved owning crop masks; never cross a crop, move feet, or alter an unapproved direction. The supplied secondary reference is semantic only; do not scale, paste, or composite it. Return one transparent PNG at the exact source canvas for the same atlas route.
```

For a single crop, state its exact source rectangle and animation users from the target ANM2. It is only a partial deliverable; list the remaining visible crop regions required before it can be installed as a full player skin.

## Hard Rules

- `64x64` is neither a universal player-skin cell nor a complete-player baseline. The official Isaac sheet itself mixes `32x32`, `64x64`, offset, overlapping, and blank ANM2 crops.
- A `144x144` player portrait, `192x64` name image, `48x48` select portrait, and `32x32` co-op portrait are different assets with different atlas routes.
- Do not turn a character-select icon, co-op icon, or death portrait into an in-run sprite sheet, or vice versa.
- Do not overwrite a shared official atlas merely because an output uses the same frame size. Discover the current project's own atlas/ANM2/mapping first.
- Do not claim generated art is game-ready until its canvas, alpha, frame grid, target mapping, and requested in-game surface have each been checked.
- Treat a custom costume or extra body layer as a separate asset. It may need the same visual language, but it does not inherit the base skin's dimensions or frame sequence without ANM2 evidence.

## Handoff

- Use `isaac-anm2-visuals` for costume, atlas, ANM2, sprite-layer, and native UI mapping checks.
- Use `isaac-players-characters` for registered player identity, `players.xml`, starting kit, co-op behavior, and all character gameplay.
- Use `isaac-testing-debugging` for per-surface in-game proof.

## Final Review

Report every requested surface, its source and output dimensions, whether it was reference-locked, the protected regions and discovered crop manifest, the remaining mapping work, and separate in-game checks for each requested surface. Do not say a player skin works merely because a menu portrait looks correct.

When any active `TBD` remains, the **last section** must be **User decisions required** and repeat every unresolved source, surface, variant, mask, mapping, or acceptance decision.