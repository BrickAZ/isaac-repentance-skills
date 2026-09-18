# REPENTOGON Development Update — 1.2.0

This release expands the public suite from **49 to 54 skills**. It adds
`isaac-repentogon-dev`, `isaac-repentogon-callbacks`, `isaac-repentogon-content`,
`isaac-repentogon-world` and `isaac-repentogon-ui`, and upgrades
`isaac-repentogon-compat` for required and optional projects.

## What Changes

- The development entry carries accepted runtime intent into project setup,
  requested migration and implementation. Existing optional projects retain
  their policy; a required choice does not need repeated approval.
- Focused contracts cover changed callback returns and damage chains, true-item/
  wisp/innate ownership, loot previews, native XML stats and IDs, custom cache,
  achievements, players, Ambush, room placement, RNG and ImGui.
- The generic router contains six distinct REPENTOGON entries. Relevant ordinary
  skills hand exact extension semantics to the matching specialist while keeping
  their mechanic, resource and ownership responsibilities.
- Shared disclosure now separates technical discovery from actual user choices.
  Missing paths, signatures, owners, builds and test commands are investigated
  by the agent or marked **Unverified — discovery required**. **TBD — user decision
  required** remains for unresolved mechanics, balance, assets, dependency policy
  and persistence semantics.

## Offline Tools And Reproducible Checks

The compat directory supplies a pure release/suffix comparator with lazy
capability checks and a read-only Lua/XML surface inventory. The inventory
recognizes listed extensions, including localized items XML, and filters scan
paths before reading; it remains a heuristic rather than a compatibility gate.
Its symbol list now uses `GetInnateCollectibleCount`.

The supplied regression coverage comprises **49 version-gate assertions**,
**18 inventory tests**, and **16 UI mock checks**. The UI test extracts the actual
factory from its reference document. Link/containment tests explicitly identify
mocked filesystem metadata; they are not a claim that Windows symlinks were
created successfully. Application eval cases accompany all six REPENTOGON skills.

From the repository root, using discovered compatible Python/Lua executables:

```text
powershell -ExecutionPolicy Bypass -File tests/test-skill-repository.ps1 -Python <python-executable>
python -B skills/isaac-repentogon-compat/tests/test_surface_inventory.py
lua skills/isaac-repentogon-compat/tests/test-version-gate.lua
lua skills/isaac-repentogon-ui/tests/test-developer-panel.lua
```

## Evidence Boundary

The bundled REPENTOGON snapshot targets **1.1.2g**, not a universal minimum or
proof of the installed build. Per-feature introduction and later fixes need
separate evidence. Maintainer documentation, the matching source tag, static
checks, pure tests, mocks and actual engine observations remain distinct.

This update does **not** establish in-game acceptance. Native callback dispatch,
XML effects, rooms and waves, achievement persistence, ImGui rendering, HUD
interaction, localization and controller behavior still need target-build game
checks when those surfaces are used. See the [evidence matrix](evidence-matrix.md)
and each specialist's source references for the exact support limits.
