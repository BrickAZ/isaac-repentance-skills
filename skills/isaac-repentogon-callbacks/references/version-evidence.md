# Version and evidence ledger

Verified against the official **1.1.2g** tag on 2026-09-05. Rolling repentogon.com pages are navigation aids; settle version-sensitive behavior with the matching tag and implementation. Do not infer a feature's earliest version from its presence in current docs.

| Surface | Confirmed feature/fix version |
| --- | --- |
| Damage ExtraSource on PRE/POST | 1.1.2 |
| Broad collectible-added trigger and group-aware innate callbacks/system | 1.1.2 |
| Removed-trigger RemoveFromPlayerForm and wisp boolean extension | 1.1.1; current WispOrInnate covers innate as well |
| Innate collectible GroupKey filter duplicate delivery fix | 1.1.2a |
| New loot PRE arguments and loot POST | 1.1.2d |
| Preview/spawning loot RNG consistency fix | 1.1.2f |
| Eternal Chest repeated payout fix | 1.1.2g |
| MC_PRE_MOD_UNLOAD ShuttingDown argument/earlier shutdown; curse-mask and pre-add replacement propagation | 1.1.0 |
| Damage table chain; MC_POST_MODS_LOADED | Verified in 1.1.2g; original introduction not established by this ledger |

The last row is an evidence limit, not a user decision. If supporting an older runtime, investigate that older tag rather than asking the user to supply an API date or silently claiming the earliest release.

Sources:

- [Official tagged changelog](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt): use the enclosing version heading, not the closest search snippet. XML stats and ShuttingDown occur under 1.1.0; there is no 1.0.13 heading here.
- [Tagged callback docs](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/enums/ModCallbacks.md): exact arguments, filters, named returns.
- [Lua dispatcher](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua): AddPriorityCallback, callback sort, RunEntityTakeDmgCallback, RunPostModsLoadedCallback, _UnloadMod and custom dispatch overrides.
- [Native callback hooks](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/CustomCallbacks.cpp): TriggerCollectibleAdded and Entity_Pickup::GetLootList.
- [LuaLootList.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaLootList.cpp): Lua GetLootList uses ShouldAdvance=false and a null player.
- [Player bindings](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/Entities/LuaEntityPlayer.cpp) and [spoof system](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/ItemSpoofSystem.cpp): GetInnateCollectibleCount and true-item query behavior.

## Documentation conflicts that matter

1. Loot docs' “RNG reset at the end of the callback” means the complete engine hook, after PRE and POST; it is not an independent reset for each mod.
2. Loot PRE prose says before content determination. The tagged hook calls native generation first, then replacement PRE and mutable POST. Do not make side effects depend on the wording.
3. A generic vanilla description of true forcing damage or non-nil stopping dispatch does not describe the tagged damage dispatcher: only false cancels it; true is ignored.
4. Generic CustomCache “starts at zero” and familiar multiplier “void” are not reliable for their special cases; read the content specialist's source-backed cache reference.

Use targeted engine checks for lifecycle and RNG behavior. A source audit proves the binding/algorithm in that tag; it does not prove the user's installed binary, other mods, or in-game outcome.
