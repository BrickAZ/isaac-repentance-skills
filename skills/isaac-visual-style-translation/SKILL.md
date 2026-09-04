---
name: isaac-visual-style-translation
description: "Design, generate, review, or write handoff prompts for translating an external character, theme, or visual identity across multiple Binding of Isaac: Repentance art surfaces. Use when player sprites, costumes, items, familiars, enemies or Bosses, portraits, and UI must look like one coherent source design at native 1x, or when technically valid assets still look visually inconsistent. 中文触发：美术风格转译、跨表面美术、统一角色风格、原设转以撒像素、角色道具Boss同主题、技术通过但不好看。"
---

# Isaac Visual Style Translation

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Boundary

This skill owns art-direction translation and cross-surface visual cohesion. It decides which source traits must survive, how they change with scale and surface, and whether the result still reads as one identity in native gameplay.

It does not own:

- project discovery, paths, resource roots, or dependencies: use `isaac-mod-context`;
- character surface inventory and source-template editing: use `isaac-character-art-surfaces`;
- ANM2 crops, pivots, layers, events, frame order, or Sprite loading: use `isaac-anm2-visuals`;
- exact-path, runtime-replacement, or Null Costume carrier choice: use `isaac-reskins-resource-overrides`;
- XML registration, IDs, mechanics, collision, AI, callbacks, or balance: use the owning mechanic skill;
- proving that an asset actually rendered in game: use `isaac-testing-debugging` after static checks.

Use this skill as primary when the central problem is translating one source identity across two or more art surfaces or judging their shared visual language. For one character surface only, keep `isaac-character-art-surfaces` primary. For one technical ANM2/path problem only, do not load this skill.

Reference mods may justify this skill during maintenance, but they are never a runtime dependency, required checkout, default layout, or authority for the target project. The shipped skill must remain usable with official Repentance assets and the target project's own files alone.

## Authority Order

Keep three authorities separate:

1. **User-approved source material** owns identity, theme, mood, and locked visual choices.
2. **The target project's discovered assets and official Repentance templates** own technical dimensions, pixel density, crops, pivots, animation structure, and display context.
3. **This skill's recommendations** fill only unspecified art-direction choices and remain suggestions.

Do not let a reference mod override an explicit user choice or a discovered native contract. Do not reproduce another mod's paths, IDs, code, or unusual dimensions merely because its art is appealing.

## First Move

Before generating or reviewing pixels:

1. Use `isaac-mod-context` to discover the target project and requested surfaces.
2. Obtain the approved source design or record exactly which source traits the user supplied in text.
3. Read the original/native template and consumer for every requested surface through the owning art/ANM2/resource skill.
4. Create one shared identity ledger, then a separate translation row for every surface.

If the source is only a vague theme, keep unresolved identity details as **`TBD — user decision required`**. A textual list can support silhouette studies, but it does not authorize invented final hair geometry, costume structure, emblem, or palette values.

Read [references/identity-translation-workflow.md](references/identity-translation-workflow.md) when extracting a design or planning more than one surface. Read [references/native-scale-visual-review.md](references/native-scale-visual-review.md) when generating, reviewing, or accepting finished assets.

## Source Pixel Fact Gate

Before writing an exact palette, outline thickness, Alpha value, antialiasing rule, visible bounding box, or padding instruction, decode and measure the actual original PNG for that surface. A black or checkerboard preview cannot prove stored outline or background pixels. Record observed source facts separately from user decisions, consumer contracts, translation strategies, unverified interpretations, and tool capability limits.

Read [references/source-pixel-fact-gate.md](references/source-pixel-fact-gate.md). Use `isaac-character-art-surfaces/scripts/inspect-png-surface.ps1` when an exact PNG fact is needed. Do not put an unverified preview interpretation or a promise about generator output dimensions into a hard generation prompt.

## Identity Translation Contract

Translate the source; do not miniaturize it literally.

- Rank source traits as **must survive**, **surface-dependent**, or **omit at this scale**.
- Separate silhouette anchors, color anchors, material/structure cues, and local marks.
- Preserve relationships, not raw detail count: which feature sits above, wraps around, interrupts, or contrasts with another often matters more than its exact ornamentation.
- Give every requested surface an explicit identity budget. A surface does not need every trait, but it must retain enough approved signals to belong to the same family at its real display size.
- Re-encode the identity for each native surface. Never create one master illustration and resize/crop it into player frames, a collectible icon, a Boss sheet, and portraits.
- Let large silhouettes and negative space carry small gameplay assets. Reserve facial detail, texture, and secondary motifs for surfaces that can actually display them.

The atlas or crop rectangle is coordinate capacity, not a target visible size. Do not enlarge art because it fails to touch cell edges or because a visible-pixel minimum is low.

## Shape, Color, And Material Language

### Shape

- Establish the largest readable masses before internal detail.
- Preserve directional identity across front, back, left, right, action, damage, transition, and rare frames owned by the actual template.
- Allow controlled within-crop silhouette changes when the chosen route supports an original design; never cross a crop boundary or drift from the proven anchor.
- Protect gameplay readability. A Boss reskin must preserve attack anticipation and danger direction even when its new silhouette is attractive.

### Color And Value

- Define palette roles rather than universal RGB values: identity primary, accent, material light, material shadow, outline, and background-separation value.
- Keep an identity accent scarce enough to remain meaningful.
- Separate dark clothing or bodies from the deepest outline with value, hue, or controlled openings. A dark subject must not become an unreadable solid block.
- Review a grayscale/value version as well as color. Hue contrast cannot rescue a silhouette that disappears at native size.

### Outline And Alpha

- Use selective, subject-attached dark outlines where the target surface needs separation.
- Do not add a rectangle, halo block, or unrelated dark backing behind the subject to force contrast.
- Do not remove all black or near-black pixels to clean a background; legitimate clothes, shadows, eyes, and outlines may be dark.
- Build and inspect the subject Alpha mask geometrically. Having an Alpha channel does not prove that the background is transparent.
- When the user or project has already identified an area as an accidental backing plate, mark the export failed immediately. Do not ask again whether the plate was intentional.

## Cross-Surface Cohesion Gate

For every requested surface, record:

- native display purpose and approximate on-screen scale;
- identity traits retained, simplified, or intentionally absent;
- silhouette relationship to the shared source;
- palette roles used;
- material cues used;
- neighboring UI, room, costume, or animation context;
- independent native `1x` acceptance evidence.

Cross-surface consistency does not mean identical shapes or palettes. It means the differences are explained by surface purpose and scale while the approved identity remains recognizable.

Static validity cannot pass this gate. If PNG, ANM2, dimensions, paths, Alpha, and frame coverage all pass but the assets look unrelated, report **technical pass / visual fail** and do not call the art complete.

## Required Preview Set

Before visual acceptance, require:

- the raw transparent asset or atlas;
- a native `1x` preview in its real or faithfully reconstructed display context;
- a `4x` nearest-neighbor view for pixel defects only;
- light gray checkerboard, pure white, and representative room/UI background composites;
- direction/action contact sheets for animated assets;
- a cross-surface board showing all requested outputs together at their own native display scales.

The `1x` contextual view is the proportion, silhouette, and readability authority. A clean enlarged sheet cannot prove that an asset works in game.

## Rejection Gates

Reject or return for revision when any of these is true unless the user explicitly approved that exact exception:

- one high-resolution or master image was merely resized into unrelated native surfaces;
- the source identity survives only in text labels, not visible shape/color/material signals;
- player directions or animation frames appear to depict different designs;
- a decoration becomes a sealed helmet-like shell without that being the design;
- dark clothing merges with outline or an artificial backing plate;
- fine detail replaces readable silhouette at native `1x`;
- a reskinned Boss obscures attack anticipation or contact direction;
- different surfaces use unexplained, contradictory identity colors or motifs;
- a technical validator is presented as proof of beauty, coherence, or in-game rendering.

## Required Output

For planning or handoff, provide:

- authority/source summary;
- requested surface matrix;
- identity feature ledger and, when the approved design distributes identity across components, a per-surface identity-distribution check;
- source-pixel measurements and prompt-fact provenance ledger;
- per-surface translation decisions;
- shared shape, palette-role, outline, Alpha, and material rules;
- technical companions that must inspect actual files;
- automated checks versus native `1x` human review;
- active **`TBD — user decision required`** items;
- explicit technical-pass and visual-pass status.

When active decisions remain, finish with **User decisions required**.
