# Synergy Review Checklist

## Automated Checks

- Prove each required input is necessary and each excluded input is rejected.
- Prove player A qualifying does not grant the result to player B.
- Prove repeated update/callback delivery cannot double-apply the result.
- Prove the result retracts or reconciles after every supported input-change path.
- Prove unknown/foreign content receives no mutation.

## In-Game Checks

- Test normal acquisition order and reverse acquisition order.
- Test co-op, twins where relevant, and an owner leaving or dying.
- Test a room transition, reroll/removal path, and reacquisition.
- Test the actual visual, damage, collision, or cache behavior that static/Lua
  tests cannot emulate.
