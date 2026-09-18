# Content version and source ledger

Verified against the official **1.1.2g** tag on 2026-09-05. The selected runtime may have stricter project requirements than a feature's first release.

| Feature | Confirmed introduction |
| --- | --- |
| Native XML stats and effect-prefixed stats | 1.1.0 |
| CustomCache core and familiarmultiplier | 1.0.11 |
| maxcoins/maxkeys/maxbombs custom cache | 1.0.12 |
| healthtype/tearscap/statmultiplier custom cache | 1.1.0 |
| CustomTags and revive family support | 1.0.9; inspect later tags for individual newer flags |
| AddNullItemEffect cooldown helper | 1.0.8 |
| content-repentogon/resources-repentogon paths | 1.1.1 |
| Players starting item names | 1.0.5 |
| Players modded trinket names, hideachievement, hurt/death sound | 1.1.0 |
| Players innateitems/innatetrinkets | 1.1.2 |
| Players card names | 1.1.2d |
| PersistentGameData.Unlock | 1.1.2 |
| Null XML/costume association; native custom achievements | Verified in 1.1.2g; original introduction not established here |
| content/ambush.xml Boss Rush-only append; challenge entries deprecated | Scope verified in 1.1.2g; challenge entries were already deprecated in Repentance |

Unestablished historical minimums are technical research work, not a reason to ask a user for an API version or mark it a user-decision TBD. Use the fixed baseline if it already meets the user's request; investigate older source tags when older support is actually needed.

## Source hierarchy and conflicts

1. Read [rolling REPENTOGON XML documentation](https://repentogon.com/xml/items.html) for discovery.
2. Pin the [1.1.2g source tree](https://github.com/TeamREPENTOGON/REPENTOGON/tree/1.1.2g) and [changelog](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt). Read the enclosing version heading: the long stats and ShuttingDown section belongs to 1.1.0, not an invented 1.0.13.
3. Resolve runtime semantics with the implementation and record remaining uncertainty honestly.

Known mismatches:

- Generic custom-cache docs say initial Value is always zero. [CustomCache.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/CustomCache.cpp) provides native defaults for special tags. Preserve the actual incoming Value.
- MC_EVALUATE_FAMILIAR_MULTIPLIER's table says void. [Tagged callback prose](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/enums/ModCallbacks.md) and [Lua dispatcher](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua) specify numeric chaining; the native patch rejects a final nonpositive multiplier.
- Generic death callback prose says “half a heart”. [Release history](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt) includes health-type fixes, including a whole coin-heart revive in 1.1.2. Do not promise a universal health result.
- `persistent` on null XML specifies room retention, not every persistence behavior imaginable. Distinguish it from the named innate-group save/rewind contract.

Implementation evidence map:

- Stat stages and XML contribution ownership: [EvaluateStats.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/EvaluateStats.cpp).
- Cache defaults/triggers/familiar acceptance: [CustomCache.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/CustomCache.cpp).
- Public effect/innate helper bindings: [LuaEntityPlayer.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/Entities/LuaEntityPlayer.cpp).
- Achievement operations: [LuaPersistentGameData.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaPersistentGameData.cpp).
- XML contracts: [items](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/items.md), [costumes](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/costumes.md), [achievements](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/achievements.md), [players](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/players.md).
- Loader precedence and Boss Rush-only ambush merge: [XMLData.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/XMLData.cpp), [ambush.xml documentation](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/ambush.md); see the dedicated XML loading reference.

These source checks establish the tagged contract, not the installed DLL's identity or the user's gameplay outcome. Validate those separately through the dev/testing workflow.
