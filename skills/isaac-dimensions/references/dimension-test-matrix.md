# Dimension Test Matrix

| Case | Required result |
| --- | --- |
| Capability absent | No unsupported API call, no fabricated id, and explicit user-approved fallback or blocked result. |
| Capability present | Entry reaches the proven target context without changing unrelated vanilla/third-party state. |
| Return | Player returns to the recorded origin context with intended state restored or cleared. |
| Re-entry | Repeated entry follows the declared reuse/recreate policy without duplicate state. |
| Death, reload, run end | Target and origin state follow the declared cleanup/save policy. |
| Optional API absent/unsupported | Core mod remains safe; optional Dimension feature is omitted or follows the approved fallback. |
| Room network inside target | Room-network tests run only after target context entry is proven. |

A same-run test must exercise custom entry, return, then a relevant vanilla/other-mod Dimension route when coexistence is promised.
