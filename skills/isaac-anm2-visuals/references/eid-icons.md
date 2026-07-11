# EID Icon ANM2 Reference

Use this for EID inline icons, transformation icons, card/pill icons, item markers, and small text-embedded visuals.

## Files To Check

- `.anm2` icon file.
- PNG spritesheet, usually 16x16, 24x24, or 32x32.
- EID registration code in the discovered bootstrap or compatibility module.
- Tests that stub `EID.InlineIcons` or `EID:addIcon`.

Use a current-project EID icon when one exists. Otherwise use the icon shape,
registration pattern, and checklist below; no third-party asset is required.

## Path Casing

Keep the current project's verified path convention, including case. If its Lua load path and on-disk resource path differ, preserve only a proven working mapping and add or update a path test before changing it.

## Icon ANM2 Shape

Small icons should usually have:

- One spritesheet.
- One layer.
- One animation name, often `Transformation`, `Icon`, or a specific icon group name.
- Width and height matching EID registration.
- A stable frame index if multiple frames are used.

## EID Registration Pattern

Use existing current-project EID support as the local source of truth. A simplified form:

```lua
local iconSprite = Sprite()
iconSprite:Load("gfx/eid/ItemIcon.anm2", true)
iconSprite:Play("Icon", true)

if EID and type(EID.addIcon) == "function" then
    EID:addIcon("modItemIcon", "Icon", 0, 16, 16, 0, 0, iconSprite)
elseif EID and type(EID.InlineIcons) == "table" then
    EID.InlineIcons.modItemIcon = { "Icon", 0, 16, 16, 0, 0, iconSprite }
end
```

Do not register an icon until the sprite loads and the animation name is known.

## Checklist

- Icon dimensions match the PNG crop and EID width/height.
- Animation name exists in the `.anm2`.
- Shortcut key is unique and namespaced.
- Fallback behavior exists when EID is missing.
- Tests verify the EID table entry or `addIcon` call.
- English/Chinese EID text uses the same icon markup when intended.
