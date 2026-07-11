# Static Checks

Static validators are useful when they check facts that do not require Isaac to run.

## Good Static Checks

- XML parses.
- Duplicate ids or names are absent inside a file.
- Referenced files exist at the expected path.
- A registered custom entity has a unique positive type/variant, a name, a valid ANM2, at least one spritesheet, and a defined default animation.
- A custom card/rune has a valid id, pickup id, and HUD key when `pocketitems.xml` exists.
- Language variants contain matching internal names.
- Skill directories contain `SKILL.md` and valid eval JSON.
- Test files exist for non-trivial behavior.

## Weak Static Checks

- Balance.
- Callback timing.
- Shader safety.
- Input behavior.
- Entity collision behavior.
- Whether an animation looks correct in-game.

For weak checks, report a manual in-game verification item instead of pretending the validator proves it.

## Extension Pattern

When adding a check:

1. Make the check deterministic.
2. Keep output actionable: file, field, value, and expected fix.
3. Use warnings for uncertain checks and failures for definite breakage.
4. Avoid network access.
5. Avoid modifying files from a validator.
6. Scope spawn checks to this mod's registrations and code. Unknown third-party entities are not static failures.
