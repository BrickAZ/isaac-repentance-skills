# Isaac Repentance Skills

[English](README.md) | 简体中文

一套专门用于《以撒的结合：忏悔》模组开发的 Codex Skills。它帮助 AI 先读取
真实项目，再处理机制、回调、实体、资源、状态、兼容与验证，减少“代码看似合理，
但 API、坐标、资源链或生命周期其实写错了”的情况。

本仓库不是模组本体，也不是要求所有项目套用同一份模板。安装后，你仍然可以像
平常一样描述需求；Codex 会根据任务选择合适的 Skill，并以目标模组和官方 Isaac
API 为准。

## 它能帮你做什么

- **先发现再实现**：寻找真实入口、模块、XML、资源路径、注册方式和测试命令，不凭空编造项目事实。
- **拆分高风险机制**：分别处理道具、卡牌、饰品、角色、使魔、实体、Boss、房间、维度、解锁、伤害和随机数等合同。
- **分清视觉表面**：区分彩色道具图、ESC My Stuff、Pickup、卡面、HUD、角色皮肤、挂饰、肖像和 ANM2，而不是拿一张 PNG 到处复用。
- **约束回调和状态**：明确 callback 过滤器、返回值、所有者、多人隔离、SaveData 和房间/楼层/重开清理。
- **默认兼容其他模组**：只处理当前模组拥有的实体、替换和状态，不全局删除未知内容。
- **诚实报告证据**：静态检查、隔离测试、模拟运行和游戏内验证分开报告，不把“测试桩没报错”写成“实机已经通过”。

## 适用范围

本仓库只适用于《以撒的结合：忏悔》模组开发，不是通用编程 Skill，也不适用于
其他游戏、引擎或应用开发。

这些 Skills 是自包含的。使用者不需要下载 YSD、东方、Samael、愚昧、
neverbrith 或其他参考模组。参考模组只用于构建和验证规则，不是运行前置。

默认实现顺序是：

1. 目标模组已经确认的代码与资源；
2. 官方 Isaac API；
3. 项目明确声明或用户明确要求的第三方库。

CuerLib、EID、MCM、StageAPI、REPENTOGON 等均不被默认视为必需前置。

## 安装

当前由仓库直接验证的方式是安装 `skills/` 下的各个 Skill 目录。仓库同时包含
`.codex-plugin/plugin.json`，但在没有可验证的一键安装入口时，本说明不假设
GitHub URL 或插件商店按钮能够自动完成安装。

### 全局安装

全局安装后，这些 Skills 可供本机的 Codex 项目使用。

```powershell
git clone https://github.com/BrickAZ/isaac-repentance-skills.git
cd isaac-repentance-skills
$target = Join-Path $HOME ".codex\skills"
New-Item -ItemType Directory -Force $target | Out-Null
Copy-Item -Recurse -Force ".\skills\isaac-*" $target
```

macOS 或 Linux：

```bash
git clone https://github.com/BrickAZ/isaac-repentance-skills.git
cd isaac-repentance-skills
mkdir -p ~/.codex/skills
cp -R skills/isaac-* ~/.codex/skills/
```

如目标位置已有同名 Skill，上述命令会更新其文件。重要的本地自定义内容应先备份。
安装或更新后，重新打开一个 Codex 任务，让 Codex 重新发现 Skills。

### 仅安装到一个项目

也可以把 `skills/` 下需要的 Skill 目录复制到目标模组的：

```text
<mod-root>/.codex/skills/
```

这种方式只影响该项目，适合隔离测试或不希望全局安装的使用者。不要只复制
`SKILL.md`；Skill 目录内的 `references/`、`scripts/`、`evals/` 和其他配套文件
也属于合同的一部分。

### 检查安装是否完整

从仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File tests/test-installed-skill-parity.ps1
```

这个检查比较仓库版本与默认全局安装目录。它证明文件一致，不证明某个具体模组已经
通过游戏内测试。

## 快速使用

多数情况下不需要背 Skill 名称。打开目标模组项目，直接描述需求即可：

```text
给这个《以撒的结合：忏悔》模组新增一个被动道具：持有时伤害 +1。
先发现项目入口、道具注册方式和现有属性实现；不要假设第三方前置。
品质、池子和解锁方式没有决定的部分保持 TBD，并提醒我决定。
```

需要严格限定过程时，可以显式指定 Skills：

```text
使用 isaac-mod-context、isaac-collectible-registration、
isaac-passive-collectibles 和 isaac-callback-contracts。
先输出发现项，再实现并分别报告静态检查与尚未完成的实机验证。
```

只想审查、不允许修改文件时，应把边界直接写进提示词：

```text
这是只读审查。不要修改文件。
检查这个世界跟随 Sprite 是否混用了世界坐标、屏幕坐标、PositionOffset
和 callback RenderOffset；未知项目事实保持 TBD。
```

当一个未知项会阻止正确实现时，Skills 会将它标为：

```text
TBD — 需要用户决定
```

并说明它影响什么。Skill 不应擅自替用户决定平衡数值、池子、权重、解锁条件、
美术方向或机制设计。

## 工作方式

一次任务通常只需要一个主 Skill 和少量辅助 Skill：

1. `isaac-repentance-router` 判断需求属于哪个领域；
2. `isaac-mod-context` 发现目标模组的真实结构；
3. 领域 Skill 定义机制、资源、状态和兼容边界；
4. `isaac-testing-debugging` 与 `isaac-validators` 区分能自动证明和仍需实机确认的内容。

Skills 提供的是决策合同，不是固定代码模板。目标项目已经存在的正确模式和用户明确
给出的设计，始终优先于通用建议。

## 能力概览

| 领域 | 覆盖内容 |
| --- | --- |
| 项目与可靠实现 | 项目发现、架构、机制合同、callback、状态、性能、测试和静态校验 |
| 实体与战斗 | 注册实体、使魔、魂火、NPC/Boss、弹幕、异常状态和自定义角色 |
| 世界与空间 | 房间、楼层、GridEntity、多房间区域和独立 Dimension |
| 道具与进度 | 主动/被动、注册、卡牌、饰品、经济、商店、联动、奖励、挑战和解锁 |
| 运行规则 | 伤害、生命、诅咒、重掷、移除、随机数和形态变身 |
| 资源与兼容 | ANM2、角色美术、换皮覆盖、音效、HUD、多语言及可选第三方 API |

## 完整 Skill Map

### 项目发现与可靠实现

| Skill | 作用 |
| --- | --- |
| `isaac-mod-context` | 发现真实入口、资源、XML、依赖和验证命令。 |
| `isaac-mod-architecture` | 划分模块边界、接入点并避免重复注册。 |
| `isaac-repentance-router` | 为陌生需求选择一个主 Skill，并控制辅助 Skill 的数量。 |
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

## 核心约束

- 不编造路径、ID、Variant、SubType、ANM2 动画名、callback 注册位置或第三方 API。
- 不把参考模组的架构、依赖或本地工具当作新项目的默认答案。
- 不用固定运行时 ID 代替 XML 本地 ID 和运行时名称解析。
- 不把 Lua table 当作 `Vector`、`RNG` 或其他 Isaac 引擎对象传给 API。
- 不把世界坐标、视觉偏移、callback 偏移和屏幕坐标混在同一次渲染计算中。
- 不因为一个表面正常，就推断另一个表面的资源链也正常。
- 不清理其他模组可能拥有的卡牌、Pickup、实体、房间、门或状态。
- 用户已经给出的数值和设计优先；只有用户未决定时才提出建议。

## 验证与证据边界

仓库级检查会验证 48 个 Skill 的 frontmatter、内部引用、TBD 合同、路由覆盖、
eval schema、离线第三方 API 参考、证据矩阵和已安装文件一致性。

```powershell
powershell -ExecutionPolicy Bypass -File tests/test-skill-repository.ps1
```

在 Windows 下，校验脚本会为 `quick_validate.py` 启用 UTF-8，避免系统 GBK 将
合法中文误判为编码错误。

证据分为四层：

1. **静态审计**：文件、XML、路径、注册、引用和代码结构；
2. **隔离行为测试**：在测试桩中验证机制分支、类型边界和状态变化；
3. **模拟或受控运行**：验证更接近引擎调用的行为；
4. **游戏内验证**：真实加载、视觉、声音、碰撞、多人和兼容性。

前一层通过不能冒充后一层通过。某项检查未运行时，Skill 应明确写出“未验证”，
而不是用推测补全结果。

## 仓库结构

```text
.codex-plugin/plugin.json  Codex plugin 清单
skills/                    48 个通用 Isaac Skills
docs/                      eval schema 与证据矩阵
tests/                     仓库审计和安装一致性检查
AGENTS.md                  维护本仓库时必须遵守的 AI 边界
README.md                  英文说明
README.zh-CN.md            中文说明
```

## 反馈问题

当某个 Skill 在真实开发中给出错误方案时，请尽量提供：

- 原始需求；
- Codex 实际给出的方案；
- 目标模组中相关文件或最小复现；
- 最新游戏日志；
- 已完成的静态、脚本和游戏内验证；
- 你认为正确的行为边界。

这类反馈比单纯增加更多规则更有价值，因为它能区分 Skill 缺口、项目事实缺失、
测试桩失真和执行 Agent 没有遵守现有合同。可以通过
[GitHub Issues](https://github.com/BrickAZ/isaac-repentance-skills/issues) 提交。
