# State Machines And Exclusions

Use this reference for mechanics with delay, probability, repetition, replacement, or restrictions.

## State Machine Rule

Name states and transitions in plain language before naming tables or callbacks.

Example for delayed damage:

```text
Idle -> EligibleHit -> Deferred -> Settled
                 \-> OriginalHit
Deferred -> Interrupted -> Settlement policy
```

The contract must state which inputs cause each transition and whether a transition can run more than once.

## Exclusion Matrix

For each mechanic, list categories rather than writing a vague "ignore special cases":

- source/event types that are eligible;
- source/event types that are excluded;
- self-created follow-up events;
- cancelled/immune/fake events;
- challenge-only or owner-only gates;
- second player, duplicate ownership, and item loss behavior;
- room, floor, run, death, and reload interruptions.

## Re-entry Policy

Choose one policy explicitly:

- `ignore`: later trigger does nothing while armed;
- `refresh`: timer/state resets;
- `stack`: record another independent instance;
- `replace`: discard prior state for new state;
- `queue`: preserve ordering;
- `settle first`: resolve old state before accepting new state.

Do not let callback ordering make this decision accidentally.
