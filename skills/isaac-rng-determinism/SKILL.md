---
name: isaac-rng-determinism
description: "Design, implement, review, debug, or write handoff prompts for Binding of Isaac: Repentance mod random selection, RNG ownership, seed scope, reproducibility, and random-state lifecycle. Use whenever a mechanic chooses random outcomes, uses RNG/RandomInt/RandomFloat/GetCollectibleRNG/GetSeeds/DropSeed/InitSeed, risks math.random misuse, must be stable for a run/room/player/event, or behaves differently after restart, reroll, co-op, or repeated callback delivery. 中文触发：随机、RNG、种子、seed、RandomInt、RandomFloat、GetCollectibleRNG、掉落种子、可复现、重开不同、随机不稳定。"
---

# Isaac RNG and Determinism

Use `isaac-mod-context` first in an unfamiliar project. This skill decides how
randomness is owned and verified; it does not decide what reward, attack, item,
or enemy behavior should be selected.

## Boundary

Use this skill for random source, draw timing, deterministic scope, replay/retry,
and co-op isolation. Use `isaac-rewards-pickups`, `isaac-projectile-combat`,
`isaac-npc-boss-ai`, or another specialist for the selected behavior itself.
Use `isaac-state-lifecycle` when a drawn outcome must persist.

Default to official Isaac RNG and discovered project helpers. Do not introduce a
third-party RNG API. Do not assume `math.random` is acceptable merely because a
visual effect looks cosmetic; user intent decides whether variation must be
deterministic.

## Randomness Contract

Before implementation, state:

- selection event and eligible owner;
- desired stability: per event, room, floor, run, player, entity, or explicitly
  non-deterministic;
- source seed/RNG route, discovered from API/current project or `TBD`;
- draw count and boundary: once at creation, once per event, or controlled retry;
- duplicate/re-entry behavior and co-op ownership;
- outcome persistence, reroll/removal/reload policy, and verification method.

Do not use a shared global RNG stream for player- or entity-owned outcomes unless
the design explicitly intends cross-owner coupling. Do not seed from an invented
field or serialize live `RNG` userdata.

## Draw at a Meaningful Edge

- Draw once when an outcome is created if later updates must preserve it.
- Do not redraw every update merely because the mechanic has an update callback.
- A retry loop needs a bounded rule and must say whether failed candidates consume
  a draw. Do not change odds by silently drawing again.
- When a callback supplies an RNG, prove its event/owner semantics before reusing
  it elsewhere.
- For collectible-owned randomness, discover the correct owner/item route; do
  not use player zero or a global item holder for co-op choices.

## Verification

Read `references/rng-review.md`. Static success does not prove reproducibility.
Test repeated eligible events, two-player ownership, reroll/removal where
relevant, and same-condition reruns. Report whether deterministic behavior was
actually verified in game or remains pending.
