# Mod Config Menu Integration

Use this only after project discovery finds `ModConfigMenu` or the user asks for
optional MCM support. It is not an Isaac official API and must not become a
required dependency by accident.

## Documented Registration Shape

The Mod Config Menu README documents:

```lua
ModConfigMenu.AddSetting(categoryName, subcategoryName, settingTable)
```

For a boolean setting, use the documented fields that apply:

```lua
{
  Type = ModConfigMenu.OptionType.BOOLEAN,
  Attribute = "stable-setting-key",
  Default = approvedDefault,
  CurrentSetting = function() end,
  Display = function() end,
  OnChange = function(value) end,
  Info = { "help text" },
}
```

Do not invent `Name`, `DisplayNameZhCn`, or another field merely because a test
stub accepts it. The README does not establish a per-locale title API. Put
verified bilingual help text in a supported surface such as `Info`; treat an
actual localized title as `TBD` until the installed MCM version proves it.

## Safe Optional Load Order

1. Guard both `ModConfigMenu` and `AddSetting`.
2. Do not register twice. Make a successful registration idempotent.
3. If the project has an existing optional-library retry convention, reuse it
   so an API that appears after the initial Lua chunk can register once later.
4. A missing or incompatible MCM must leave the core setting backed by its
   approved saved/default value.
5. Test absent, present-at-load, late-available, and repeated-update cases.
