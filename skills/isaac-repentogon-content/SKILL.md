---
name: isaac-repentogon-content
description: Implement or audit REPENTOGON native content contracts for XML loading and ambush.xml Boss Rush waves, item stats, effect stats, null items and costumes, revive tags, custom cache, achievements and players.xml. Use when Lua-only designs may duplicate native mechanics or when XML loading, generated IDs and persistence need version-aware handling. 中文触发：原生属性、XML 注册、null 道具、自定义缓存、成就、复活标签。
---

# REPENTOGON Native Content

Use native content deliberately when REPENTOGON is the selected runtime. The reference target is **1.1.2g**. This skill covers engine-owned XML registration, native effects/cache and progression; it does not replace the feature's balance or visual requirements.

Use `isaac-mod-context` for an unfamiliar project, `isaac-repentogon-compat` for dependency/version/packaging decisions, and `isaac-repentogon-dev` for complete implementation and one authoritative owner per mechanic. Pair with `isaac-repentogon-callbacks` for return chains and lifecycle; with the applicable item, character, costume, or unlock specialist for the surrounding feature.

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

## Load the relevant contract

- Content versus resources, REPENTOGON-specific roots, and ambush.xml Boss Rush-only support: `references/xml-loading.md`.
- Native stats, null items/costumes and revival: `references/native-items.md`.
- CustomCache defaults, triggers and special tags: `references/custom-cache.md`.
- Achievement persistence and players.xml extensions: `references/achievements-players.md`.
- Version floors, direct source links and documentation conflicts: `references/version-evidence.md`.

## Workflow

1. Discover the actual content/resources layout, existing identifiers, XML registrations, Lua stat owners and save ownership. Technical facts are the agent's investigation work.
2. Confirm the selected runtime and packaging contract. XML is loaded by the engine; a Lua `if REPENTOGON then` cannot hide incompatible XML. Resolve optional-runtime deployment through compat before introducing it.
3. Assign one authority for each statistic, temporary effect, innate grant and unlocked state. Use native XML for unconditional supported stats; do not also add that bonus through MC_EVALUATE_CACHE. Put `effect*` bonuses on the TemporaryEffect when that is the intended source.
4. Separate XML-local association IDs from generated runtime IDs. Resolve custom names through the matching API; never reuse XML IDs as runtime constants or confuse costume, null item, collectible and achievement IDs.
5. Follow the cache, duration and save lifecycle. Prefer native persistence where it exists; do not regrant native effects on every cache/continue event or mirror achievements into a second authoritative save flag.
6. Integrate through the project's existing structure, dependency gate and visual/UI conventions. Investigate docs/source disagreements against the selected tag before implementation.
7. Check XML parsing, referenced resources, identifiers, duplicate stat owners and callback registration. Then test relevant add/remove, stack, reroll, expire, room change, continue, rewind, co-op and unlock-disabled behavior in game. Report these as separate proof levels.

## Required handoff

State the selected version, XML versus Lua responsibilities, identifier mapping, cache triggers, effect duration and persistence owner. Give source evidence and real verification results. Ask only for genuine unresolved user decisions such as an unspecified revival policy or target dependency mode; do not make the user look up APIs.
