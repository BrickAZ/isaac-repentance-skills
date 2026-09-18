# Inventory ownership and loot previews

## Inventory is several different surfaces

All handlers begin with the implicit mod argument. These POST callbacks return nothing. Types in the filter column are registration filters.

| Callback | Lua parameters after mod | Filter |
| --- | --- | --- |
| MC_POST_ADD_COLLECTIBLE (1005) | Type, Charge, FirstTime, Slot, VarData, Player | CollectibleType |
| MC_POST_TRIGGER_COLLECTIBLE_ADDED (1053) | Player, Type, FirstTimePickingUp, WispOrInnate | CollectibleType |
| MC_POST_TRIGGER_COLLECTIBLE_REMOVED (1095) | Player, Type, RemoveFromPlayerForm, WispOrInnate | CollectibleType |
| MC_POST_ADD_INNATE_COLLECTIBLE (1054) | Player, Type, GroupKey, Amount, Duration | CollectibleType or GroupKey string |
| MC_POST_REMOVE_INNATE_COLLECTIBLE (1056) | Player, Type, GroupKey, Amount, ExpiredDuration | CollectibleType or GroupKey string |
| MC_POST_ADD_INNATE_TRINKET (1055) | Player, Type, GroupKey, Amount, Duration | TrinketType or GroupKey string |
| MC_POST_REMOVE_INNATE_TRINKET (1057) | Player, Type, GroupKey, Amount, ExpiredDuration | TrinketType or GroupKey string |

Added/removed trigger surfaces include item wisps and innate items. `WispOrInnate` distinguishes those from real items but does not distinguish wisp from innate. FirstTime is not proof of a natural pedestal pickup, and a true-item count is not provenance either. Item wisps refer to collectible-granting wisps; do not classify every Book of Virtues familiar as one.

A real AddCollectible can cause both the broad trigger callback and MC_POST_ADD_COLLECTIBLE. Choose one settlement owner, or deduplicate based on a proven transaction. Removal, reroll, expiry and re-add events need corresponding teardown. See [trigger implementation](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/CustomCallbacks.cpp) and [callback signatures](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/enums/ModCallbacks.md).

## True items and innate groups

1.1.2g APIs:

```lua
player:HasCollectible(id, ignoreModifiers, ignoreSpoof)
player:GetCollectibleNum(id, onlyCountTrueItems, ignoreSpoof)
player:GetInnateCollectibleCount(id, groupKey)
player:AddInnateCollectible(id, amount, groupKey, duration, addCostume)
player:RemoveInnateCollectible(id, amount, groupKey)
```

Defaults: HasCollectible booleans false; GetCollectibleNum booleans false; Count GroupKey=""; Add Amount=1, GroupKey="", Duration=-1, AddCostume=true; Remove Amount=1, GroupKey="". Remove returns the removed count. Matching innate trinket Add/Remove/Count APIs also exist.

For a true held-item rule, use `player:GetCollectibleNum(id, true, true)` or `player:HasCollectible(id, true, true)`. This excludes modifiers and spoof/innate effects in this target. `GetInnateCollectibleCount(id, groupKey)` counts that group, not all groups. **GetInnateCollectibleNum is not an API in 1.1.2g**; do not generate it.

The 1.1.2 group-aware system persists nonempty GroupKey grants through quit/continue and Glowing Hourglass. Use a stable, namespaced key for the mechanic's owner; use RemoveInnateCollectible to remove that group's grants. Do not add another copy on every continue or cache evaluation. Empty/default group semantics are not interchangeable with the persistent named-group contract. Explicitly decide whether a starting innate grant or another mod's grant counts for the requested rule.

Proof: [EntityPlayer documentation](https://repentogon.com/EntityPlayer.html), [1.1.2g player Lua bindings](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/Entities/LuaEntityPlayer.cpp), [ItemSpoofSystem.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/ItemSpoofSystem.cpp). The binding registers GetInnateCollectibleCount, not the invented Num variant.

## Loot generation and previews

Exact handlers; neither callback supports a registration filter:

- MC_PRE_PICKUP_GET_LOOT_LIST (1334): `function(mod, pickup, shouldAdvance, rng, player)`. Return a **LootList userdata** for full replacement; nil preserves the current result. A Lua array is not LootList.
- MC_POST_PICKUP_GET_LOOT_LIST (1336): `function(mod, pickup, lootList, shouldAdvance, rng, player)`. Mutate the supplied list for an addition/change; return nothing.
- Player can be nil, including the Lua `pickup:GetLootList()` path. Apply variant/subtype conditions inside the callback.
- ShouldAdvance=false denotes inspection such as Guppy's Eye. Still calculate the same loot, using the supplied RNG. Do not grant rewards, consume inventory, advance a separate RNG, increment a persistent counter, or spawn entities during preview.
- At 1.1.2g the engine snapshots DropRNG before native generation and restores it **after the whole PRE plus POST dispatch** on preview. Individual mod callbacks do not each get a fresh RNG. Earlier callbacks can consume it before later callbacks.
- The PRE name/docs say “before”, but the hook first obtains the native list, then calls PRE for replacement, then POST for mutation. Rely on the return/mutation contract, not an assumption that native generation has not run.
- `pickup:GetLootList()` is a preview query; changing its returned list is not a registration of future loot. Avoid recursively calling it inside these callbacks.

`LootList()` constructs a list. `list:PushEntry(Type, Variant, SubType, Seed, RNG)` appends an entry; Seed defaults to Random(), RNG defaults to nil. Supply a seed from the provided RNG when deterministic entries are needed. `list:GetEntries()` exposes entries for inspection.

Illustrative rule: append a penny to ordinary chests on both preview and actual opening. This example's reward is illustrative, not a selected project balance value.

```lua
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_GET_LOOT_LIST,
    function(_, pickup, loot, shouldAdvance, rng, player)
        if pickup.Variant ~= PickupVariant.PICKUP_CHEST then return end
        loot:PushEntry(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            CoinSubType.COIN_PENNY,
            rng:Next()
        )
        -- No spawn, inventory write, counter increment, or POST return.
    end)
```

ShouldAdvance=false must not skip the list modification, otherwise Guppy's Eye omits the reward. If eligibility needs a player, define a consistent nil-player rule and obtain owner evidence without silently treating nil as player 1.

Use **1.1.2g** as the tested target: the new args and POST arrived in 1.1.2d, preview/spawn RNG consistency was repaired in 1.1.2f, and Eternal Chest repeat payouts were repaired in 1.1.2g. Validate repeated previews then opening, no-preview opening with the same initial seed, another loot-modifying mod, nil player, and repeated chest payouts.

Evidence: [loot callback docs](https://repentogon.com/enums/ModCallbacks.html#mc_pre_pickup_get_loot_list), [GetLootList native hook](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/CustomCallbacks.cpp), [LuaLootList.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaLootList.cpp), [LootList API](https://repentogon.com/LootList.html), [EntityPickup API](https://repentogon.com/EntityPickup.html).
