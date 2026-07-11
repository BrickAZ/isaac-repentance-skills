# Localization Synchronization

Use this when item text, metadata, EID text, config labels, wiki text, or translations change.

## Surfaces

- Base content XML and every discovered locale XML that owns the changed text
- Matching pool XML when pool names or pool text are involved
- EID description blocks or language files only when the project enables EID integration
- MCM display text and info text only when the project enables MCM integration
- Encyclopedia/wiki entries only when the project enables that integration
- `metadata.xml` when workshop-facing text changes

## Hard Rules

- Do not update only one language variant when matching variants exist.
- Each discovered locale surface should contain text for that locale; do not invent missing locales.
- If a surface is intentionally not updated, say why in the final report.
- Keep mechanical numbers consistent across languages.

## Text Review

Check:

- Item name.
- Pickup line.
- Long EID description, when EID integration exists.
- Charge/use instructions.
- Button prompts.
- Special limitations and edge cases.
- Icon tags and formatting markers.
