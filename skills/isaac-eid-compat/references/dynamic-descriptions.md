# Dynamic Description Queries

Use this when EID displays a computed result, eligibility, counter or prediction.
The gameplay owner defines what happens; EID formats the same approved data.
For loader/export semantics use
[the architecture contract](../../isaac-mod-architecture/references/module-loading-and-exports.md).

## Provider And Query

1. Discover the already-loaded gameplay provider and its query API. A private
   local cache can remain behind exported methods. Do not re-include its module
   to obtain the query or copy the algorithm into a second authority.
2. Resolve the provider after its initialization. A modifier may register before
   gameplay modules only if invocation safely resolves the current provider at
   the verified ready point; missing provider/method means omit that optional
   addition and retain the existing description, not crash or invent a result.
3. A display query does not advance gameplay RNG, deplete item pools, spawn,
   use items, settle rewards or write gameplay state. Deterministic prediction
   and private memoization are allowed when they leave gameplay outcomes intact.
4. Query context includes the actual relevant player/source, seed and current
   eligibility inputs. Define when the prediction expires and whether later
   changes legitimately alter it; do not promise a locked future result unless
   the mechanic owns such a reservation.
5. Read the same result/plan that execution will use for the same context. A
   separately seeded prediction is valid only if it reproduces the approved
   algorithm and all relevant inputs without consuming its gameplay stream.
6. Sorting or decorating a returned shared table can corrupt the effect. Respect
   its ownership contract; copy before formatting, including nested tables when
   they are mutable. Keep computed display payloads plain; resolve needed player
   context transiently rather than caching RNG/world userdata across lifecycles.

## Language And Registration

- Use the installed EID language API for EID text. `Options.Language` and EID's
  selected language may differ; map the project's actual supported locales and
  fallback without forcing EID to change language.
- A module may return a registration factory accepting a locale. Load/cache the
  factory according to the project's loader contract, then invoke it for each
  intended locale. Caching a factory is different from skipping its invocations.
- Namespace modifier IDs by mod, feature and locale where each locale owns a
  distinct modifier. The condition checks the exact runtime object identity and
  current locale. Preserve the callback's documented description return contract.
- Check target-version duplicate semantics. The inspected EID source updates the
  condition/callback for an existing modifier name; that is not evidence that
  all EID registrations deduplicate, or that an old closure updates itself.
- After gameplay reconstruction, modifiers must resolve the current provider or
  be deliberately rebound. On unload remove only owned registrations through a
  verified supported API when needed. An old global boolean cannot prove that
  registration still exists in a replacement EID object.
- Keep EID optional. A missing/late EID or unsupported modifier API must not
  change core effects, content registration or base localization. Follow the
  bounded registration policy in `eid-api-contract.md`.

Source provenance: the inspected EID 5.23 source reports commit `bc0551a`;
same-name replacement above is a snapshot fact, not a universal guarantee.
Sources checked 2026-10-21: maintainer
[description guide](https://github.com/wofsauge/External-Item-Descriptions/wiki/Adding-Descriptions),
[modifier snapshot](https://github.com/wofsauge/External-Item-Descriptions/blob/bc0551a/features/eid_api.lua)
and [language snapshot](https://github.com/wofsauge/External-Item-Descriptions/blob/bc0551a/features/eid_language_manager.lua).
Verify the installed version before choosing exact calls and replacement/removal behavior.

## Evidence

Compare repeated queries with the same context: identical effect-relevant output,
unchanged gameplay RNG/pool/resources and no new registrations. Mutating the
display copy must not affect execution. Exercise missing provider, provider
replacement, different co-op owners, EID absent/late, EID-language override and
locale switching. Scripted tests prove these modeled contracts; native EID
rendering and actual reload/registration timing need a matching-build game check.
