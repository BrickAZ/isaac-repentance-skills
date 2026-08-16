---
name: isaac-room-networks
description: Design, implement, review, or write handoff prompts for a Binding of Isaac Repentance feature that spans multiple custom rooms as one owned area, gallery, dungeon, route, hub, or room chain. Use this when the central problem is room nodes, edges, entry/exit, return routes, paging between owned rooms, room-network state, or safe failure when no legal connection can be allocated. Use isaac-dimensions only when the game-level Dimension context itself is central. Do not treat a debug room reload as a room network. 中文触发：房间网络、多个自定义房间、独立区域、陈列室、房间链、房间路线、房间枢纽、房间入口、返回房间、区域传送。
---

# Isaac Room Networks

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when a feature owns a graph of two or more rooms. It coordinates the area; it does not replace room registration, door primitives, or game-level dimension ownership.

## Boundary

- **This skill owns**: network identity, owned room nodes and edges, entry/return contract, navigation progress, area session state, partial-network failure, and network-level tests.
- **isaac-rooms-stages owns**: individual room registration, room XML, door slots, grid legality, level APIs, and per-room mutation.
- **isaac-dimensions owns**: game-level Dimension identity, entry/exit between dimensions, and cross-dimension isolation. This skill consumes a confirmed dimension context; it never creates or switches one.
- **isaac-state-lifecycle owns**: storage/keying/reset/save mechanics after this skill defines the network state.
- **Optional APIs**: StageAPI or REPENTOGON are guarded integrations only after the project declares them. They are not the default way to make a room network.

## First Move

1. Use isaac-mod-context to discover room registration, level/room APIs, existing room identity conventions, and test entry points.
2. State the player-facing area promise: why the player enters, how they navigate, and how they return.
3. Discover whether the requested rooms are all in one confirmed dimension context. If the Dimension itself is unknown or must change, route that decision to isaac-dimensions first.
4. Read `references/room-network-contract.md` and
   `references/room-network-tests.md` before selecting an allocation or transition route.
5. Keep entry carrier, room allocation, physical door topology, and player transition as separate facts. A successful local door call is not proof that a usable network exists.

## Network Contract

Before implementation, define:

- Network key and ownership boundary.
- Confirmed dimension context consumed by the network.
- Node source: discovered room ids/descriptors or project-proven allocation route.
- Edge source: discovered door/transition route and legal-candidate policy.
- Entry trigger and origin snapshot.
- Navigation order: free graph, linear chain, hub-and-spoke, or user-approved paging.
- Return route, interruption policy, and cleanup.
- Partial-network policy: stop, return, retry later, or user-approved reduced area.
- Failed-entry UX and charge/consumption policy when an active item is the entry carrier.

## Hard Rules

- Do not equate a room reload, console goto, negative debug room index, or fixed local coordinate with a real network node or map edge.
- Do not allocate an area by repeatedly calling a door API until something appears. Discover candidate slots, neighboring-room facts, and allocation preconditions first.
- Do not consume a one-time entry, item charge, or once-per-floor success merely because allocation was attempted. Commit only after the user-approved entry result is actually reachable.
- If the network cannot be created in the current context, do not silently turn the feature into a no-op. Report the failed-entry route and use the user-approved fallback or explicit non-consumption policy.
- Do not delete unrelated doors, mutate unknown rooms, or clean vanilla-owned resources to make an owned network appear connected.
- Do not create or switch a game-level Dimension here. Hand that work to isaac-dimensions.
- A network saved across reload must use plain stable identities, never live Room, Door, Entity, or descriptor userdata.

## Required Output

`markdown
## Room Network Contract

- Player-facing area promise:
- Network key and owner:
- Confirmed dimension context consumed:
- Node registration/allocation source:
- Edge/door/transition source:
- Entry trigger and origin snapshot:
- Navigation model:
- Return and interruption behavior:
- No-candidate / partial-network policy:
- Active-item failed-use policy, if applicable:
- State/reset/save boundary:
- Optional dependency gates:
- Required static, scripted, and in-game checks:
`

## Final Review

Report the discovered node/edge facts, dimension context, entry and return route, no-candidate outcome, partial-network behavior, state cleanup, and separate normal-floor in-game proof. Do not call a debug-room reproduction topology verification.


When any active `TBD` remains, the **last section** of the response must be
`**User decisions required**`. Repeat every unresolved network, dimension,
entry, return, fallback, and cleanup decision there; do not end on the
verification matrix.
