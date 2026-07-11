# Input Interception

Use this when feedback temporarily blocks controls, consumes input, or creates a modal popup/menu.

## Hard Rules

- Do not block all controls unless the design explicitly says the game should pause or modal-lock.
- Use Isaac action constants where possible.
- Define release conditions: timer, confirmation, cancellation, room transition, game end.
- Be careful with priority callbacks; state why early/late priority is needed.
- Restore normal input even if the player changes room or exits the run.

## Prompt Checklist

- Action(s) to intercept.
- Hook mode.
- Priority.
- Owner state.
- Release condition.
- Multiplayer behavior.

