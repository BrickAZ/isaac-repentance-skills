---
name: isaac-validators
description: Run or extend static validators for Binding of Isaac Repentance mods. Use this whenever the user asks to verify, check, validate, sanity-check, catch broken XML, duplicate ids, missing assets, missing translations, blank cards, blank/meaningless custom entities, broken anm2/png paths, skill package consistency, or whether a coding agent's Isaac mod changes are safe before in-game testing. Supports a generic mod-root runner. 中文触发：检查、静态检查、验证、XML 报错、重复 id、路径丢失、贴图缺失、翻译缺失、空白卡、空白实体、无效实体、anm2 路径、交付前检查。
---

# Isaac Validators

Use this skill after Isaac mod edits, before claiming work is done, and whenever the user reports broken loading, blank cards, missing icons, missing text, or assets that do not show.

The goal is to catch static mistakes early. This does not replace in-game testing, but it should stop many XML/path/id/localization mistakes before Isaac is launched.

## First Move

Before reviewing by eye, run the generic bundled validator from the target mod
root. Replace `<skill-directory>` with the installed skill folder:

```powershell
powershell -ExecutionPolicy Bypass -File <skill-directory>/scripts/validate-isaac-mod.ps1 -Root . -ModObjectName <mod-object-name>
```

When the project is unfamiliar, use `isaac-mod-context` first to discover the
root, mod object name, module directories, and language files rather than
guessing command arguments.

If the task is only a handoff prompt, include the applicable command in the
required verification section.

## Validation Profiles

- **Generic runner**: accepts any mod root and optional mod object name; parses
  XML, checks duplicate XML keys and asset paths, scans direct callback
  registrations in `main.lua` plus `scripts/` by default, accepts additional
  `-LuaDirectories` when a project uses another module root, and can verify a
  supplied skill package.

The generic runner is intentionally conservative. A project-specific overlay
may add checks only after that project establishes a stable convention.

## What The Validator Checks

The first version checks:

- XML files under `content/` can be parsed.
- Duplicate `id` and `name` attributes inside the same XML file.
- Obvious missing asset paths referenced from XML values ending in `.anm2`, `.png`, `.wav`, `.ogg`, `.mp3`, `.fs`, or `.fsh`.
- `docs/skills/*/SKILL.md` exists.
- `docs/skills/*/evals/evals.json` parses when present.
- Skills are self-contained: no third-party mod names or absolute local paths appear in their Markdown/JSON instructions.
- Direct callback registrations across Lua modules point at existing handlers and are not duplicated with the same callback/handler/filter tuple when the source uses the supported direct form.

Read `references/static-checks.md` before extending the validator. Read `references/validation-reporting.md` before reporting results to the user.

## Hard Rules

- Do not call static validation "game verified." Static checks prove only that files are internally plausible.
- If a validator failure points at unrelated dirty work, report it separately and do not silently fix it unless the user asked.
- Prefer adding a deterministic validator for repeated mistakes instead of writing the same manual checklist again.
- Keep validators conservative. A false positive that blocks every run will teach future agents to ignore the tool.
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

## Final Review

Before saying validation is complete, report:

- Validator command run.
- Pass/fail summary.
- Any failures that belong to the current task.
- Any failures that appear pre-existing or unrelated.
- Manual in-game checks still required.
