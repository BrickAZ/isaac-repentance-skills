---
name: isaac-collectible-registration
description: "Register, review, debug, or write handoff prompts for Binding of Isaac: Repentance collectible metadata and icon assets: items.xml active/passive/familiar entries, gfxroot, gfx filenames, collectible PNG discovery, ESC pause-menu inventory icons, and blank/missing collectible display. Use whenever a custom item exists but has a blank/wrong pause-menu icon, missing collectible art, items.xml gfx/gfxroot issue, item pedestal display asset issue, or collectible registration mismatch. 中文触发：道具注册、items.xml、gfxroot、gfx、道具图标、暂停菜单道具图标、ESC 道具、道具空白图标、收藏品贴图、道具底座图标。"
---

# Isaac Collectible Registration

Use this skill for the registration and static display-asset chain shared by
active, passive, and familiar collectibles. Use `isaac-mod-context` first in an
unfamiliar project.

## Boundary

This skill owns `items.xml` metadata, `gfxroot`, `gfx`, and the matching
collectible PNG that the game uses for native collectible display surfaces,
including the ESC pause-menu inventory icon. It does not own item balance,
pools, held behavior, active-item charge/use logic, familiar AI, or custom Lua
HUD drawing.

- Use `isaac-item-economy` for quality, tags, pools, weights, and availability.
- Use `isaac-passive-collectibles`, `isaac-active-item-mechanics`, or
  `isaac-familiars` for behavior.
- Use `isaac-anm2-visuals` only when the requested surface actually uses an
  ANM2/spritesheet. A normal collectible `gfx` PNG is not an excuse to create
  an ANM2 or manual render route.

Default to official Isaac content conventions and discovered project facts. Do
not require a third-party library or reference-mod checkout.

## Discover the Registration Chain

Before changing a collectible, record:

- actual `items.xml` path and root `gfxroot` value;
- entry kind (`active`, `passive`, or `familiar`), registered name, and id route;
- entry `gfx` filename and the resolved collectible PNG path;
- existing project naming/casing convention and nearby known-good entry;
- which native surface is wrong: pause menu, pedestal/collectible display, or
  another surface that must be independently discovered.

Do not invent a root, filename, id, or image size. YSD and Reverie both show the
same contract shape: `gfxroot` plus per-item `gfx` resolves to a collectible PNG
under the project resource tree, but each mod's root differs.

## Native Pause-Menu Icon Rule

The ESC item icon is native collectible display, not a runtime HUD overlay.

- Do not use `MC_POST_RENDER`, `Sprite:Render`, or world/screen coordinates to
  fake the icon.
- Do not treat a gameplay callback, active charge, cache calculation, or EID
  description as proof the icon path is valid.
- If the native icon is blank/wrong, inspect the XML entry kind, `gfxroot`,
  `gfx` filename, exact PNG existence/casing, and current-project registration
  load path before changing item behavior.

## Registration Contract

```markdown
## Collectible Registration Contract

- Item kind and registered name:
- items.xml and gfxroot:
- Item id lookup source:
- gfx filename:
- Resolved collectible PNG path:
- Native display surface(s) to verify:
- Economy fields owned elsewhere:
- Behavior fields owned elsewhere:
- Optional/conditional ANM2 or description surfaces:
- Static and in-game verification:
```

Keep the XML entry type aligned with the intended collectible behavior. A valid
PNG does not prove a passive cache effect or active-use callback works; conversely
working Lua does not prove the native pause icon can resolve.

## Validation

Use `isaac-validators` for XML, duplicate-id, and asset-path checks when the
project supports them. Verify in game by acquiring the owned item and opening
ESC; inspect the actual pause icon and other requested native display surfaces.
Do not call a file-existence check proof of correct in-game rendering.
