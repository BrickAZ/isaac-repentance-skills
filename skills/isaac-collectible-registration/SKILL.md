---
name: isaac-collectible-registration
description: "Register, review, debug, or write handoff prompts for Binding of Isaac: Repentance collectible metadata and colored icon assets: items.xml active/passive/familiar entries, gfxroot, gfx filenames, collectible PNG discovery, pedestal/collectible display, and blank/missing colored collectible art. Use whenever a custom item has a missing/wrong items.xml gfx image, item pedestal display issue, colored HUD/Extra HUD collectible image issue, or collectible registration mismatch. Route ESC My Stuff, collection-page, and Last Will sketch/death-portrait icons to isaac-anm2-visuals. 中文触发：道具注册、items.xml、gfxroot、gfx、道具彩色图标、道具底座图标、道具空白贴图、收藏品贴图。"
---

# Isaac Collectible Registration

Use this skill for the registration and colored display-asset chain shared by
active, passive, and familiar collectibles. Use `isaac-mod-context` first in an
unfamiliar project.

## Boundary

This skill owns `items.xml` metadata, `gfxroot`, `gfx`, and the matching colored
collectible PNG. It does not own item balance, pools, held behavior, active-item
charge/use logic, familiar AI, custom Lua HUD drawing, or `deathanm2` sketches.

- Use `isaac-item-economy` for quality, tags, pools, weights, and availability.
- Use `isaac-passive-collectibles`, `isaac-active-item-mechanics`, or
  `isaac-familiars` for behavior.
- Use `isaac-anm2-visuals` for native `deathanm2` item sketches shown by ESC
  My Stuff, the collection page, or Last Will. A colored `gfx` PNG neither
  proves nor replaces that ANM2 route.

Default to official Isaac content conventions and discovered project facts. Do
not require a third-party library or reference-mod checkout.

## Discover the Registration Chain

Before changing a collectible, record:

- actual `items.xml` path and root `gfxroot` value;
- entry kind (`active`, `passive`, or `familiar`), registered name, and id route;
- entry `gfx` filename and the resolved colored collectible PNG path;
- existing project naming/casing convention and nearby known-good entry;
- which surface is wrong: colored collectible/pedestal display, Extra HUD, or a
  native death-portrait surface that must route to `isaac-anm2-visuals`.

Do not invent a root, filename, id, or image size. A colored collectible resource
chain is valid only after the current project's `gfxroot` plus per-item `gfx`
resolves to a resource under that project's own tree.

## Colored Gfx Rule

The `gfx` chain is native collectible artwork, not a reason to invent a manual
HUD route or a death-portrait route.

- Do not use `MC_POST_RENDER`, `Sprite:Render`, or world/screen coordinates to
  fake a missing native colored collectible image.
- Do not treat a gameplay callback, active charge, cache calculation, or EID
  description as proof the `gfx` path is valid.
- If the colored image is blank/wrong, inspect the XML entry kind, `gfxroot`,
  `gfx` filename, exact PNG existence/casing, and current-project registration
  load path before changing item behavior.
- If the complaint is about the ESC My Stuff sketch, collection-page sketch, or
  Last Will portrait, do not inspect `gfx` as the sole fix; route to
  `isaac-anm2-visuals` and discover `deathanm2`.

- High-priority default: do not propose a same-name `_mystuff.png` copied from a colored collectible `gfx` PNG. Use the discovered `deathanm2` ANM2, spritesheet, and item-frame mapping instead. A user-requested or project-established alternative is allowed, but record its explicit loader/mapping and require an in-game proof for ESC My Stuff.

## High-Priority Official Colored-Icon Suggestion

- If the user has not supplied a compatible colored collectible image, recommend a 32x32 `gfxroot + gfx` PNG before implementation.
- If the user asks to generate that absent image, generate a 32x32 colored collectible PNG and wire it through the discovered `gfxroot + gfx` route.
- Preserve a user-provided or project-established alternative when its registration path is known; report the mismatch rather than silently resizing or replacing it.
## Registration Contract

```markdown
## Collectible Registration Contract

- Item kind and registered name:
- items.xml and gfxroot:
- Item id lookup source:
- gfx filename:
- Resolved colored collectible PNG path:
- Colored display surface(s) to verify:
- Death-portrait surface delegated to ANM2, if requested:
- Economy fields owned elsewhere:
- Behavior fields owned elsewhere:
- Static and in-game verification:
```

Keep the XML entry type aligned with the intended collectible behavior. A valid
PNG does not prove a passive cache effect or active-use callback works; conversely
working Lua does not prove the colored `gfx` path can resolve.

## Validation

Use `isaac-validators` for XML, duplicate-id, and asset-path checks when the
project supports them. Verify in game by acquiring the owned item and checking
the requested colored display surface. Verify any ESC/collection/Last Will
sketch separately through `isaac-anm2-visuals`. Do not call a file-existence
check proof of correct in-game rendering.