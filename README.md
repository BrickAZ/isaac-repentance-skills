# Isaac Repentance Skills

一套面向 Codex 的《以撒的结合：忏悔》模组开发 skills。它不提供一个
“万能模板”，而是把容易出错的决策拆开：先发现项目事实，再选择机制、回调、
资源、状态和验证路径。

这是一个 Codex plugin 源仓库。插件清单位于
`.codex-plugin/plugin.json`，通用 skills 位于 `skills/`。

## 适用范围

本插件只服务于《以撒的结合：忏悔》辅助模组开发，不是通用编程工具，
也不适用于其他游戏、引擎或应用开发。

## 核心原则

- 先读取目标模组，再写实现。
- 默认使用官方 Isaac API 和目标模组已有代码。
- CuerLib、EID、MCM、StageAPI 等均不是默认前置。
- 用户未决定的数值、池子、权重、美术和机制细节保持 `TBD`，并在每次涉及它们的答复中标为“需要用户决定”。
- 不编造路径、实体 Variant、ANM2 动画名、回调注册位置或第三方 API。
- 静态校验、隔离行为测试和实际游戏验证分别报告，不能混为“已验证”。
- 原生 UI 表面彼此独立：彩色道具图、ESC My Stuff、卡面、HUD、角色选择、合作菜单、成就和 Boss 肖像必须分别发现并验证。
- 用户未提供美术时，官方尺寸仅是可覆盖的源帧建议；生成资源仍必须接入已发现的 XML、ANM2、图集与映射，不能假设 loose PNG 会自动加载。

## 本版强化

- 为原生视觉补充可覆盖的官方资源基线，以及彩色道具图、ESC My Stuff、卡面、HUD 与世界 Pickup 的明确分流。
- 强化世界坐标与屏幕坐标边界：手动 Sprite:Render 必须经过 Isaac.WorldToScreen，并按 owner 偏移与尺寸策略验证。
- 强化空白/无意义实体防护：只校验、替换或清理当前模组明确拥有的 Spawn/Morph 路径，不干扰其他模组。
- 为 EID、MCM、StageAPI 与 REPENTOGON 补齐缺失依赖和重复注册等 eval，保持官方 API fallback。
- 全量复核 39 个 skill、197 条 eval 与 254 个 reference 链接；结构、引用和插件校验均通过。实际游戏验证仍由具体模组与运行环境完成。

## 本版新增能力

- **全局 TBD 提醒**：39 个 skill 都会把影响当前工作的未知项标为“需要用户决定”，说明影响，并在答复末尾汇总未决事项。
- **实体引擎类型边界**：`isaac-entities` 与 `isaac-testing-debugging` 防止把 Lua table 当作 `Vector` 等引擎值传入 API，并要求测试桩验证真实调用边界。
- **房间拓扑与门位验证**：`isaac-rooms-stages` 与测试 skill 区分调试房、真实地图连通、合法门槽与本地坐标；无候选时不得静默消耗状态或删除无关门。
- **原生机制隔离**：`isaac-mechanic-contracts` 防止借用原版机制后清理原版拥有的房间、维度或实体，并要求同局隔离验证。
- **奖励、文本与注册一致性**：补齐奖励确认/延迟结算、静态 XML 多语言、运行期本地 ID 解析、可选依赖延迟出现，以及道具注册的稳定本地 ID 约束。
## Skill Map

### 项目发现与可靠实现

| Skill | 作用 |
| --- | --- |
| `isaac-mod-context` | 发现真实入口、资源、XML、依赖和验证命令。 |
| `isaac-mod-architecture` | 划分模块边界、接入点并避免重复注册。 |
| `isaac-repentance-router` | 为陌生需求选择一个主 skill，并控制辅助 skill 的数量。 |
| `isaac-mechanic-contracts` | 先定义机制的输入、结果与边界，再选择实现。 |
| `isaac-callback-contracts` | 选择 callback、过滤器、注册时机和返回值。 |
| `isaac-state-lifecycle` | 管理运行期状态、SaveData 以及房间、重开和死亡清理。 |
| `isaac-performance-hotpaths` | 审核逐帧扫描、重复 Spawn 和其他性能热点。 |
| `isaac-testing-debugging` | 分层复现、调试和验证问题，并分开验证各原生 UI 表面。 |
| `isaac-validators` | 检查 XML、资源引用、重复 ID、常见回调和本模拥有的实体生成链。 |

### 实体与战斗

| Skill | 作用 |
| --- | --- |
| `isaac-entities` | 处理注册实体、碰撞、生命周期和视觉载体。 |
| `isaac-familiars` | 处理跟随物生成、所有权、多玩家和重生。 |
| `isaac-npc-boss-ai` | 设计 NPC/Boss 状态机和攻击节奏。 |
| `isaac-projectile-combat` | 管理弹幕归属、伤害、命中和清理。 |
| `isaac-players-characters` | 开发自定义角色和 Tainted 变体。 |
| `isaac-rooms-stages` | 处理房间、楼层、门和切层。 |

### 道具、掉落与进度

| Skill | 作用 |
| --- | --- |
| `isaac-active-item-mechanics` | 为主动道具提供充能、输入、UI 等机制分流壳。 |
| `isaac-passive-collectibles` | 管理被动道具持有、Cache、失去、重掷和重新获得。 |
| `isaac-collectible-registration` | 处理主动/被动道具 XML，并分开彩色图与原生 ESC My Stuff 图标链。 |
| `isaac-cards-pockets` | 处理卡牌、符文、药丸和口袋物品，分开卡面、Pickup、HUD/EID，并防止空白实体。 |
| `isaac-trinkets` | 处理饰品注册、持有判断、叠加及其独立视觉表面。 |
| `isaac-item-economy` | 审核品质、池子、权重、tags 和解锁后的经济影响。 |
| `isaac-item-synergies` | 定义多道具、饰品和角色联动的归属、叠加与失效边界。 |
| `isaac-reroll-removal-contracts` | 管理重掷、移除、替换后的幂等 reconciliation。 |
| `isaac-rng-determinism` | 管理随机源、抽取边界、种子范围和多人可复现性。 |
| `isaac-rewards-pickups` | 处理奖励选择、已拥有目标的 Spawn/Morph、世界 Pickup 资源链和失败保留原物。 |
| `isaac-challenges` | 处理挑战 XML、起始物品和运行规则。 |
| `isaac-unlocks-progression` | 处理永久解锁、成就、存档、可用性 gate 和独立展示表面。 |

### 伤害、诅咒与运行规则

| Skill | 作用 |
| --- | --- |
| `isaac-damage-health-contracts` | 处理伤害语义、无敌帧、来源归属、递归与致命/复活边界。 |
| `isaac-curses-run-modifiers` | 管理已有诅咒位的运行期增加、抑制、重算和清理。 |

### 资源、文本与可选集成

| Skill | 作用 |
| --- | --- |
| `isaac-anm2-visuals` | 处理 ANM2、Sprite、坐标系、视觉载体和可覆盖的原生 UI 资源基线。 |
| `isaac-audio-render-feedback` | 处理音效、shader、render 和输入拦截。 |
| `isaac-hud-ui-state` | 管理 HUD/UI 显示、世界坐标转屏幕坐标和短效状态清理。 |
| `isaac-localization-runtime` | 处理运行期多语言和依赖分流。 |
| `isaac-compat-descriptions` | 处理 EID/百科描述与可选依赖兼容。 |
| `isaac-config-options` | 处理配置、SaveData 和可选 MCM 接入。 |
| `isaac-eid-compat` | 处理可选 EID 描述、图标与语言注册。 |
| `isaac-mcm-compat` | 处理可选 Mod Config Menu 配置界面与重复注册。 |
| `isaac-stageapi-compat` | 处理可选 StageAPI 房间、楼层与版本兼容。 |
| `isaac-repentogon-compat` | 处理可选 REPENTOGON API、版本门控和官方 fallback。 |
## 不做什么

这套 skills 不替用户决定平衡数值、视觉风格或机制设计，也不承诺未经运行的
代码已经通过实际游戏验证。项目事实与用户决定始终优先于通用模式。

## 仓库结构

```text
.codex-plugin/plugin.json  Codex plugin 清单
skills/                    39 个通用 Isaac skills
AGENTS.md                  给维护本仓库的 AI 的边界说明
```
