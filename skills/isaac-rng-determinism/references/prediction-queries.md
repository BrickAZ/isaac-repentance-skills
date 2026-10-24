# Prediction Queries And Independent Random Streams

Use this when EID, a UI or another item previews a random result. A separate RNG
can isolate random draws; it does not isolate every operation called by the
query. A pool query that depletes the real pool, a shared RNG reset, a reward
spawn or a gameplay write is still a side effect. A `Get`/`Preview` name is not
proof of purity. Use `isaac-eid-compat` for presentation and
`isaac-repentogon-world` for version-specific native preview APIs.

## Prediction Contract

- Identify the actual scope/owner and inputs: seed, shift/algorithm, ordered
  candidates, eligibility, draw count and rejection policy. Same seed alone
  does not make different algorithms or candidate orders equivalent.
- The RNG factory supplies a fresh independent stream. Do not reseed or advance
  the gameplay-owned stream just to display information. Check the selected
  build's constructor and `RandomInt` signatures before adapting a snippet.
- Predict and execute the same approved plan for the same context. Reusing a
  committed plan and deterministic recomputation are both possible designs;
  neither grants a reservation when eligibility can change later.
- A cache key/invalidation rule must include relevant context changes. Do not
  force every mechanic to reset to a run seed or reroll on each render.
- Copy candidate data before destructive selection. Expose a safe display
  result according to the provider's ownership contract; nested mutable results
  need more than an array copy.

## Deterministic Selection Example

This pure Lua query selects scalar IDs without replacement. The caller supplies
the approved count and canonical candidate order. `newRng(seed)` is a discovered
project adapter returning a fresh stream whose `RandomInt(limit)` returns an
integer in `[0, limit - 1]`; it is not a promised native constructor signature.
The adapter validates engine-specific seed legality. There is no pool lookup,
gameplay RNG or effect application in the example.

```lua
return function(newRng, context)
    assert(type(context.count) == "number" and context.count >= 0
        and context.count % 1 == 0, "count must be a nonnegative integer")
    local candidates, result = {}, {}
    for i, id in ipairs(context.candidates) do candidates[i] = id end
    local count = math.min(context.count, #candidates)
    if count == 0 then return result end
    local rng = newRng(context.seed)
    for _ = 1, count do
        local index = rng:RandomInt(#candidates) + 1
        result[#result + 1] = table.remove(candidates, index)
    end
    return result
end
```

The example depends on a genuinely independent factory. Injecting the live
gameplay RNG or a factory with writes breaks that premise; the helper cannot
infer independence from an object's shape. Candidate snapshots must be built by
a separately verified non-mutating route. The algorithm is an example, not a
new reward/balance rule for the target mod.

## Observable Checks

Compare zero, one and many display queries followed by execution. At equal
context, effect-relevant results must match and gameplay RNG/pool/resources
must be unchanged by viewing. Cover input-order/eligibility changes, co-op
owners, invalidation and mutation of returned display data. An instrumented
factory or pool must expose contamination rather than silently making every
query pure in a test double.

Run `lua <skill-dir>/tests/test-prediction-query.lua`. Its deterministic stream
is a test adapter, not Isaac's RNG implementation. It checks the documented
selection/copy behavior and demonstrates a contaminated-factory control; native
RNG, pool and UI behavior still require selected-build evidence.
