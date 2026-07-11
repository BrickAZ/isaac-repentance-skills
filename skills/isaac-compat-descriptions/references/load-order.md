# Load Order And Module Organization

Use this when adding description or compatibility files.

## Rules

- Load core helpers before content modules that depend on them.
- Load text/description modules after ids exist or in the same style the repo already uses.
- Guard optional integration modules at the entry point or inside the module before API calls.
- Keep compatibility files separate from item mechanics when the integration is non-trivial.
- Do not spread one integration across many unrelated files unless the repo already has that structure.

## Review Checklist

- Include/require path matches the file location.
- Missing optional dependency does not crash.
- Re-loading does not register duplicate callbacks unnecessarily.
- Language files are only loaded when their APIs are available.

