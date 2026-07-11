# Temporary UI And Render For Active Items

Use this when an active item draws a panel, charge meter, prompt, selector, or screen overlay.

For pure visual/audio/shader implementation details, also use `isaac-audio-render-feedback`.

## Questions

- Is the visual screen-space or world-space?
- Is it tied to the player position, active slot, HUD, or room center?
- Does it need to render while paused, during menus, or only during gameplay?
- Does it have an `.anm2` asset? If yes, use `isaac-anm2-visuals` for asset hookup.
- Does it require SFX or shader feedback? If yes, use `isaac-audio-render-feedback`.

## Hard Rules

- Do not mutate gameplay state in a render callback unless there is no gameplay callback available.
- Keep sprite creation/cache ownership explicit; avoid creating a new `Sprite()` every frame.
- Name animation names from the actual `.anm2`; do not invent them.
- Report in-game verification needs because render position and scale often need visual checks.

