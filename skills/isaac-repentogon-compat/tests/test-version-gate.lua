-- Pure helper regression tests. Does not initialize Isaac or any mod.
local source = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local root = source:match("^(.*)/tests/[^/]+$")
local Gate = dofile(root .. "/scripts/version-gate.lua")
local passed = 0
local function equal(actual, expected, name)
    assert(actual == expected, name .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
    passed = passed + 1
end
local comparisons = {
    {"1.1.2a", "1.1.2g", false}, {"1.1.2g", "1.1.2h", false},
    {"1.1.2g", "1.1.2g", true}, {"1.1.2g", "1.1.2", true},
    {"1.1.2", "1.1.2a", false}, {"1.1.10", "1.1.9z", true},
    {"1.2.0", "1.1.99z", true}, {"2.0.0", "1.9.99z", true},
    {"1.1.2g", "1.1.3", false}, {"1.0.10b", "1.0.10c", false},
}
for _, case in ipairs(comparisons) do
    equal(Gate.meetsRelease(case[1], case[2]), case[3], case[1] .. " / " .. case[2])
end
for _, value in ipairs({"dev build", "", "1.1", "v1.1.2", "1.1.2-rc1", "1.1.2aa", "1.1.2G", "1.1.2 ", "1.1.2.3", "01.1.2", "99999999999999999999.0.0"}) do
    equal(Gate.meetsRelease(value, "1.1.2"), nil, "unsupported actual " .. value)
    equal(Gate.meetsRelease("1.1.2", value), nil, "unsupported minimum " .. value)
end
equal(Gate.meetsRelease(nil, "1.1.2"), nil, "nil")
equal(Gate.meetsRelease(112, "1.1.2"), nil, "number")
equal(Gate.check(nil, "1.1.2"), false, "absent")
equal(Gate.check(true, "1.1.2"), false, "non-table")
equal(Gate.check({Version = "dev build"}, "1.1.2"), false, "dev cannot masquerade as release")
local probes = 0
local function probe()
    probes = probes + 1
    return {Ambush = true}
end
equal(Gate.check(nil, "1.1.2", probe), false, "absent is lazy")
equal(Gate.check({Version = "1.1.2a"}, "1.1.2g", probe), false, "old is lazy")
equal(probes, 0, "no extension probe before version gate")
local runtime = {Version = "1.1.2g", MeetsVersion = function() return true end}
equal(Gate.check(runtime, "1.1.2g", probe), true, "release and capability")
equal(probes, 1, "probe runs once")
equal(Gate.check(runtime, "1.1.2g", function() return {Ambush = false} end), false, "missing capability")
equal(Gate.check(runtime, "1.1.2g", function() return {Ambush = 1} end), false, "truthy is not proof")
equal(Gate.check(runtime, "1.1.2g", function() error("unsupported symbol") end), false, "probe error")
equal(Gate.check(runtime, "1.1.2g", function() return nil end), false, "bad probe output")
equal(Gate.check(runtime, "1.1.2g", {}), false, "probe must be function")
equal(Gate.check(runtime, "1.1.2h"), false, "does not trust MeetsVersion")
equal(runtime.Version, "1.1.2g", "runtime not mutated")
print("PASS version-gate: " .. passed .. " assertions (pure Lua; no engine claims)")
