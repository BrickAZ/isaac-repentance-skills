---
name: isaac-dimensions
description: "Design, implement, review, or write handoff prompts for Binding of Isaac Repentance features whose central problem is a game-level Dimension context: identifying, entering, leaving, registering or selecting a custom/special dimension, cross-dimension state isolation, return behavior, and compatibility with vanilla or optional APIs. Use this only when the Dimension itself matters; use isaac-room-networks for multiple owned rooms inside one already-confirmed dimension. Never assume Repentance, StageAPI, or REPENTOGON exposes a custom-dimension registration API. 中文触发：自定义维度、独立维度、Dimension、跨维度、进维度、离开维度、维度传送、维度隔离、维度返回。"
---

# Isaac Dimensions

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when the game-level Dimension context is the feature. A custom room, a room chain, or a red-room door does not become an independent Dimension merely because it feels separate.

## Boundary

- **This skill owns**: Dimension identity and ownership, entry/exit contract, cross-dimension state isolation, origin/return context, re-entry, save/reload/death behavior, and dimension-level verification.
- **isaac-room-networks owns**: graph, nodes, edges, and navigation among multiple owned rooms after this skill supplies a confirmed Dimension context.
- **isaac-rooms-stages owns**: individual room/stage registration, room descriptors, grid/door legality, and ordinary room transitions.
- **isaac-state-lifecycle owns**: actual state storage, serialization, keys, and reset mechanics.
- **Optional APIs**: use isaac-stageapi-compat or isaac-repentogon-compat only when the target project explicitly declares the dependency and its installed API proves the required capability.

## First Move

1. Use isaac-mod-context to discover the target game's supported APIs, project dependency declarations, existing dimension conventions, and test entry points.
2. State whether the request requires a new game-level Dimension, a known vanilla/special Dimension, or only a separate room network. Route the third case to isaac-room-networks instead.
3. Read `references/dimension-contract.md` and
   `references/dimension-test-matrix.md` before selecting an entry or registration approach.
4. Prove the exact API surface that creates, identifies, or enters the requested Dimension. If no project/official/declared optional API proves it, keep the feature route TBD — user decision required; do not fabricate a dimension id or emulate one by changing room indices.
5. Define the origin context and return behavior before creating any persistent dimension state.

## Dimension Contract

Before implementation, define:

- Dimension identity source and ownership: official, project-defined, or explicitly optional API.
- Entry trigger, caller, origin room/stage/dimension snapshot, and transition result.
- Exit/return trigger and what survives or resets across the boundary.
- Which content is dimension-owned versus vanilla/other-mod content that must remain untouched.
- Re-entry, death, reload, run end, and unexpected transition policy.
- Whether a room network will run inside the Dimension; if so, hand it the confirmed context instead of creating nodes here.
- No-capability policy when the required dimension API is unavailable.

## Hard Rules

- Do not invent a Dimension enum, numeric id, registration call, or callback from a reference mod, documentation fragment, or API name alone.
- Do not call a vanilla Dimension mechanism and then close, remove, reset, or repurpose vanilla-owned rooms/entities/state to imitate a custom Dimension. Follow isaac-mechanic-contracts native-mechanism isolation rules.
- Do not treat a room network, red-room allocation, hidden room, debug room, or direct room transition as evidence that a new game-level Dimension exists.
- Do not let a missing Dimension capability silently degrade into the same mechanic in the current dimension unless the user explicitly approves that fallback.
- Keep origin and target state distinct. A return failure must not strand the player, leak the target state into the origin, or erase vanilla/third-party content.
- Store only plain stable identities in persistent data; never save live Room, Level, Player, Entity, Door, or descriptor userdata.
- A Dimension context is a capability/result contract, not a hard-coded number passed down to room logic without discovery proof.

## Required Output

`markdown
## Dimension Contract

- Player-facing promise:
- Dimension identity source and ownership:
- Project/official/optional API proof:
- Entry trigger and origin snapshot:
- Target context acquisition/registration route:
- Exit and return route:
- Dimension-owned versus preserved content:
- Re-entry/death/reload/run-end policy:
- Room-network handoff, if applicable:
- No-capability fallback or blocked policy:
- State/reset/save boundary:
- Optional dependency gates:
- Required scripted and in-game checks:
`

## Final Review

Report the proven Dimension capability, entry/return sequence, origin and target isolation, optional dependency behavior, all interruption paths, and a same-run in-game check that verifies vanilla/other-mod state remains intact.
