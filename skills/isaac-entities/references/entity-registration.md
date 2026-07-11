# Entity Registration

Use this when adding or reviewing a registered entity.

## Inspect First

1. Check whether `content/entities2.xml` exists in the current mod.
2. Search existing code for `EntityType`, `Variant`, `Subtype`, `Isaac.Spawn`, `MC_POST_*_INIT`, `MC_POST_*_UPDATE`, and `MC_PRE_*_COLLISION`.
3. When no local entity is comparable, use this registration checklist and
   leave undecided allocations as `TBD`; do not require a third-party mod checkout.

## Registration Fields To Confirm

- Entity kind: effect, familiar, tear, laser, knife, pickup, NPC, boss, or another vanilla category.
- Type, variant, subtype, and internal name.
- ANM2 path and default animation.
- Collision size and grid collision behavior when relevant.
- Shadow, champion/boss flags, and visual layering when relevant.
- Whether Lua gets the id through XML constants, enums, or local lookup helpers.

## Caution

Variant/subtype collisions cause very confusing bugs. Never choose numbers by
vibe. Use current-project allocations or an explicit `TBD`.
