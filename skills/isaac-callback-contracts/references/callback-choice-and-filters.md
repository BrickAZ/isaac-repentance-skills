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
| Draw feedback | `MC_POST_RENDER` | presentation-only state; no core mutation by default |

## Filtering Rule

Use the callback registration filter when the API supports it. Keep additional semantic guards in the handler, because registration filters rarely express item ownership, challenge gate, damage source, or state lifetime completely.

## Timing Rule

Write down whether the mechanic needs to act before an event, at the event, after the event, or once per frame. Do not substitute a frame update for an event callback merely because it is easier to find.
