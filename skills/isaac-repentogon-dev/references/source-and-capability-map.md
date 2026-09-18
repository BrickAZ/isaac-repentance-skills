# Source and Capability Map

Reference 1.1.2g; checked 2026-09-05. Selected research index, not exhaustive API
coverage. Unlisted API means research needed, not unavailable.

## Primary Sources

- [Official docs](https://repentogon.com/docs.html)
- [Install/launcher](https://repentogon.com/install.html)
- [Releases](https://github.com/TeamREPENTOGON/REPENTOGON/releases)
- [Pinned changelog](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt)
- [Lua wrappers/dispatcher](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua)
- [Lua interfaces](https://github.com/TeamREPENTOGON/REPENTOGON/tree/1.1.2g/repentogon/LuaInterfaces)
- [Pinned docs](https://github.com/TeamREPENTOGON/REPENTOGON/tree/1.1.2g/docs/docs)

Translations aid reading; verify API names, warnings and version boundaries
against original and matching implementation. Shipped docs can also contain errors.

## Established Version Boundaries

| Feature | Evidence-backed boundary |
| --- | --- |
| XML stats; ShuttingDown unload argument; healthtype/tearscap/statmultiplier | 1.1.0, pinned changelog |
| Damage ExtraSource; trigger added incl wisp/innate | 1.1.2, pinned changelog and callback references |
| Innate GroupKey filter duplicate callback fix | 1.1.2a |
| POST loot and PRE RNG/Player parameters | 1.1.2d |
| Loot preview/actual RNG consistency fix | 1.1.2f |
| Eternal Chest loot duplication fix | 1.1.2g |
| players.xml innate starting items/trinkets | 1.1.2 |
| players.xml card by mod name | 1.1.2d |
| Other documented surfaces | Verified against 1.1.2g; older introduction not established here |

Use a feature's required fixes as well as introduction. Do not invent older
minimum versions or promote the reference release into every project's minimum.
Focused references link exact docs/source for each row.

## Further Extension Areas

| Need | Official starting point | Companion |
| --- | --- | --- |
| Entity/player config | [EntityConfig](https://repentogon.com/EntityConfig.html), [XMLData](https://repentogon.com/XMLData.html) | entities, players-characters |
| Boss pools and generation | [BossPoolManager](https://repentogon.com/BossPoolManager.html), [LevelGenerator](https://repentogon.com/LevelGenerator.html) | npc-boss-ai, rooms-stages |
| Sprites/rendering/shaders | [Sprite](https://repentogon.com/Sprite.html), [Renderer](https://repentogon.com/Renderer.html) | anm2-visuals, audio-render-feedback |
| Main menus | [MenuManager](https://repentogon.com/MenuManager.html) | hud-ui-state |
| Item/economy | [ItemPool](https://repentogon.com/ItemPool.html) | economy, shops-deals-pricing |
| Debug/performance | [Debugging](https://repentogon.com/changes/Debugging.html) | testing-debugging, performance-hotpaths |

Links locate research, not pre-validated signatures. Read binding/wrapper/call site
for the needed method, return/nullability, ownership and version. Distinguish
source-derived behavior from observed engine tests.
