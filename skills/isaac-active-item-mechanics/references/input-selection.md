# Input And Selection Mechanics

Use this when an active item needs held input, button combos, directional choice, or a temporary option menu.

## Common Routes

- `MC_POST_PLAYER_UPDATE`: good for per-player held state, timers, cooldowns, and gameplay logic.
- `MC_INPUT_ACTION`: good for intercepting a specific action, blocking or redirecting input, or reading action-triggered state.
- `MC_POST_RENDER`: good for drawing the selection UI, but not for mutating core gameplay state unless the repo already does so.

## Hard Rules

- Separate input reading from UI drawing.
- Define keyboard/controller behavior through Isaac button actions, not raw key names, unless the repo already uses raw input.
- If input is blocked, specify exactly which action and when blocking ends.
- Track selection state per player when multiple players can use the item.
- Clear temporary input state on new room, player death, game end, or cancellation when relevant.

## Prompt Checklist

- Button/action names.
- Whether the mechanic uses press, hold, release, or two-step selection.
- Cancellation path.
- Multiplayer behavior.
- Reset callback.

