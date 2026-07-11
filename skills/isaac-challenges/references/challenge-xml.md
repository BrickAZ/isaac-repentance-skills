# Challenge XML Registration

Use this when adding or reviewing a `content/challenges.xml` entry.

## Common Attributes

- `name`: displayed challenge name.
- `id`: challenge XML id. Keep unique within the mod.
- `startingitems`: comma-separated collectible ids with no spaces.
- `startingtrinkets`: comma-separated trinket ids, usually max 2.
- `startingpill`: pill effect id.
- `startingcard`: card/rune/soul stone id.
- `playertype`: starting player type id.
- `endstage`: last stage of the challenge.
- `roomfilter`: comma-separated room type ids to remove from generation.
- `cursefilter`: curse bitmask to remove.
- `getcurse`: curse bitmask to force.
- `altpath`, `secretpath`, `megasatan`: path/end-boss routing.
- `canshoot`: whether player can shoot.
- `redhp`, `maxhp`, `soulhp`, `blackhp`, `coins`: starting resources.
- `difficulty`: game difficulty.

## Hard Rules

- Read existing challenge ids before choosing a new one.
- Do not use item names in `startingitems`; XML expects numeric ids.
- Keep comma lists free of spaces.
- If XML cannot express a rule, put the rule in a challenge Lua module and gate it.
- If adding multilingual description surfaces, use `isaac-compat-descriptions`.
- If `startingcard` uses a custom card/rune/soul stone, use `isaac-cards-pockets` to verify `pocketitems.xml`, card id, pickup art, and HUD art.

## Review Checklist

- New XML id is unused.
- Name matches Lua challenge id lookup.
- Starting inventory is intentional.
- Endstage and path flags are stated.
- Room/curses filters are explained rather than cargo-culted.
