# Project Discovery

## Stable Facts To Collect

| Surface | Inspect | Record |
| --- | --- | --- |
| Mod identity | `RegisterMod` call | Lua object variable, display name, bootstrap file |
| Code layout | bootstrap plus module folders | behavior owner and directories to scan |
| Module loading, when relevant | wrapper implementation and import callers | path resolution, native/project cache key, export shape, instance owner, import side effects and teardown/rebind |
| Content | existing XML files | exact file names, not assumed categories |
| Localization | file suffixes | every actual locale and matching content type |
| Verification | scripts and tests | command, runtime, and unavailable checks |

## Ambiguity Rules

- A `main.lua` file can be bootstrap, behavior owner, or both. Record which is
  observed; do not infer the destination for new code from its existence.
- A custom wrapper around `RegisterMod` or callback registration may hide the
  real object name. Record the wrapper and route to architecture/callback
  review rather than guessing.
- `local mod = ExistingMod` is an alias, not a second registration;
  `return function(...) ... end` is a function export until its caller proves
  what invoking it creates. A path such as `items.items` can be two actual
  directories, not an API category or evidence of a duplicate load.
- A wrapper named `Load`, `include` or `RequireOnce` can cache by its own keys.
  Discover whether it stores the export or factory result, its context and
  invalidation, and the target runtime/build. Missing implementation is
  `Unverified — discovery required`, not a user choice about technical paths.
- For EID loaded before gameplay, find both provider readiness and optional API
  availability. Defer reading a provider only to a verified ready point; do not
  invent a `scripts/` root, public registry or global mod name.
- A missing XML file can mean the project does not use that content type, not
  that the file should be created.
- A missing translated file means localization scope is unknown until the user
  or project conventions decide it.
