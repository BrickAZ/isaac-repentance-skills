# HUD 输入入口、ImGui 与坐标

基线 1.1.2g，2026-09-05；源码与官方说明，不包含实机可视/输入证明。

## 三种界面行为

| 界面 | 何时可交互 | 用途 |
|---|---|---|
| ImGui 菜单/普通窗口 | REPENTOGON 覆盖层打开时 | 开发面板、只读检查、表单 |
| pinned ImGui 窗口 | 关闭覆盖层后只显示 | 信息展示，不是正常游玩点击入口 |
| 模组 HUD 按钮 | 项目自己的渲染/输入命中逻辑允许时 | 正常游玩界面上可点的“开发者”入口 |

**源码确认**：`!menuShown` 时 `handleWindowFlags` 添加 NoMove、NoNav、NoDecoration、NoInputs；固定窗口不绕过此规则。`ImGui.IsVisible()` 只检查 menuShown，所以可以是 false 而 pinned 窗口仍可见。

依据：[tag ImGui.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/ImGui.cpp#L48-L53)、[tag 可见性实现](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/CustomImGui.h#L530-L535)、[官方 ImGui](https://repentogon.com/ImGui.html)。

用户指定小 HUD 按钮时，使用 `isaac-hud-ui-state` 确定现有 HUD 渲染层和命中规则。在点击边沿确认按钮内且状态允许后，打开自己的窗口并 `ImGui.Show()`；进入覆盖层后停止 HUD 的重复点击处理。按键按住不能每帧切换。点击不能穿透成射击/主动道具等动作；需使用项目已核实的输入仲裁，不把仅画出按钮称为实现交互。

以上是 **集成设计推论**；ImGui 不提供此常驻 HUD 命中合同。沿用已确认位置/美术/打开方式，不用技术实现问题重新询问用户设计。不在退出时全局 `ImGui.Hide()` 强关他人的面板。

在已完成命中与输入仲裁的**单次点击**中，可调用下面这个只负责打开面板的适配函数；窗口必须已由本 Mod 创建，标识从实际模块传入：

```lua
local function OpenOwnedDeveloperPanel(windowId)
    if not Isaac.IsInGame() then return false end
    if not ImGui.ElementExists(windowId) then return false end
    ImGui.SetVisible(windowId, true)
    ImGui.Show()
    return true
end
```

`SetVisible` 改变指定元素的可见性，`Show()` 打开共享覆盖层；只调用后者不能保证自己的窗口可见。此函数不承担 HUD 绘制、命中或手柄导航，不能凭它声称完整按钮已可交互。依据：[1.1.2g Show/SetVisible 绑定](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/LuaImGui.cpp#L748-L800)。

## 坐标空间

| API / 数值 | 空间与返回 |
|---|---|
| `ImGui.GetMousePosition()` | ImGui/屏幕像素 `Vector`，不用 `Input.GetMousePosition()` 替代 |
| `ImGui.SetWindowPosition(id, x, y)` | ImGui 像素位置 |
| `ImGui.SetSize(id, width, height)` | 像素尺寸 |
| `ImGui.WorldToImGui(worldPosition)` | `Isaac.WorldToScreen(position) * Isaac.GetScreenPointScale()`，返回 Vector |
| `ImGui.ImGuiToWorld(screenPosition)` | `Isaac.ScreenToWorld(position)`，返回 Vector |

这两个坐标转换在 tag 的 `main_ex.lua` 中定义为别名，不在 LuaImGui.cpp 的 C++ 注册表；不能因为一个文件搜不到就判为不存在。网页中 GetMousePosition/转换函数的 `void` 返回标签不准确，tag 实际返回 Vector。HUD 渲染点、世界点与 ImGui 像素点分别标记；不能将世界实体坐标直接用于窗口定位或按钮 hitbox。

依据：[tag 鼠标实现](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/ImGuiFeatures/LuaImGui.cpp#L582-L600)、[tag 坐标别名](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua#L1848-L1851)、[官方坐标说明](https://repentogon.com/ImGui.html#imguitoworld)。

官方记录 `ImGuiToWorld` 在游戏缩放超过 `MaxRenderScale` 时不正确。转换不是主菜单操作世界的许可；先证明当前对局，再用世界坐标。非世界 UI 尽量在同一屏幕空间绘制和命中，避免不必要的来回转换。

## 实机验收

覆盖窗口化/全屏、改变分辨率、正常/高缩放、打开/关闭覆盖层、进入/退出对局；确认按钮可见且可点、点击只触发一次、无输入穿透、无鼠标偏移，固定窗口关闭覆盖层后确实不交互。中文字体与文字宽度也需实际渲染检查。静态坐标公式正确不等于实际点击区域正确。
