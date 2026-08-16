---
name: isaac-audio-render-feedback
description: Add, review, debug, or write handoff prompts for audiovisual feedback in Binding of Isaac Repentance mods. Use this whenever a task mentions sounds.xml, custom SFX, silent or undecodable audio, OGG/WAV routing, SFXManager, music.xml, MusicManager, shaders.xml, MC_GET_SHADER_PARAMS, MC_POST_RENDER, overlays, screen-space rendering, world-space rendering, input blocking, black-screen risk, render layers, or feedback effects that are not just anm2 hookup. Also use isaac-state-lifecycle when feedback has enable/disable state, timers, cached sprites, or input-lock release conditions. 中文触发：音效、无声、音频解码、OGG、WAV、SFXManager、BGM、音乐、MusicManager、shader、滤镜、全屏特效、渲染、屏幕叠层、输入拦截、黑屏、反馈效果。
---

# Isaac Audio Render Feedback

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill for SFX, shader, render, overlay, and input-blocking feedback.

Read `../isaac-mod-context/references/design-authority.md` before suggesting feedback style, intensity, duration, visual direction, or input-lock behavior. Preserve explicit user intent and label proposals as suggestions.

The goal is to keep feedback effects from being wired as the wrong kind of asset. `.anm2` visuals are handled by `isaac-anm2-visuals`; this skill handles the surrounding audio, shader, render timing, screen/world coordinates, and input interception.

## First Move

Before editing or writing a prompt:

1. In an unfamiliar mod, use `isaac-mod-context` to discover XML, asset roots, bootstrap files, and existing feedback routes. Do not assume `content/`, `resources/`, or `main.lua`.
2. Decide whether the request is SFX, music, shader, screen-space render, world-space render, input interception, or a combination.
3. If `.anm2` paths or sprite animation names are involved, also use `isaac-anm2-visuals`.
4. If the feedback belongs to a complex active item, also use `isaac-active-item-mechanics`.
5. If feedback state persists beyond one frame, also use `isaac-state-lifecycle`.
6. Inspect current-project examples before inventing callback names or path conventions.

## Route The Feedback

- **SFX / music**: `content/sounds.xml`, `content/music.xml`, `resources/sfx`, `resources/music`, `SFXManager`, or music manager behavior. Read `references/sfx-music.md`.
- **Shader params**: `content/shaders.xml`, `MC_GET_SHADER_PARAMS`, shader names, enable/disable state, black-screen risk. Read `references/shader-params.md`.
- **Render / overlay**: `MC_POST_RENDER`, player/entity render callbacks, screen-space versus world-space, cached sprites, draw order. Read `references/render-overlay.md`.
- **Input interception**: `MC_INPUT_ACTION`, blocking controls during popups/menus/selection, restoring control safely. Read `references/input-interception.md`.
- **Feedback review**: when reviewing or prompting another agent, read `references/feedback-review-checklist.md`.

## Hard Rules

- Do not use shader changes for a simple sprite flash unless the design really needs a screen/post-process effect.
- Do not create sprites every frame in render callbacks; cache or own them in explicit state.
- Do not mutate core gameplay state in render callbacks unless there is no better callback and the repo already uses that pattern.
- Do not block input without a clear release condition.
- Do not assume shader safety. If a shader can black-screen or obscure gameplay, state fallback and verification.
- Keep screen-space and world-space coordinates distinct.
- For manual `Sprite:Render`, a world-space anchor is not a render coordinate:
  calculate the live owner-relative anchor, convert it with
  `Isaac.WorldToScreen`, then render. If an `ENTITY_EFFECT` owns world
  tracking, verify its `PositionOffset` and `SpriteOffset` separately.
- Require an anchor plan for above-owner visuals: player visual/flying offsets,
  enemy size bands, Boss differences, ANM2 pivot, and in-game checks. A single
  fixed Y offset is not a general solution.
- Register sounds/shaders in XML and verify the referenced asset path exists.
- Keep the playback route aligned with the asset role: a short custom sound uses the discovered `sounds.xml`/SFX registration and `SFXManager`; music uses the discovered `music.xml` registration and `MusicManager`. Do not move a one-shot sound into the music system merely because an OGG decodes there.
- For ordinary Repentance without a project-proven alternate loader, use uncompressed PCM WAV as the high-priority default for custom SFX. Treat OGG or another compressed SFX asset as unverified until the target runtime or an established project example proves that exact `sounds.xml` route; music OGG support is not SFX OGG proof.
- A successful `pcall(SFXManager.Play, ...)`, a no-throw Lua stub, or a recorded call proves only Lua dispatch. It does not prove that Isaac opened, decoded, or audibly played the file. Require the latest game log and an audible in-game trigger check before reporting playback success.

## Self-Contained Fallback

When the current mod has no matching feedback path, use this skill's route
references and review checklist. Keep sound/shader registration, render
lifetime, input release, and in-game fallback explicit without requiring a
third-party mod checkout.

## Handoff Prompt Template

```markdown
## Audio/Render Feedback Spec

- Feedback type:
- Trigger:
- Lifetime:
- SFX/music assets:
- Registration XML, playback manager, and resolved runtime id:
- Container/codec and target-loader evidence:
- Latest game-log load/decode result:
- Audible in-game trigger result:
- Shader name and params:
- Render callback:
- Coordinate space:
- World anchor owner and offset policy:
- World-to-screen or entity-follow route:
- Input interception:
- Related anm2 assets:
- Fallback if optional/unsafe:
- Existing examples to read:
- Required manual verification:
```

## Final Review

Before saying the feedback is complete, report:

- Which feedback routes were used.
- Every XML and asset path touched.
- Callback names used.
- Coordinate space and render owner.
- Input blocking and release condition.
- Shader/SFX behavior that still needs in-game verification.
- For audio, which evidence was static, scripted dispatch, game-log loading/decoding, and audible in-game playback.
