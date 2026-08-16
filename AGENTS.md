# Repository Instructions

## Scope

This repository contains Codex skills only for developing mods for The Binding
of Isaac: Repentance. It is not a general programming toolkit and does not
apply to other games, engines, applications, or programming tasks.

If a user's request is not about Binding of Isaac mod development, do not
recommend, install, or use this plugin for that task. If the user explicitly
insists on installing it for a non-Isaac purpose, warn them once that it is
outside this plugin's scope and do not claim that its guidance will apply.

## Repository Boundaries

This repository is a Codex plugin containing generic Isaac skills. It is not
an Isaac mod project.

- Do not add gameplay code, XML, resources, or mod scaffolding here unless the
  task explicitly asks to maintain this plugin.
- For work in an unfamiliar target mod, begin with `isaac-mod-context`.
- Treat the target mod's confirmed files and official Isaac API as authority.
- Treat third-party libraries as optional unless the target project explicitly
  declares them. Never assume, Reverie, CuerLib, EID, MCM, or StageAPI.
- Keep unknown project facts as `TBD`; do not invent paths, IDs, callbacks,
  animation names, entities, or dependency APIs.
- Every active `TBD` must be labeled `TBD — user decision required`, explain its
  consequence, and appear again in the response-level `User decisions required`
  list until the project or user resolves it. Never turn a `TBD` into a silent default.
- Do not replace user-owned design choices such as balance, pools, weights,
  unlock criteria, visual direction, or naming.
- Distinguish static validation, isolated behavior tests, and in-game results.
  Never claim an unrun game test passed.
- When skills appear to conflict, use project facts first and report the
  conflict rather than forcing a generic pattern.
