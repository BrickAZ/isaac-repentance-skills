# Familiar Review Checklist

Use this before declaring familiar work complete.

## Identity And Registration

- Is the route cache-owned, temporary, or an owned vanilla/wisp change?
- Are type, variant, subtype, XML, ANM2 path, and animation names verified?
- Does every callback filter the intended familiar identity?

## Count And Owner

- Is target count derived only from its stated authority?
- Does a count change request the verified cache refresh?
- Does each instance use its actual owner rather than player zero, an index, or variant alone?
- Do two players and duplicate copies remain separate?

## Behavior And Damage

- Is init idempotent after cache recreation?
- Does one state own movement at a time?
- Are follower membership transitions explicit when leaving/returning to follow?
- Are target validity, collision damage source, cadence, and repeat-hit guard defined?

## Lifecycle And Proof

- Does removal align with the source count so the engine will not unexpectedly recreate it?
- Are room, floor, death, reload, and item-loss policies explicit?
- Are third-party APIs optional unless declared by the project?
- Did tests cover registration, count/refresh, owner separation, duplicate copies, excluded targets/events, and cleanup?
- Were in-game checks listed for movement, animation, collision, co-op, and reload?
