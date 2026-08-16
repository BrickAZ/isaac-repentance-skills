# EID API Contract Snapshot

This bundled note is an offline routing aid, not proof of the API installed on a player's machine.

## Provenance

- Primary source: https://github.com/wofsauge/External-Item-Descriptions/wiki/Adding-Descriptions
- Retrieved: 2026-08-01
- Scope: EID description registration and load-order guards documented by the EID maintainers.

## Stable Contract

1. Treat EID as optional unless the target project explicitly declares it as required.
2. Check that the runtime `EID` global exists before any call. Never infer availability from a folder name, Workshop subscription, or reference mod.
3. The documented common registration methods are `EID:addCollectible`, `EID:addTrinket`, `EID:addCard`, `EID:addPill`, and `EID:addEntity`. Verify the installed signature before writing code.
4. Registration IDs are runtime subtype IDs. Resolve them from this mod's registered content; do not substitute XML-local IDs or hard-coded global ItemConfig positions.
5. EID documents `EID_POST_LOAD` for mods that load before EID. Use it only when the installed build exposes that callback; otherwise use a discovered, bounded registration point.
6. Registration must be idempotent. A late-load retry may continue only until the first confirmed success.
7. EID absence must not disable mechanics, XML localization, or another description path.

## Version-sensitive Surface

Language identifiers, markup, inline icons, transformations, conditional descriptions, callbacks, and helper functions can change. Inspect the installed EID docs/code before using them. Unknown fields remain `TBD - user decision required` when they are user choices, or unresolved project facts when discovery is still possible.

## Branch Tests

- EID absent: no call, no error, core behavior intact.
- EID present: only discovered IDs/languages are registered.
- EID loads late: registration happens once.
- Repeated bootstrap/reload: no duplicate registrations.
- Unsupported or incomplete API: skip the optional integration and report the missing surface.
