# Source, Surface, Mode, And Validation Contract

Choose the native consumer and art mode before changing pixels. They are separate axes.

## Two Independent Axes

### Surface / consumer

Examples include player skin, head decoration, body costume, portrait, name image, character-select icon, co-op icon, death portrait, HUD image, and another project-proven surface. The consumer owns canvas, display scale, source template, mapping, and Alpha policy.

### Art mode

| Mode | Purpose | Silhouette rule |
| --- | --- | --- |
| `pure-recolor` | Same anatomy and outline with changed color/internal pixels | Source Alpha must remain equal |
| `original-full-skin` | Original character on an existing coordinate/animation contract | Controlled Alpha additions/removals are allowed inside approved owning masks |
| `separate-decoration` | Independently layered hair, hat, horn, cloak, or clothing | Validate the decoration and base independently |
| `independent-composition` | A separately composed portrait, name, menu, or other non-atlas surface | Follow that consumer's measured source contract; do not inherit player-atlas rules |

`independent-ui-surface` is not a fourth silhouette mode. A name image is a surface and may use `independent-composition`; a player skin is another surface and may use `pure-recolor` or `original-full-skin`.

## Alpha Policy

Declare one policy per output surface after measuring its native source or project contract:

- `binary`: only fully transparent and fully opaque pixels are allowed.
- `source-matched`: permitted Alpha values and placement follow the measured source.
- `palette-plus-coverage`: visible RGB and Alpha coverage follow a measured UI/font/surface contract.
- `unrestricted-but-clean`: semi-transparency is allowed, but detached fringe, dirty backing geometry, and accidental mattes still fail.

Do not impose binary Alpha across a project. A player atlas, UI name image, portrait, and effect can legitimately use different policies.

## Contract Consistency Preflight

Before generation and again before validation, list:

1. selected surface/consumer;
2. selected art mode;
3. Alpha policy;
4. approved silhouette changes and owning masks;
5. identity requirements that require visible geometry;
6. every validator assertion.

Stop before generation when any contradiction remains, including:

- `original-full-skin` plus complete source-Alpha equality;
- requested coat/shoulder silhouette plus body Alpha additions forbidden;
- source-matched semi-transparent UI edges plus project-wide binary Alpha;
- exact native dimensions required plus an unmeasured generator result treated as final;
- separate decoration requested plus validation performed only against the base skin;
- independent native surfaces plus one master image resized into every consumer.

Do not weaken a correct consumer contract merely to make a candidate pass. Correct the selected mode, mask, policy, or candidate first.

## Identity Distribution Gate

Use this gate only when the user-approved identity ledger requires features across multiple components. Record each must-survive feature against head frames, body frames, special frames, portraits, and small UI surfaces. Mark `required`, `simplified`, `optional`, or `omitted by scale`.

If removing one decoration leaves an `original-full-skin` as only a vanilla recolor while the approved ledger requires a coat, shoulders, body structure, or another silhouette-bearing feature, report **technical crop pass / identity-distribution fail**. This does not create a universal rule that every full skin must change body Alpha; the user's approved identity ledger remains the authority.

## Deterministic Tools

Measure a PNG surface:

```powershell
powershell -ExecutionPolicy Bypass -File <skill-directory>/scripts/inspect-png-surface.ps1 -Path <png> -Json
```

Validate changed pixels against the chosen mode, approved mask, and ANM2 crop manifest:

```powershell
powershell -ExecutionPolicy Bypass -File <skill-directory>/scripts/validate-owned-crops.ps1 -Mode original-full-skin -Source <source.png> -Output <output.png> -Manifest <manifest.json> -ApprovedMask <mask.png> -Json
```

These tools prove measurable file contracts only. They do not prove identity, proportion, beauty, pivot motion, consumer loading, or in-game rendering.

Treat low minimum pixel counts and required identity colors only as `blank-frame guard` or `missing-identity-signal guard`. Never report them as visual-quality proof.
