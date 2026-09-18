---
name: isaac-repentogon-callbacks
description: Implement or audit REPENTOGON callback contracts, including changed vanilla return chains, damage ExtraSource, callback priorities, mod load/unload, true-item versus wisp/innate inventory events, and deterministic pickup loot previews. Use after REPENTOGON capability/dependency selection; pair with isaac-repentogon-dev for feature implementation. 中文触发：扩展回调、伤害返回链、库存魂火、innate、掉落预览、卸载回调。
---

# REPENTOGON Callback Contracts

Use this specialist when REPENTOGON is the selected runtime and correctness depends on its callback arguments, return propagation, event timing, or ownership. The verified reference target is **1.1.2g**; feature introduction is not proof that older builds contain later fixes.

Start with `isaac-mod-context` for an unfamiliar project. Use `isaac-repentogon-compat` for dependency mode, version detection, missing-runtime behavior, and packaging; use `isaac-repentogon-dev` for the feature's implementation ownership and integration. Ordinary vanilla-only callback work belongs to `isaac-callback-contracts`. Native XML and custom cache belong to `isaac-repentogon-content`.

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

## Read only what the task needs

- Registration, priorities, damage changes and lifecycle: `references/dispatch-damage-lifecycle.md`.
- Inventory ownership, innate groups and loot previews: `references/inventory-loot.md`.
- Historical minimums, source authority and known documentation conflicts: `references/version-evidence.md`.

## Workflow

1. Identify the actual caller, registered function, filter, dependency gate and selected REPENTOGON version. Preserve user-approved runtime decisions; investigate missing technical facts.
2. Write the complete Lua signature, including the implicit mod first argument. A documentation table's “optional argument” is the registration filter, not an additional argument to append to the handler.
3. State nil, false, true, table/userdata, and POST behavior separately for this callback. Read its dispatcher; do not import another callback's cancellation rule or assume every non-nil return stops a chain.
4. Assign one owner to each mutation/reward/consumption. Distinguish real inventory, item wisps, innate grants, TemporaryEffects and pickup provenance. Registering two observation surfaces does not justify two rewards.
5. Implement with existing project conventions and narrow filters where the API supports them. Preserve incoming modified values when contributing to a chain. Never simulate modified damage through recursive `TakeDamage` when its return table suffices.
6. Verify the actual feature minimum and required fixes. Let compat supply an established gate; checking one enum or only `REPENTOGON ~= nil` is not a complete version contract.
7. Exercise cancellation by a second callback, ordering, nil sources, wisp/innate changes, continue/rewind, and repeated loot previews as relevant. Static checks and mocked dispatch tests are not in-game proof.

## Required handoff

Report the selected runtime, precise handler and filter, chain/side-effect behavior, source evidence, touched files, and tests actually run. Separate verified results from remaining runtime checks. For unspecified game balance or dependency policy, ask only the unresolved user choice after completing independent discovery.
