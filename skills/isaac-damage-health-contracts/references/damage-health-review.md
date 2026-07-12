# Damage and Health Review

| Route | Target | Eligible source/flags | Original hit | Health result | Credit | Re-entry guard | Lifecycle | Proof |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

## Required Negative Cases

- An excluded source/flag does not trigger or cancel the mechanic.
- A foreign hit is not mistaken for the mod's replacement damage.
- An owned replacement cannot recursively create itself.
- Two co-op players do not share a temporary guard or health result.
- Death, revival, removal, room transition, and reload do not retain stale guards.

## Evidence Levels

- **Static:** callback filter/return is tied to the discovered contract; source
  marker and all cleanup paths exist.
- **Controlled runtime:** record eligible, excluded, repeat, re-entry, co-op, and
  lethal-path behavior with narrow instrumentation.
- **In game:** confirm health UI, i-frame/contact cadence, death/revival, and
  damage credit for the actual target classes.

Static success does not prove that the engine accepted the callback return or
that the original hit resolved as intended.
