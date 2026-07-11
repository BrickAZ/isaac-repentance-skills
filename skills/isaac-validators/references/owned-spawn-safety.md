# Owned Spawn Safety

Use this reference whenever the current mod creates, morphs, replaces, or resolves an entity, pickup, card, rune, pill, effect, tear, familiar, NPC, or collectible pedestal.

## Compatibility Boundary

The current mod protects only targets it owns or deliberately replaces. Do not install a global callback that deletes, morphs, or rejects unknown entities merely because their type, variant, or subtype is unfamiliar. Another mod may legitimately create that entity.

The safe boundary is:

- Validate an owned target before this mod spawns or morphs it.
- Leave a third-party entity untouched unless the current mechanic explicitly selected it and has a documented compatibility rule.
- If an owned replacement target is invalid, preserve the original entity or suppress only this mod's optional reward/effect.

## Spawn Contract

Before an owned spawn, prove the target belongs to one of these routes:

| Route | Required proof | Invalid-target behavior |
| --- | --- | --- |
| Vanilla entity/pickup | Known vanilla enum and a valid subtype/item/card id | Do not spawn the optional reward. |
| Registered custom entity | `entities2.xml` name/type/variant plus valid ANM2, spritesheet, and default animation | Do not spawn; never fall back to an unrelated raw custom variant. |
| Custom card/rune/pill | `pocketitems.xml` registration plus id, pickup, HUD key, and generation gate | Do not generate or replace; keep an existing non-owned card unchanged. |
| Third-party entity | Explicit optional-mod detection and that mod's public id/API | Do nothing when the dependency is absent; never treat an unknown entity as invalid globally. |

## Runtime Rules

- Do not use `0`, `-1`, or an arbitrary raw custom variant as a fallback for a failed `Isaac.GetEntityVariantByName` lookup.
- A failed custom lookup must return `nil`/`false` and skip only the owned spawn. For a replacement, leave the original entity unchanged.
- Keep the owner/gate next to the spawn call: item ownership, challenge gate, or explicit feature state.
- Do not use a global `MC_PRE_ENTITY_SPAWN` blacklist for this purpose. It would break other mods and cannot prove ownership.
- Treat `pcall(Isaac.Spawn(...))` as crash containment only, not validity proof.

## Review Output

For every new non-vanilla spawn, report:

```markdown
- Spawn owner and gate:
- Target class: vanilla | current-project registered | optional third-party
- Type / variant / subtype or lookup name:
- Registration and asset proof:
- Failure behavior:
- Compatibility boundary:
```
