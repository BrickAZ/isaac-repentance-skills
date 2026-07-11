# Spawn, Morph, and Fallback

## Spawn Contract

Before `Isaac.Spawn` or `game:Spawn`, identify:

- entity type, variant, subtype, position, velocity;
- player or entity ownership/spawner;
- seed policy when deterministic behavior matters;
- pickup price, options index, shop state, and any pickup-specific behavior;
- the exact failure outcome.

For an optional owned reward, an invalid candidate means no spawn. Report it in
debug output if helpful; do not manufacture a generic or blank replacement.

## Morph Contract

Morph is a replacement transaction:

1. Read the original pickup state needed to preserve its behavior.
2. Validate the replacement target.
3. Apply the intended Morph/replace operation once.
4. Re-check only the properties the mechanism owns.

If step 2 fails, leave the original pickup untouched. Do not delete it first,
and do not use a random subtype as a recovery path.

## Compatibility Boundary

The current project can strictly validate its own registry entries. A card, pickup, or
entity from another mod may be legitimate even when it is unknown locally.
Only transform third-party content when the user explicitly defines that
interaction; otherwise, preserve it.
