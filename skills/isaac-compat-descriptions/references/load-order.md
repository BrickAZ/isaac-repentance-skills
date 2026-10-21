# Load Order And Module Organization

Use this when adding description or compatibility files.

For returned tables/factories, `include`/`require`, namespaces, shared-instance
authority and cycles, use
[isaac-mod-architecture](../../isaac-mod-architecture/references/module-loading-and-exports.md).
For EID queries, current language and modifier rebinding, use
[isaac-eid-compat](../../isaac-eid-compat/references/dynamic-descriptions.md).
This file owns only the integration's place in the discovered load sequence.

## Rules

- Load core helpers before content modules that depend on them.
- Load text/description modules after ids exist or in the same style the repo already uses.
- Guard optional integration modules at the entry point or inside the module before API calls.
- Keep compatibility files separate from item mechanics when the integration is non-trivial.
- Resolve the already-loaded provider after it is ready. Loading a description
  before gameplay is possible only with a safe deferred lookup or a discovered
  registration point; it is not permission to replay a gameplay module or to
  make optional EID a prerequisite for the effect.
- Do not spread one integration across many unrelated files unless the repo already has that structure.

## Review Checklist

- Include/require path matches the file location.
- Missing optional dependency does not crash.
- Re-loading binds to the current live provider and intended registrations;
  verify the target API's replace/remove behavior instead of assuming deduplication.
- Language files are only loaded when their APIs are available.

