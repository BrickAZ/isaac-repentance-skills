# XML loading, native stats and null effects

## Engine loading comes before Lua capability branches

For per-file loading, path precedence and the Boss Rush-only `content/ambush.xml` contract, read [XML loading](xml-loading.md). Ordinary challenge-room entries in ambush.xml are deprecated and ignored in Repentance.

`content/*.xml` adds supported registrations; `resources/*.xml` overrides original resources/configuration where that surface permits it. Their semantics are not interchangeable. Inspect the actual file type and runtime loader; do not move a whole base XML into content or replace vanilla content to add one custom item.

A Lua guard cannot prevent the engine from parsing XML. **1.1.1** added `content-repentogon` and `resources-repentogon` folders with priority above the corresponding `-dlc3` paths. These are versioned packaging surfaces, not a universal guarantee of a functioning fallback mechanic. Use the approved required/optional dependency plan from compat and validate the actual installed target. See [official changelog](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt), [XML documentation index](https://repentogon.com/xml/items.html) and the project's own loader layout.

## Native stat modifiers: one owner

Since **1.1.0**, collectible, trinket and null entries support:

`tears flattears tearsmult damage flatdamage damagemult shotspeed speed range luck`

Corresponding standard cache flags are automatically supplied. Do not duplicate the same stat bonus in a Lua MC_EVALUATE_CACHE handler. Conditions that native XML cannot express may need MC_EVALUATE_STAT or the project's existing stat system, but give each contribution one owner.

The stage matters:

| Attribute | Where it contributes |
| --- | --- |
| damage | Ordinary damage-up stage, before vanilla diminishing-return calculations; not literal final Damage addition |
| flatdamage | Flat damage stage after that calculation, before most later multipliers |
| tears | Ordinary tears-up calculation, subject to the normal cap |
| flattears | Flat tears stage after the normal cap, before later multipliers |
| damagemult / tearsmult | Native multiplier stage for the respective statistic |

Use `effectdamage`, `effectflatdamage`, `effecttears`, etc. for the item's **TemporaryEffect** rather than held inventory. An active item merely being held does not mean its TemporaryEffect is active. Null items are themselves used through their effects; audit the engine calculation before combining normal and effect-prefixed attributes on a null.

Illustrative entry fragments, using already-registered names/assets:

```xml
<!-- This held collectible owns a native formula-stage damage bonus. -->
<passive name="Example Native Bonus" description="Example" gfx="example.png" damage="1" />
<!-- This active item's temporary effect owns the flat bonus. -->
<active name="Example Temporary Bonus" description="Example" gfx="example_active.png"
        maxcharges="4" effectflatdamage="2" />
```

These sample numbers are demonstrations. The active's use code must apply its effect with the approved duration/stacking policy; do not also assign `player.Damage = player.Damage + 2`. XML validity alone does not prove the effect is applied or the displayed art is correct.

Sources: [tagged items documentation](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/items.md), [EvaluateStats.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/EvaluateStats.cpp). Read the named calculation hooks when formula ordering affects balance rather than claiming all “damage up” is mathematically identical.

## Null item and costume IDs

A null item is an effect carrier, not a pedestal collectible.

```xml
<!-- items.xml fragment; local ID 1 only associates the two registrations. -->
<null id="1" name="Example Timed Null" persistent="true" cooldown="300" />
<!-- costumes2.xml fragment; path is a project asset placeholder. -->
<costume id="1" type="none" anm2path="example_null.anm2" />
```

For association, the null's local id must be at least 1 and match a type="none" costume in the same mod. Resolve the null's **runtime** ID with `Isaac.GetNullItemIdByName("Example Timed Null")`. This is distinct from `Isaac.GetCostumeIdByPath` and from collectible IDs. Never pass local 1 as though it were the generated null ID.

By default a null effect ends when leaving the room. `persistent="true"` permits it to cross rooms; `cooldown` specifies update frames, about 30 per second. A persistent cooldown=300 effect can still expire. Do not describe persistent as automatically permanent or infer every save/rewind guarantee from that one attribute.

Use the player's TemporaryEffects API for add/remove/count/cooldown. The REPENTOGON helper is:
`player:AddNullItemEffect(id, applyCostume=false, cooldown=VanillaCooldown, additive=true)`.
Its cooldown parameter is not the count parameter of `player:GetEffects():AddNullEffect`. The helper extends the existing cooldown when additive=true and resets it when false; negative cooldowns reduce it. The helper dates to **1.0.8**. Verify the intended stacking and costume behavior instead of substituting the APIs by name similarity.

Sources: [items/null reference](https://repentogon.com/xml/items.html), [costumes2 reference](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/costumes.md), [EntityPlayer helper](https://repentogon.com/EntityPlayer.html#addnullitemeffect), [Isaac ID lookup](https://repentogon.com/Isaac.html).

## Revival is a tag plus an implemented transaction

Custom tags are case-insensitive, space-separated tokens in `customtags`.

- `revive`: held copies count toward the extra-life machinery and preserve the run save across death. It **does not revive the player**.
- `reviveeffect`: the corresponding TemporaryEffect supplies that count; for nulls it has the same effect as revive.
- `chancerevive`: adds the question-mark display when paired with a revive tag.
- `hiddenrevive`: suppresses its HUD life count, overriding chancerevive display.

Consume the intended life and revive under one owner; do not leave the grant indefinitely reusable. With a preexisting tagged life, `MC_PRE_TRIGGER_PLAYER_DEATH` runs before vanilla revive checks, while `MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES` runs after them. Both have `function(mod, player)`; returning false cancels death and revives, or a successful direct `player:Revive()` stops later death callbacks. A manual revival with no preexisting tagged extra life risks the engine having already deleted the save. Choose the required precedence; do not invent it.

Illustrative post-vanilla null-life handler, registered after the selected runtime gate:

```lua
local nullID = Isaac.GetNullItemIdByName("Example Stored Life")
mod:AddCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES,
    function(_, player)
        local effects = player:GetEffects()
        if not effects:HasNullEffect(nullID) then return end
        effects:RemoveNullEffect(nullID, 1)
        return false
    end)
```

This assumes the named null is registered with revive and the intended persistence policy. Final health/invulnerability, failed chance, another mod cancelling revival, co-op and special health types need their own approved contract and runtime checks. Do not promise all health types revive to the same “half heart”; later fixes change special cases.

Evidence: [tagged revive documentation/examples](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/items.md), [death/revive callbacks](https://repentogon.com/enums/ModCallbacks.html#mc_pre_trigger_player_death), [native callback source](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/CustomCallbacks.cpp).
