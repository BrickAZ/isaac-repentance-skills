# Shared Helpers And Constants

Shared helpers are useful when they make repeated logic safer.

## Good Shared Helpers

- Stable id lookup tables.
- Player key helpers.
- State reset helpers.
- XML/language helper scripts.
- Validator scripts.
- Debug logging wrappers that can be disabled.

## Rules

- Keep helpers small and named by what they do.
- Avoid helper modules that import every content module.
- Do not create helpers for one-off behavior.
- Keep constants close to the content type unless many modules need them.
