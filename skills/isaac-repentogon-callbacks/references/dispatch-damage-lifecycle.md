# Dispatch, damage and lifecycle

All signatures below show the actual Lua handler, including `mod`. The fixed target is REPENTOGON 1.1.2g. The [tagged Lua dispatcher](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua) is the authority for return propagation; the [callback reference](https://repentogon.com/enums/ModCallbacks.html) is a convenient rolling index.

## Registration and ordering

`mod:AddCallback(callbackID, fn, filter)` uses priority 0. `mod:AddPriorityCallback(callbackID, priority, fn, filter)` accepts a numeric priority. Smaller values execute earlier; equal values use registration order. The standard constants are IMPORTANT=-200, EARLY=-100, DEFAULT=0, LATE=100. A LATE callback can still have later callbacks after it, and cannot observe an event already cancelled earlier. See [ModReference](https://wofsauge.github.io/IsaacDocs/rep/ModReference.html#addprioritycallback) and [CallbackPriority](https://wofsauge.github.io/IsaacDocs/rep/enums/CallbackPriority.html).

A function passed to AddCallback receives the registered mod as argument one, including when defined outside a colon method. Thus `function(_, player)` and `function mod:Handler(player)` both reserve that position. The filter is not automatically appended to callback arguments. Unsupported filters may suppress delivery; omit them unless documented.

Most callback dispatch uses the first non-nil return, but named overrides have different algorithms. Never generalize that rule to all callbacks. Examples in this target:

| Callback | Changed chain rule |
| --- | --- |
| MC_ENTITY_TAKE_DMG | false cancels immediately; valid table fields update later calls; true is ignored |
| MC_POST_CURSE_EVAL | returned curse mask becomes the next callback's input |
| MC_PRE_ADD_COLLECTIBLE | a returned replacement collectible ID is passed to later callbacks |
| MC_POST_PICKUP_SELECTION | replacement table's third positional field controls continuation; inspect this special dispatcher before returning |
| MC_EVALUATE_CUSTOM_CACHE | returned numeric value becomes the next evaluator's input |

For MC_POST_PICKUP_SELECTION specifically, the tuple is `{Variant, SubType, Continue}`; `Continue=true` propagates the changed selection, whereas an ordinary valid replacement stops this chain. This is unrelated to damage's table keys.

## Damage

Actual handler:
`function(mod, entity, damage, damageFlags, source, damageCountdown, extraSource)`.

- MC_ENTITY_TAKE_DMG (11): registration filter EntityType; return nil, false, or a supported modification table.
- MC_POST_ENTITY_TAKE_DMG (1006): same arguments and filter; observational, return nothing.
- `source` is EntityRef. The optional/nullable `extraSource` EntityRef was added in **1.1.2**. It identifies certain originating lasers, melee knife hitboxes, Gello and Brimstone Balls where Source resolves to their player parent. Guard the ref and its Entity; it is not guaranteed for every hit.
- Modification keys are `Damage` (number), `DamageFlags` (integer), and `DamageCountdown` (number). Omitted fields retain the incoming values. Keys are case-sensitive; Source and ExtraSource are not supported replacement fields.
- Each valid table contribution updates the arguments seen by subsequent handlers. Returning false stops the chain and cancels the damage, including earlier modifications. Returning true does not force damage and does not stop this chain.
- POST is not a contractual promise of a positive hit-point delta. Check the feature's own requirements for fake damage, shields, invulnerability, health types and multi-segment entities.

Illustrative additive modifier; runtime capability gate and the approved multiplier belong to the caller:

```lua
local function AdjustDamage(_, entity, damage, flags, source, countdown, extraSource)
    if not ShouldModifyThisHit(entity, flags, source, extraSource) then
        return nil
    end
    return { Damage = damage * approvedMultiplier }
end
mod:AddPriorityCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    CallbackPriority.DEFAULT,
    AdjustDamage,
    EntityType.ENTITY_PLAYER
)
```

`ShouldModifyThisHit` and `approvedMultiplier` are explicit project-supplied placeholders, not REPENTOGON APIs. Do not recursively call TakeDamage and cancel the original to implement this adjustment. Test two modifiers, an earlier/later false canceller, and a true-returning callback; verify the incoming amount is respected.

## Load/unload

`MC_POST_MODS_LOADED` (1210): `function(mod)`, no filter, void. It runs after mod Lua scripts initialize, making it suitable for deferred cross-mod registration. It does not establish that run objects, menu subsystems or PersistentGameData are ready; use each API's own lifecycle and the feature's initialization contract.

`MC_PRE_MOD_UNLOAD` (73): `function(mod, unloadedMod, shuttingDown)`, no filter, void. The boolean and earlier shutdown timing are **1.1.0** changes. This can be delivered for other mods. Compare the unloaded mod before your cleanup. On normal unloading, the dispatcher removes that mod's callbacks after this event. A game shutdown remains a poor time to create new game entities or perform work needing already-torn-down systems.

```lua
local installed = false
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function(_)
    if installed then return end
    RegisterProjectIntegrations()
    installed = true
end)
mod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, function(_, unloadedMod, shuttingDown)
    if unloadedMod ~= mod then return end
    ReleaseProjectIntegrations(shuttingDown)
    installed = false
end)
```

The two project helper functions must own reversible registrations and cleanup; they are not engine APIs. Do not treat unloading as a replacement for normal run-save logic. Evidence: [tagged callback documentation](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/enums/ModCallbacks.md), [main_ex.lua](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua), [native callback hooks](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/CustomCallbacks.cpp).
