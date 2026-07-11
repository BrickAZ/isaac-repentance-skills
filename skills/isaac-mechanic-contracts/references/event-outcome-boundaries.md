# Event And Outcome Boundaries

Natural-language mechanics often collapse several events into one word such as "use", "hurt", "kill", or "spawn". Split them before choosing callbacks.

## Common Splits

| Vague wording | Events that must be separated |
| --- | --- |
| "use the item" | button press, eligibility check, failed attempt, successful activation, continuing effect, settlement |
| "take damage" | incoming hit, eligibility filter, cancellation/rewrite, post-hit reward, delayed settlement |
| "kill an enemy" | lethal hit, entity death, replacement/minion death, reward spawn, room-clear state |
| "spawn a card" | generation decision, owned-target validation, pickup spawn, HUD presentation, use callback |

## Rule

State which event changes state and which event merely observes it. A failed attempt must not accidentally consume, expire, or arm a mechanic unless that is an explicit design choice.

## Example

For a conditional active item, do not say "on use, consume three cards and create a reward." Instead define:

1. Attempt: player presses use.
2. Failure: fewer than three eligible cards; no consumption and no charge loss.
3. Success: remove exactly three cards, create the reward, record successful use.
4. Expiration: only an unused armed item expires at floor end, if the design says so.
