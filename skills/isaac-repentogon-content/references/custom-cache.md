# Custom cache: declarations, defaults and triggers

Use a namespaced lowercase tag such as `examplemod_power` to avoid accidental shared ownership. Item XML `customcache="examplemod_power tearscap"` declares a space-separated list on collectibles, trinkets or nulls. A declaration establishes recalculation triggers, not the mechanic's value.

Actual Lua handler for MC_EVALUATE_CUSTOM_CACHE (1224):
`function(mod, player, customCacheTag, value)`, optional registration filter string tag, numeric return. Return nil for no contribution or a number to replace the value passed to later callbacks. An additive contribution should use the incoming value; do not reset every other mod's result to zero.

```lua
local tag = "examplemod_power"
mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE,
    function(_, player, evaluatedTag, currentValue)
        return currentValue + ComputeApprovedContribution(player)
    end,
    tag
)
-- When the contribution's independent source state changes:
player:AddCustomCacheTag(tag, true)
-- To consume the last evaluation:
local power = player:GetCustomCacheValue(tag)
```

ComputeApprovedContribution is a pure project function, not an engine API; it must not recursively reevaluate the same tag. Do not grant effects or increment state in evaluation.

`player:AddCustomCacheTag(stringOrTableOfStrings, evaluateImmediately=false)` queues tags or evaluates immediately when true. Queued tags are processed with an ensuing item/cache evaluation. Collectible/item-wisp changes can evaluate immediately; trinket and TemporaryEffect changes can wait until the next player update. Avoid assuming every POST inventory callback can already observe the final cache value.

Declared tags are automatically evaluated when relevant items/effects are added or removed, and XML-known tags participate in CACHE_ALL. A tag used only through Lua can be manually evaluated but is not automatically included in every CACHE_ALL as though it had an XML declaration. CustomCache is derived state; do not create a second authoritative saved value.

## Special native tags do not all start at zero

The tagged implementation's GetDefaultCustomCacheValue overrides the generic default:

| Tag | Initial value and special behavior in 1.1.2g |
| --- | --- |
| custom, non-special tag | 0 |
| maxcoins | 99, or 999 when Deep Pockets is present; global cap, callback only on player 1 |
| maxkeys / maxbombs | 99; global cap, callback only on player 1 |
| healthtype | Native player HealthType, not a generic numerical zero |
| tearscap | 5; a changed result requests CACHE_FIREDELAY |
| statmultiplier | 1 plus Cracked Crown contribution, then Tainted Bethany adjustment; a changed result reevaluates damage, fire delay, shot speed, range and speed |
| familiarmultiplier | Special invalidation path; does not invoke MC_EVALUATE_CUSTOM_CACHE |

Never use “always 0” from the generic callback prose to replace the native tears cap, resource caps or health type. Preserve incoming native defaults and earlier mod contributions as the design requires. Statmultiplier is the vanilla item-stat modifier mechanism, not a blanket multiplication of all fields including luck.

For familiarmultiplier, evaluation is lazy when a familiar's multiplier is queried. Use MC_EVALUATE_FAMILIAR_MULTIPLIER (1225):
`function(mod, familiar, multiplier, player)`, filter FamiliarVariant, return a **number**. BFFS/Hive Mind are already incorporated into the incoming multiplier. The tagged callback table erroneously says void; its explanatory body and Lua dispatcher accept numeric chaining. The native patch only accepts a final value greater than zero, so returning zero is not a supported way to disable a familiar.

For a conditional contribution, preserve the incoming value and do not multiply the BFFS bonus a second time. Evaluate only on relevant source changes, not every render frame. Test normal tags, native tags, CACHE_ALL, effect removal/expiry, and two mods contributing to the same tag.

Primary evidence:

- [Official items/customcache documentation](https://repentogon.com/xml/items.html#customcache): XML declaration and triggers.
- [CustomCache.cpp at 1.1.2g](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/CustomCache.cpp): GetDefaultCustomCacheValue, EvaluateCustomCache, EvaluateFamiliars and invalidation paths; authority for special defaults and timings.
- [main_ex.lua](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua): RunAdditiveThirdArgCallback for custom cache and RunAdditiveSecondArgCallback for familiar multipliers.
- [Callback documentation at the same tag](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/enums/ModCallbacks.md): compare the familiar return table with its body.
- [CustomCacheTag enum](https://repentogon.com/enums/CustomCacheTag.html) and [player API](https://repentogon.com/EntityPlayer.html): names and public methods.
