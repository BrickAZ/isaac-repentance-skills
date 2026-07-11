# Registration And Return Contracts

## Registration Proof

For each handler, prove all four links:

1. The handler function exists.
2. Its `AddCallback` registration executes during mod load.
3. The callback filter matches the intended item/entity/card when applicable.
4. A behavior test invokes the registered callback and checks the observable result.

The generic validator scans direct `ModObject:AddCallback(..., Owner.Handler)` registrations across Lua modules when given the mod object name. Project profiles may add stricter conventions. Neither form can prove that an unregistered helper should have been a callback; use the Mechanic Contract and tests for that.

## Return Rule

`nil`, `false`, and `true` do not have one universal meaning in Isaac callbacks. Before using a return value, inspect the closest known-good callback of the same `ModCallbacks` type and confirm the API behavior. Record the selected return in the Callback Contract together with its intended consequence.

## Cache Rule

`MC_EVALUATE_CACHE` reads cache flags; it does not automatically run just because arbitrary state changed. When a mechanic arms, expires, gains stacks, or loses an item, state the exact cache-refresh call and flags.

## Priority And Duplicate Rule

Use priority only when callback order changes observable behavior and explain the competing callback. Do not register the same callback/handler/filter pair twice; it can double rewards, double damage, or make a bug look random.
