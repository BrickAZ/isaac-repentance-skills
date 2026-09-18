# ImGui API: 1.1.2g

核验日期 2026-09-05；官方页面 + 固定 tag 的静态证据，无游戏实测。API 全部经 `ImGui` 全局表点调用，不能套用原生 Dear ImGui 的 Begin/End 即时模式。

## 创建与回调

| 精确调用 | 合同 |
|---|---|
| `ImGui.CreateMenu(id, label)` | REPENTOGON 顶部菜单入口；tag 要求显式 label |
| `ImGui.CreateWindow(id, title, parentId)` | 前两参数显式传入；可选第三参数为 tag 支持的父元素 ID |
| `ImGui.AddElement(parentId, id, type, label)` | label 可省略；id 可传空字符串但仍占第二参数；没有 callback 参数 |
| `ImGui.AddButton(parentId, id, label, callback, isSmall)` | label 默认空，callback 默认 nil，isSmall 默认 false；callback 注册到 Clicked |
| `ImGui.AddCallback(id, callbackType, fn)` | 给已有元素每一类型一个回调槽 |
| `ImGui.RemoveCallback(id, callbackType)` | 移除自己的指定回调槽 |
| `ImGui.AddText(parentId, text, wrapText, id)` | wrapText 默认 false，id 默认空；需要更新时使用稳定非空 ID |
| `ImGui.UpdateText(id, text)` | 更新已存在元素 |

`AddWindow` 不在 tag 的 Lua 注册表，也没有 main_ex.lua 别名；使用 `CreateWindow`。网页中标题的可选写法与 tag 强制字符串检查不同，样例始终显式传 title/label。创建父元素后才创建孩子。重复非空 ID 会先删除已有元素，所以命名冲突会影响其他代码。

依据：[官方 ImGui](https://repentogon.com/ImGui.html)、[tag LuaImGui.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/LuaImGui.cpp)、[tag 官方演示](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/repentogon_tests/test_imgui.lua)。

```lua
ImGui.AddElement(parentId, buttonId, ImGuiElement.Button, "检查")
ImGui.AddCallback(buttonId, ImGuiCallback.Clicked, function(clickCount)
    -- clickCount 是该元素点击计数，不是 EntityPlayer。
end)
-- 专用按钮的等价注册形式：
-- ImGui.AddButton(parentId, buttonId, "检查", onClick, true)
```

不要同时以两种形式注册同一元素。`ImGuiCallback.Render` 在元素绘制前执行，仅作 UI 更新；点击事件不要写成每帧执行。Clicked 回调中修改自己所在元素树可能使 C++ 遍历失效，这是基于容器迭代实现的谨慎设计推论；关闭用 SetVisible，结构销毁安排在生命周期/拥有者调用，不在元素自身回调中重建整树。

依据：[官方 ImGuiCallback 枚举](https://repentogon.com/enums/ImGuiCallback.html)、[tag CustomImGui.h](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/CustomImGui.h)。

## ID、可见性与销毁

| 调用 | 含义 |
|---|---|
| `ElementExists(id)` | 存在性查询，不等于可见 |
| `RemoveElement(id)` | 按 ID 删除；根节点包含所属孩子 |
| `LinkWindowToElement(windowId, elementId)` | 将元素连接为窗口/Popup 的切换入口 |
| `SetVisible(id, boolean)` / `GetVisible(id)` | 设置/查询元素实际可见状态 |
| `Show()` / `Hide()` | 全局 ImGui 覆盖层打开/关闭 |
| `IsVisible()` | 覆盖层是否正打开，不代表 pinned 窗口可见性 |
| `SetWindowPinned(id, boolean)` | 覆盖层关闭后继续显示窗口；不使其可交互 |
| `SetSize(id, width, height)` | 元素像素尺寸 |
| `SetWindowPosition(id, x, y)` | 窗口位置请求，屏幕/ImGui 像素空间 |

`RemoveMenu`、`RemoveWindow` 是已废弃的 `RemoveElement` 别名；`SetWindowSize` 是 `SetSize` 别名。新代码使用主名称。1.1.2g 的 `GetWindowPinned` 绑定读取第二个 Lua 参数，与文档的一个参数写法不一致；不要用它实现核心状态机，维护自有 pinned 状态或先验证目标构建。

全局 `Reset()` 会清除所有自定义元素，不能用于本 Mod 的卸载。RGON 自己在全量重载路径调用它，不代表 Mod 有同样清场权限。根据已确认的项目唯一前缀只回收自己的根节点和 Mod 回调。

依据：[tag 绑定与别名](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/LuaImGui.cpp#L849-L1025)、[tag 可见性与元素管理](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/CustomImGui.h)、[tag 全量重载重置](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua#L1885-L1887)。

## 状态守卫

ImGui 可在主菜单显示；Game/Level/Room/Player 操作放在 `Isaac.IsInGame()` 成功的分支，点击时重新取得对象。主菜单应显示“请先进入一局游戏”等普通文本。游戏世界写入不能由 Render 或 UI 可见性自动触发。

依据：[Isaac.IsInGame](https://repentogon.com/Isaac.html#isingame)、[tag Isaac 绑定](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaIsaac.cpp#L592-L595)。
