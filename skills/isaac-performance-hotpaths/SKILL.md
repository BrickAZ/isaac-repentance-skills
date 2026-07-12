---
name: isaac-performance-hotpaths
description: "Review, design, implement, or write handoff prompts for Binding of Isaac: Repentance mod performance-sensitive update, render, entity-scan, spawn, and cache paths. Use whenever a mod stutters, has per-frame logic, repeatedly scans entities, spawns effects/projectiles frequently, rebuilds tables or sprites, or needs a performance review. 中文触发：性能、卡顿、掉帧、每帧、遍历实体、重复生成、缓存刷新、优化。"
---

# Isaac Performance Hot Paths

Use `isaac-mod-context` first in an unfamiliar mod. Discover actual callbacks,
state owners, asset loading, and resource conventions before changing a hot path.

## Boundary

This skill reduces measured or plausibly hot runtime work. It does not choose
gameplay balance, invent project structure, or replace callback/lifecycle
contracts. Use `isaac-callback-contracts`, `isaac-state-lifecycle`,
`isaac-entities`, `isaac-projectile-combat`, or `isaac-audio-render-feedback`
for those separate concerns.

Default to official Isaac APIs. Any third-party library, including REPENTOGON, is
optional: use it only after explicit project declaration and runtime/API discovery.
Its absence needs an official fallback or a clearly documented unsupported branch.

## Diagnose First

Separate confirmed facts from `TBD`. Never call an improvement measured unless it
has reproducible evidence.

For each suspect path, identify:

- callback and frequency: event, room entry, entity update, every frame, render;
- scope: run, room, owner, entity, or bounded work queue;
- work: scans, allocations, `Isaac.Spawn`, resource/sprite loading, table rebuilds,
  cache evaluation, or save serialization;
- trigger signal, behavior that must remain unchanged, and evidence method.

Treat `MC_POST_RENDER` as visual-only unless project facts prove an exception. Do
not move gameplay settlement into render simply to remove an update callback.

## Choose the Smallest Safe Reduction

- Replace an every-frame full scan with an event, room-dirty flag, bounded cadence,
  or maintained owner list only when its cleanup is defined.
- Build immutable sprites, lookup tables, colors, and configuration per resource
  lifecycle, not per frame. Do not accidentally share mutable owner state.
- Spawn on state transitions, cooldown edges, or a bounded queue. A cap must name
  its owner and reset condition.
- Re-evaluate player cache only when cache-relevant state changes.
- In dense rooms, bound work explicitly. Do not silently throttle behavior that
  affects gameplay or visual semantics; surface it as a design decision.

Never cache entity references across room/run boundaries without lifecycle proof,
and never replace per-owner state with one global shortcut.

## Handoff and Review

Read `references/hotpath-review.md` for a review table and verification split.
Before finalizing, answer: why the path is hot, what work changed, what owns and
invalidates the optimization, how co-op and lifecycle boundaries behave, and what
remains unmeasured.

Never describe static analysis, stub execution, or a lack of crash as in-game
performance proof.
