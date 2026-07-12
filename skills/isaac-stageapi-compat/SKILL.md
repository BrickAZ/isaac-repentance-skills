---
name: isaac-stageapi-compat
description: Add, review, or debug optional StageAPI integration for Binding of Isaac Repentance mods. Use for StageAPI custom rooms, stages, doors, room transitions, callbacks, and version-sensitive room/stage enhancements. Require an explicitly declared and usable StageAPI installation first; never assume a StageAPI version, function, or fallback path. 中文触发：StageAPI、自定义楼层、自定义房间、StageAPI 房间、StageAPI 门、StageAPI 兼容。
---

# Isaac StageAPI Compatibility

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
