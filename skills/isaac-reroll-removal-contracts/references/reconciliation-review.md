# Reconciliation Review

## Desired-State Questions

- What current input predicate authorizes this effect?
- What owned state should exist when it is true?
- What owned state must disappear when it is false?
- Can the same reconciliation run twice without extra stat, entity, reward,
  timer, or marker changes?

## Automated Checks

- Test each implemented change source independently.
- Test repeated notification with unchanged eligibility.
- Test removal followed by reacquisition.
- Test player A changes without affecting player B.
- Test unknown foreign content remains untouched.

## In-Game Checks

- Exercise actual reroll/replacement mechanics, not only simulated counts.
- Check room transition, death, continued run, and reload according to the
  declared lifecycle boundary.
- Verify no visible effect, collision object, or spawned owned entity remains
  after removal.
