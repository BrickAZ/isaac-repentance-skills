---
name: isaac-eid-compat
description: Add, review, or debug optional External Item Descriptions (EID) integration for Binding of Isaac Repentance mods. Use for EID item, trinket, card, pill, character, inline-icon, conditional-description, or language registration. Require discovery of a usable EID global/API first; EID must never be a default mod dependency. 中文触发：EID、道具描述、外置道具描述、EID 图标、EID 兼容、描述注册。
---

# Isaac EID Compatibility

EID is optional presentation integration. Core gameplay, XML localization, and
other description paths must work without it.

## First Move

1. Use `isaac-mod-context` to discover content IDs, real locales, bootstrap,
   existing optional-library guards, and description ownership.
2. Prove the current runtime exposes a usable EID global/API before calling it.
   A folder name, Workshop subscription, or reference-mod example is not proof.
3. Discover the installed API/version when it exists. Do not invent method
   names, inline-icon fields, or language codes.
4. Keep user-provided text, values, icons, and language choices locked; omitted
   presentation decisions stay `TBD`.

## Hard Rules

- Guard every EID registration. Missing EID means skip registration cleanly.
- Do not `require` EID, add it as a mandatory dependency, or make gameplay
  depend on description registration succeeding.
- Register only this mod's discovered IDs and languages; do not overwrite
  vanilla or another mod's descriptions without explicit authorization.
- Keep EID text consistent with actual mechanics. Route XML/base localization
  to `isaac-localization-runtime` and optional descriptions to
  `isaac-compat-descriptions`.
- Test both branches: EID absent causes no error; EID present receives only the
  expected registrations, once each.

## Required Output

```markdown
## EID Compatibility Contract
- Discovered EID proof/version:
- Core behavior without EID:
- Registered content IDs and languages:
- API calls verified from installed docs/code:
- Duplicate/late-load policy:
- Failure/no-EID behavior:
- Tests and in-game checks:
```
