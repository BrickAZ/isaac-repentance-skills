---
name: isaac-stageapi-compat
description: Add, review, or debug optional StageAPI integration for Binding of Isaac Repentance mods. Use for StageAPI custom rooms, stages, doors, room transitions, callbacks, and version-sensitive room/stage enhancements. Require an explicitly declared and usable StageAPI installation first; never assume a StageAPI version, function, or fallback path. 中文触发：StageAPI、自定义楼层、自定义房间、StageAPI 房间、StageAPI 门、StageAPI 兼容。
---

# Isaac StageAPI Compatibility

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

StageAPI is an optional expansion route, not a substitute for project discovery
or official API behavior.

## First Move

1. Use `isaac-mod-context` and `isaac-rooms-stages` to discover the mod's
   declared dependency, current room/stage authority, and official fallback.
2. Prove the installed StageAPI object and version/API surface before selecting
   a method. StageAPI releases vary; never copy function names from examples.
3. Define what happens without StageAPI: an official equivalent, or explicit
   absence of the optional room/stage enhancement. Keep unapproved content,
   IDs, weights, and transition policy as `TBD`.

## Hard Rules

- Do not `require` StageAPI or call it before a guarded availability check.
- Never make a normal run crash, softlock, or mutate unrelated rooms when the
  optional library is absent or reports an unsupported version.
- Own only rooms, doors, state, and callbacks created by this integration.
  Route lifecycle to `isaac-state-lifecycle` and callback details to
  `isaac-callback-contracts`.
- Test no-StageAPI behavior separately from the installed-StageAPI branch;
  test repeated registration and room transition cleanup.

## Required Output

```markdown
## StageAPI Compatibility Contract
- Declared dependency and discovered API/version proof:
- Optional enhancement and official/no-op fallback:
- Owned room/stage/door identifiers:
- Registration and lifecycle timing:
- No-StageAPI and unsupported-version behavior:
- Tests and in-game checks:
```
