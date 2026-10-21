# 可回收的只读开发面板

此示例供目标模组集成，不是新的 Mod 脚手架。先完成 `isaac-repentogon-compat` / `isaac-repentogon-dev` 的依赖、目标版本及 ready 门禁，再调用工厂；required 已获授权时不重新询问。基线接口在 tag 1.1.2g 核实，示例没有游戏实测证据。

入口是在 REPENTOGON 覆盖层顶部菜单中点击“开发者”。正常游玩时始终可点的 HUD 入口需另外实现，见 `hud-and-coordinates.md`。

## 生命周期

| 事件 | 处理 |
|---|---|
| 模组初始化完成 | 安装一次，创建自己的菜单/窗口/回调 |
| 显式重复安装或同一 mod 对象重载 | 先 Destroy 前一实例，旧回调不累积 |
| 点击读取 | 先判当前对局，再取得当前描述符；只更新 UI 文本 |
| 新局/续局、退局 | 隐藏自己的面板，清除旧房间展示 |
| 关闭/再打开 | 只隐藏或切换，不销毁注册 |
| 自己卸载/显式销毁 | 移除自己回调和根节点；其他 Mod 的节点保留 |

`MC_PRE_MOD_UNLOAD` 在 RGON 中传入将卸载的 Mod 和 ShuttingDown；不能将其他 Mod 的卸载当作自己卸载。示例不用其返回值。依据：[官方 unload 回调](https://repentogon.com/enums/ModCallbacks.html#mc_pre_mod_unload)。原生生命周期回调的最终时序仍按目标项目/构建核验，并关联 `isaac-callback-contracts`。

## Lua 集成示例

### 缓存与重建合同

模块返回的工厂可以被缓存；初始化仍须在能力门禁后用当前 Mod 调用工厂。
顶层捕获旧 Mod 并创建 UI 的模块，不能仅靠 `require` 的一次执行保证重载安全。
区分工厂缓存、当前 UI 实例、外部元素是否存在这三个事实；元素被清理后，
旧 `registered` 布尔值不能阻止必要的重建。先处理上一实例的清理，再安装新实例。

替换 Mod 对象时，确认旧实例实际收到卸载或显式 Destroy；新 Mod 上的字段找不到
旧实例，不能据此宣称没有旧回调。旧实例被销毁后，其外部残留函数也不能读取世界、
更新或隐藏使用相同 ID 的新面板。`ElementExists` 只证明元素存在，不能证明它
仍绑定当前依赖。具体加载与重载语义见
[架构合同](../../isaac-mod-architecture/references/module-loading-and-exports.md)，
实例替换见 [状态合同](../../isaac-state-lifecycle/references/module-instance-lifecycle.md)。

把 `ExampleMod` 前缀一次性替换为项目已确认的唯一标识。以下代码可作为模块返回一个工厂；主初始化在门禁后调用 `AttachDeveloperPanel(mod)`。示例不在顶层创建 Game/Player，不使用全局 Reset/Hide。

```lua
local function AttachDeveloperPanel(mod)
    local KEY = "__ExampleModDeveloperPanel"
    local MENU, WINDOW = "ExampleMod.DevMenu", "ExampleMod.DevPanel"
    local STATUS = "ExampleMod.DevStatus"
    local previous = mod[KEY]
    if previous then previous.Destroy() end

    local ui, handlers = {}, {}
    local destroyed = false

    local function SetStatus(text)
        if destroyed then return end
        if ImGui.ElementExists(STATUS) then ImGui.UpdateText(STATUS, text) end
    end

    local function ResetRunView()
        if destroyed then return end
        if ImGui.ElementExists(WINDOW) then ImGui.SetVisible(WINDOW, false) end
        SetStatus("点击读取当前房间；未进入对局时仅显示提示。")
    end

    local function InspectRoom()
        if destroyed then return end
        if not Isaac.IsInGame() then
            SetStatus("请先进入一局游戏。")
            return
        end
        local desc = Game():GetLevel():GetCurrentRoomDesc()
        if not desc or not desc.Data then
            SetStatus("当前房间尚未就绪。")
            return
        end
        SetStatus("当前房间：" .. tostring(desc.Data.Name))
    end

    local function RemoveOwnElements()
        -- 先删引用菜单入口的窗口，再删菜单及其孩子。
        if ImGui.ElementExists(WINDOW) then ImGui.RemoveElement(WINDOW) end
        if ImGui.ElementExists(MENU) then ImGui.RemoveElement(MENU) end
    end

    function ui.Destroy()
        if destroyed then return end
        destroyed = true
        for _, entry in ipairs(handlers) do
            mod:RemoveCallback(entry[1], entry[2])
        end
        RemoveOwnElements()
        if mod[KEY] == ui then mod[KEY] = nil end
    end

    local function Bind(id, fn)
        mod:AddCallback(id, fn)
        handlers[#handlers + 1] = { id, fn }
    end

    -- 回收仅属于本模块的遗留根节点；不碰其他前缀。
    RemoveOwnElements()
    ImGui.CreateMenu(MENU, "ExampleMod")
    ImGui.CreateWindow(WINDOW, "开发者")
    ImGui.AddElement(MENU, MENU .. ".Open", ImGuiElement.MenuItem, "开发者")
    ImGui.LinkWindowToElement(WINDOW, MENU .. ".Open")
    ImGui.AddText(WINDOW, "点击读取当前房间。", true, STATUS)
    ImGui.AddButton(WINDOW, WINDOW .. ".Inspect", "读取房间", InspectRoom, true)
    ImGui.AddButton(WINDOW, WINDOW .. ".Close", "关闭", function()
        if destroyed then return end
        ImGui.SetVisible(WINDOW, false)
    end, true)
    Bind(ModCallbacks.MC_POST_GAME_STARTED, ResetRunView)
    Bind(ModCallbacks.MC_PRE_GAME_EXIT, ResetRunView)
    Bind(ModCallbacks.MC_PRE_MOD_UNLOAD, function(_, unloadingMod)
        if unloadingMod == mod then ui.Destroy() end
    end)
    mod[KEY] = ui
    return ui
end

return AttachDeveloperPanel
```

接口依据：[官方 ImGui 示例](https://repentogon.com/examples/ImGuiMenu.html)、[tag 官方测试](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/repentogon_tests/test_imgui.lua)、[tag 元素/回调绑定](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/LuaImGui.cpp)、[Isaac.IsInGame](https://repentogon.com/Isaac.html#isingame)。

示例是生命周期模式，不替代项目门禁与 bootstrap。`luamod`、`luareset` 对模块缓存和 UI 的处理按目标版本核验。若项目加载器创建新 mod 对象，必须保证旧实例实际收到了卸载/显式 Destroy，不能只依赖新对象上的 KEY 清理旧回调。若目标卸载阶段 UI 系统已不可访问，采用已验证的更早 teardown 时机；不猜测关闭顺序。

## 验证清单

- 对同一 mod 工厂调用两次：仅一套根节点、一个读取 callback、三条生命周期注册。
- 保存旧读取/关闭闭包，替换实例后再调用：不读取世界、不改动新面板；显式卸载后，同一工厂可为新 Mod 重建。
- 主菜单点击：不调用 Game，不异常，出现中文提示；进入对局点击显示当前房间。
- 新局/续局、退局：窗口隐藏，旧房间名清除；再开可读取新对象。
- 自己卸载/Destroy 两次：幂等回收；其他 Mod 卸载不会关闭此面板，其他前缀节点保留。
- 实机确认中文、覆盖层打开方式、关闭后游戏输入恢复、luareset/卸载阶段无错误。mock 通过不能声称这些已实测。
