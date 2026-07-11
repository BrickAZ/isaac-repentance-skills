# Costume ANM2 Reference

Use this when the visual should attach to the player as a costume, overlay, mask, headpiece, body layer, wing, or persistent appearance.

## When To Use

Use a costume route when:

- The visual belongs on the player body/head.
- It should follow player animation automatically.
- It is tied to an item, form, state, or temporary transformation.
- Lua should add/remove the visual by costume id rather than manually rendering every frame.

Do not use this route for free-floating effects, screen UI, EID icons, or registered entities.

## Files To Check

- `content/costumes2.xml`
- `resources/gfx/characters/*.anm2`
- `resources/gfx/characters/*.png`
- `main.lua` for `Isaac.GetCostumeIdByPath(...)`
- Behavior tests that stub `GetCostumeIdByPath`

Use the current project's `content/costumes2.xml` and a working local costume
as the source of truth. If neither exists, follow the XML and Lua contracts in
this reference rather than requiring a third-party mod checkout.

## XML Pattern

The repo uses:

```xml
<costumes anm2root="gfx/characters/" version="1">
  <costume
    id="17493"
    anm2path="costume_strong_laxative.anm2"
    type="none"
    priority="98"
  />
</costumes>
```

Keep `anm2path` relative to `anm2root`.

## Lua Pattern

Use the exact resource path:

```lua
local COSTUME_PATH = "gfx/characters/costume_item_name.anm2"

local function GetItemNameCostumeId()
    if Isaac and Isaac.GetCostumeIdByPath then
        return Isaac.GetCostumeIdByPath(COSTUME_PATH)
    end
    return nil
end
```

Then add/remove by id using the local pattern already present in the item implementation.

## ANM2 Shape

Costume `.anm2` files usually contain animation names like:

- `HeadDown`
- `HeadRight`
- `HeadUp`
- `HeadLeft`
- body or flying variants when the costume requires them

Do not invent `Idle` for a player costume unless the existing costume file actually uses it.

## Checklist

- The `.anm2` lives under the same root that XML and Lua expect.
- `content/costumes2.xml` references the file if XML registration is needed.
- Lua path uses the full `gfx/characters/...` path.
- `type`, `priority`, `isFlying`, and skin color flags are intentional.
- The item removes temporary costumes when the state ends.
- Tests cover add/remove calls or at least costume path lookup.
