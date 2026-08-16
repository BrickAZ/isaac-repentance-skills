# Wisp And Virtues Contract Reference

## Route Selection

| Route | Use when | Guardrail |
| --- | --- | --- |
| Native Virtues behavior | The engine already creates the desired item wisp for a successful use | Do not manually create a duplicate |
| `wisps.xml` definition | The discovered project/resource root maps a registered item to custom wisp properties | Verify schema, local/runtime ID mapping, and assets from actual files |
| Explicit event wisp | The mechanic intentionally creates an item wisp outside automatic use | Define owner, source item, count, and duplicate boundary |
| Ordinary familiar | The object should exist independently of Book of Virtues/item-wisp semantics | Route to `isaac-familiars` |

Do not choose an item wisp just because the object orbits the player. Virtues
identity matters for engine interactions, subtype mapping, count, and removal.

## Active Use Matrix

For every discovered use flag or call path, classify:

- whether the active mechanic succeeds;
- whether charge/item consumption occurs;
- whether native Virtues already creates a wisp;
- whether the call is a repeated/secondary invocation;
- whether one additional wisp is intended;
- which player and active slot own the event.

Use this matrix rather than one broad “on active used” boolean. Car Battery-like
behavior and scripted use can call handlers more than once or with different
flags.

## Identity And Resources

Keep these identities separate:

1. stable XML-local collectible ID;
2. discovered runtime collectible ID;
3. item-wisp variant and source-item subtype;
4. optional project-owned custom familiar/effect identity;
5. `wisps.xml` entry and resource root;
6. ANM2 animation/spritesheet path.

Never infer a wisp's source item from its appearance. Never assign a global
runtime item number into an atlas/XML frame order.

## Count And Lifecycle

- Define wisps per successful use and repeated-use behavior.
- Discover engine/project capacity and what is evicted when full.
- Decide whether item loss or reroll should remove existing wisps; do not assume.
- Bind cleanup to actual owner and source subtype.
- On death/removal, separate native wisp destruction from project-owned rewards,
  explosions, status effects, or sounds.
- Avoid recreating destroyed wisps unless an explicit standing entitlement owns
  them; most use-created wisps represent past successful uses.

## Review Checklist

- Creation authority is singular and proven.
- Source collectible local/runtime identities are not confused.
- Success and repeated-use flags are classified.
- Owner player and active slot are explicit.
- Variant/subtype/source filters preserve vanilla and foreign wisps.
- Count, capacity, HP, damage, shot behavior, and unsupported inheritance are
  explicit.
- Item loss, reroll, death, room/floor, and continue behavior are explicit.
- XML, ANM2, PNG, and animation names come from discovered files.
- Static, mock, and in-game evidence remain separate.

## Common Failures

- Native Virtues and manual code both create a wisp.
- Every callback invocation is treated as a fresh successful use.
- The wisp is assigned to player zero.
- Variant-only scans modify all item wisps.
- Runtime collectible IDs are hard-coded.
- “Inherits all tears” hides unsupported flags and variants.
- Capacity is handled by deleting arbitrary wisps.
- A use-created wisp is respawned every room/update after death.
