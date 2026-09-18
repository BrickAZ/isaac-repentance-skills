---
name: isaac-repentogon-ui
description: Use when building or reviewing in-game REPENTOGON ImGui developer panels, menu buttons, callbacks, visibility, teardown, or screen/world coordinate handling for Binding of Isaac mods. Covers CreateWindow naming, AddButton versus AddElement callbacks, menu/run guards, and the difference between a clickable HUD entry and a pinned ImGui window. 中文触发：忏悔龙界面、开发者按钮、ImGui 面板、游戏内菜单、固定窗口、鼠标坐标。
---

# ISAAC REPENTOGON UI

沿用已确认的依赖和 UI 设计；用户已授权 required REPENTOGON 时直接实现，不重新询问。技术缺口由 Agent 读取项目和目标版本证据解决；只有真正未决的用户选择进入 TBD。用户要求游戏内按钮/面板时交付游戏内入口，不能转成浏览器页面。

## TBD Disclosure Contract

A `TBD` is a genuinely unresolved user design choice. Missing paths, API
signatures, callback owners, build identities, and tool commands are technical
facts: discover them, or report **Unverified — discovery required** with the
specific evidence gap. Do not turn research work into a request for user permission.
Existing project decisions and explicit standing user preferences remain binding.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Preserve user-owned balance, mechanics, assets, dependency policy, and persistence semantics; resolve routine technical implementation choices within the authorized scope.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` for the shared user-decision and technical-discovery policy.

## 工作入口

1. 未知目标先用 `isaac-mod-context`；共同依赖 [isaac-repentogon-compat](../isaac-repentogon-compat/SKILL.md) 的版本/能力门禁与 [isaac-repentogon-dev](../isaac-repentogon-dev/SKILL.md) 的开发流程。先门禁，再注册任何 UI/扩展回调。
2. 明确入口：REPENTOGON 覆盖层中的菜单/按钮，还是正常游玩 HUD 上的小按钮。Pinned ImGui 关闭覆盖层后没有输入，不能冒充 HUD 点击入口。
3. 只读必要参考；1.1.2g 是证据基线，不能从最新版网页推断用户安装版本。

| 工作 | 参考 |
|---|---|
| 名称、参数、点击回调、ID 与可见性 | `references/imgui-api.md` |
| 可回收只读面板与注册/退出/重载 | `references/developer-panel.md` |
| HUD 输入入口、坐标、缩放与菜单态 | `references/hud-and-coordinates.md` |

## 核心合同

- 使用 `CreateWindow`，不存在已核实的 1.1.2g `AddWindow`。`AddElement` 不收点击函数；用 `AddButton` 第四参数或独立 `AddCallback`。
- 创建一次，状态变化更新；ID 用本 Mod 唯一前缀。关闭只隐藏本窗口；销毁仅移除自己的元素和回调，不调用全局 `ImGui.Reset()` / `Hide()` 清场。
- 按钮回调每次以 `Isaac.IsInGame()` 判断对局，再取当前世界对象。菜单能显示不代表玩家/房间存在；不跨退出保存 userdata。
- 只读按钮无游戏状态写入。未来动作按钮单独核验目标、触发一次、失败反馈；Render 不生成道具、波次或房间。
- 生命周期与 HUD 状态分别关联 `isaac-state-lifecycle`、`isaac-hud-ui-state`；世界动作关联 `isaac-repentogon-world`。不假定 MCM/StageAPI 存在。

## 离线回归

```text
lua <skill-dir>/tests/test-developer-panel.lua
```

测试直接提取 `references/developer-panel.md` 中的 Lua 工厂，覆盖 16 项 mock
检查；它验证文档示例与模拟接口下的创建、事件及清理行为，不证明原生 ImGui、
HUD 点击、中文显示或手柄支持。运行结果与游戏内验收分开报告。

## 验收交付

说明实际入口与打开方式、版本证据、菜单/对局状态、ID 所有权、销毁路径和坐标空间。隔离验证创建两次、点击、关闭/重开、未入局、退局、重载、卸载、其他 Mod 元素保留；中文显示、正常游玩 HUD 点击、缩放/分辨率与输入穿透需要游戏内另验。清楚区分静态、mock 行为和实机结果。
