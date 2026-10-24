# Method Adapters And Registration Lifetime

Use this when a project's callback helper accepts method names or substitutes
an instance for the engine's Mod argument. Read the helper before interpreting
its call site. `Item:AddCallback(id, "OnUse")` may be a custom adapter; native
`mod:AddCallback` receives a function, not that string. A static validator that
only scans direct registrations cannot prove the adapter executes correctly.

## Adapter Contract

Record the native registration owner, captured instance, method lookup policy,
engine arguments forwarded, filter, priority, exact return policy and removal
handle. Directly returning the method call preserves `false`, `nil` and multiple
return positions; `result or nil`, boolean coercion or a missing `return` can
change callback control flow. The engine still interprets only the returns
documented for that callback and target build.

Dynamic lookup sees method replacement on the captured instance. It does not
follow a replacement registry object. For class-copy and instance semantics,
read [the architecture reference](../../isaac-mod-architecture/references/classes-and-method-dispatch.md).
Use a direct function when runtime method replacement is not needed.

## Small Adapter Example

This optional pure Lua helper illustrates the contract. It does not add a class
framework or change a project's existing callback API. Its owner is fixed for
the binding's lifetime. Reconstructing that owner requires disposing the binding
and binding the new owner. Discover native methods/callback IDs before adapting it.

```lua
return function(mod, owner, callbackId, methodKey, filter, priority)
    assert(callbackId ~= nil, "callback id is missing")
    assert(type(owner[methodKey]) == "function", "callback method is missing")
    local function handler(_, ...)
        local method = owner[methodKey]
        assert(type(method) == "function", "callback method is missing")
        return method(owner, ...)
    end
    if priority == nil then
        mod:AddCallback(callbackId, handler, filter)
    else
        mod:AddPriorityCallback(callbackId, priority, handler, filter)
    end
    local attached = true
    return {
        Destroy = function()
            if not attached then return end
            attached = false
            mod:RemoveCallback(callbackId, handler)
        end,
    }
end
```

Keep the wrapper identity: removing `owner[methodKey]` does not remove the
different function registered above. Missing methods should produce a useful
initialization/runtime failure; returning an arbitrary `false` as a fallback can
cancel damage, spawning or another callback-specific operation.

## Duplicate Registration Versus Engine Reload

- Executing a registering module twice during one live Mod instance can add two
  callbacks. The engine has not necessarily performed an unload between calls.
- A supported native unload/reload may remove that Mod's old callbacks. Verify
  the selected build and path instead of claiming every reload duplicates them.
- Engine callback removal does not prove EID modifiers, ImGui elements or cached
  closures were removed or rebound. Verify each external owner separately.
- An author may explicitly support restart-only development. Document and test
  that scope; a full hot-reload implementation is not a default requirement.

For REPENTOGON unloading use the matching-build
`isaac-repentogon-callbacks` contract. The inspected dispatcher implements
per-Mod removal after its unload callbacks; the
[public unload docs](https://repentogon.com/enums/ModCallbacks.html#mc_pre_mod_unload)
describe the Mod/shutdown arguments. This is source evidence, not a performed
game reload or a guarantee for every build.

Run `lua <skill-dir>/tests/test-method-adapter.lua`. It executes the example
against an explicit registration ledger: arguments, returns, method/object
replacement, priority/filter, removal identity and unrelated callbacks. Native
delivery, ordering and actual reload cleanup require target-game evidence.
