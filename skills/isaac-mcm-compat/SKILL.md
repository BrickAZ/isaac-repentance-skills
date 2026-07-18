---
name: isaac-mcm-compat
description: Add, review, or debug optional Mod Config Menu (MCM) integration for Binding of Isaac Repentance mods. Use for MCM settings, categories, controls, callbacks, late loading, duplicate registration, and configuration UI compatibility. Require discovery of a usable ModConfigMenu API first; MCM must never be a mandatory dependency. 中文触发：MCM、Mod Config Menu、设置菜单、配置菜单、选项开关、设置注册。
---

# Isaac MCM Compatibility

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

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
