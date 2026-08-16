# Transformation And Form Contract Reference

## Route Selection

| Route | Authority | Key test |
| --- | --- | --- |
| Vanilla engine form query | Proven official form enum/API | Does the engine already calculate this form? |
| Custom reversible transformation | Current per-player contributor qualification | Does item loss immediately or conditionally deactivate it? |
| Custom permanent transformation | Stable saved activation key plus idempotent runtime rebuild | Can reload/continue replay the reward or lose the form? |
| Display-only group | EID/encyclopedia/progress UI adapter | Does core gameplay survive when the adapter is absent? |
| Actual custom character | Player registration and character lifecycle | Is a different PlayerType truly required? |

Do not collapse these routes. A visual costume can represent any of them, but
does not determine gameplay authority.

## Contributor Counting

For each contributor, record:

- stable local identity and runtime lookup;
- whether it is a collectible, trinket, temporary effect, character/form state,
  or declared third-party content;
- unique presence versus copy count;
- point weight and cap if any;
- locked/unavailable/disabled behavior;
- reroll, removal, duplication, and temporary-grant behavior.

Compute one per-player qualification result from these rules. Do not use visual
inventory order, item atlas frames, or global runtime IDs as contributor keys.

## Edge State Machine

Use explicit previous/current qualification:

| Previous | Current | Action |
| --- | --- | --- |
| false | false | Ensure reversible grants are absent; no activation feedback |
| false | true | Activate once; add owned grants/presentation; persist if permanent |
| true | true | Reconcile idempotently; never replay one-time rewards |
| true | false | Remove only reversible owned grants; permanent form remains active |

For a permanent form, the saved activation key becomes gameplay authority after
the first valid transition. Inventory may still drive progress display, but must
not silently undo the form.

## Effect Ownership

Transformation effects can include cache stats, hidden collectible effects,
abilities, costumes, familiar counts, status immunity, audio/visual feedback,
unlocks, or room rules. Assign each effect an owner token/key and removal path.

Do not remove a shared hidden effect or costume only because the transformation
no longer needs one copy. Reconcile the transformation's own contribution
against other project/engine sources.

## Presentation Boundary

EID progress, transformation icons, encyclopedia pages, costume layers, sounds,
and shaders are adapters. Guard optional APIs and load actual assets. Core
qualification and gameplay must still work without them unless the user has
explicitly declared a hard dependency.

## Review Checklist

- Route is classified and authority is singular.
- Contributors use stable identities and explicit copy/temp-effect semantics.
- Threshold and per-player/co-op policy are explicit.
- Activation is edge-triggered and replay-safe.
- Reversible versus permanent behavior is explicit.
- Granted effects/costumes have exact ownership and removal rules.
- EID and art are presentation adapters, not gameplay registration.
- Reroll, removal, duplication, reacquisition, death, and continue are tested.
- No custom `PlayerForm` enum or API is invented.
- Static, mock, and in-game evidence remain separate.

## Common Failures

- Treating an EID transformation icon as an engine form.
- Hard-coding global runtime collectible IDs.
- Counting all co-op inventories together.
- Replaying activation rewards every cache evaluation or room entry.
- Removing a permanent form after contributor loss.
- Leaving a reversible form active after reroll.
- Removing hidden effects/costumes owned by another source.
- Converting PlayerType to avoid defining a normal transformation contract.
