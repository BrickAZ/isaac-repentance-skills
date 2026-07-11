# Lua Gate And Loading

Use this when a challenge has Lua behavior.

## Challenge Id Lookup

Common patterns:

```lua
local Challenge = {}
Challenge.Id = Isaac.GetChallengeIdByName("Challenge Name")
```

or a repo helper:

```lua
local Challenge = ModChallenge("Challenge Name", "DATA_KEY")
```

Follow the current repo's style.

## Hard Rules

- Every challenge callback must start with an `Isaac.GetChallenge()` guard or call a helper that enforces the same guard.
- Do not run challenge setup on continued saves unless the design requires it.
- Add the script to the mod's loading entry: `main.lua`, `scripts/contents.lua`, or the current registry.
- Return the module if the repo's include pattern expects it.
- Do not make a challenge global unless the repo already does that.

## Callback Patterns

- `MC_POST_GAME_STARTED`: first-run setup and continued-save decisions.
- `MC_POST_PLAYER_INIT`: starting player health/pocket setup that must happen at player init.
- `MC_POST_UPDATE` or `MC_POST_PEFFECT_UPDATE`: ongoing challenge rule.
- `MC_PRE_GAME_EXIT`: cleanup or reset local cooldowns.

## Review Checklist

- Challenge id is resolved by name or helper.
- Load entry exists.
- All callbacks are gated.
- Continued-save behavior is explicit.
- Local state resets safely.

