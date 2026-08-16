# Optional Dependency Gates

Use this when code touches EID, CuerLib, StageAPI, Mod Config Menu, Encyclopedia, Boss Bars, or any global provided by another mod.

## Dependency Class

- Official API or project-owned code: default route. Prefer it before adding a library dependency.
- Required dependency: the mod should stop or degrade loudly if missing, and metadata/documentation must say so.
- Optional dependency: wrap calls in a guard and provide fallback behavior.
- Soft integration: load extra descriptions/config/wiki only when the target mod exists.

## Hard Rules

- Never call optional globals at top level without a guard.
- Do not add a new required dependency just to shorten an implementation. Use an official API fallback or a small project-owned helper unless the user explicitly requests the dependency.
- Prefer `if EID then ... end` style for simple EID registration.
- For larger integrations, put guarded code in a compatibility module and load it from a known place.
- If a dependency is required, make that explicit in the handoff and final report.
- Do not let missing optional mods break core item behavior.

## Review Checklist

- Missing dependency behavior is defined.
- Load order is safe.
- Optional module does not mutate core state before dependency check.
- Compatibility code can be skipped without syntax/runtime errors.

## Late Availability Is A Separate Condition

Use a retrying optional-integration path only when the current project proves
that the optional global or capability can appear after the mod's first load.
A simple missing dependency does not justify per-frame polling.

- Put all registration in one idempotent `tryRegister` helper.
- Check the required capability, not only a global name.
- Mark success only after the complete registration succeeds; successful calls
  must stop future retries and must not duplicate descriptions, callbacks, or
  modifiers.
- Choose an existing project-owned safe retry hook or documented bounded window.
  If late availability is not proven, use one guarded registration attempt.
- Missing forever remains a supported optional-dependency outcome: core gameplay
  must not wait for, save, or fail because of it.