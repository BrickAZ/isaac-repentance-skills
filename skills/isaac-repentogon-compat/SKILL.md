---
name: isaac-repentogon-compat
description: Add, review, or debug third-party REPENTOGON integration for Binding of Isaac Repentance+ mods. Use for REPENTOGON-only callbacks, Lua API extensions, XML extensions, version guards, custom tags, performance features, or compatibility with REPENTOGON's Lua 5.4 runtime. Require explicit project intent plus a usable REPENTOGON global and version proof; never assume REPENTOGON exists. 中文触发：忏悔龙、Repentogon、REPENTOGON、扩展 API、扩展回调、Repentogon XML、Lua 5.4、版本检查。
---

# Isaac REPENTOGON Compatibility

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

REPENTOGON is a third-party script extender. The target project may declare it
as a required dependency or use it as an optional enhancement; undeclared means
optional. Treat every callback, global, XML attribute, and runtime behavior as
unavailable until project intent and the actual runtime prove support.

## First Move

1. Use `isaac-mod-context` to discover the project's declared target game,
   dependency policy, bootstrap, Lua compatibility expectations, and tests.
2. Classify the dependency mode from project declarations or an explicit user
   decision: **required**, **optional enhancement**, or **undeclared**. Keep the
   core mechanic on official APIs for optional/undeclared use; do not invent an
   allegedly equivalent vanilla fallback after the project chooses required.
3. Verify a usable global, the installed version, and the exact extension
   surface. Use discovered documentation; never compare guessed version strings
   or assume the newest website matches the player's build.
4. Classify the feature: extended callback, Lua API, XML attribute, custom tag,
   performance enhancement, or runtime-only convenience. Then read the exact
   installed documentation for that surface.

## Dependency And Capability Contract

- **Required + absent/insufficient**: stop this mod's initialization before any
  extension-only callback, registry, XML-dependent mutation, or partial gameplay
  state is installed. Report the missing dependency/minimum version clearly.
  Do not continue under a behaviorally different fallback and call it equivalent.
- **Optional/undeclared + absent**: do not evaluate REPENTOGON symbols. Run the
  official implementation or explicitly omit only the optional enhancement
  without a crash, softlock, or malformed XML path.
- **Optional + present but insufficient**: do not call the newer API. Use a
  separately proven earlier route or omit the enhancement and report the
  unsupported surface.
- **Present and sufficient**: use only the discovered API signature, callback
  return contract, XML spelling, lifecycle behavior, and ready timing.
- Presence alone is not version proof. A reference mod's guard can demonstrate
  dependency intent while still being too weak to copy as a version gate.
- Do not treat Lua 5.4 availability as permission to rely on Lua-version
  features in code intended to load without REPENTOGON.

## Hard Rules

- Never register a REPENTOGON callback, use an extended enum, or add an
  REPENTOGON XML attribute on an unguarded path.
- Resolve the dependency gate before extension registration. A failed required
  gate must not leave half-registered callbacks, menus, entities, or save state.
- Do not copy a callback return policy from a vanilla callback or another
  REPENTOGON callback. Route exact timing and returns to
  `isaac-callback-contracts`.
- Do not add version-sensitive XML merely because it parses locally. Route XML
  registration to the appropriate content skill and test the no-REPENTOGON
  loading path.
- Custom tags, extra item stats, room/loot extensions, and new callbacks can
  change semantics. Preserve user-decided values; keep omitted behavior as
  `TBD` rather than silently replacing an official implementation.
- Test three branches: absent, present-but-insufficient, and present-sufficient.
  Also test repeated registration and the actual in-game engine behavior.

## Bundled Offline Reference

Read `references/repentogon-contract.md` before choosing a version gate or
extension-only surface. It records official capability/version caveats, while
the installed REPENTOGON build and its bundled docs remain authoritative.
## Required Output

```markdown
## REPENTOGON Compatibility Contract
- Dependency mode: required / optional enhancement / undeclared:
- Project declaration and runtime/version/ready proof:
- Required-dependency stop boundary or optional no-extension behavior:
- Exact API/XML/callback surface verified from installed docs:
- Official fallback or explicit omitted-enhancement behavior:
- Version gate and no-REPENTOGON gate:
- State/ownership/lifecycle boundary:
- User-locked values and true TBDs:
- Automated branch tests and in-game checks:
```

## Final Review

Report the exact version gate, every REPENTOGON-only line, no-extension behavior,
and which XML/callback semantics were verified from the installed build. Do not
claim plain Repentance compatibility for code that requires the extender.
