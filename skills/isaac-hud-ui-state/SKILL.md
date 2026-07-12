---
name: isaac-hud-ui-state
description: "Design, implement, review, debug, or write handoff prompts for Binding of Isaac: Repentance mod HUD, world-following indicators, prompts, counters, selectors, and short-lived UI state. Use whenever UI coordinates, player-specific display, manual Sprite rendering, pause, room changes, or HUD state cleanup matters. 中文触发：HUD、UI、提示、计数器、选择菜单、头顶标记、屏幕坐标、WorldToScreen、暂停、界面状态。"
---

# Isaac HUD and UI State

Use `isaac-mod-context` before an unfamiliar project. Discover existing HUD,
render, asset, state, and multiplayer conventions rather than assuming paths,
animation names, or a UI framework.

## Boundary

This skill governs visual carrier selection, coordinate domains, UI ownership, and
lifecycle. It does not decide gameplay effects, item balance, or ANM2 asset
authoring. Use `isaac-mechanic-contracts` for settlement, `isaac-anm2-visuals`
for ANM2 facts, `isaac-state-lifecycle` for durable state, and
`isaac-audio-render-feedback` for broader audiovisual feedback.

Default to official Isaac APIs. Third-party UI APIs and REPENTOGON are optional
only after explicit project declaration and runtime/API discovery. They cannot be
the default route or erase the need for an official fallback.

## Select a Carrier Before Coding

- **HUD/screen UI:** fixed to the screen, such as counters and menus.
- **World-following indicator:** attached above a player or entity.
- **Entity visual:** needs engine-world placement or entity lifecycle.
- **Costume:** only when the request explicitly changes player appearance.

Do not use HUD coordinates for world movement or a loose manually-rendered sprite
as a collision, damage, AI, HP, or targeting entity. Route such behavior through
`isaac-entities`.

## Coordinate Contract

State the coordinate domain for each position:

- Use world positions for entity logic and world placement.
- Manual `Sprite:Render` requires screen coordinates. Convert an anchored world
  point with `Isaac.WorldToScreen(worldPosition)` before rendering.
- Build a head anchor from the live owner position plus discovered offset rules.
  A fixed Y offset is a provisional parameter, not a universal anchor.
- Validate players and NPCs separately when size, flying/position offset, Boss
  scale, or ANM2 pivot differs.

Code inspection alone does not prove placement. Test relevant owner classes and
record unresolved offsets as `TBD`.

## State, Render, and Cleanup

Keep gameplay settlement outside render callbacks. Owner-bound UI must identify
the owner and distinguish co-op players; do not replace it with a global boolean
unless the feature is explicitly global.

For temporary UI define creation, update, visibility, and cleanup at duration
expiry, owner removal/death/invalidity, required room/level/run boundaries,
pause/menu behavior, and mod reload. Discover asset paths and animation names;
never invent them.

Read `references/ui-state-review.md` for the carrier/coordinate/lifecycle table.
Never call a UI correct merely because it did not crash or because a stub rendered.
