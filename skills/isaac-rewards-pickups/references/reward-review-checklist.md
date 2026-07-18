# Reward Review Checklist

- [ ] Explicit reward values are locked; omitted values remain `TBD` or a labeled suggestion.
- [ ] Source and allowed candidates are stated.
- [ ] Candidate validation happens before spawn or Morph.
- [ ] Repeat boundary and de-duplication key are stated.
- [ ] Player/entity owner and co-op behavior are stated where relevant.
- [ ] Invalid optional rewards do not create blank content.
- [ ] Failed replacements preserve the original pickup.
- [ ] Unrelated and third-party content remains untouched unless explicitly targeted.
- [ ] Tests cover valid, invalid, repeated, and compatibility cases.
- [ ] A collision-triggered side effect has confirmation evidence, a player/source de-duplication key, and stale-candidate cleanup.
- [ ] A delayed reward distinguishes entitlement from spawn; target context is proven and pending state clears only after settlement.
- [ ] Unspecified expiry/carry-over behavior for an unrealized entitlement remains `TBD` or user-approved.