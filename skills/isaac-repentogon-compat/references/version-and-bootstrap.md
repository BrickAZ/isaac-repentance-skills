# Full-release Gate and Bootstrap

## Helper Contract

`scripts/version-gate.lua` accepts observed `major.minor.patch` plus at most
one lowercase a..z suffix. It compares numeric tuples, then base < a < ... < z.
Leading zeroes, dev labels, uppercase, prefixed, four-part and arbitrary suffix
formats are unrecognized and fail closed. This is not universal SemVer or a
promise about future release naming.

`Gate.meetsRelease(actual,minimum)`: true/false for recognized releases, or nil
with reason for unsupported input.
`Gate.check(runtime,minimum,capabilityProbe)`: requires a table with sufficient
recognized Version, then optionally calls a lazy read-only probe. Probe returns
a table of named booleans, all literally true. MeetsVersion is not trusted.
The helper has no engine calls or state writes.

## Integration Shape

Adapt paths to the discovered project; this fragment is not a registered mod:

```lua
local Gate = include("scripts.compat.version_gate") -- pure project-owned module
local ok, reason = Gate.check(REPENTOGON, "1.1.2g", function()
    return {
        postLoot = type(ModCallbacks) == "table"
            and type(ModCallbacks.MC_POST_PICKUP_GET_LOOT_LIST) == "number",
        isInGame = type(Isaac) == "table"
            and type(Isaac.IsInGame) == "function",
    }
end)
if not ok then
    -- Show one localized diagnostic through the project's vanilla-safe route.
    return -- required: stop this mod; optional: return only from the enhancement
end
-- Load and register feature modules once, through their existing owner.
```

Here g is an example target including loot fixes; POST and RNG/Player first
appeared in d, preview RNG was fixed in f, Eternal Chest duplication in g.
Do not copy this minimum to unrelated mechanics. Capability existence still
does not establish correct returns, ready timing, or native fixes.

Passing the missing global as nil is safe. Do not build the availability table
outside the lazy function. pcall classifies a read-only probe error, not the
safety of a gameplay call. No registration, saving or spawning belongs in probes.

## Dev Builds and Initialization

Anonymous dev builds are rejected. Supporting one requires a separate verified
commit/build identity and feature/fix evidence; do not spoof its release string
or simply bypass checks. Resolve technical evidence yourself where accessible.

Resolve all required capabilities before including side-effectful modules.
One owner registers once. Failure messages should be clear and emitted once.
Review shipped XML/resources separately: they may be processed before Lua.
Cleanup owns only this mod's UI/state. Pure helper tests cannot prove packaged
mod initialization, engine callback semantics or correct game installation.
