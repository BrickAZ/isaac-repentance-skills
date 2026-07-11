# Config Contract

Use this reference after project discovery. It prevents a settings request from
silently becoming a gameplay or dependency decision.

## Decision Split

| Question | Owner | Default rule |
| --- | --- | --- |
| Setting name, label, default | User/design authority | Keep `TBD` when absent |
| MCM required or optional | Project declaration/user | Undeclared means guarded optional |
| Saved-data shape and migration | State lifecycle | Discover current convention |
| What existing marked content does after toggle | Mechanic contract | Never infer from UI choice |
| Which new owned events the setting gates | Content/mechanic skill | Limit to explicit ownership |
| Localized wording | Compatibility/descriptions | Discover locales first |

## Safe Flow

1. Load a plain configuration table through the project convention.
2. Validate type, known fields, and schema version before use.
3. Recover malformed or missing fields to the approved default. If no default
   is approved, stop at `TBD` rather than writing a silent policy.
4. Expose the setting through an optional guarded UI only when it exists.
5. Have the owned gameplay creation/read path consume the setting.
6. Define separately whether existing runtime objects continue, settle, or are
   cleaned when the value changes.

## Minimum Tests

- UI library absent: mod loads and core feature uses the approved value.
- UI library present: one setting registration, correct current value, no
  duplicate registration after reload/start callbacks.
- Missing save, malformed JSON/table, wrong field type, and older schema.
- Each setting value gates only its owned path.
- Existing runtime content follows the explicit mechanic contract.
- Every discovered locale has the intended setting text.
