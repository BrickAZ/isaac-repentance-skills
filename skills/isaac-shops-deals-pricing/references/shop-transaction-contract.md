# Shop And Deal Transaction Reference

## Route Table

| Route | Prefer | Do not assume |
| --- | --- | --- |
| Native coin shop | Preserve engine purchase and price behavior; modify only proven extension points | Price enum numbers, buyer identity, discount order, restock timing |
| Native heart/deal | Preserve native deal semantics and health-form rules | That every heart-looking cost is direct HP subtraction |
| Discount/free purchase | Share one price source between display and charge | That setting one field updates every UI and purchase path |
| Custom cost | Build an explicit atomic transaction and rollback path | That native pickup collection will wait for custom payment |

## Commit Ordering

For a custom transaction, define the authoritative sequence before code:

1. resolve live pickup and buyer;
2. confirm the transaction has not already committed;
3. calculate price from the current authoritative state;
4. prove affordability and eligibility;
5. reserve or commit payment according to the approved failure policy;
6. deliver the reward or native pickup result;
7. remove/mark the pickup only after successful delivery;
8. trigger owned feedback and restock/reconciliation once;
9. clear transient transaction state.

If delivery can fail after payment, define a rollback or deferred entitlement.
Never rely on “this call normally succeeds” for a non-refundable custom cost.

## Price Invalidation Matrix

| Event | Review |
| --- | --- |
| Pickup created/restocked | New content, slot identity, seed, base price |
| Reroll/Morph | Clear old price/buyer markers; price the new identity |
| Buyer changes | Player-specific discounts, health, currency, eligibility |
| Discount item gained/lost | Display and affordability become dirty together |
| Room revisit/continue | Reconcile live pickup against serializable owned state |
| Pickup no longer shop-owned | Stop custom shop handling without deleting foreign state |

## Native Versus Custom Payment

Do not mix native and manual charges without proving who owns each phase. Typical
double-charge failures come from observing a native purchase and then subtracting
the same currency again. Typical free-purchase failures come from changing only
the display while native affordability still uses the old price.

Health/deal costs require the health contract because affordability, lethal
behavior, special player health types, and deal side effects are not equivalent
to subtracting a number from generic HP.

## Review Checklist

- Pickup, slot, buyer, and source mod ownership are proven.
- Price amount/currency/discount order are user-approved or discovered.
- Display and payment use one authoritative price.
- Native payment is not duplicated by manual code.
- Custom payment and delivery are atomic or have a rollback/entitlement path.
- Unaffordable attempts preserve pickup and resources.
- Reroll, Morph, restock, room revisit, and continue clear stale price state.
- Co-op charges the actual buyer and respects player-specific resources.
- Unknown third-party custom prices are preserved.
- Static, mock, and in-game evidence remain separate.

## Common Failures

- Charging player zero in co-op.
- Hard-coding an undocumented price number.
- Repricing every pickup every frame.
- Showing a discount without changing actual affordability.
- Charging manually after a native purchase already committed.
- Removing the pickup before custom delivery succeeds.
- Reusing a stale slot price after reroll or restock.
