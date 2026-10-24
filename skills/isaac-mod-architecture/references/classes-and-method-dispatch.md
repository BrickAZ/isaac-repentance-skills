# Classes, Instances And Method Replacement

Use this when a project already has a class/component helper, or when a caller
expects replacing a method or module to update registered behavior. For engine
registration and a runnable adapter, use
[method-adapters.md](../../isaac-callback-contracts/references/method-adapters.md).

## Discover The Actual Helper

Lua class helpers are project code, not an Isaac API or a required dependency.
Keep the existing module/table/factory pattern when it already fits. Before
using a helper, read its implementation and one constructor/caller together:

- A table made callable by `__call` is still a table. Constructor syntax alone
  does not imply a native function or engine userdata.
- `for k, v in pairs(base) do child[k] = v end` copies current field values.
  Later replacement of `base.Method` does not update the copied child method.
  Metatable-chain inheritance can behave differently; inspect the actual chain.
- Copying a nested table copies its reference. Mutable counters, lists and
  player state placed on a shared prototype can couple instances. Create
  independent state in the constructor when independence is intended.
- Discover whether the base constructor is called automatically or explicitly.
  Do not call it twice, or assume a copied method table initialized its state.
- Extra arguments/metadata such as `expectedType` are effective only when the
  helper actually consumes them. A shortened screenshot is not its full API.

## Three Replacement Boundaries

| Operation | What can observe it |
| --- | --- |
| Replace `owner.Method` on the same object | A wrapper that looks up `owner[key]` on each event sees it; a captured function keeps the original. |
| Replace `registry.Item` with a new object | A wrapper capturing the old `owner` stays bound to that object. Rebind it, or use an already-designed current-provider resolver. |
| Replace a base method after shallow-copy inheritance | Existing child copies keep the copied method unless deliberately updated. Do not claim live inheritance from a snapshot helper. |

Method replacement and instance reconstruction need separate contracts. Dispose
the old registration before binding a replacement when required by the actual
owner lifecycle. A resolver must also handle not-ready/disposed providers; it
is not a reason to add a global dispatcher to a small mod.

## Private State And Exported References

`local` hides a name, not an object returned by a public method. If `GetState()`
returns an internal table, callers can still mutate it. Choose an intentionally
mutable API, an owned copy, or a read-only contract and use tests appropriate to
that choice. A shallow copy is insufficient for mutable nested data. Do not
impose proxies or a deep-copy framework when scalar results or a narrow query
already meet the consumer's needs.

Evidence: Lua table/reference and metatable semantics from the
[Lua manual](https://www.lua.org/manual/5.4/manual.html#2.1), checked 2026-10-24.
These language rules do not establish native Isaac reload behavior or require
the reference mod's class implementation.
