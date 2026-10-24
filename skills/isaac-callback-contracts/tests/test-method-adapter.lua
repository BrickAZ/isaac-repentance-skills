-- Executes the documented adapter against a registration ledger, not Isaac.
local path = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local folder = assert(path:match("^(.*)/tests/[^/]+$"))
local file = assert(io.open(folder .. "/references/method-adapters.md", "rb"),
    "documented method adapter is missing")
local document = file:read("*a"):gsub("\r\n", "\n")
file:close()
local snippet = assert(document:match("```lua\n(.-)\n```"))
local bind = assert(load(snippet, "method-adapters.md", "t", _G))()
local checks = 0
local function check(value, label)
    assert(value, label)
    checks = checks + 1
end
local function rejects(fn, label)
    check(not pcall(fn), label)
end
local registrations, removals = {}, {}
local mod = {}
function mod:AddCallback(id, handler, filter)
    assert(type(handler) == "function", "native registration needs a function")
    registrations[#registrations + 1] = { id = id, handler = handler, filter = filter }
end
function mod:AddPriorityCallback(id, priority, handler, filter)
    self:AddCallback(id, handler, filter)
    registrations[#registrations].priority = priority
end
function mod:RemoveCallback(id, handler)
    removals[#removals + 1] = { id = id, handler = handler }
    for i = #registrations, 1, -1 do
        if registrations[i].id == id and registrations[i].handler == handler then
            table.remove(registrations, i)
        end
    end
end
local foreign = function() return "foreign" end
mod:AddCallback(10, foreign, 99)
local received
local owner = { OnEvent = function(self, ...)
    received = { self = self, args = table.pack(...) }
    return "old"
end }
local binding = bind(mod, owner, 10, "OnEvent", 55)
local entry = registrations[2]
check(#registrations == 2 and entry.filter == 55, "filter and unrelated registration preserved")
check(entry.handler ~= owner.OnEvent, "engine receives the wrapper function")
check(entry.handler(mod, "player", nil, "flags") == "old", "initial method executes")
check(received.self == owner and received.args.n == 3 and received.args[3] == "flags",
    "only engine mod argument is replaced and nil argument is retained")
local oldMethod = owner.OnEvent
owner.OnEvent = function(self, ...)
    check(self == owner, "replacement receives the bound owner")
    return false, nil, "new"
end
local values = table.pack(entry.handler(mod, 1))
check(values.n == 3 and values[1] == false and values[2] == nil and values[3] == "new",
    "same-owner method replacement preserves false and all return positions")
check(oldMethod(owner) == "old", "captured original method remains a different binding")
local registry = { Item = owner }
registry.Item = { OnEvent = function() return "replacement owner" end }
check(entry.handler(mod) == false and registry.Item:OnEvent() == "replacement owner",
    "method lookup does not silently follow a replacement registry object")
owner.OnEvent = nil
rejects(function() entry.handler(mod) end, "missing live method is explicit")
owner.OnEvent = function() return nil end
check(entry.handler(mod) == nil, "nil return is preserved")
local priority = bind(mod, registry.Item, 11, "OnEvent", 77, -20)
check(registrations[3].priority == -20 and registrations[3].filter == 77,
    "priority and filter reach the native boundary")
binding.Destroy()
binding.Destroy()
check(#removals == 1 and removals[1].handler == entry.handler,
    "exact registered wrapper is removed once")
check(#registrations == 2 and registrations[1].handler == foreign,
    "other bindings and foreign callbacks survive disposal")
priority.Destroy()
check(#registrations == 1 and registrations[1].handler == foreign,
    "replacement binding can be disposed independently")
rejects(function() mod:AddCallback(10, "OnEvent") end, "string is not a native handler")
rejects(function() bind(mod, owner, nil, "OnEvent") end, "missing callback id rejected")
rejects(function() bind(mod, owner, 10, "Missing") end, "missing initial method rejected")
print("Method adapter checks passed: " .. checks)
