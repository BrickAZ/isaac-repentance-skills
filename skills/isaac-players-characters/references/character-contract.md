# Character Contract

Write this before implementing a playable character or alternate variant.

## Identity

- Registered player name and resolved type.
- Whether an alternate/tainted form exists and how it is resolved.
- Display, portrait, costume, and player XML surfaces actually present.

## Start Boundary

Specify each starting grant separately: new run, continue, player join, revive,
and reinitialization. Starting content must be idempotent at the chosen
boundary.

When any boundary is not user-approved, keep it `TBD`; do not silently select
“new run only”, “never on revive”, or another familiar policy. A proposed
default must be labeled `Suggestion` and remain out of implementation.

## Co-op And State

- Use a per-player owner such as existing project player data or a verified
  stable key.
- Decide whether twins share, copy, or independently own character state.
- Define cleanup for death, player removal, new room, new level, new run, and
  save/load only when the mechanic needs those boundaries.

Describe an unknown implementation by state purpose and owner. Do not turn a
contract label into a fake code fact such as `hasStartingCardGrant` or
`reviveUsedThisFloor`; name a concrete field only after discovering it in the
project.

## Visual And Text Surfaces

Route visuals to `isaac-anm2-visuals`. Route optional EID/MCM/wiki and runtime
text to the compatibility/localization skills. They must not determine player
identity or core gameplay.
