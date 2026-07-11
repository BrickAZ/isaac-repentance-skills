# Visual Carrier Decision Reference

Use this before choosing an `.anm2` route. Many failures come from misunderstanding the user's visual intent, not from the `.anm2` file itself.

## Core Distinction

Decide whether the request is asking to change Isaac's body, add a visual near Isaac, spawn a world effect, render screen UI, or embed an icon in text.

Do not treat every phrase like "on Isaac" as a costume. The visual may simply be anchored to the player position.

## Decision Table

| User intent | Carrier | Route |
| --- | --- | --- |
| "Change Isaac's head/body/face/clothes/wings/mask" | Player body costume | `costumes.md` |
| "A thing floats above/follows/rotates around the player" | Lua Sprite anchored to player position | `lua-sprite-effects.md` |
| "A flash, slash, burst, ring, wave, warning, popup, or short feedback" | Timed Lua Sprite effect | `lua-sprite-effects.md` |
| "A meter, counter, keyboard prompt, selection frame, panel, or overlay" | Screen-space UI Sprite | `ui-hud-sprites.md` |
| "An icon inside EID text or transformation text" | EID inline icon | `eid-icons.md` |
| "Looks like a vanilla pickup/collectible/trinket/card but with custom art" | Vanilla template with spritesheet replacement | `vanilla-template-reuse.md` |
| "It has collision, damage, AI, pickup behavior, familiar logic, tear behavior, or variant/subtype" | Registered entity | Entity-registration route, intentionally skipped by this skill |

## Hard Rules

- If it must be part of the player's walking/facing/body animation, use a costume.
- If it follows the player's position but does not need body animation, use a Lua Sprite effect.
- If it has collision, damage, AI, or entity callbacks, do not fake it as a manual Sprite; it needs entity registration.
- If it is fixed to the screen, use UI/HUD.
- If it is shown inside EID text, use EID icon handling.
- If it is visually equivalent to a vanilla object with new art, consider vanilla template reuse before making a new `.anm2`.

## Clarifying Phrases

When writing a prompt for another Codex agent, make the carrier explicit:

- "This is a player costume, not a floating effect."
- "This is a player-anchored visual effect, not a change to Isaac's body."
- "This is a world effect without collision, not an entity."
- "This has gameplay collision, so the visual asset alone is not enough."
- "This is a screen-space HUD sprite, not a room/world sprite."

## Examples

**Head mask that turns with Isaac**

Use `content/costumes2.xml`, a `resources/gfx/characters/*.anm2` costume, and `Isaac.GetCostumeIdByPath`.

**Halo above the player for 30 frames**

Use a Lua Sprite effect. Store the sprite in state, render it at `player.Position + Vector(0, -36)`, and expire it after 30 frames. Do not add it to `costumes2.xml`.

**Slash that damages enemies**

The visual can use `.anm2`, but the mechanic is an entity or collision route. This skill can check asset names and animations, but it should not design the entity behavior.

**EID transformation badge**

Use an EID inline icon, usually a small 16x16 or 24x24 `.anm2` with a known animation frame.
