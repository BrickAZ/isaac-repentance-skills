-- Extract the actual documentation factory. This verifies its Lua/UI ownership
-- logic against explicit doubles; it does not prove native ImGui or game timing.
local path = debug.getinfo(1, "S").source:sub(2):gsub("\\", "/")
local folder = assert(path:match("^(.*)/tests/[^/]+$"))
local file = assert(io.open(folder .. "/references/developer-panel.md", "rb"))
local document = file:read("*a"):gsub("\r\n", "\n")
file:close()
local snippet = assert(document:match("```lua\n(.-)\n```"))
local checks = 0
local function check(value, label)
    assert(value, label)
    checks = checks + 1
end
local elements = { Foreign = { children = {} } }
local gui = {}
local function create(id, parent)
    assert(type(id) == "string" and not elements[id], "unique id")
    if parent then assert(elements[parent], "parent must exist") end
    elements[id] = { children = {}, parent = parent }
    if parent then elements[parent].children[id] = true end
end
function gui.ElementExists(id) return elements[id] ~= nil end
function gui.CreateMenu(id, title) assert(type(title) == "string"); create(id) end
function gui.CreateWindow(id, title) assert(type(title) == "string"); create(id) end
function gui.AddElement(parent, id, kind, label)
    assert(kind == 1 and type(label) == "string"); create(id, parent)
end
function gui.LinkWindowToElement(window, item)
    assert(elements[window] and elements[item])
end
function gui.AddText(parent, text, wrap, id)
    assert(type(text) == "string" and type(wrap) == "boolean")
    create(id, parent); elements[id].text = text
end
function gui.UpdateText(id, text) assert(elements[id]); elements[id].text = text end
function gui.AddButton(parent, id, label, callback, small)
    assert(type(callback) == "function" and type(small) == "boolean")
    create(id, parent); elements[id].click = callback
end
function gui.SetVisible(id, visible)
    assert(elements[id]); elements[id].visible = visible
end
function gui.RemoveElement(id)
    assert(elements[id])
    local children = {}
    for child in pairs(elements[id].children) do children[#children + 1] = child end
    for _, child in ipairs(children) do gui.RemoveElement(child) end
    local parent = elements[id].parent
    if parent and elements[parent] then elements[parent].children[id] = nil end
    elements[id] = nil
end
local mod, callbacks = {}, {}
function mod:AddCallback(id, callback)
    callbacks[#callbacks + 1] = { id = id, fn = callback }
end
function mod:RemoveCallback(id, callback)
    for i = #callbacks, 1, -1 do
        if callbacks[i].id == id and callbacks[i].fn == callback then
            table.remove(callbacks, i)
        end
    end
end
local function fire(id, ...)
    local copy = {}
    for i, entry in ipairs(callbacks) do copy[i] = entry end
    for _, entry in ipairs(copy) do
        if entry.id == id then entry.fn(mod, ...) end
    end
end
local inGame, room, gameCalls = false, nil, 0
local env = setmetatable({
    ImGui = gui, ImGuiElement = { MenuItem = 1 },
    ModCallbacks = { MC_POST_GAME_STARTED = 1, MC_PRE_GAME_EXIT = 2, MC_PRE_MOD_UNLOAD = 3 },
    Isaac = { IsInGame = function() return inGame end },
    Game = function()
        gameCalls = gameCalls + 1
        assert(inGame, "Game must not be read at title")
        return { GetLevel = function()
            return { GetCurrentRoomDesc = function() return room end }
        end }
    end,
}, { __index = _G })
local attach = assert(load(snippet, "developer-panel.md", "t", env))()
check(gameCalls == 0 and #callbacks == 0, "module load is inert")
local first = attach(mod)
check(gameCalls == 0 and #callbacks == 3, "attach does not read game")
local inspectId, window = "ExampleMod.DevPanel.Inspect", "ExampleMod.DevPanel"
local status = "ExampleMod.DevStatus"
elements[inspectId].click()
check(gameCalls == 0 and elements[status].text:find("请先", 1, true), "title click is guarded")
inGame, room = true, { Data = { Name = "Room A" } }
elements[inspectId].click()
check(gameCalls == 1 and elements[status].text:find("Room A", 1, true), "reads current room")
room = nil
elements[inspectId].click()
check(elements[status].text:find("尚未就绪", 1, true), "nil descriptor is handled")
room = {}
elements[inspectId].click()
check(elements[status].text:find("尚未就绪", 1, true), "nil config is handled")
room = { Data = { Name = "Room B" } }
fire(1, true)
check(elements[window].visible == false and not elements[status].text:find("Room A", 1, true), "continue clears old display")
elements[inspectId].click()
check(elements[status].text:find("Room B", 1, true), "new room read is fresh")
fire(2, true)
check(elements[window].visible == false and not elements[status].text:find("Room B", 1, true), "exit clears old display")
inGame = false
local priorCalls = gameCalls
elements[inspectId].click()
check(gameCalls == priorCalls, "after-exit click cannot read Game")
local second = attach(mod)
check(#callbacks == 3 and elements.Foreign ~= nil, "reattach has one owner, preserves foreign UI")
first.Destroy()
check(#callbacks == 3 and elements[window] ~= nil, "old destroy cannot remove replacement")
elements[window .. ".Close"].click()
check(elements[window].visible == false, "close only hides")
fire(3, {}, false)
check(#callbacks == 3 and elements[window] ~= nil, "foreign unload is ignored")
fire(3, mod, false)
check(#callbacks == 0 and elements[window] == nil and elements.Foreign ~= nil, "self unload cleans only owned UI")
second.Destroy()
check(#callbacks == 0 and elements.Foreign ~= nil, "destroy is idempotent")
print("Developer panel mock checks passed: " .. checks .. "; native game behavior unverified")
