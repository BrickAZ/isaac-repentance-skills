# TBD Disclosure

Use this policy whenever a project fact or user design decision is unresolved.

## What Counts As Active

An active `TBD` changes the current recommendation, code path, validation plan, or whether work can honestly be called complete. Examples include an unspecified room-entry route, unconfirmed callback owner, user-owned balance value, optional dependency choice, unknown resource path, or unfinished persistence policy.

A historical unknown that no longer affects the task is not active. A fact discovered from the project, official API, or an explicit user decision is no longer a `TBD` and must not keep being repeated.

## Required Response Shape

1. Label each active item as **`TBD — user decision required`** at the point it affects the work.
2. State the consequence: what cannot be implemented, verified, or claimed until it is decided.
3. Keep any alternatives explicitly optional; do not silently select one.
4. At the end of every response relying on active items, list all remaining items under **User decisions required**.
5. If a mutation would choose one alternative, stop before it. Safe discovery, read-only validation, and conditional planning may continue.

## Example

`TBD — user decision required: the active item's fallback when no legal gallery room can be allocated. Until this is decided, the implementation can discover and test room eligibility, but must not silently turn the item into a no-op or choose a third-party room framework.`

**User decisions required**

- Gallery-entry fallback when no legal room allocation route exists.
