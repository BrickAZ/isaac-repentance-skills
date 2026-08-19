# Isaac Repentance Skills

[English](README.md) | 简体中文

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
- 强化世界、视觉/渲染、回调偏移与屏幕坐标边界：逻辑标记默认只做一次 `owner.Position + 世界偏移 -> Isaac.WorldToScreen`；其他偏移仅由已发现的项目适配器消费且每项只应用一次，转换失败时不得用世界坐标继续绘制。
- 强化空白/无意义实体防护：只校验、替换或清理当前模组明确拥有的 Spawn/Morph 路径，不干扰其他模组。
- 为 EID、MCM、StageAPI 与 REPENTOGON 补齐缺失依赖和重复注册等 eval，保持官方 API fallback。
- 全量复核 48 个 skill 的结构、评测、引用与插件清单；静态校验通过。实际游戏验证仍由具体模组与运行环境完成。

## 本版新增能力

- **全局 TBD 提醒**：48 个 skill 都会把影响当前工作的未知项标为“需要用户决定”，说明影响，并在答复末尾汇总未决事项。
- **五个独立运行合同**：新增状态效果、商店/交易定价、GridEntity、Book of Virtues 魂火和套装变身，分别处理来源、计时、付款、网格坐标、魂火映射与形态激活，避免继续塞进伤害、经济、房间或普通使魔 skill。
- **实体引擎类型边界**：`isaac-entities` 与 `isaac-testing-debugging` 防止把 Lua table 当作 `Vector` 等引擎值传入 API，并要求测试桩验证真实调用边界。
- **房间拓扑与门位验证**：`isaac-rooms-stages` 与测试 skill 区分调试房、真实地图连通、合法门槽与本地坐标；无候选时不得静默消耗状态或删除无关门。
- **原生机制隔离**：`isaac-mechanic-contracts` 防止借用原版机制后清理原版拥有的房间、维度或实体，并要求同局隔离验证。
- **奖励、文本与注册一致性**：补齐奖励确认/延迟结算、静态 XML 多语言、运行期本地 ID 解析、可选依赖延迟出现，以及道具注册的稳定本地 ID 约束。
- **彩色道具透明通道合同**：彩色 `gfx` 必须用主体 alpha 蒙版而非“非色键像素全不透明”；在浅灰棋盘、白色、房间近似色复核，并逐 ANM2 裁切帧验收。`isaac-validators -CheckPngTransparency` 会警告缺失 alpha、统一外底或疑似内嵌深色底板，仍要求原生游戏表面验收。
- **角色美术表面分流**：严格区分游戏内 skin、头发/头饰挂饰、肖像、名称、角色选择、合作与死亡界面素材；图集裁切是坐标容量，不是视觉占满目标，普通头发以原版头部和原生 1× 叠加比例为准。
- **原版换皮与资源覆盖合同**：识别无 Lua 的纯资源模组，发现 `resources/` 与版本化资源根，区分精确路径覆盖、运行时换图和 Null Costume，并把加载顺序与遮挡策略保留为显式兼容决策。
- **音效与音乐证据合同**：区分 `sounds.xml`/`SFXManager` 和 `music.xml`/`MusicManager`；普通短音效优先采用 PCM WAV，除非目标项目已证明其他加载路线可用。`pcall` 或测试桩无报错只证明 Lua 调用成功，最终仍需最新游戏日志与实机可听结果。
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
| `isaac-wisps-virtues` | 处理 Book of Virtues、`wisps.xml`、魂火来源、重复使用、容量、死亡和资源映射。 |
| `isaac-npc-boss-ai` | 设计 NPC/Boss 状态机和攻击节奏。 |
| `isaac-projectile-combat` | 管理弹幕归属、伤害、命中和清理。 |
| `isaac-status-effects` | 管理异常状态的目标资格、来源、持续、叠加/刷新、免疫、周期伤害与清理。 |
| `isaac-players-characters` | 开发自定义角色和 Tainted 变体。 |
### 世界与空间

| Skill | 作用 |
| --- | --- |
| `isaac-rooms-stages` | 处理单房、楼层、门、房间拓扑和切层。 |
| `isaac-grid-entities` | 处理 GridEntity 的格子索引、合法位置、碰撞、破坏、归属和房间重访。 |
| `isaac-room-networks` | 处理多个自定义房间组成的独立区域、入口、路线、返回与局部失败。 |
| `isaac-dimensions` | 处理游戏层面的独立 Dimension、跨维度进入/返回、隔离与生命周期。 |

### 道具、掉落与进度

| Skill | 作用 |
| --- | --- |
| `isaac-active-item-mechanics` | 为主动道具提供充能、输入、UI 等机制分流壳。 |
| `isaac-passive-collectibles` | 管理被动道具持有、Cache、失去、重掷和重新获得。 |
| `isaac-collectible-registration` | 处理主动/被动道具 XML，并分开彩色图与原生 ESC My Stuff 图标链。 |
| `isaac-cards-pockets` | 处理卡牌、符文、药丸和口袋物品，分开卡面、Pickup、HUD/EID，并防止空白实体。 |
| `isaac-trinkets` | 处理饰品注册、持有判断、叠加及其独立视觉表面。 |
| `isaac-item-economy` | 审核品质、池子、权重、tags 和解锁后的经济影响。 |
| `isaac-shops-deals-pricing` | 处理商店/交易的运行时价格、购买者、付款、交付、补货和重掷重算。 |
| `isaac-item-synergies` | 定义多道具、饰品和角色联动的归属、叠加与失效边界。 |
| `isaac-transformations-forms` | 处理原版 PlayerForm 查询、自定义套装变身、贡献计数、激活、可逆性和展示分流。 |
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
| `isaac-character-art-surfaces` | 拆分角色各类美术表面，并约束原版参考编辑、头发/头饰比例、1× 叠加预览、服装遮挡矩阵和头套式失败。 |
| `isaac-reskins-resource-overrides` | 处理原版角色换皮、纯资源模组、精确路径覆盖、多资源根、运行时换图与加载顺序冲突。 |
| `isaac-anm2-visuals` | 处理 ANM2、Sprite、坐标系、视觉载体和可覆盖的原生 UI 资源基线。 |
| `isaac-audio-render-feedback` | 处理 SFX/音乐注册与格式、播放器职责、解码证据、shader、render 和输入拦截。 |
| `isaac-hud-ui-state` | 管理 HUD/UI 显示、世界坐标转屏幕坐标和短效状态清理。 |
| `isaac-localization-runtime` | 处理运行期多语言和依赖分流。 |
| `isaac-compat-descriptions` | 处理 EID/百科描述与可选依赖兼容。 |
| `isaac-config-options` | 处理配置、SaveData 和可选 MCM 接入。 |
| `isaac-eid-compat` | 处理可选 EID 描述、图标与语言注册。 |
| `isaac-mcm-compat` | 处理可选 Mod Config Menu 配置界面与重复注册。 |
| `isaac-stageapi-compat` | 处理可选 StageAPI 房间、楼层与版本兼容。 |
| `isaac-repentogon-compat` | 处理可选 REPENTOGON API、版本门控和官方 fallback。 |
## 验证与证据边界

仓库级检查会验证 48 个 skill 的 frontmatter、内部引用、TBD 合同、路由
覆盖、eval schema、离线第三方 API 参考和证据矩阵。Windows 下脚本会主动为
`quick_validate.py` 设置 UTF-8，避免系统 GBK 把合法中文误判为编码错误。

```powershell
powershell -ExecutionPolicy Bypass -File tests/test-skill-repository.ps1
```

`evals.json` 中的 `files` 是仓库内真实上下文，`fixture_files` 是题目中的
虚构项目文件；完整约定见 `docs/eval-schema.md`。静态审计、盲测回答、模拟
运行和游戏内验证是四种不同证据，前一层通过不得冒充后一层通过。
## 不做什么

这套 skills 不替用户决定平衡数值、视觉风格或机制设计，也不承诺未经运行的
代码已经通过实际游戏验证。项目事实与用户决定始终优先于通用模式。

## 仓库结构

```text
.codex-plugin/plugin.json  Codex plugin 清单
skills/                    48 个通用 Isaac skills
AGENTS.md                  给维护本仓库的 AI 的边界说明
```
