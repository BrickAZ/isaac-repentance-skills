# Challenge Review Checklist

Use this before handing off custom challenge work.

## Checklist

- `content/challenges.xml` entry exists and id is unique.
- Lua challenge module exists when runtime rules are needed.
- Lua module is included by the mod's loading entry.
- Challenge id lookup matches the XML/display name.
- All challenge-only callbacks are gated by `Isaac.GetChallenge()`.
- Continued-save behavior is explicit.
- Starting inventory is not duplicated by XML and Lua.
- Item-pool removals are intentional.
- Room/curses/path/endstage rules are documented.
- Spawn replacements cannot loop.
- Tests or manual checks cover challenge start and a normal run non-leak case.

