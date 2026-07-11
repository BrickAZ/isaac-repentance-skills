# Compatibility Modules

Use this for MCM, Encyclopedia, Boss Bars, StageAPI, CuerLib translation support, or other optional mod integrations.

## Common Surfaces

- MCM: settings pages, labels, toggle state, translation of options and help text.
- Encyclopedia/wiki: item pages, hidden entries, icon conversion from EID text.
- Boss Bars: boss icon and display support.
- StageAPI: stage/boss/room integration.
- CuerLib: helper callbacks, translations, item/pickup/stage helpers.

## Hard Rules

- Keep compatibility code in a clearly named compatibility location when the project already has one.
- Separate config state from gameplay state.
- When using CuerLib helpers, state whether the current project already depends on CuerLib. If it does not, do not make it a hidden requirement.
- Avoid making MCM or wiki support the only place a mechanic is documented.

## Prompt Checklist

- Target compatibility mod.
- Required or optional.
- File to load from.
- Fallback behavior.
- Language coverage.
- Manual in-game check.
