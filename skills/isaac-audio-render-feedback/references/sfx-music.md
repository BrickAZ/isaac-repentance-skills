# SFX And Music

Use this when adding or reviewing sounds, music, voiceover, or active-item sound feedback.

## Typical Ordinary-Repentance Routes

- Short custom SFX: discovered `sounds.xml`, discovered SFX resource root, uncompressed PCM WAV, runtime sound id, and `SFXManager`.
- Music: discovered `music.xml`, discovered music resource root, project-supported music asset such as OGG, runtime music id, and `MusicManager`.

These are high-priority defaults when the project has no established alternative. Discover actual roots and registration names; do not assume literal `content/` or `resources/` paths in an unfamiliar project.

## Format And Playback Contract

- Do not infer that `sounds.xml` can decode an OGG because `music.xml` can decode one. They are different registration and playback pipelines.
- For ordinary Repentance custom SFX, prefer uncompressed PCM WAV unless the target runtime or current project proves another exact SFX container/codec route.
- Preserve a project-proven alternative, including an explicitly declared loader or extender, but record its dependency/version gate and no-dependency behavior. A reference-mod file alone is evidence to inspect, not a new dependency.
- Use `SFXManager` for short effects and `MusicManager` for music. Do not occupy, replace, or interrupt global music merely to play a bark, click, impact, voice line, or other one-shot feedback.
- Pitch/volume variation may reuse one SFX asset through the verified `SFXManager:Play` signature. Do not generate multiple files or guess argument order when one project-proven call is sufficient.
- Do not invent a universal sample rate, channel count, or bit depth. Inspect a current-project known-good SFX or target documentation, then verify the delivered WAV is actually PCM rather than a compressed codec stored in a `.wav` container.

## Proof Boundary

1. Static inspection may prove XML shape, resolved path, file existence, container, and codec metadata.
2. A Lua test or `pcall(SFXManager.Play, ...)` may prove id resolution and that the call path does not throw.
3. The latest game log must show no missing-resource, open, or decode failure for the tested asset.
4. An in-game trigger must be audibly checked at the intended volume, pitch, overlap, and repeated-use behavior.

Do not collapse these four levels into one success claim. In particular, `pcall` success is not decoder or speaker output evidence.

## Conventional Path Examples

- `content/sounds.xml`
- `content/music.xml`
- `resources/sfx/*.wav`
- `resources/music/*.ogg`

## Hard Rules

- XML id/name and asset path must both be updated.
- Do not call `SFXManager():Play(...)` with an id that is not defined or not already known.
- Do not add music behavior when a one-shot SFX is enough.
- State whether the sound should play on successful use, failed use, cooldown, selection move, confirmation, or cancellation.
- Verify file container/codec, extension, resolved path, and path casing.
- Treat silence with a successful Lua call as an asset-loader/decode or routing symptom until the latest log and in-game playback prove otherwise.

## Prompt Checklist

- Sound purpose.
- Trigger callback.
- Asset path.
- XML registration.
- Volume/pitch/loop expectations.
- Failure/cancel feedback.

