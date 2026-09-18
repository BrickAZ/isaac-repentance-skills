---
name: isaac-eid-compat
description: Add, review, or debug optional External Item Descriptions (EID) integration for Binding of Isaac Repentance mods. Use for EID item, trinket, card, pill, character, inline-icon, conditional-description, or language registration. Require discovery of a usable EID global/API first; EID must never be a default mod dependency. 中文触发：EID、道具描述、外置道具描述、EID 图标、EID 兼容、描述注册。
---

# Isaac EID Compatibility

## TBD Disclosure Contract

A `TBD` is a genuinely unresolved user design choice. Missing paths, API
signatures, callback owners, build identities, and tool commands are technical
facts: discover them, or report **Unverified — discovery required** with the
specific evidence gap. Do not turn research work into a request for user permission.
Existing project decisions and explicit standing user preferences remain binding.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Preserve user-owned balance, mechanics, assets, dependency policy, and persistence semantics; resolve routine technical implementation choices within the authorized scope.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` for the shared user-decision and technical-discovery policy.

EID is optional presentation integration. Core gameplay, XML localization, and
other description paths must work without it.

## First Move

1. Use `isaac-mod-context` to discover content IDs, real locales, bootstrap,
   existing optional-library guards, and description ownership.
2. Prove the current runtime exposes a usable EID global/API before calling it.
   A folder name, Workshop subscription, or reference-mod example is not proof.
3. Discover the installed API/version when it exists. Prefer the active runtime
   object and installed source for exact signatures; package metadata alone may
   be stale. Do not invent method names, inline-icon fields, or language codes.
4. Keep user-provided text, values, icons, and language choices locked; omitted
   presentation decisions stay `TBD`.

## Hard Rules

- Guard every EID registration. Missing EID means skip registration cleanly.
- Treat EID's own bootstrap, global interception, caches, and internal module
  loading as library implementation details. A content mod must not copy EID's
  internal `RegisterMod` override or mutate EID globals to register descriptions.
- Do not `require` EID, add it as a mandatory dependency, or make gameplay
  depend on description registration succeeding.
- Register only this mod's discovered IDs and languages; do not overwrite
  vanilla or another mod's descriptions without explicit authorization.
- Keep EID text consistent with actual mechanics. Route XML/base localization
  to `isaac-localization-runtime` and optional descriptions to
  `isaac-compat-descriptions`.
- Test both branches: EID absent causes no error; EID present receives only the
  expected registrations, once each.

## Bundled Offline Reference

Read `references/eid-api-contract.md` before choosing an EID registration or
late-load strategy. It records maintainer-documented common calls and their
guard boundaries, but the installed EID build remains authoritative.
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
