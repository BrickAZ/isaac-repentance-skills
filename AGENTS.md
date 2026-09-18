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
- Discover unknown technical facts such as paths, IDs, callback owners, API
  signatures, builds, and test commands. If evidence remains unavailable, report
  `Unverified — discovery required` with the specific limit; do not invent facts
  or ask the user to choose them. Continue authorized independent work.
- Reserve `TBD — user decision required` for genuinely unresolved user choices.
  Explain their consequences and list them under `User decisions required` in
  responses that depend on them. Stop only mutations that would make that choice;
  accepted decisions remain authorization for routine technical implementation.
- Do not replace user-owned design choices such as balance, pools, weights,
  unlock criteria, visual direction, or naming.
- Distinguish static validation, isolated behavior tests, and in-game results.
  Never claim an unrun game test passed.
- When skills appear to conflict, use project facts first and report the
  conflict rather than forcing a generic pattern.
