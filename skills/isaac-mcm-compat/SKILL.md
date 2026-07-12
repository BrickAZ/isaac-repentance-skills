---
name: isaac-mcm-compat
description: Add, review, or debug optional Mod Config Menu (MCM) integration for Binding of Isaac Repentance mods. Use for MCM settings, categories, controls, callbacks, late loading, duplicate registration, and configuration UI compatibility. Require discovery of a usable ModConfigMenu API first; MCM must never be a mandatory dependency. 中文触发：MCM、Mod Config Menu、设置菜单、配置菜单、选项开关、设置注册。
---

# Isaac MCM Compatibility

MCM is an optional UI layer. The mod owns its configuration values and default
behavior; MCM only edits exposed settings when it is actually available.

## First Move

1. Use `isaac-mod-context` and `isaac-config-options` to discover the real
   setting owner, defaults, persistence, and existing optional guards.
2. Prove a usable `ModConfigMenu` API exists at runtime, then inspect the
   installed version's API shape before registration.
3. Define whether settings are runtime-only or saved before creating UI. Keep
   omitted defaults, labels, ranges, and categories as `TBD`.

## Hard Rules

- Missing MCM must leave the mod functional with its own approved defaults.
- Do not treat MCM's current UI value as the sole source of truth; synchronize
  through the discovered config owner.
- Register idempotently. Late availability may retry only until success; do
  not add duplicate controls every update.
- Do not invent MCM fields, option types, localization fields, or a required
  library load path from another mod.
- Test absent MCM, present MCM, repeated registration, saved/default value
  handling, and behavior after a setting changes.

## Required Output

```markdown
## MCM Compatibility Contract
- Discovered MCM proof/version:
- Config owner/default/persistence:
- Controls and user-locked values:
- Registration timing/idempotency:
- No-MCM behavior:
- Tests and in-game checks:
```
