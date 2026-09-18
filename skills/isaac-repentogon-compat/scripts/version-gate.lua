-- Project-owned optional helper. It never installs callbacks or calls engine APIs.
-- Copy deliberately into an existing project module layout; do not edit REPENTOGON.
local Gate = {}

local function parseRelease(value)
    if type(value) ~= "string" then return nil end
    local major, minor, patch, suffix = value:match("^(%d+)%.(%d+)%.(%d+)([a-z]?)$")
    if not major then return nil end
    local parts = {major, minor, patch}
    for i = 1, 3 do
        local token = parts[i]
        -- Only the observed canonical release grammar is supported. Unknown
        -- formats require evidence, not a guessed SemVer/prerelease ordering.
        if #token > 9 or (#token > 1 and token:sub(1, 1) == "0") then return nil end
        parts[i] = tonumber(token)
    end
    parts[4] = suffix == "" and 0 or (suffix:byte() - string.byte("a") + 1)
    return parts
end

-- true/false: understood releases; nil: unsupported or unverifiable version.
function Gate.meetsRelease(actual, minimum)
    local installed, required = parseRelease(actual), parseRelease(minimum)
    if not installed or not required then
        return nil, "Version is not a supported release label (major.minor.patch plus optional a-z)."
    end
    for i = 1, 4 do
        if installed[i] ~= required[i] then return installed[i] > required[i] end
    end
    return true
end

-- capabilityProbe is lazy: it runs only after presence AND release comparison.
-- It must return { descriptiveCapabilityName = boolean, ... } and only inspect
-- availability. Do not spawn entities, start challenges or mutate state to probe.
function Gate.check(runtime, minimum, capabilityProbe)
    if type(runtime) ~= "table" then
        return false, "REPENTOGON is required but its runtime table is unavailable."
    end
    local meets, reason = Gate.meetsRelease(runtime.Version, minimum)
    if meets == nil then return false, reason end
    if not meets then return false, "REPENTOGON " .. minimum .. " or a later verified release is required." end
    if capabilityProbe ~= nil then
        if type(capabilityProbe) ~= "function" then return false, "Capability probe must be a function." end
        local ok, capabilities = pcall(capabilityProbe)
        if not ok or type(capabilities) ~= "table" then
            return false, "Required API availability could not be checked."
        end
        for name, available in pairs(capabilities) do
            if available ~= true then return false, "Required API is unavailable: " .. tostring(name) end
        end
    end
    return true, "Release and supplied availability checks passed; semantics still require matching evidence."
end

return Gate
