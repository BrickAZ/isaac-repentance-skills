-- Exercises the documented draw algorithm with a deterministic RNG adapter.
local path = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local folder = assert(path:match("^(.*)/tests/[^/]+$"))
local file = assert(io.open(folder .. "/references/prediction-queries.md", "rb"),
    "documented prediction query is missing")
local document = file:read("*a"):gsub("\r\n", "\n")
file:close()
local snippet = assert(document:match("```lua\n(.-)\n```"))
local predict = assert(load(snippet, "prediction-queries.md", "t", _G))()
local checks = 0
local function check(value, label)
    assert(value, label)
    checks = checks + 1
end
local function same(a, b)
    if #a ~= #b then return false end
    for i, value in ipairs(a) do if value ~= b[i] then return false end end
    return true
end
local function newRng(seed)
    local state = seed
    return { RandomInt = function(_, count)
        state = (state * 16807) % 2147483647
        return state % count
    end }
end
local context = { seed = 37, count = 3, candidates = { 11, 22, 33, 44, 55 } }
local baseline = predict(newRng, context)
check(#baseline == 3, "requested draw count honored")
check(same(context.candidates, { 11, 22, 33, 44, 55 }), "input candidate array unchanged")
local seen = {}
for _, id in ipairs(baseline) do
    check(not seen[id], "without-replacement result contains no duplicate")
    seen[id] = true
end
local gameplayDraws, poolWrites, executions = 0, 0, 0
local function execute(plan)
    executions = executions + 1
    gameplayDraws = gameplayDraws + 1
    return table.concat(plan, ",")
end
local results = {}
for _, previews in ipairs({ 0, 1, 10 }) do
    gameplayDraws, poolWrites, executions = 0, 0, 0
    for _ = 1, previews do
        local shown = predict(newRng, context)
        shown[1] = -1
    end
    check(gameplayDraws == 0 and poolWrites == 0 and executions == 0,
        "display queries do not touch modeled gameplay boundaries")
    results[#results + 1] = execute(predict(newRng, context))
    check(gameplayDraws == 1 and executions == 1, "only explicit execution commits")
end
check(results[1] == results[2] and results[2] == results[3],
    "zero one or ten previews leave committed plan identical")
check(same(predict(newRng, context), baseline), "editing display result cannot corrupt later result")
local changed = { seed = 37, count = 2, candidates = { 22, 44 } }
local revised = predict(newRng, changed)
check(#revised == 2 and revised[1] ~= revised[2], "changed eligibility is recomputed")
local calls = 0
local function mustNotConstruct()
    calls = calls + 1
    error("empty selection must not draw")
end
check(#predict(mustNotConstruct, { seed = 37, count = 0, candidates = { 11 } }) == 0,
    "zero count is an empty plan")
check(#predict(mustNotConstruct, { seed = 37, count = 4, candidates = {} }) == 0,
    "empty candidates do not draw")
check(calls == 0, "empty cases never construct RNG")
local contaminatedCalls = 0
local function sharedFactory(seed)
    contaminatedCalls = contaminatedCalls + 1
    gameplayDraws = gameplayDraws + 1
    return newRng(seed)
end
local before = gameplayDraws
predict(sharedFactory, context)
check(contaminatedCalls == 1 and gameplayDraws ~= before,
    "contaminated factory exposes why independent-source proof is still necessary")
local reversed = { seed = 37, count = 3, candidates = { 55, 44, 33, 22, 11 } }
check(not same(predict(newRng, reversed), baseline),
    "same seed does not make a changed candidate order equivalent")
print("Prediction query checks passed: " .. checks)
