---
name: isaac-repentogon-compat
description: Add, review, or debug optional REPENTOGON integration for Binding of Isaac Repentance+ mods. Use for REPENTOGON-only callbacks, Lua API extensions, XML extensions, version guards, custom tags, performance features, or compatibility with REPENTOGON's Lua 5.4 runtime. Require explicit project intent plus a usable REPENTOGON global and version proof; never assume REPENTOGON exists. 中文触发：忏悔龙、Repentogon、REPENTOGON、扩展 API、扩展回调、Repentogon XML、Lua 5.4、版本检查。
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

REPENTOGON is an optional script extender. Treat every one of its callbacks,
globals, XML attributes, and runtime behaviors as unavailable until the target
project explicitly opts in and the actual runtime proves support.

## First Move

1. Use `isaac-mod-context` to discover the project's declared target game,
   dependency policy, bootstrap, Lua compatibility expectations, and tests.
2. Confirm the user wants a REPENTOGON-only enhancement. Keep the core mechanic
   on official APIs unless the user explicitly accepts a REPENTOGON requirement.
3. Verify a usable global and the installed version. Use the discovered version
   check/API documentation; never compare guessed version strings or assume the
   newest web documentation matches the player's build.
4. Classify the proposed feature: extended callback, Lua API, XML attribute,
   custom tag, performance enhancement, or runtime-only convenience. Then read
   the exact installed documentation for that surface.

## Capability Contract

- **Absent**: do not call REPENTOGON APIs. Run the official implementation or
  explicitly omit the optional enhancement without a crash, softlock, or
  malformed XML path.
- **Present but insufficient**: do not call the newer API. Use an earlier
  supported route or omit the enhancement; record the version requirement.
- **Present and sufficient**: use only the discovered API signature, callback
  return contract, XML spelling, and lifecycle behavior.
- Do not treat Lua 5.4 availability as permission to rely on Lua-version
  features in code intended to load without REPENTOGON.

## Hard Rules

- Never register a REPENTOGON callback, use an extended enum, or add an
  REPENTOGON XML attribute on an unguarded path.
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

## Required Output

```markdown
## REPENTOGON Compatibility Contract
- User-approved REPENTOGON requirement or optional enhancement:
- Project declaration and runtime/version proof:
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
