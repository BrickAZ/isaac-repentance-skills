# Reskin Route Review

Use this review after project discovery.

| Question | Exact-path override | Runtime replacement | Null Costume |
| --- | --- | --- | --- |
| Does it replace an existing native path globally? | Yes | No | No |
| Can it be a resource-only mod? | Yes | No | Usually no |
| Is state owned per actual player? | Not applicable | Required | Required for Add/Remove |
| Main compatibility risk | Load order and broad tables | Reload/state reset | Priority and occlusion |
| Default hot-path policy | No Lua needed | No per-frame asset load | No repeated reapply loop |

## Review Gates

1. Confirm the requested native surface.
2. For a vanilla override, inspect the supported version's native source and record the exact resource root, relative directory, filename, case, and extension. Do not derive the final key from memory or another mod.
3. Discover the consumer contract: standalone image, spritesheet cell, ANM2 crop/layer/index, or broad XML table.
4. Preserve canvas size, format, pixel density, alpha behavior, atlas cells/crops, indices, and frame order. Exact path alone does not make a replacement compatible.
5. Discover every resource root and same-relative-path collision.
6. Choose the narrowest carrier that meets the behavior. Do not upgrade a resource-only replacement to Lua without a runtime requirement.
7. Keep load order, occlusion, and optional-mod policy visible as user decisions.
8. Verify normal/tainted, co-op, continue, revive, transformations, and supported version roots where those surfaces apply.
9. Separate static path/layout proof from in-game proof of which override actually loaded.

## Common False Positives

- The directory and filename match, but the PNG canvas or extension changed.
- The sheet dimensions match, but cells were rearranged or completed art was globally rescaled.
- A replacement has an alpha channel, but its intended transparent regions contain opaque or keyed-color residue.
- `metadata.xml` exists or was generated, so the agent assumes the intended resource loaded.
- One load order worked, so the agent claims compatibility with every mod that targets the same native path.
