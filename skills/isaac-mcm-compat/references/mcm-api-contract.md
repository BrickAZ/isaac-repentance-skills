# Mod Config Menu API Contract Snapshot

This bundled note is an offline routing aid, not proof that Mod Config Menu is installed.

## Provenance

- Primary source: https://github.com/Zamiell/isaac-mod-config-menu
- Quick start: https://github.com/Zamiell/isaac-mod-config-menu/blob/main/docs/quick-start.md
- Retrieved: 2026-08-01
- Scope: Mod Config Menu Pure integration documented by its maintainers.

## Stable Contract

1. Treat MCM as optional unless the target project explicitly declares it as required.
2. The documented integration checks the runtime `ModConfigMenu` global and returns cleanly when it is absent.
3. The maintainers explicitly advise integrations not to initialize/invoke MCM with `require`, `dofile`, `pcall`, or `loadfile`; inspect the installed API instead.
4. The mod's own config state is authoritative. MCM controls read and write that state; they do not replace persistence, defaults, or validation.
5. Settings registration must be idempotent. Do not add the same category or control each update/render callback.
6. Labels, ranges, defaults, option types, callbacks, and persistence belong to the target project and user decisions. Do not copy them from another mod.

## Version-sensitive Surface

`AddSetting` and convenience `Add*` functions, option-table fields, localization behavior, duplicate removal, and late-load handling may differ by MCM version/fork. Verify the installed global's methods and the selected MCM implementation before calling them.

## Branch Tests

- MCM absent: approved defaults and core behavior still work.
- MCM present: controls reflect and update the real config owner.
- Repeated bootstrap/reload: controls are not duplicated.
- Invalid saved value: target-project validation repairs or rejects it without relying on MCM.
- Unsupported API/fork: skip optional UI and report the missing surface.
