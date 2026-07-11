# Ownership And Multipliers

Trinkets can behave differently depending on whether they are held, smelted, gulped, golden, or duplicated.

## Questions

- Does the effect apply when held only?
- Does it apply when smelted/gulped?
- Does golden trinket double or otherwise scale the effect?
- Does each player own their own effect?
- What happens when the player drops the trinket?

## Implementation Notes

- Prefer the repo's existing helper style for player-keyed state.
- Use `player:HasTrinket(...)` for ownership checks.
- Use `player:GetTrinketMultiplier(...)` when the effect should scale.
- If scaling would break balance or logic, explicitly clamp or ignore multiplier.
