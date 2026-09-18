---
name: isaac-repentogon-world
description: Use when developing or reviewing REPENTOGON room configuration, Level room placement, RoomDescriptor state, Ambush waves, or deterministic world previews for Binding of Isaac mods. Covers GetNextWave/GetNextWaves, nil/false placement failures, shared room weights, and engine RNG ownership. 中文触发：忏悔龙房间、楼层放置、挑战房波次、Boss Rush、房间预览、世界状态。
---

# ISAAC REPENTOGON World

先沿用已确认的项目与用户授权。用户已选择 required REPENTOGON 时，直接实现该路线，不重新询问依赖选择。技术事实缺失由 Agent 读取项目、官方文档和目标版本源码解决；仅真正未决的用户选择进入下述 TBD 流程。

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

1. 未知目标模组先用 `isaac-mod-context`。共同依赖 [isaac-repentogon-compat](../isaac-repentogon-compat/SKILL.md) 的依赖/版本门禁与 [isaac-repentogon-dev](../isaac-repentogon-dev/SKILL.md) 的开发流程；门禁成功后才进入本技能。
2. 明确此次操作属于配置注册、地图放置、运行中房间状态、波次控制或预览。全局表存在不证明当前对局可用；访问游戏对象前检查 `Isaac.IsInGame()`，回调中重新取得当前 Level/RoomDescriptor。
3. 按表只读必要参考；其中 1.1.2g 是核验基线，不自动代表用户安装版本。区别官方文档、tag 源码与源码推断。

| 表面 | 必读参考 |
|---|---|
| RoomConfig、RoomDescriptor、Level、维度与门 | `references/rooms.md` |
| Ambush、普通/Boss 挑战房、Boss Rush | `references/ambush.md` |
| RNG、预览、共享状态、恢复与续局 | `references/rng-and-ownership.md` |

## 执行合同

- `RoomConfig` 是配置；`RoomDescriptor` 是地图记录；当前 `Room` 是活跃实例。保持这三者边界。
- 预检用 `CanPlaceRoom` / 候选位置；提交用 `TryPlaceRoom`，检查 falsy 返回并保留原逻辑。预览不调用放置、减权或生成。
- `GetNextWave` 必须房型守卫和 nil 分支；1.1.2g 的 `GetNextWaves` 有明确实现缺陷，不作为严格只读预览的默认路线。
- 每项写入记录所有者、影响范围、触发时机和退出/续局/重载恢复。共享最大波数不按猜测覆盖回默认值。
- 拓扑/自定义房间网络转交 `isaac-room-networks`、`isaac-rooms-stages`；生命周期转交 `isaac-state-lifecycle`；不把 StageAPI 当隐含依赖。

## 交付与验证

交付精确 API/版本证据、预览与提交路径、失败值处理、所有权及生命周期、实际测试结果。用隔离测试覆盖菜单态、配置缺失、nil/false、无有效位置、维度、重复调用、RNG/权重不变；地图可通行、波次实机行为和续局必须游戏内另验。未运行则明确标记未验，不以源码或静态通过替代。
