---
name: isaac-mod-architecture
description: Plan, review, or implement architecture-safe organization for Binding of Isaac Repentance mods. Use this whenever work risks making a bootstrap file too large, duplicating callback logic, adding many items/entities/cards at once, creating shared helpers, moving code into modules, changing load order, creating registries, or deciding where constants, state tables, tests, validators, and content files should live. Use isaac-mod-context first in an unfamiliar project. 中文触发：main.lua 太大、拆文件、拆模块、重构、加载顺序、回调重复、公共函数、注册表、代码放哪里。
---

# Isaac Mod Architecture

Use this skill when the task touches module organization, load order, shared helpers, or repeated patterns across multiple Isaac content types.

The goal is not to redesign the mod for its own sake. The goal is to keep future item/entity/card/challenge work easy to route, test, and debug without breaking current working patterns.

## First Move

Before moving code:

1. In an unfamiliar project, use `isaac-mod-context` to identify bootstrap/load files, module roots, mod objects, and test/validation entry points.
2. Read the discovered bootstrap/load file and identify the current registration pattern.
3. Write down whether that file is a bootstrap, an implementation owner, or both; then locate the actual owner of the behavior being changed.
4. Read the closest existing helper or repeated block.
5. Decide whether the task needs architecture work or only a local implementation.
6. If the implementation stays in a large single Lua entry file, inspect its existing top-level local declarations before adding a feature-local group of helpers or tables.
7. If the change is broad, write a short migration plan and keep it reversible.
8. Use `isaac-testing-debugging` and `isaac-validators` after structural changes.

## Route The Architecture Work

- **Module boundaries**: when to split item/card/entity/challenge code and what each module owns. Read `references/module-boundaries.md`.
- **Callback registration**: shared callback helpers, load order, duplicate callback prevention, per-content registration. Read `references/callback-registration.md`.
- **Shared helpers and constants**: id maps, state helpers, RNG helpers, language helpers, asset helpers. Read `references/shared-helpers.md`.
- **Implementation ownership**: distinguish bootstrap/load files from behavior owners so content skills do not regress into `main.lua`. Read `references/implementation-ownership.md`.
- **Architecture review**: before final answer, read `references/architecture-review-checklist.md`.

## Hard Rules

- Do not refactor unrelated content while implementing one item or card.
- Do not move working code without a verification plan.
- Do not create a new abstraction unless it removes real duplication or matches an existing pattern.
- Preserve existing public names and mod naming quirks unless the user explicitly asks to rename them.
- Keep callback ownership obvious. A future agent should be able to find who registers a callback and why.
- Keep tests close to behavior changes.

## Monolithic Lua Scope Budget

Lua compiles a source chunk with a finite local-variable budget. A large `main.lua` can be structurally valid before a feature adds one more group of top-level `local` helpers and makes the whole mod fail to load.

- Do not add a feature's entire state machine as new chunk-level locals just because the file has no modules.
- For a self-contained feature in a monolithic file, prefer a `do ... end` block so its helper locals are out of scope before later code, or attach only the deliberately public handler to the existing mod/module table.
- Do not invent a numerical "safe local count". Parse or load the full discovered entry file with the closest available compatible Lua runner after the change.
- A unit test that imports only an extracted helper does not cover this failure. At least one regression test must load the real entry file or an equivalent complete chunk.

## Handoff Prompt Template

```markdown
## Architecture Spec

- Current pattern:
- Pain point:
- Proposed boundary:
- Files to move or create:
- Callback/load order:
- Shared helpers:
- Risks:
- Verification:
- Rollback path:
```

## Final Review

Before saying architecture work is complete, report:

- Structural changes made.
- Why each new file/helper exists.
- Load order and callback ownership.
- Tests and validators run.
- Any intentionally deferred cleanup.
