# Card, Pill, And Pocket Interaction

Use this when an active item triggers card/pill-like behavior, reads pocket slots, consumes cards/pills, or interacts with custom pocket items.

For custom card/rune/soul stone/pill registration, card generation, `content/pocketitems.xml`, or blank/abnormal card visuals, use `isaac-cards-pockets`.

## Routes

- `MC_USE_CARD`: for actual card/rune/soul stone use callbacks.
- `MC_USE_PILL`: for pill effects.
- `MC_USE_ITEM`: for active item use.
- Player pocket APIs: inspect current repo examples before assuming a method name or slot behavior.

## Hard Rules

- Do not mix collectible id, card id, and pill effect id.
- Do not assume a card/pill effect should be implemented as an active item callback just because an active item triggers it.
- If a card/pill is consumed, specify which slot and failure policy.
- If an active item repeats or simulates a card effect, guard against recursive callbacks or same-frame double-use state.

## Prompt Checklist

- Which content id is involved: collectible, card, pill, or pocket active.
- Whether the effect consumes the pocket item.
- Whether it can trigger from non-player sources.
- Same-frame recursion guard if needed.
