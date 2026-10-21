-- Executes the documented factory and explicit loader doubles, not Isaac itself.
local path = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local folder = assert(path:match("^(.*)/tests/[^/]+$"))
local file = assert(io.open(folder .. "/references/module-loading-and-exports.md", "rb"))
local document = file:read("*a"):gsub("\r\n", "\n")
file:close()
local snippet = assert(document:match("```lua\n(.-)\n```"))
local checks = 0
local function check(value, label)
    assert(value, label)
    checks = checks + 1
end
local function rejects(fn, label)
    check(not pcall(fn), label)
end
local buildCalls, applyCalls, randomState = 0, 0, 73
local function build(key)
    buildCalls = buildCalls + 1
    return { key, key + 1 }
end
local function apply(player, ids)
    applyCalls = applyCalls + 1
    randomState = randomState + 1
    check(player.name == "holder", "execution receives explicit owner")
    check(ids[1] ~= -1, "execution uses unmodified plan")
    ids[1] = -2
    return "applied"
end
local create = assert(load(snippet, "module-loading-and-exports.md", "t", _G))()
check(type(create) == "function" and buildCalls == 0 and applyCalls == 0, "factory load is inert")
local planner = create(build, apply)
local registry = { Planner = planner }
local gameplay, description = registry.Planner, registry.Planner
check(gameplay == description, "consumers share the bootstrap-owned instance")
local first = gameplay.GetPreview(10)
check(first[1] == 10 and first[2] == 11 and buildCalls == 1, "first query builds a plan")
first[1] = -1
local second = description.GetPreview(10)
check(second[1] == 10 and first ~= second and buildCalls == 1, "query returns owned copies")
check(applyCalls == 0 and randomState == 73, "display queries do not apply effects or consume gameplay RNG")
check(gameplay.Execute({ name = "holder" }, 10) == "applied", "explicit execution returns effect result")
check(applyCalls == 1 and buildCalls == 1, "execution shares the preview plan")
check(randomState == 74, "only the explicit effect advances the modeled gameplay RNG")
check(description.GetPreview(10)[1] == 10, "effect consumer cannot mutate cached plan")
check(description.GetPreview(20)[1] == 20 and buildCalls == 2, "context change rebuilds plan")
planner.Invalidate()
check(planner.GetPreview(20)[1] == 20 and buildCalls == 3, "explicit invalidation rebuilds")
local other = create(build, apply)
check(other ~= planner, "a new factory call owns a distinct instance")
other.GetPreview(20)
check(buildCalls == 4, "new instance does not inherit another cache")
planner.Destroy()
planner.Destroy()
rejects(function() planner.GetPreview(20) end, "destroyed query rejects stale use")
rejects(function() planner.Execute({ name = "holder" }, 20) end, "destroyed execute rejects stale use")
check(other.GetPreview(20)[1] == 20, "destroy does not invalidate another owner")
rejects(function() create(false, apply) end, "invalid query dependency rejected")
rejects(function() create(build, false) end, "invalid effect dependency rejected")
rejects(function() other.GetPreview(nil) end, "missing context key rejected")
rejects(function() other.GetPreview({}) end, "runtime object cannot be a context token")
other.Destroy()
rejects(function() other.Invalidate() end, "destroyed instance cannot be invalidated for reuse")
local builderIds = { 31, 32 }
local isolated = create(function() return builderIds end, apply)
isolated.GetPreview("source-copy")
builderIds[1] = -1
check(isolated.GetPreview("source-copy")[1] == 31, "builder-owned table cannot mutate private cache later")
isolated.Destroy()
local invalid = create(function() return { "not-an-id" } end, apply)
rejects(function() invalid.GetPreview("invalid") end, "invalid ID payload rejected")
invalid.Destroy()

-- Model documented cache/scope differences. Native build behavior remains separate.
local loaded, loads, callbacks = {}, {}, {}
local function includeDouble(root, name)
    local id = root .. "/" .. name
    loads[id] = (loads[id] or 0) + 1
    callbacks[id] = (callbacks[id] or 0) + 1
    return { root = root, state = {}, generation = loads[id] }
end
local function requireDouble(root, name)
    if not loaded[name] then loaded[name] = includeDouble(root, name) end
    return loaded[name]
end
local a = includeDouble("A", "scripts.shared")
local b = includeDouble("A", "scripts.shared")
check(a ~= b and a.state ~= b.state, "repeat include can split state")
check(callbacks["A/scripts.shared"] == 2, "top-level registration repeats with include")
check(includeDouble("B", "scripts.shared").root == "B", "include scope stays with its modeled mod root")
local c = requireDouble("A", "scripts.cached")
check(requireDouble("A", "scripts.cached") == c, "require reuses the cached result")
check(requireDouble("B", "scripts.cached").root == "A", "shared require key models cross-mod collision")
check(requireDouble("A", "scripts.cached").generation == 1, "cached code survives a modeled bootstrap rerun")
local newGeneration = includeDouble("A", "scripts.cached")
check(newGeneration ~= c and newGeneration.generation == 2, "fresh execution differs from cached generation")
check(requireDouble("B", "orchard_b.shared").root == "B", "distinct require namespace avoids modeled collision")
print("Module contract checks passed: " .. checks .. "; loader behavior modeled, native reload unverified")
