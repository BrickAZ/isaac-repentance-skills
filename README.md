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
- YSD、Reverie、CuerLib、EID、MCM、StageAPI 等均不是默认前置。
- 用户未决定的数值、池子、权重、美术和机制细节保持 `TBD`。
- 不编造路径、实体 Variant、ANM2 动画名、回调注册位置或第三方 API。
- 静态校验、隔离行为测试和实际游戏验证分别报告，不能混为“已验证”。

## Skill Map

### 项目发现与可靠实现

| Skill | 作用 |
| --- | --- |
| `isaac-mod-context` | 发现真实入口、资源、XML、依赖和验证命令。 |
| `isaac-mod-architecture` | 划分模块边界、接入点并避免重复注册。 |
| `isaac-mechanic-contracts` | 先定义机制的输入、结果与边界，再选择实现。 |
| `isaac-callback-contracts` | 选择 callback、过滤器、注册时机和返回值。 |
| `isaac-state-lifecycle` | 管理运行期状态、SaveData 以及房间、重开和死亡清理。 |
| `isaac-testing-debugging` | 分层复现、调试和验证问题。 |
| `isaac-validators` | 检查 XML、资源引用、重复 ID 和常见回调问题。 |

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
| `isaac-collectibles` | 处理被动收集品的注册、持有/叠加、缓存属性、事件效果和清理。 |
| `isaac-cards-pockets` | 处理卡牌、符文、药丸和口袋物品，并防止空白实体。 |
| `isaac-trinkets` | 处理饰品注册、持有判断和叠加。 |
| `isaac-item-economy` | 审核品质、池子、权重、tags 和解锁后的经济影响。 |
| `isaac-rewards-pickups` | 处理奖励选择、Spawn/Morph 和失败时保留原物。 |
| `isaac-challenges` | 处理挑战 XML、起始物品和运行规则。 |
| `isaac-unlocks-progression` | 处理永久解锁、成就、存档和可用性 gate。 |

### 资源、文本与可选集成

| Skill | 作用 |
| --- | --- |
| `isaac-anm2-visuals` | 处理 ANM2、Sprite、坐标系和视觉载体选择。 |
| `isaac-audio-render-feedback` | 处理音效、shader、render 和输入拦截。 |
| `isaac-localization-runtime` | 处理运行期多语言和依赖分流。 |
| `isaac-compat-descriptions` | 处理 EID/百科描述与可选依赖兼容。 |
| `isaac-config-options` | 处理配置、SaveData 和可选 MCM 接入。 |

## 不做什么

这套 skills 不替用户决定平衡数值、视觉风格或机制设计，也不承诺未经运行的
代码已经通过实际游戏验证。项目事实与用户决定始终优先于通用模式。

## 仓库结构

```text
.codex-plugin/plugin.json  Codex plugin 清单
skills/                    26 个通用 Isaac skills
AGENTS.md                  给维护本仓库的 AI 的边界说明
```
