# Ambush: 1.1.2g 合同

核验日期：2026-09-05。证据级别：官方网页 + 固定 tag 源码静态核对；没有游戏运行证明。当前网页不是版本锁，其他版本需重新核对。

## 精确接口

下表为 `Ambush` 全局表的点调用。该表的多数绑定直接访问 `g_Game`，因此表存在不能代替当前对局检查。

| 调用 | 返回 / 作用 |
|---|---|
| `Ambush.GetCurrentWave()` | 当前挑战房或 Boss Rush 波数 integer |
| `Ambush.GetNextWave()` | 下一挑战房配置 `RoomConfigRoom` 或 `nil` |
| `Ambush.GetNextWaves()` | 后续挑战房配置表；见下方缺陷 |
| `Ambush.GetMaxChallengeWaves()` / `SetMaxChallengeWaves(waves)` | 普通挑战房上限，初始 3 |
| `Ambush.GetMaxBossChallengeWaves()` / `SetMaxBossChallengeWaves(waves)` | Boss 挑战房上限，初始 2 |
| `Ambush.GetMaxBossrushWaves()` / `SetMaxBossrushWaves(waves)` | Boss Rush 上限，默认 15；setter 仅将大于 25 的值钳到 25 |
| `Ambush.StartChallenge()` | 开始挑战房或 Boss Rush |
| `Ambush.SpawnWave()` / `SpawnBossrushWave()` | 生成对应波次；不是预览 |

依据：[官方 Ambush](https://repentogon.com/Ambush.html)、[1.1.2g LuaAmbush.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaAmbush.cpp)。负数等输入没有通用安全钳制保证；在模组合同中验证用户已批准的取值。

## 单波预览

两个预览函数共同调用 `SetupAmbushData`，要求当前配置 `Type == 11`，即 `RoomType.ROOM_CHALLENGE`；普通与 Boss 挑战房均适用，Boss Rush 不适用。错误房型会抛 Lua error。

单波版本复制 Ambush RNG，尚未开始时采用 `SpawnSeed`，查询使用 `ReduceWeight=false`。无配置或达到尝试上限的路径返回 `nil`。它没有检查“当前波数已经达到设置上限”，因此返回配置不证明还有一波会实际发生。以下示例在项目已完成 REPENTOGON 门禁后使用：

```lua
local function InspectNextChallengeWave()
    if not Isaac.IsInGame() then return nil, "尚未进入对局" end
    if Game():GetRoom():GetType() ~= RoomType.ROOM_CHALLENGE then
        return nil, "当前不是挑战房"
    end
    local config = Ambush.GetNextWave()
    if not config then return nil, "没有可预览的波次配置" end
    return config, "配置可读；实际波次仍受当前挑战状态影响"
end
```

依据：[tag 的 SetupAmbushData 与 GetNextWave](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaAmbush.cpp#L104-L165)。示例是接口合同演示，未经游戏内验收；不修改返回的共享配置。

## GetNextWaves 已知实现缺陷

以下属于 **1.1.2g 源码推断**，不能误写成官方宣称已修复：

- 源码计算 Boss 房的 `limit`，实际循环仍比较普通 `ambushWaves`，所以表长不可靠地表示 Boss 剩余波数。
- 为模拟后续抽取，它先读权重再执行 `ReduceWeight=true`，最后恢复记录的权重。中途 `!config` 分支直接返回，绕过恢复和结果填表；不能保证异常路径无共享权重影响。
- 空生成配置与重复选中配置的恢复行为也需实测；不把正常路径有恢复循环推导为任意输入下纯函数。

依据：[tag 的 GetNextWaves](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaAmbush.cpp#L168-L228)。默认 UI 检查用有守卫的单波查询；需要多波确定性时先报告限制并核对目标构建，不能拿它每帧刷新并承诺无副作用。

## 写入范围与危险调用

普通/Boss 挑战上限由 C++ 全局变量持有；官方明确记录新开游戏不重置。它们不是当前房间私有参数。临时修改前记录原值、所有者及已写值；恢复前检查是否仍由本逻辑持有，处理退局、续局和重载，不能无条件写回 3/2。Boss Rush setter 写入 Ambush 字段；不要从普通挑战变量推导其 reset 语义。

官方记录：`SpawnWave` 在 Greed/Greedier 或 Blue Womb 会崩溃；`StartChallenge` 在挑战房/Boss Rush 以外可能只永久关门；`SpawnBossrushWave` 在会话从未触发 Boss Rush 时不起作用。这些 API 不用于判断是否可用，也不在预览/Render 回调中调用。

依据：[官方的 Bug 与上限说明](https://repentogon.com/Ambush.html)、[tag 全局变量与 setters](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaAmbush.cpp#L5-L84)。

验收：普通/Boss 挑战房、Boss Rush、其他房、尚未进入游戏；nil 配置、已结束挑战；多次预览的 RNG/权重；新局/续局/重载与其他 Mod 写入冲突。静态发现不能替代这些实机检查。

## 危险动作之前的只读上下文谓词

以下补充仍以 1.1.2g、2026-09-05 为核验边界。先检查 `Isaac.IsInGame()`，再获取 `Game()`、房间和楼层。官方将它定义为游戏对象及当前状态检查；tag 的 Lua 绑定转发至 `Isaac::IsInGame()`。仅检查 `Ambush` 表存在、当前房间类型或玩家数量都不能替代该门禁。依据：[官方 IsInGame](https://repentogon.com/Isaac.html#isingame)、[tag LuaIsaac.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaIsaac.cpp#L592-L596)。

模式和楼层使用以下精确判定：

- `game:IsGreedMode()` 为 true 同时表示 Greed 或 Greedier，不需要再猜测一个 `IsGreedierMode` 接口。
- `game:GetLevel():GetStage() == LevelStage.STAGE4_3` 表示 Blue Womb，枚举值为 9。`RoomType.ROOM_BLUE`（28）是蓝钥匙房的房型，不是该楼层判定；也不用背景或显示名称推断楼层。
- `RoomType.ROOM_CHALLENGE`（11）同时包含普通和 Boss 挑战房；Boss 挑战房不是 `ROOM_BOSS`（5）。Boss Rush 使用 `RoomType.ROOM_BOSSRUSH`（17）。

依据：[基础 API 的 IsGreedMode](https://wofsauge.github.io/IsaacDocs/rep/Game.html#isgreedmode)、[LevelStage 枚举](https://wofsauge.github.io/IsaacDocs/rep/enums/LevelStage.html)、[RoomType 枚举](https://wofsauge.github.io/IsaacDocs/rep/enums/RoomType.html)。这些是基础 API 文档；tag 的 `SetupAmbushData` 另外确认预览只接受类型 11，并用配置的 Subtype 区分 Boss 挑战房，不能据此推导所有危险动作都有相同的引擎检查。

| 动作名 | 本合同允许继续审查的房型 | 证据与限制 |
|---|---|---|
| `StartChallenge` | `ROOM_CHALLENGE` 或 `ROOM_BOSSRUSH` | 官方记录其他房型可能永久关门 |
| `SpawnWave` | `ROOM_CHALLENGE` | **保守集成白名单**；官方描述可在当前房间生成对应楼层的挑战波次，没有宣称引擎仅允许挑战房 |
| `SpawnBossrushWave` | `ROOM_BOSSRUSH` | **保守集成白名单**；还需另行证明本次游戏会话已经触发过 Boss Rush |

共同排除 Greed、Greedier 和 Blue Womb，是本合同对三个危险动作采用的保守边界。官方明确崩溃记录针对 `SpawnWave`；不要写成已证明另外两个 API 在这些上下文也必然崩溃。**1.1.2g 源码静态结论**：三个 Lua 包装函数直接取 `g_Game->GetAmbush()` 并调用底层动作，没有在包装层检查上述上下文；这不代表已穷尽底层引擎的条件。依据：[官方危险动作说明](https://repentogon.com/Ambush.html#spawnwave)、[tag 三个动作的包装函数](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaAmbush.cpp#L17-L35)。

```lua
-- 只读判定：operation 是动作名字串，本函数从不调用任何 Ambush 动作。
local function InspectAmbushActionContext(operation)
    if type(REPENTOGON) ~= "table" or type(Isaac) ~= "table"
        or type(Isaac.IsInGame) ~= "function" or type(Ambush) ~= "table" then
        return false, "需要已核实版本的 REPENTOGON"
    end
    if operation ~= "StartChallenge" and operation ~= "SpawnWave"
        and operation ~= "SpawnBossrushWave" then
        return false, "不支持的动作名称"
    end
    if type(Ambush[operation]) ~= "function" then
        return false, "当前构建缺少对应接口"
    end
    if not Isaac.IsInGame() then return false, "尚未进入对局" end

    local game = Game()
    if game:IsGreedMode() then return false, "贪婪及贪婪强化模式禁用" end
    if game:GetLevel():GetStage() == LevelStage.STAGE4_3 then
        return false, "Blue Womb 楼层禁用"
    end

    local roomType = game:GetRoom():GetType()
    local isChallenge = roomType == RoomType.ROOM_CHALLENGE
    local isBossrush = roomType == RoomType.ROOM_BOSSRUSH
    if operation == "StartChallenge" and not (isChallenge or isBossrush) then
        return false, "开始挑战仅接受挑战房或 Boss Rush"
    elseif operation == "SpawnWave" and not isChallenge then
        return false, "本合同仅在挑战房审查挑战波次生成"
    elseif operation == "SpawnBossrushWave" and not isBossrush then
        return false, "本合同仅在 Boss Rush 审查 Boss Rush 波次生成"
    end
    return true, "基础上下文通过；仍需审查当前挑战状态和执行时机"
end
```

返回 true **不是执行许可或无崩溃保证**。调用方仍须核实当前挑战是否已开始/结束、重复触发防护、实际执行回调与房间切换时机；执行前重读上下文，不能长期缓存布尔值。`SpawnBossrushWave` 所需的会话历史没有由这个谓词证明；项目未可靠记录时保持禁用，不能调用该动作来试探，也不能拿当前波数猜测。预览与 Render 路径只消费只读结果，不接任何 `Start`/`Spawn` 调用。本示例只提供可复用检查合同，没有操作游戏，语法通过也不等于游戏内验收通过。
