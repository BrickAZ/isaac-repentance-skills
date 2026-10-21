# Module Loading, Shared Queries And Instance Lifecycles

[简体中文](#简体中文) | [English](#english)

## 简体中文

本次更新七个已有 Skill，不增加新的 Skill，也不改变插件版本。

| Skill | 本次改进 |
| --- | --- |
| `isaac-mod-context` | 发现加载包装器、缓存作用域、导出形态、消费者及就绪时序，不把未知 API 事实交给用户拍板。 |
| `isaac-mod-architecture` | 区分加载器、函数/表导出、工厂与实例；共享启动入口创建的实例；定义查询和效果边界及跨模组命名空间。 |
| `isaac-eid-compat` | 动态描述只读查询；显示副本与排序语义；EID 自身语言、语言注册函数、提供方就绪和版本绑定的重复注册合同。 |
| `isaac-compat-descriptions` | 将动态 EID 和加载合同路由到对应 Skill；可选兼容层不重复执行玩法模块。 |
| `isaac-state-lifecycle` | 缓存闭包与当前实例分离；旧依赖失效、资源归属、重建和已确认纯数据持久化。 |
| `isaac-repentogon-ui` | 缓存工厂不等于面板已安装；旧读取/关闭/销毁函数不得操作使用相同 ID 重建的新面板。 |
| `isaac-testing-debugging` | 使用会执行真实模块体的加载替身；验证嵌套别名、副作用、重复初始化及当前代绑定；区分脚本与原生证据。 |

配套变更包括四份专项参考、一个新的可执行模块示例测试、已有 UI 示例测试的扩展和 17 个新增 eval 定义。七份 eval 集合从 53 条增至 70 条；定义数不等于实际执行次数。

验证记录（2026-10-21）：

- 模块示例的 33 项检查和 UI 示例的 22 项模拟检查通过。
- 四个新建独立 Codex 对话覆盖上述七份 Skill；人工语义复核为 4/4 场景、19/19 验收点满足。没有发送预期答案；这是小样本应用测试，不是统计效果证明。
- 四个对话限定了应读 Skill，未验证自动路由能力；其中一个对话有两次入口读取输出截断，专项参考完整。
- 没有在游戏中验证真实 include 搜索、require 缓存、EID 渲染、ImGui 卸载顺序或热重载。

本次提交不包含另一轮未发布的角色切换 Skill、相应路由、插件版本或 README 的整包发布修改。交接副本仅移除了状态 Skill 中与该未发布功能有关的四行指引；本次模块合同保持不变。

## English

This update refines seven existing skills. It does not add a skill or bump the plugin version.

The changes distinguish module execution, exports, factories, cached instances, registration ownership and the lifetime of live dependencies. Dynamic EID descriptions consume read-only gameplay queries rather than advancing gameplay RNG or depleting the real pool. Display formatting must respect result ownership and meaningful order. Cached UI factories must bind current dependencies; disposed callbacks must not read the world or affect a replacement panel that reuses the same IDs.

Four focused references, a runnable module example test, extended UI example checks and 17 eval definitions accompany the guidance. The seven eval sets contain 70 cases, up from 53; definitions are not execution results.

Evidence is deliberately separated: 33 module checks and 22 UI-double checks passed; four fresh Codex chats satisfied 19 manually reviewed application gates. Those chats were given skill names and scenarios, not expected answers. One chat had truncated entrypoint reads but complete topic references. This is a small application review, not a statistical benchmark, automatic-routing test or native Isaac validation.

The separately pending character-switching skill and release metadata are outside this patch. Only an unrelated four-line route to that unpublished skill was omitted from the handoff copy of the state skill. The tested module-contract guidance is unchanged.
