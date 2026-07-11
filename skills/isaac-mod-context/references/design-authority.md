# Design Authority

Use this rule whenever a task includes a mechanic choice, reward policy,
numeric value, pool/quality decision, restriction, visual direction, or
player-facing wording.

- An explicit user decision is locked. Do not replace, rebalance, reinterpret,
  or silently improve it.
- An omitted design field remains `TBD`. A proposal is a labeled suggestion,
  not approved input.
- Do not turn a suggestion into Lua, XML, ANM2, or gameplay behavior without
  direct user approval or an explicitly approved project decision record.
- The agent may choose technical details that do not alter design intent:
  file placement, callback wiring, storage representation, formatting,
  validation, and test scaffolding.

Before implementation, record only relevant fields as `Locked`, `Approved`,
`TBD`, or `Suggestion`. Do not invent numbers or restrictions to make the
record look complete.
