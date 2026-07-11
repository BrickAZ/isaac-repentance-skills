# Runtime Localization Architecture

Use this reference when runtime text, fonts, or visual assets vary by game
language.

## Choose A Pattern

### Minimal Optional Adapter

Use a small project-owned table when only a few strings or one optional
description integration need localization. Keep core gameplay on official API
and load the optional adapter only behind its dependency guard.

### Central Registry

Use one translation module when the mod has many text keys, item classes,
fonts, or localized visual assets. It should:

1. Load a known default locale first.
2. Register only discovered or explicitly supported locales.
3. Expose one text resolver and one font/asset resolver.
4. Fall back from requested locale to default locale, then to a safe project
   fallback.

Use a declared library registry only when the project already requires it.
Otherwise keep the registry project-owned.

## Code Mapping Contract

Keep these distinct when necessary:

- Game option code, such as the value read from the current language option.
- Internal translation-table key.
- Optional integration code, such as an EID locale key.
- Asset suffix or path segment for a localized texture.

Store mapping in one table. Do not infer a filename by concatenating an
unverified language code.

## Localized Assets

For language-specific PNG or ANM2 text textures:

- Resolve the current locale to a verified asset path.
- Verify the requested asset exists before replacing a spritesheet.
- Use the default-locale asset when the requested one is absent.
- Cache the selected sprite and invalidate it only when the language changes.

## Required Checks

- Each supported locale resolves text or intentionally falls back.
- Missing locale, font, or PNG uses the documented fallback without crashing.
- Optional EID/MCM/wiki modules can be skipped without changing core gameplay.
- Text is tested in game when font glyph coverage or layout matters.
