---
name: isaac-shops-deals-pricing
description: "Use when designing, implementing, reviewing, debugging, or writing handoff prompts for Binding of Isaac: Repentance shop and deal transactions, including pickup price, `ShopItemId`, `Price`, automatic price updates, discounts, free purchases, coin shops, heart deals, custom costs, buyer eligibility, payment, delivery, restock, reroll, Morph, co-op payer ownership, and display-versus-charge consistency. This skill owns runtime purchase semantics, not item-pool placement or balance authority. 中文触发：商店、价格、ShopItemId、Price、折扣、免费购买、恶魔交易、天使交易、自定义代价、购买者、扣款、补货、Restock、重掷后价格、显示价格、合作购买。"
---

# Isaac Shops Deals Pricing

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

## Core Principle

A shop or deal is a transaction: identify one pickup and one buyer, calculate
one authoritative price, prove affordability, commit payment, deliver the
result, and reconcile the slot afterward. A displayed number, a pickup `Price`,
or a price callback alone does not prove the player was charged correctly.

Use official Isaac APIs and the target project's proven conventions by default.
Do not assume a helper library, custom currency framework, or price enum.

## Boundary

This skill owns runtime price, buyer eligibility, payment, delivery, failure,
restock, and price reconciliation.

- Use `isaac-item-economy` for pool placement, quality, weights, tags, and how
  often shop/deal content appears.
- Use `isaac-rewards-pickups` for selecting, spawning, morphing, or preserving
  the world pickup itself.
- Use `isaac-reroll-removal-contracts` when reroll, replacement, duplication, or
  restock invalidates an existing transaction state.
- Use `isaac-damage-health-contracts` when payment consumes health or interacts
  with lethal, invulnerability, or revival rules.
- Use `isaac-callback-contracts` for exact price/purchase callback signatures,
  filters, return values, and timing.
- Use `isaac-hud-ui-state` only for a separately stated custom price display.

## First Move

1. Use `isaac-mod-context` in an unfamiliar mod. Discover pickup creation,
   price assignment, purchase detection, buyer resolution, restock/reroll paths,
   custom currency state, optional dependencies, and test commands.
2. Read `references/shop-transaction-contract.md` and classify the route as a
   native coin shop, native heart/deal price, native discount/free purchase,
   or a project-owned custom transaction.
3. Keep price amount, currency, discount ordering, affordability policy,
   restock policy, and failed-payment behavior as user decisions unless the
   project or request already fixes them.
4. Prove the callback/API version before writing a signature or numeric price.

## Transaction Contract

| Phase | Required fact or decision |
| --- | --- |
| Pickup identity | Exact owned pickup, subtype/content identity, slot identity, and seed |
| Buyer candidate | Actual colliding/activating player and co-op eligibility |
| Price source | Native price, callback result, pickup field, discount, or custom calculation |
| Currency | Coins, heart/deal form, pickup/resource, collectible, charge, or custom state |
| Display | Which engine/custom surface renders the price and when it refreshes |
| Affordability | Exact resource snapshot and exclusions before mutation |
| Commit | Order of payment, delivery, pickup removal, and side effects |
| Failure | No-charge/no-delivery rollback or another explicitly approved result |
| Reconciliation | Restock, reroll, Morph, duplicate purchase, room revisit, and reload |

## Hard Rules

- Resolve the actual buyer from the purchase/collision/input event. Never charge
  player zero, the first player, or the item owner merely because one exists.
- Do not choose a coin price, heart cost, discount, free flag, or custom resource
  amount when the user has not decided it. Suggestions must remain labeled and
  must not enter code silently.
- Verify native price constants, callback timing, return semantics, and pickup
  fields from the discovered API. Do not encode undocumented numeric price
  values or assume negative/positive ranges mean the same thing everywhere.
- Maintain one authoritative price per transaction edge. If display uses one
  calculation and payment uses another, define a shared source and prove they
  update on the same dirty events.
- Recalculate only on proven price-invalidating edges: pickup creation, buyer or
  room change, discount change, reroll/Morph, restock, or another discovered
  event. Do not rewrite every shop pickup every frame.
- Make custom transactions atomic. If affordability, payment, delivery, or
  target validation fails, do not leave a partial charge, removed pickup,
  duplicated reward, or consumed active charge.
- Preserve native shop/deal behavior unless the mechanic explicitly owns and
  replaces it. Do not manually charge again after the engine already completed
  the purchase.
- A pickup becoming free, non-shop, rerolled, morphed, restocked, or removed must
  invalidate stale buyer/price state. Do not carry a previous slot's price to a
  new pickup.
- Keep transaction markers pickup/slot scoped and buyer proof player scoped.
  Co-op players may have different resources, discounts, or health forms.
- Touch only pickups and transaction state this mod owns. Do not normalize or
  delete unknown prices from other mods merely because they use custom values.
- Do not serialize live pickups, players, sprites, or userdata. Persist only an
  approved serializable entitlement or transaction key when the design requires
  cross-room/continue recovery.

## Verification

Verify an affordable purchase, unaffordable attempt, two co-op buyers with
different resources, discount/free change, reroll or Morph, restock, duplicate
event delivery, room revisit, and failed custom delivery when applicable.

Static inspection can prove shared calculation paths and ownership guards. A
mock can prove transaction ordering only if it enforces real callback order and
engine value types. Actual price rendering, native payment, heart/deal behavior,
collision ownership, and restock cadence require in-game verification.

## Required Output

```markdown
## Shop / Deal Transaction Contract

- Route and native/custom authority:
- Pickup and slot identity:
- Buyer proof and co-op policy:
- Price source and invalidation edges:
- Currency and affordability rule:
- Display/charge consistency:
- Commit order:
- Failure and rollback behavior:
- Restock/reroll/Morph reconciliation:
- Runtime state owner and cleanup:
- Companion skills and exact API facts to discover:
- Static, isolated, and in-game verification:
- User decisions required:
```
