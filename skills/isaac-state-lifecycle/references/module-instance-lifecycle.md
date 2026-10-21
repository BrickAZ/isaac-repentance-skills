# Module Instance Lifecycle

Use this when a shared module, cached factory or integration survives longer than
the world/Mod instance it references. Read
[the architecture contract](../../isaac-mod-architecture/references/module-loading-and-exports.md)
for loader choice and public interfaces.

## Separate The Authorities

| State | Owner and validity |
| --- | --- |
| Loader result | Native/project cache; a cache hit proves identity only, not current registration or live dependencies. |
| Runtime instance | Current initialization generation; owns closures, handlers and temporary resources. |
| Prediction cache | Context token including the mechanic's relevant seed/player/eligibility inputs; invalidates on actual input changes. |
| External registration | Target API/object, stable owned ID and current callback; may outlive the Mod or be cleared independently. |
| Saved gameplay state | Approved plain data under the existing save authority; reconstructs runtime objects. |

Do not serialize module tables containing functions, Mod/player/room userdata or
engine resources. A module cache is not a reason to add SaveData. Preserve the
approved persistence policy rather than turning transient instance state into a
new permanent store.

## Replacement Protocol

1. Discover whether the actual operation re-executes modules, recreates the Mod,
   resets caches, removes callbacks or clears external UI/description objects.
   Treat `luamod`, `luareset`, disabling a mod and a new game run separately;
   record build/source evidence instead of assuming identical behavior.
2. Detach this instance's callbacks/resources at the verified lifecycle point.
   Keep cleanup scoped to the exact owner; never clear all mods' registrations.
3. Mark the old instance disposed, release cached world objects and prevent
   stale callbacks from writing into replacement resources with reused IDs.
4. Recreate with current dependencies and register for the new live generation.
   A cached pure factory can be reused when current Mod/context is passed at
   invocation; an already-created instance capturing old dependencies cannot.
5. Publish the replacement through the discovered owner. Rebind consumers that
   captured the old object, or use an intentional current-provider lookup at
   call time with a defined ready/failure result.
6. Restore only approved saved plain data and validate current ownership. A new
   run or provider replacement may require invalidation without any disk write.

`registered` and `disposed` are different facts. Destroying an instance must not
leave a permanent guard that silently prevents a valid replacement. Conversely,
resetting a guard alone does not remove old registrations. Repeated cleanup is
safe, and an old cleanup call cannot destroy the replacement generation.

## Checks

Test duplicate bootstrap, independent factory instances, shared consumers,
cache invalidation, old-method invocation after teardown, new Mod with a cached
factory, external roots removed while the loader cache remains, and no-game or
invalid-owner queries. Preserve another mod's resources. Confirm native cleanup
timing separately; a mocked unload event cannot establish the engine's order.
