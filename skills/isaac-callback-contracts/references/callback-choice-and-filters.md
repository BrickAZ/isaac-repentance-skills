# Callback Choice And Filters

Choose callbacks by the event in the Mechanic Contract, not by the content's name.

| Need | Usual route | Guard to state explicitly |
| --- | --- | --- |
| Recalculate a stat | `MC_EVALUATE_CACHE` | matching cache flag, ownership count, refresh path |
| React to/cancel incoming damage | `MC_ENTITY_TAKE_DMG` | player/entity filter, source, flags, re-entry policy |
| Start or intercept active use | `MC_USE_ITEM` / `MC_PRE_USE_ITEM` | item id, active slot, attempt versus successful use |
| Resolve a custom card/pill | `MC_USE_CARD` / `MC_USE_PILL` | card/pill id and custom registration |
| Decide generated card content | `MC_GET_CARD` | owned generation gate, no normal-run leakage |
| Track a created/updated entity | matching entity lifecycle callback | type/variant/subtype and owner key |
| Reset room/floor/run state | room/level/game lifecycle callback | reset owner and continued-run policy |
| Draw screen feedback | `MC_POST_RENDER` | presentation-only state; screen coordinates and pass ownership |
| Draw player/entity-attached feedback | matching player/entity render callback | owner filter, coordinate adapter, callback `RenderOffset` ownership, render mode/pass |

## Filtering Rule

Use the callback registration filter when the API supports it. Keep additional semantic guards in the handler, because registration filters rarely express item ownership, challenge gate, damage source, or state lifetime completely.

A registration filter narrows delivery; it does not rewrite the callback's handler signature or parameter order. Verify the exact callback signature first, then pass the filter in the registration position documented by the discovered API/project pattern. Test one matching and one non-matching delivery instead of inferring correctness from a registration line.

## Timing Rule

Write down whether the mechanic needs to act before an event, at the event, after the event, or once per frame. Do not substitute a frame update for an event callback merely because it is easier to find.

Do not treat callback count as elapsed real time without runtime evidence. Update, player-update, render, animation-event, and room-frame clocks can pause, repeat, or diverge; route duration semantics to `isaac-state-lifecycle`.

For `MC_EVALUATE_CACHE`, keep the handler idempotent: inspect the delivered cache flag, derive the contribution from current ownership/count/state, and request only affected flags when a cache-relevant transition becomes dirty. Do not call `EvaluateItems` every frame or accumulate the same bonus on every cache pass.

## Render Callback Rule

The callback signature tells you what arguments are delivered, not how to mix
them. For manual world-following sprites, write a coordinate ledger and select
one adapter:

- Default logical marker: owner world position plus declared world offset,
  exactly one `Isaac.WorldToScreen`, no implicit `PositionOffset` or callback
  `RenderOffset`.
- Rendered-body match: a discovered project helper deliberately owns visual
  offsets, camera behavior, callback offset, and pass corrections. Apply each
  contribution once and test the helper contract.

If conversion fails, skip the owned draw rather than render a world coordinate.
State which render modes are accepted; do not let a one-pass marker draw again
in reflection/refraction merely because the callback fired there.
