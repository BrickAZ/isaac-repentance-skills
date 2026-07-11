# Config Review Checklist

- [ ] Project discovery proves the save, UI, and locale conventions.
- [ ] User-chosen default is preserved; absent default remains `TBD`.
- [ ] Required versus optional dependency is explicit.
- [ ] Optional UI calls are guarded and core behavior has a fallback.
- [ ] MCM registration uses only documented `AddSetting` fields; a stub has not
      invented the production contract.
- [ ] A late optional UI API can register once when the project has a retry
      convention, and repeated updates cannot duplicate the setting.
- [ ] Saved data contains only plain serializable values.
- [ ] Missing, malformed, and old data have an explicit recovery path.
- [ ] Runtime preference and per-entity/per-player state are separate.
- [ ] Existing in-flight behavior is explicitly delegated to a mechanic contract.
- [ ] New gates only touch owned content; foreign mod content is untouched.
- [ ] Missing UI, both values, reload, malformed data, locales, and in-game
      toggle behavior are tested.
