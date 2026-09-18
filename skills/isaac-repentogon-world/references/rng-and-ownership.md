# RNG 预览与世界状态所有权

基线：1.1.2g 源码 + 官方文档，核验于 2026-09-05。以下可验证状态边界，不承诺复制 RNG 即能模拟全部游戏行为。

## 实际 RNG 与独立预览

`level:GetGenerationRNG()` 返回引擎 `_generationRNG` 的指针，不是副本；在它上面 `Next`、`RandomInt` 或 `SetSeed` 会影响生成序列。预览分类：

| 需求 | 路线 |
|---|---|
| 只看下一随机值 | `rng:PhantomNext()` / `PhantomInt(max)` / `PhantomFloat()` / `PhantomVector()` |
| 按相同状态独立推进多次 | 读取 seed 和 shiftIdx，新建本地 RNG |
| 只读房间配置抽取 | 独立 seed + `RoomConfig.GetRandomRoom(..., false, ...)` |
| 实际改变地图/波次 | 明确提交路径，不在预览函数中执行 |

Phantom 方法不推进原状态；反复调用看到的仍是同一前瞻。`PhantomInt` 的 tag 实现也复用双参数区间处理，但基线示例只使用官方单参数形式。`GetShiftIdx()` 找不到标准组合时返回 nil，不能把 nil 交给默认参数后声称精确克隆。

```lua
local function CopyKnownRNG(source)
    local shift = source:GetShiftIdx()
    if shift == nil then return nil, "无法复制未识别的 RNG 位移组合" end
    local seed = source:GetSeed()
    if seed == 0 then return nil, "当前 RNG 种子无效" end
    return RNG(seed, shift)
end
```

前提是通过 REPENTOGON 依赖/版本门禁，且 source 来自有效当前上下文；此示例未经游戏实测。独立推进只能保证不消费原 RNG，不证明与后续引擎/其他 Mod 的消费路径相同。

依据：[官方 RNG](https://repentogon.com/RNG.html)、[tag RNG 实现](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaRNG.cpp)、[tag GetGenerationRNG](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaLevel.cpp#L308-L310)。RNG 构造不接受 0；楼层放置 seed 0 是另一份合同。

## 写入记录

每项副作用至少回答：

1. 写什么：模板权重、配置集、地图描述符、当前房间实体、共享波数还是引擎 RNG？
2. 谁拥有：本 Mod、本机制、本局/层/房，还是所有 Mod 共用？
3. 何时提交：用户动作/机制触发一次，是否需要防重入？
4. 何时恢复或重建：离房、换层、新局、续局、退局、luareset/Mod 重载？
5. 失败保留什么：nil/false 后的原有地图、奖励、用户设置或后续路线？

临时覆盖共享值时保存原值及本次已写值；恢复时重新读取，若他方已改写则不能直接覆盖。单靠数值相等不证明唯一所有者；复杂共存需要项目明确的协调协议。不要为了“恢复默认”无条件写入 Ambush 的 3/2，或重置全局 RNG/所有配置权重。

这是基于共享字段与指针绑定的 **设计推论**；不是引擎提供的事务/所有权 API。运行存储方式与恢复时机沿用目标项目已批准的生命周期合同，未批准的永久玩法变更才是用户决策。

## 只读预览的验收

比较调用前后原 RNG seed、位移索引、相关配置权重与已放置房间数；连续刷新和缺失配置路径都要测。不要用一次返回值相同替代状态不变检查。1.1.2g `Ambush.GetNextWaves` 的恢复早退问题见 `ambush.md`，不能纳入无副作用预览白名单。

隔离脚本只能证明模组的分支/封装行为；引擎内部波次、地图和续局行为需游戏内验证。跨局/层保存时用稳定身份键重定位，不持久化 userdata 或把旧指针当本局对象。
