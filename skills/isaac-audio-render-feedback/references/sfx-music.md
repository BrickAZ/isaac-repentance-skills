# SFX And Music

Use this when adding or reviewing sounds, music, voiceover, or active-item sound feedback.

## Files

- `content/sounds.xml`
- `content/music.xml`
- `resources/sfx/*.wav`
- `resources/music/*.ogg`

## Hard Rules

- XML id/name and asset path must both be updated.
- Do not call `SFXManager():Play(...)` with an id that is not defined or not already known.
- Do not add music behavior when a one-shot SFX is enough.
- State whether the sound should play on successful use, failed use, cooldown, selection move, confirmation, or cancellation.
- Verify file format and path casing.

## Prompt Checklist

- Sound purpose.
- Trigger callback.
- Asset path.
- XML registration.
- Volume/pitch/loop expectations.
- Failure/cancel feedback.

