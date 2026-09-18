# Native achievements and players.xml

## Achievement IDs and authority

Register custom achievements in `content/achievements.xml`. The engine generates their runtime IDs; manually assigned XML IDs are ignored. Supply a stable, unique `name` and resolve it with `Isaac.GetAchievementIdByName(name)`. If name is omitted the text is used, which is a poor stable key for localization-sensitive content. Do not hardcode a generated ID or assume that an item's local ID, achievement ID and character ID coincide.

At an appropriate initialized lifecycle point:

```lua
local achievementID = Isaac.GetAchievementIdByName("Example Achievement")
local persistent = Isaac.GetPersistentGameData()
if not persistent:Unlocked(achievementID) then
    local unlockedNow = persistent:TryUnlock(achievementID, false)
    -- Use unlockedNow only as the result of this attempt.
end
```

Name validity and API readiness must be established by project initialization. This is not permission to access PersistentGameData while arbitrary top-level Lua scripts load. MC_POST_MODS_LOADED establishes Lua-script completion, not universal game/save/menu readiness.

`PersistentGameData:Unlocked(id)` returns boolean. `TryUnlock(id, blockPaperPopup=false)` returns boolean; it can fail when achievements are disabled or the achievement is already unlocked. **Do not silently replace it with Unlock.** `Unlock(id, blockPaperPopup=false)` was added in **1.1.2** as a more forceful operation that bypasses normal disabled-achievement restrictions; use only when that behavior is actually required and authorized.

REPENTOGON persists custom unlocked state natively. Avoid a parallel authoritative mod-save bit that may diverge. Independent progress counters can still have their own save owner. A popup suppression flag is not the same as unlocking eligibility, and `hidden` is a presentation property rather than a custom save mechanism.

Bind unlocks through `achievement="Custom Achievement Name"` on supported item/trinket/player entries. Achievement presentation includes text/name, popup artwork and hidden behavior; inspect the actual assets instead of promising registration alone yields a usable unlock screen.

Sources: [achievements.xml](https://repentogon.com/xml/achievements.html), [tagged achievement docs](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/achievements.md), [PersistentGameData API](https://repentogon.com/PersistentGameData.html), [Isaac name lookup](https://repentogon.com/Isaac.html), [LuaPersistentGameData.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaPersistentGameData.cpp).

## Player extensions and units

Use `content/players.xml` for added characters under the established loader contract. Preserve the project's selection/tainted naming and portrait surfaces; a new XML attribute does not supply missing artwork.

| Attribute/surface | Contract |
| --- | --- |
| items | Comma-separated vanilla IDs or modded item names; text item support dates to 1.0.5 |
| trinket | Modded name support in 1.1.0 |
| innateitems / innatetrinkets | Starting innate grants in 1.1.2; these are not true inventory copies |
| card | Modded card by name in 1.1.2d |
| heartcontainers, redhearts, soulhearts, blackhearts, healthlimit | Half-heart units; black hearts are added after soul hearts rather than replacing them |
| goldenhearts, bonehearts, brokenhearts, rottenhearts | One unit per such heart; bone hearts begin empty |
| eternalheart | 1 gives the eternal-heart state |
| healthtype | HealthType value; test the selected health model and revive behavior |
| speedmodifier, firedelaymodifier, damagemodifier, rangemodifier, shotspeedmodifier, luckmodifier | Offsets relative to Isaac's base values |
| gigabombs | Does not replace ordinary bomb count |
| completionparent | Another character's name; a tainted parent uses the -Tainted- suffix |
| nomarks | Values other than false hide completion marks |
| noshake | true disables the portrait shake behavior |
| achievement | Unlock binding requires the appropriate locked portrait frame and unlockedby visual layer |
| hideachievement | Hide the normal character until unlocked; does not independently control the tainted menu |
| modcostume | Local same-mod costume ID with type=none, remains through Mines chase; mutually exclusive with the vanilla costume attribute |
| hurtsound / deathsound | Numeric ID or sound name; deathsound also affects white-fire interaction |

Modded trinket names, hideachievement, hurtsound and deathsound arrived in **1.1.0**. Do not treat “current docs list the attribute” as a minimum-version check for older deployments. For attributes whose historical introduction is not listed here, the verified baseline is 1.1.2g; investigate older tags if the project requires them.

Character starting innate grants must not be re-added on every init/cache/continue event. Let the engine own XML starting state and inspect the actual innate group system when Lua needs its own grants. If a rule requires a physical item, query true ownership; see the callback specialist.

Validate XML resolution, normal/tainted selection, locked/unlocked assets, first spawn and continue, co-op/subplayers, damage and revive with the chosen health type, and costume retention/removal. Static XML/path checks do not prove any of those in-game behaviors.

Sources: [official players.xml extensions](https://repentogon.com/xml/players.html), [same-tag players documentation](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/players.md), [official release history](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt), [EntityPlayer innate APIs](https://repentogon.com/EntityPlayer.html).
