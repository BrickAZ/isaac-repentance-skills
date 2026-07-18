---
name: isaac-collectible-registration
description: "Register, review, debug, or write handoff prompts for Binding of Isaac: Repentance collectible metadata and colored icon assets: items.xml active/passive/familiar entries, gfxroot, gfx filenames, collectible PNG discovery, pedestal/collectible display, and blank/missing colored collectible art. Use whenever a custom item has a missing/wrong items.xml gfx image, item pedestal display issue, colored HUD/Extra HUD collectible image issue, or collectible registration mismatch. Route ESC My Stuff, collection-page, and Last Will sketch/death-portrait icons to isaac-anm2-visuals. 中文触发：道具注册、items.xml、gfxroot、gfx、道具彩色图标、道具底座图标、道具空白贴图、收藏品贴图。"
---

# Isaac Collectible Registration

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

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

## Stable Local ID Registration Rule

Every custom collectible registration must declare an explicit, unique, stable
local `id` on its `active`, `passive`, or `familiar` `items.xml` entry. This is
a registration rule for **all** custom collectibles, including a normal colored
`gfxroot + gfx` route; it is not conditional on requesting an ESC portrait.

- Discover the project's existing local-id convention before assigning a value.
- Do not substitute XML order, a temporary ordinal, `Isaac.GetItemIdByName`,
  an `ItemConfig` value, console output, or a current runtime/global number
  such as `733` for the declared local `id`.
- If an existing project has entries without ids, mark their registration
  `blocked`/`TBD` until the user approves an explicit migration table. Preserve
  existing assignments, append new ids only, and never silently sort, renumber,
  or derive ids from the current document order.
- A project-declared custom loader may add a separate visual mapping key, but it
  does not remove the requirement for the collectible entry's declared local
  `id`.


## Native Death Portrait Registration Gate

Apply this additional gate when the user requests a native ESC My Stuff,
collection-page, or Last Will collectible sketch. The universal local-id rule
above already applies to every collectible; this gate only adds the native
portrait mapping work.

1. Discover the exact requested native surface and route it to `isaac-anm2-visuals`.
2. Use the collectible entry's declared, unique, stable local `id` as the
   candidate death-portrait frame key, then inspect the actual ANM2 convention.
3. A project-declared custom loader may add an equally stable mapping key, but
   it cannot replace the required declared local `id`.
4. If the entry lacks its local `id`, the registration and the portrait route
   are both `blocked`/`TBD` pending the user-approved append-only migration.
5. Only after the local key and any loader mapping are approved/discovered may
   the ANM2 frame mapping be edited and verified under another mod load order.

## Discover the Registration Chain

Before changing a collectible, record:

- actual `items.xml` path and root `gfxroot` value;
- entry kind (`active`, `passive`, or `familiar`), registered name, and declared stable local `id`;
- entry `gfx` filename and the resolved colored collectible PNG path;
- existing project naming/casing convention and nearby known-good entry;
- which surface is wrong: colored collectible/pedestal display, Extra HUD, or a
  native death-portrait surface that must route to `isaac-anm2-visuals`.
- for a requested native death portrait: declared stable local id, ANM2 frame convention, declared custom loader key if any, or blocked/migration status.

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

- High-priority default: do not propose a same-name `_mystuff.png` copied from a colored collectible `gfx` PNG. Use the discovered `deathanm2` ANM2, spritesheet, and declared-`items.xml`-local-id-to-frame mapping instead. Any missing declared local id already blocks collectible registration; do not proceed with a death-portrait mapping until the user approves the append-only migration. A runtime `Isaac.GetItemIdByName`/ItemConfig ID is not a death-portrait frame index. A user-requested or project-established alternative is allowed, but record its explicit loader/mapping and require an in-game proof for ESC My Stuff.

## High-Priority Official Colored-Icon Suggestion

- If the user has not supplied a compatible colored collectible image, recommend a 32x32 `gfxroot + gfx` PNG before implementation.
- If the user asks to generate that absent image, generate a 32x32 colored collectible PNG and wire it through the discovered `gfxroot + gfx` route.
- Preserve a user-provided or project-established alternative when its registration path is known; report the mismatch rather than silently resizing or replacing it.
## Registration Contract

```markdown
## Collectible Registration Contract

- Item kind and registered name:
- items.xml and gfxroot:
- Declared stable local id and migration status:
- gfx filename:
- Resolved colored collectible PNG path:
- Colored display surface(s) to verify:
- Death-portrait surface delegated to ANM2, if requested:
- Death-portrait ANM2 frame convention / custom loader / blocked migration status:
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
