# Official World Pickup Baselines

Use these as high-priority Repentance defaults only when a task creates or replaces a custom world-pickup visual. These are source-frame sizes for the pickup entity ANM2, not HUD or menu icon sizes.

| World pickup kind | Official source frame | Official atlas |
| --- | --- | --- |
| Heart | 32x32 | `Pickup_001_Heart.png`, 96x192 |
| Coin | 32x16 | `Pickup_002_Coin.png`, 256x128 |
| Key | 16x32 | `Pickup_003_Key.png`, 64x64 |
| Bomb | 32x32 | `Pickup_016_Bomb.png`, 192x256 |
| Chest | 32x32 | `Pickup_005_Chests.png`, 256x256 |
| Pill | 32x32 | `Pickup_007_Pill.png`, 128x256 |
| Battery | 32x32 | `pickup_018_littlebattery.png`, 64x32 |
| Card or rune world pickup | 32x32 | `pickup_017_card.png`, 128x128 |
| Trinket world pickup | 32x32 | The discovered trinket visual route; ordinary official trinket art is 32x32 |
| Collectible pedestal colored art | 32x32 | The discovered `gfxroot + gfx` collectible PNG; pedestal animation has separate altar/shadow layers |

## Decision Gate

1. If the reward spawns an existing official subtype, do not generate new art. Use the official pickup's existing visual route.
2. If the task creates a custom world-pickup visual and the user supplied compatible art, preserve it and discover its ANM2/entity mapping.
3. If no compatible art is supplied, report the matching table row as the recommended source frame.
4. If the user asks to generate the absent art, generate that source frame and integrate it into the discovered pickup ANM2/atlas. Do not create a loose PNG and assume `Isaac.Spawn` will load it.
5. A different size requires an explicit user decision or a project-owned route. Record the mapping and verify the actual world pickup in game.

## Surface Boundaries

- Heart HUD art is 16x16 and is not the 32x32 world-heart pickup.
- A card face is 16x24 and is not the 32x32 world card/rune pickup.
- Collectible colored art is 32x32, but item pedestal altar/shadow layers are separate.
- Trinket pickup, HUD/pocket indicator, costume, and EID icon remain independent surfaces.