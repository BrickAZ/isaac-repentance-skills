---
name: isaac-validators
description: Run or extend static validators for Binding of Isaac Repentance mods. Use this whenever the user asks to verify, check, validate, sanity-check, catch broken XML, duplicate ids, missing assets, missing translations, blank cards, blank/meaningless custom entities, broken anm2/png paths, skill package consistency, or whether a coding agent's Isaac mod changes are safe before in-game testing. Supports a generic mod-root runner. 中文触发：检查、静态检查、验证、XML 报错、重复 id、路径丢失、贴图缺失、翻译缺失、空白卡、空白实体、无效实体、anm2 路径、交付前检查。
---

# Isaac Validators

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill after Isaac mod edits, before claiming work is done, and whenever the user reports broken loading, blank cards, missing icons, missing text, or assets that do not show.

The goal is to catch static mistakes early. This does not replace in-game testing, but it should stop many XML/path/id/localization mistakes before Isaac is launched.

## First Move

Before reviewing by eye, run the generic bundled validator from the target mod
root. Replace `<skill-directory>` with the installed skill folder:

```powershell
powershell -ExecutionPolicy Bypass -File <skill-directory>/scripts/validate-isaac-mod.ps1 -Root . -ModObjectName <mod-object-name>

For a custom colored collectible PNG review, add -CheckPngTransparency. It warns about a missing alpha channel, outer matte, or large dense low-luminance region; it does not replace subject-mask, three-background, per-frame, or in-game verification.
```

When the project is unfamiliar, use `isaac-mod-context` first to discover the
root, mod object name, module directories, and language files rather than
guessing command arguments.

If the task is only a handoff prompt, include the applicable command in the
required verification section.

## Validation Profiles

- **Generic runner**: accepts any mod root and optional mod object name; discovers `resources/` and versioned `resources-*` roots unless `-ResourceDirectories` is supplied; parses XML, checks duplicate XML keys and asset paths, scans direct callback registrations in `main.lua` plus `scripts/` by default, accepts additional `-LuaDirectories` when a project uses another module root, and can verify a supplied skill package. A resource-only mod does not need Lua or `content/` to pass.

The generic runner is intentionally conservative. A project-specific overlay
may add checks only after that project establishes a stable convention.

## What The Validator Checks

The first version checks:

- XML files under `content/` and discovered resource roots can be parsed.
- Resource-only layouts are accepted; native-named tables such as resource-root `players.xml` or `costumes2.xml` receive exact-path/load-order warnings rather than a false missing-content failure.
- Unresolved asset references from those broad native tables are summarized per file because they may intentionally fall back to official game resources; the summary still requires target-build and in-game verification.
- Asset references resolve across every discovered resource root, including versioned roots such as `resources-dlc3/`.
- Lua references to ANM2 events are compared with events declared by local ANM2 files. An unbound missing event is a warning; a proven target contract must be reviewed by `isaac-anm2-visuals`.
- High-frequency callbacks that also load/replace spritesheets and uses of `Isaac.GetPlayer(0)` receive conservative runtime/co-op warnings.
- Duplicate `id` and `name` identities inside the same XML file, qualified by discovered discriminator attributes such as `type`, `variant`, `subtype`, and `skinColor` so valid native variants are not collapsed.
- Obvious missing asset paths referenced from XML values ending in `.anm2`, `.png`, `.wav`, `.ogg`, `.mp3`, `.fs`, or `.fsh`.
- When the optional `-CheckPngTransparency` profile is requested, custom collectible `gfx` PNGs are decoded to warn about a missing alpha channel, a uniform opaque corner matte, or a large dense low-luminance rectangle including an inset plate. This is a warning, because intentionally full-frame art must remain a user decision and a generic validator cannot infer the intended subject mask.
- `docs/skills/*/SKILL.md` exists.
- `docs/skills/*/evals/evals.json` parses when present.
- Skills are self-contained: no third-party mod names or absolute local paths appear in their Markdown/JSON instructions.
- Direct callback registrations across Lua modules point at existing handlers and are not duplicated with the same callback/handler/filter tuple when the source uses the supported direct form.

Read `references/static-checks.md` before extending the validator. Read `references/validation-reporting.md` before reporting results to the user.


`-CheckPngTransparency` is a conservative image warning profile, not a proof that arbitrary art is correct. It can catch missing alpha, a uniform opaque outer matte, and a large dense low-luminance rectangle including an inset plate. It cannot infer an author's intended subject mask, decide whether a deliberately dark full-frame object is wrong, or validate ANM2 frame crops without their discovered crop manifest. Pair it with `isaac-anm2-visuals` and the three-background visual review.
## Hard Rules

- Do not call static validation "game verified." Static checks prove only that files are internally plausible.
- Do not fail a confirmed resource-only mod because `main.lua`, `RegisterMod`, or `content/` is absent.
- Do not decide which same-relative-path resource wins across roots or mod load order without runtime/version evidence.
- Treat hot-path asset reload, first-player ownership, broad exact-path override, and unbound ANM2 event results as warnings unless a narrower proven contract justifies failure.
- If a validator failure points at unrelated dirty work, report it separately and do not silently fix it unless the user asked.
- Prefer adding a deterministic validator for repeated mistakes instead of writing the same manual checklist again.
- Keep validators conservative. A false positive that blocks every run will teach future agents to ignore the tool.
- For character hair or head decorations, never require both side edges to contain pixels, impose a high minimum visible-pixel count, or require the silhouette to exceed the vanilla head. Those checks reward filling the crop and are invalid.
- When reviewing whether a proposed validator rule is sound in the abstract, give the conceptual verdict without inventing project-specific TBDs that do not affect that verdict. Crop manifests, alpha thresholds, and paths become active only when the user asks to implement or run the check.
- A project-specific character-art profile may warn about a discovered maximum bounding box, anchor/center drift, abrupt direction/frame size changes, protected-face coverage, dirty alpha, or cross-crop pixels. It must report these separately from the native `1x` visual verdict and must not claim that a passing file is attractive, proportionate, or not a head shell.
- When a validator cannot know Isaac runtime behavior, mark the result as a warning or manual-check item.

## When To Extend

Extend this skill or its script when a mistake repeats:

- Blank or abnormal card generation.
- Missing card HUD/pickup art.
- Missing EID or localization entry.
- `.anm2` references a spritesheet that is absent.
- XML id/name duplicates.
- Challenge rule leaks into normal runs.
- A coding agent forgets to run behavior tests.
- A published skill accidentally requires a source mod from the original author's machine.
- A custom entity, card, or pickup can spawn with no meaningful content because its registration or asset chain is incomplete.
- A generated colored collectible PNG is flattened onto black and renders as an opaque square on its pedestal.

## Final Review

Before saying validation is complete, report:

- Validator command run.
- Pass/fail summary.
- Any failures that belong to the current task.
- Any failures that appear pre-existing or unrelated.
- Manual in-game checks still required.
