# RoomConfig / RoomDescriptor / Level

核验基线：REPENTOGON tag `1.1.2g`，2026-09-05，官方文档和源码；无实机证明。

## 先确定对象与时机

| 对象 | 责任 | 常见误用 |
|---|---|---|
| `RoomConfig` / `RoomConfigRoom` | 房间模板与配置集 | 把获得模板当作已放进地图 |
| `RoomDescriptor` | 本楼层地图记录、种子、门、保存状态 | 把直接字段写入当成完整门连接 |
| `Game():GetRoom()` | 当前活动房间 | 跨退局/楼层持有旧引用 |
| `Game():GetLevel()` | 当前楼层和放置入口 | 主菜单调用、混淆维度 |

读取当前世界前使用 `Isaac.IsInGame()`，执行动作时重新定位楼层、维度和房间；延迟操作需确认还是原请求的世界。依据：[Isaac.IsInGame](https://repentogon.com/Isaac.html#isingame)、[tag 绑定](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaIsaac.cpp#L592-L595)。

## 配置接口：点调用

```text
RoomConfig.GetRandomRoom(seed, reduceWeight, stage, roomType,
    shape = RoomShape.NUM_ROOMSHAPES, minVariant = 0, maxVariant = -1,
    minDifficulty = 0, maxDifficulty = 10, requiredDoors = 0,
    subtype = -1, mode = -1)
RoomConfig.GetRoomByStageTypeAndVariant(stage, roomType, variant, mode = -1)
RoomConfig.GetStage(stage)
RoomConfig.AddRooms(stage, mode, rooms)
RoomConfig.LoadStb(stage, mode, filename)
```

以上是签名记法，带 `=` 的默认参数不是可直接运行的 Lua 调用。`stage` 使用 `StbType`，不是 `LevelStage`。查询失败先判空，按变体查询明确可返回 nil。tag 查询返回原配置指针的 const metatable，不是给调用者独占的可修改副本。预览查询用 `reduceWeight=false`；`true` 会改变房间抽取权重。

`AddRooms` 将 Lua 房间加入配置集，返回表按输入顺序对应，转换失败位置可能是 nil；不能依赖 `ipairs` 越过孔洞。`LoadStb` 从所有 Mod 的 `content(-repentogon)/rooms/` 读取；filename 不含 `content/rooms/` 前缀，同名文件可从多个 Mod 全部加载。注册必须有稳定所有者与一次性时机，不放进每帧逻辑。

依据：[官方 RoomConfig](https://repentogon.com/RoomConfig.html)、[tag 参数验证与注册](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/Room/LuaRoomConfig.cpp)。具体 mode/类型边界按被调用函数核对，不能跨函数套用；例如 tag 随机查询 mode 验证与按变体查询并不相同。

## 楼层接口：冒号调用

```text
level:CanPlaceRoom(config, gridIndex, dimension = -1,
    allowMultipleDoors = true, allowSpecialNeighbors = false,
    allowNoNeighbors = false)
level:TryPlaceRoom(config, gridIndex, dimension = -1, seed = 0,
    allowMultipleDoors = true, allowSpecialNeighbors = false,
    allowNoNeighbors = false)
level:FindValidRoomPlacementLocations(config, dimension = -1,
    allowMultipleDoors = true, allowSpecialNeighbors = false)
level:GetNeighboringRooms(gridIndex, roomShape, dimension = -1)
level:CanPlaceRoomAtDoor(config, neighborDescriptor, doorSlot,
    allowMultipleDoors = true, allowSpecialNeighbors = false)
level:TryPlaceRoomAtDoor(config, neighborDescriptor, doorSlot, seed = 0,
    allowMultipleDoors = true, allowSpecialNeighbors = false)
```

签名记法，不是可运行 Lua。`CanPlaceRoom` 返回 boolean；候选位置返回索引表；`TryPlaceRoom` 成功返回新 RoomDescriptor，普通失败 nil，但越界索引返回 false。`TryPlaceRoomAtDoor` 的无效描述符或门坐标路径也可返回 false。统一 `if not result then`，失败保留原状态/后续路线，禁止直接解引用。

tag 的地图索引为 `0..168`，维度参数 `-1..2`，`-1` 代表当前维度。seed `0`/nil 根据地点、形状与楼层 placement seed 确定性生成；负 seed 错误。不能把这个 0 规则用于 `RNG(0)`。

依据：[官方 Level](https://repentogon.com/Level.html)、[tag LuaLevel.cpp](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/LuaLevel.cpp#L138-L310)。

放置要检查占用、地图边界、形状、双方门位、特殊邻居；候选列表不会提交。提交仍调用 `TryPlaceRoom`，它重新预检并连接邻居。`Level:PlaceRoom` 不完整检查合法性且不建立所需邻接门，不是安全默认。`allowNoNeighbors=true` 是主动允许孤岛的设计选择，不能用来让失败测试“变绿”。邻居映射为 DoorSlot 到 RoomDescriptor，遍历用 `pairs`，且“存在邻居”本身不证明能连接。

依据：[官方放置说明](https://repentogon.com/Level.html#tryplaceroom)、[tag 放置与连门实现](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/Room/RoomPlacement.cpp)。

## 描述符不是事务接口

`desc:GetDimension()`、`desc:GetNeighboringRooms()`、`desc:GetValidNeighborPlacementLocations(config, allowMultipleDoors, allowSpecialNeighbors)` 用于定位/检查。`AllowedDoors` 是当前启用门位掩码，不是模板所有可用门；`Doors[0..7]` 存门目标索引。tag 的 setter 直接写字段，没有完整双向连接事务，勿替代 TryPlaceRoom。

`desc:InitSeeds(rng)` 调用引擎初始化；保存实体/装饰/地形向量访问器引用引擎容器，不是 Lua 快照。不要在预览中改它们，也不要把调用名带 Get 当作返回副本的证据。

依据：[官方 RoomDescriptor](https://repentogon.com/RoomDescriptor.html)、[tag 字段与容器绑定](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/LuaInterfaces/Room/LuaRoomDescriptor.cpp)。

## 验证交付

检查普通和特殊房、边界/重叠、L/大房门位、有效/无效维度、无候选位置、nil/false、重复触发。记录模板选取是否减权与何时实际放置。静态检查不证明门可走、镜像维度可达、续局保存正确；这些单列实机验收。
