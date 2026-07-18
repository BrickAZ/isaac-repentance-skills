---
name: isaac-item-economy
description: "Review, design, implement, or write handoff prompts for Binding of Isaac Repentance item economy: item quality, pools, weights, depletion, tags, unlock/availability conditions, pool dilution, and itempools/XML synchronization. Use this whenever a user asks where an item should appear, how often it should appear, which pool fits it, whether its quality/weight/tags are fair, or whether itempools language files are synchronized. 中文触发：道具池、池子、权重、品质、quality、tags、稀释池子、出现频率、商店池、恶魔池、天使池、宝箱池、解锁、经济、平衡、itempools。"
---

# Isaac Item Economy

## TBD Disclosure Contract

A `TBD` is an unresolved project fact or user decision, not permission to guess.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Do not choose a balance value, room route, fallback mechanism, asset, dependency, identifier, callback, or persistence policy on the user's behalf.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` whenever an unresolved fact or user decision remains active.

Use this skill when an item needs to enter the run economy, not merely exist in `items.xml`.

Read `../isaac-mod-context/references/design-authority.md` alongside this skill's economy-specific approval rules. The shared rule governs all design authority; this skill adds the pool and XML review surface.

The goal is to make pool placement, weight, quality, tags, depletion, and availability explicit while preserving the user's authority over balance decisions. A registered item with the wrong pool or weight can warp the run even when its Lua behavior is perfect.

## First Move

Before adding or reviewing itempools:

1. Read the item's Basic Item Spec and Mechanic Contract when the behavior affects power or consistency.
2. In an unfamiliar mod, use `isaac-mod-context` to discover the item and pool XML, all declared locales, and existing item-economy conventions. Do not assume `content/`, `itempools.xml`, or a fixed language set.
3. Read the current project's item XML, every discovered locale variant, and every discovered pool XML variant.
4. Read the closest current-project items occupying the proposed pool. When local precedent is insufficient, use this skill's pool and weight references without requiring another mod checkout.
5. Decide the player-facing acquisition story before choosing a numeric weight.
6. Mark every value the user already gave as `locked`. Mark every omitted balance field as `TBD` before offering advice.

Read the relevant reference:

- Pool placement and availability: `references/pool-placement.md`.
- Quality, weights, depletion, tags, and pool dilution: `references/weight-quality-tags.md`.
- Review table and static verification: `references/economy-review-checklist.md`.

## Hard Rules

- User-specified quality, pools, weights, tags, depletion, unlocks, and exclusions are locked decisions. Do not replace, reinterpret, or silently "balance" them.
- For an omitted field, provide one recommended proposal and, when the trade-off is meaningful, one alternative. Label each as `Suggestion`, include its reason, and keep it out of source XML until the user or an explicit upstream approval record accepts it.
- A `Suggestion` completes a review/handoff surface; it is not a claim that the value is objectively correct.
- Do not assign a pool, quality, tag, or weight merely because a similar item used one.
- Distinguish item power, reliability, rarity, and acquisition route. Quality does not replace pool placement; low weight does not repair a fundamentally wrong pool.
- State whether the item should deplete from a pool and why; treat `Weight`, `DecreaseBy`, and `RemoveOn` as one contract.
- Update the base item/pool XML and every discovered locale surface that owns the same data. The validator checks local name resolution, numeric fields, and structural parity; it cannot judge whether the economy feels fair.
- Do not put an item in every plausible pool to make it easy to encounter. Each extra pool dilutes that pool and changes the mod's identity.
- Keep tags coherent with actual mechanics and item category. Do not use tags as decorative metadata.
- If an unlock or challenge gate changes availability, write the gate separately from default pool placement.
- If the task chooses or replaces a concrete runtime reward/pickup, route that path to `isaac-rewards-pickups`; item economy does not authorize an unapproved reward subtype or quantity.

## Required Output

```markdown
## Item Economy Spec

- Item and mechanic summary:
- User decisions (locked):
- Missing fields (TBD):
- Suggestions needing approval:
- Intended acquisition story:
- Proposed quality and rationale:
- Pool entries and rationale:
- Weight / DecreaseBy / RemoveOn policy:
- Tags and rationale:
- Unlock or availability gates:
- Pools intentionally excluded:
- Similar local items reviewed:
- Base and discovered-locale XML surfaces:
- Static validator checks:
- In-game economy checks:
```

## Final Review

Before saying economy work is complete, report the review table with user decisions separated from suggestions, list the XML files changed, and distinguish structural validation from subjective balance review. Do not describe an unapproved suggestion as final balance.
