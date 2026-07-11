---
name: isaac-mod-context
description: Discover the actual project context of a Binding of Isaac Repentance mod before applying generic Isaac skills. Use when starting work in an unfamiliar mod, adapting a skill to another project, locating the RegisterMod object, finding Lua module roots, discovering content XML and language variants, or deciding which project-specific profile applies. 中文触发：新 mod、陌生项目、项目结构、mod 对象、RegisterMod、模块目录、语言文件、内容目录、适配 skill、项目上下文。
---

# Isaac Mod Context

Use this skill before a generic Isaac skill assumes a mod object name, module
layout, XML file, language variant, test command, or project-specific profile.
It discovers facts. It does not choose mechanics, balance values, rewards, or
visual direction.

## First Move

From the target mod root, inspect:

1. `main.lua` and any bootstrap/load files for `RegisterMod`, `require`,
   `include`, and callback registration.
2. Existing Lua roots such as `scripts/`, `src/`, `modules/`, or the project's
   own equivalent. Do not assume all behavior belongs in `main.lua`.
3. Existing `content/*.xml` files, including items, pools, pockets, entities,
   challenges, costumes, sounds, music, and shaders only when present.
4. Actual language variants by grouping files such as `items.xml`,
   `items.<locale>.xml`, and matching pool files. Do not assume English and
   Chinese files exist.
5. Declared or observed dependency facts: official API use, project-owned helpers, required libraries, and optional integrations with their guards.
6. Existing test, lint, or validation commands and their supported runtime. For executable tests, discover and record the actual runner path and version; absence from `PATH` alone is not proof that no compatible runner exists.

## Project Context Contract

Before handing work to another skill, output only observed facts:

```markdown
## Isaac Project Context

- Mod root:
- RegisterMod object(s) and source file:
- Bootstrap/load file(s):
- Behavior module root(s):
- Content XML actually present:
- Language variants actually present:
- Dependency classification and evidence:
- Existing test/validation entry points:
- Discovered test runner(s), path(s), and version(s):
- Project-specific profile available:
- Unknown or ambiguous facts:
```

If more than one `RegisterMod` object or module root exists, keep the owner as
`TBD` until the requested content surface identifies it.

## Routes

- Generic static validation: `isaac-validators` with the discovered root,
  mod object name, and Lua directories.
- Project-specific conventions: load that project's profile only after the
  contract confirms the project.
- Content ownership and multi-surface ordering: use the project's router when
  it has one; otherwise start with `isaac-mechanic-contracts` for unclear
  gameplay semantics.
- Module ownership: use `isaac-mod-architecture` when the bootstrap is not
  the behavior owner or a structural change is requested.

## Hard Rules

- Do not invent a `Mod`, `Neverbirth`, `Main`, or other module object name.
- Do not assume `content/`, `scripts/`, a language pair, or a test directory
  exists until inspected.
- When a target project/root is available, inspect it before marking its facts
  `TBD`. “Do not assume” means discover actual paths and names; it does not
  permit skipping discovery. Use `TBD` only for facts still absent or
  ambiguous after the applicable search.
- Do not create a second `RegisterMod` object inside a behavior module.
- Treat Isaac's official API and existing project code as the default. Do not introduce or call a third-party library until the project context identifies it as required or optional.
- Do not treat project discovery as authorization to change design decisions.
- Do not select a project-specific profile merely because its files have a
  similar shape.

## Final Review

Before passing context onward, report what was observed, what remains unknown,
and which later skills may safely rely on the contract.
