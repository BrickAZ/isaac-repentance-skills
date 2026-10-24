# Module Loading And Exports

Use this when another item, description, UI or compatibility module needs existing
functionality. Discover the current loader before selecting a pattern; do not
replace a working project convention with a framework from a reference mod.

## Loader Choice

| Loader | Documented baseline | Review consequence |
| --- | --- | --- |
| `include("path.module")` | Executes on every call; resolves within the calling mod | Repeated execution can create independent state and repeat top-level registration. One bootstrap can save the returned instance for all consumers. |
| `require("namespace.module")` | Caches by module name; identical names can collide across mods | Use a project-specific module namespace and verify the target runtime's cache/reload behavior. A cached value can retain old closures or skip needed registration. |
| Project wrapper or factory | Can add its own caching, injection or registration | Inspect the wrapper and callers. Record both native loading and project-owned instance policy. |

No loader is universally preferred. Pure modules can be executed again cheaply;
stateful instances need an explicit owner. Returning a table does not itself
cache it. `return function(...) ... end` exports a callable; inspect its caller
to distinguish a factory, installer or query. It does not by itself return an
initialized Mod. `local mod = ExistingMod` aliases an existing object; it does not register a
new Mod. Keep private locals and export only the needed interface.

Baseline sources: [Isaac additional Lua files](https://wofsauge.github.io/IsaacDocs/rep/tutorials/Using-Additional-Lua-Files.html)
and [Lua require](https://www.lua.org/manual/5.3/manual.html#pdf-require), checked
2026-10-21. They document cache/scope behavior, not every REPENTOGON build's
unload sequence. `package` is not universally available in Isaac's sandbox;
do not require `--luadebug`, replace global `require`, or clear another mod's
cache to solve ordinary content sharing.

## Export Contract

| Field | Establish before a second consumer is added |
| --- | --- |
| Export shape | Table, factory, data or another existing return contract; dot/colon calling convention. |
| Instance authority | Who loads/creates it, where it is stored, and whether consumers need the same identity or independent instances. |
| Query | Inputs, context/seed, return shape, readiness/failure result and permitted memoization; no gameplay RNG advancement, pool depletion or effect execution. |
| Effect | Explicit actual player/source, RNG and relevant flags; which existing owner handles costs, cooldowns and success. |
| Result ownership | Immutable-by-contract view, owned copy or deliberately mutable API; shallow copies do not isolate nested tables. |
| Dependencies | Initialization order, optional guards and when a provider can be resolved. |
| Lifetime | Cache key/invalidation, registration owner, teardown and how consumers receive the replacement. |

An existing callback is not automatically a public effect API. It may include
engine-only arguments, charge settlement, ownership checks or return semantics.
Discover whether the request needs the native full `UseActiveItem` route or only
an existing effect core. Preserve approved mechanics; route unclear behavior to
`isaac-mechanic-contracts` and active-use details to `isaac-active-item-mechanics`.

## Initialization And Namespaces

- A module table is not published until its right-hand-side construction ends.
  A child loaded during `mod.Items = { A = loadA(), B = loadB() }` cannot rely on
  `mod.Items.B` being ready; it may observe nil or a previous generation's table.
- Resolve a genuine dependency first or pass it to the factory. A deliberate
  declaration/binding phase can handle cycles; do not add one for independent
  modules. Deferred lookup is appropriate only when the provider is known to be
  ready at call time; handle a genuinely missing provider explicitly.
- Distinguish module-name/cache keys, Lua globals, registry fields and external
  registration IDs. A unique folder does not protect an unrelated ImGui ID or
  global. An `include`-only `scripts/` folder is not by itself a collision defect.
- Keep names and paths already in use. Rename only a demonstrated conflict with
  a complete caller update; never transplant reference-mod class APIs or roots.
- Register once per intended live instance/generation. Importing an effectful
  file twice is different from an engine-managed mod unload/reload. Discover
  which registrations the engine removes and which external systems retain.
- Reload re-executes the bootstrap and the loading branches it reaches; it does
  not execute every Lua file merely because the file exists. Keep native Mod
  cleanup separate from same-instance imports and external registrations.

For class helpers, method snapshots and returned state aliases, read
[classes-and-method-dispatch.md](classes-and-method-dispatch.md). A private
local name does not protect a mutable object returned to another consumer.

## Small Query/Effect Factory

This is a pure Lua interface example, not a mod bootstrap or an engine API.
Save the factory's returned instance once in the project's existing registry.
`buildPreview(contextKey)` must deterministically return an array of runtime IDs
without consuming gameplay RNG or pools; `apply(player, ids)` is the project's
approved effect function. The caller supplies a plain context token covering
seed, player and availability inputs relevant to its mechanic, and invalidates
when those inputs change. This example caches only the most recent context.

```lua
return function(buildPreview, apply)
    assert(type(buildPreview) == "function" and type(apply) == "function")
    local api, cachedKey, cachedIds = {}, nil, nil
    local destroyed = false

    local function CopyIds(ids)
        assert(type(ids) == "table", "expected ID array")
        local copy = {}
        for i, id in ipairs(ids) do
            assert(type(id) == "number" and id > 0 and id % 1 == 0)
            copy[i] = id
        end
        return copy
    end

    local function CheckLive()
        assert(not destroyed, "module instance was destroyed")
    end

    function api.GetPreview(contextKey)
        CheckLive()
        assert(type(contextKey) == "string" or type(contextKey) == "number")
        if not cachedIds or contextKey ~= cachedKey then
            local ids = CopyIds(buildPreview(contextKey))
            cachedKey, cachedIds = contextKey, ids
        end
        return CopyIds(cachedIds)
    end

    function api.Execute(player, contextKey)
        CheckLive()
        return apply(player, api.GetPreview(contextKey))
    end

    function api.Invalidate()
        CheckLive()
        cachedKey, cachedIds = nil, nil
    end

    function api.Destroy()
        if destroyed then return end
        destroyed = true
        cachedKey, cachedIds, buildPreview, apply = nil, nil, nil, nil
    end

    return api
end
```

This sample does not register callbacks. The discovered callback owner delegates
to the live instance; it does not import or create a fresh one on every call.
The array copy contract applies to scalar IDs only, not arbitrary nested state.
Teardown invalidates old methods; reconstruction creates a new instance and
updates consumers. Query purity still depends on the supplied builder.

Run `lua <skill-dir>/tests/test-module-contracts.lua`. The test extracts this
factory, checks shared identity, copies, explicit effect calls, invalidation and
stale-use rejection, and exercises separate loader doubles. It does not prove
native reload behavior; use `isaac-testing-debugging` for that evidence boundary.
