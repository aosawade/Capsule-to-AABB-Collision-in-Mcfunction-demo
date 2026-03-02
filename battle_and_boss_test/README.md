# Battle & Boss Test 数据包

一个为 Minecraft 1.21.11 设计的战斗与 BOSS 测试数据包，实现了**胶囊体与 AABB 的精确碰撞检测系统**，并集成了**玩家动作系统**（跳跃下半身无敌和闪避无敌）。数据包与 Animated Java 动画系统深度集成，支持动态动画的碰撞检测。

## 特性

- **精确的几何碰撞检测**：基于相对坐标的胶囊体 ↔ AABB 相交算法
- **玩家状态系统**：正常、全身无敌、下半身无敌三种状态
- **跳跃下半身无敌**：自动检测跳跃动作，提供短暂的下半身无敌帧
- **闪避无敌系统**：带有冷却机制的主动闪避能力
- **Animated Java 集成**：支持动态动画胶囊体的实时碰撞检测
- **可视化调试工具**：内置碰撞箱可视化系统，便于测试和调试
- **模块化架构**：各系统解耦，易于维护和扩展

## 快速开始

### 1. 安装数据包
1. 下载 `battle_and_boss_test.zip` 或克隆此仓库
2. 将数据包放入 Minecraft 世界的 `datapacks` 文件夹
3. 在游戏中执行 `/reload` 加载数据包

### 2. 初始化系统
在游戏中执行以下命令初始化系统：
```mcfunction
function collision_check:collision_sys_init
function player_action:player_action_init
function globle:globle_init
```

### 3. 启用碰撞检测
```mcfunction
scoreboard players set #enable_detect_loop boolean 1
```

### 4. 测试碰撞检测
使用测试功能生成测试碰撞箱和射线：
```mcfunction
function collision_check:test/sum_testbox
function collision_check:test/sum_testray
function collision_check:test/give_stick
```

## 系统架构

数据包包含四个命名空间，各自负责不同的功能模块：

### 1. `collision_check` - 碰撞检测核心系统
- `loop.mcfunction` - 主循环检测入口（每 tick 执行）
- `collision_sys_init.mcfunction` - 系统初始化
- `colli_success_func.mcfunction` - 碰撞成功回调函数
- `rel_coo_detect/` - 相对坐标检测实现（当前使用的算法）
- `abs_coo_detect/` - 绝对坐标检测（已弃用）
- `col_visualization/` - 碰撞箱可视化功能
- `test/` - 测试和调试函数

### 2. `globle` - 全局工具函数
- `transform_pos.mcfunction` - 位置矩阵变换
- `transform_vec.mcfunction` - 矢量矩阵变换
- `pos_rel2display.mcfunction` - 相对坐标到展示实体坐标转换
- `vec_rel2display.mcfunction` - 相对矢量到展示实体坐标转换
- `get_locator.mcfunction` - 获取定位器函数

### 3. `player_action` - 玩家动作系统
- `loop.mcfunction` - 动作系统主循环
- `player_action_init.mcfunction` - 动作系统初始化
- `jump/` - 跳跃下半身无敌系统
- `dodge/` - 闪避无敌系统

### 4. `minecraft` - 游戏集成
- `tags/function/load.json` - 加载时执行的函数
- `tags/function/tick.json` - 每 tick 执行的函数

## 碰撞检测原理

### 算法概述
数据包实现了**胶囊体与轴对齐边界框（AABB）**的精确碰撞检测。算法基于以下步骤：

1. **坐标系转换**：使用相对坐标系统，以玩家为原点建立坐标系
2. **问题转换**：将胶囊体 ↔ AABB 检测转换为射线 ↔ 扩展AABB 检测
3. **射线-AABB 相交**：使用 Slab Method 计算相交区间
4. **碰撞判定**：根据相交区间判断是否发生碰撞

### 检测流程
```
loop → run_as_player → load_aabb → run_as_capsule → load_capsule → cap2aabb_check → ray2box_check
```

### 关键算法实现

#### 1. 胶囊体表示
胶囊体由以下参数定义：
- 起点位置：`(posX_0, posY_0, posZ_0)`
- 方向矢量：`(vec_dx, vec_dy, vec_dz)`
- 长度：`lenght`
- 半径：`radius`

#### 2. AABB 扩展
将胶囊体半径加到 AABB 的每个维度：
```
box_max_x = aabb_max_x + radius + radius
```

#### 3. 射线-AABB 相交算法（Slab Method）
对于每个坐标轴计算：
```
t_enter = (min - origin) / direction
t_exit = (max - origin) / direction
```
取各轴的 `t_enter` 最大值和 `t_exit` 最小值，如果 `t_enter < t_exit` 且 `t_enter < 射线长度`，则相交。

#### 4. 快速排除优化
- 检查射线起点是否在 AABB 内
- 检查射线方向与坐标轴平行时的特殊情况
- 提前返回减少计算量

### 数学公式
胶囊体与 AABB 的碰撞检测转换为射线与扩展 AABB 的检测：
```
扩展AABB = AABB ⊕ 半径球
胶囊体中心线 = 起点 + t * 方向矢量 (0 ≤ t ≤ 长度)
检测射线 = 胶囊体中心线
```

## 玩家动作系统

### 跳跃下半身无敌
**机制**：检测玩家跳跃动作，在跳跃期间提供下半身无敌帧

**实现细节**：
- 使用计分板 `player_jump` 检测跳跃
- 状态码 `2` 表示下半身无敌状态
- 无敌时长：10 tick（可配置）
- AABB 高度在跳跃期间减少，模拟下半身无敌效果

**相关函数**：
- `detect_jump.mcfunction` - 检测跳跃并设置状态
- `jump_end.mcfunction` - 结束跳跃无敌状态

### 闪避无敌系统
**机制**：玩家激活闪避时获得短暂无敌帧，带有冷却机制

**实现细节**：
- 冷却时间：10 tick，分段恢复（0%, 40%, 70%, 90%, 100%）
- 无敌时长：可配置（默认 10 tick）
- 使用皮革马铠作为魔咒效果载体
- 通过魔咒等级表示冷却进度

**状态管理**：
- `dodge_effect_time` - 无敌剩余时间
- `dodge_cd` - 冷却进度
- 状态码 `1` 表示全身无敌状态

**相关函数**：
- `dodge_detect.mcfunction` - 检测闪避状态和冷却
- `dodge_activate.mcfunction` - 激活闪避
- `dodge_sfx.mcfunction` - 闪避特效

## 与 Animated Java 集成

### 胶囊体配置
Animated Java 动画中的展示实体可以通过添加以下标签和 NBT 数据来集成碰撞检测：

1. **添加标签**：
```mcfunction
/tag @e[type=item_display,limit=1] add collision_check_capsule
```

2. **配置胶囊体参数**（存储在实体 NBT 的 `data/param` 路径下）：
```json
{
  "data": {
    "param": {
      "cap": {
        "posX_0": 0,    # 起点 X（相对坐标）
        "posY_0": 0,    # 起点 Y
        "posZ_0": 0,    # 起点 Z
        "vec_dx": 100,  # 方向 X（放大100倍）
        "vec_dy": 0,    # 方向 Y
        "vec_dz": 0,    # 方向 Z
        "lenght": 100,  # 长度（放大100倍）
        "radius": 50    # 半径（放大100倍）
      }
    }
  }
}
```

### 示例数据包
项目包含一个示例 Animated Java 数据包 `capsule_test`，展示了如何配置胶囊体进行碰撞检测。

## API 参考

### 计分板系统

#### 碰撞检测相关
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#enable_detect_loop` | boolean | 碰撞检测总开关（0=关闭，1=开启） |
| `#is_collision` | boolean | 当前检测周期是否发生碰撞 |
| `#player_wide` | int | 玩家 AABB 宽度（格×100） |
| `#player_hight` | int | 玩家 AABB 高度（格×100） |
| `@s status` | int | 玩家状态（0=正常，1=全身无敌，2=下半身无敌） |

#### 玩家动作相关
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `@s player_jump` | int | 跳跃检测（1=正在跳跃） |
| `@s jump_time` | int | 跳跃无敌剩余时间 |
| `@s dodge_effect_time` | int | 闪避无敌剩余时间 |
| `@s dodge_cd` | int | 闪避冷却进度（0-9） |

### 存储路径

#### 碰撞检测存储
- `collision_check:detected_aabb` - 玩家 AABB 数据
- `collision_check:detected_cap` - 胶囊体相对坐标和参数
- `collision_check:temp` - 临时计算存储

#### 全局工具存储
- `globle_transform_temp` - 坐标变换临时存储

### 函数接口

#### 初始化函数
```mcfunction
# 碰撞检测系统初始化
function collision_check:collision_sys_init

# 玩家动作系统初始化
function player_action:player_action_init

# 全局工具初始化
function globle:globle_init
```

#### 主要功能函数
```mcfunction
# 手动触发碰撞检测（单次）
function collision_check:loop

# 生成测试碰撞箱
function collision_check:test/sum_testbox

# 生成测试射线
function collision_check:test/sum_testray

# 获取测试用木棍（用于调整碰撞箱）
function collision_check:test/give_stick
```

#### 可视化函数
```mcfunction
# 更新玩家 AABB 可视化
function collision_check:col_visualization/update_visual_box

# 显示碰撞结果可视化
function collision_check:col_visualization/aabb_col_display
```

## 性能优化

### 优化策略
1. **相对坐标系统**：避免全局坐标计算，减少浮点运算
2. **距离筛选**：只检测 160 格范围内的胶囊体
3. **快速排除**：在完整计算前进行快速判断
4. **状态缓存**：复用已加载的玩家 AABB 数据
5. **批量处理**：使用 `run_as_player` 和 `run_as_capsule` 减少上下文切换

### 性能监控
建议在性能关键场景中监控以下指标：
- 每 tick 检测的玩家数量
- 每玩家检测的胶囊体数量
- 碰撞检测函数的执行时间

## 扩展与自定义

### 添加新的碰撞形状
要添加新的碰撞形状，需要：
1. 在 `rel_coo_detect/` 中创建新的检测函数
2. 实现形状到射线的转换逻辑
3. 在 `run_as_capsule` 中调用新的检测函数

### 修改玩家 AABB 尺寸
通过修改以下计分板值调整玩家碰撞箱：
```mcfunction
# 设置玩家宽度为 0.6 格（60 = 0.6×100）
scoreboard players set #player_wide int 60

# 设置玩家高度为 1.8 格（180 = 1.8×100）
scoreboard players set #player_hight int 180
```

### 自定义无敌时长
```mcfunction
# 修改跳跃无敌时长（单位：tick）
scoreboard players set @s jump_time 20

# 修改闪避无敌时长
scoreboard players set @s dodge_effect_time 15
```

## 常见问题

### Q: 碰撞检测不准确怎么办？
A: 检查以下配置：
1. 胶囊体参数是否正确（注意数值已放大100倍）
2. 玩家是否具有 `aabb` 标签
3. 碰撞检测开关 `#enable_detect_loop` 是否开启

### Q: 闪避无敌无法激活？
A: 确保：
1. 玩家穿着皮革马铠（魔咒效果器）
2. 冷却进度 `dodge_cd` 为 0
3. 相关魔咒已正确注册

### Q: 如何调试碰撞检测？
A: 使用可视化工具：
1. 执行 `function collision_check:col_visualization/update_visual_box`
2. 查看玩家周围的碰撞箱显示
3. 使用测试函数生成碰撞箱和射线进行测试

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进这个项目！

### 开发规范
1. 遵循现有的代码风格和命名约定
2. 添加新功能时请同时添加测试函数
3. 更新相关文档
4. 确保向后兼容性

### 测试要求
1. 在 Minecraft 1.21.11 中测试所有功能
2. 验证碰撞检测的准确性
3. 测试性能影响

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 致谢

- 感谢 Minecraft 命令系统社区的技术支持
- 感谢 Animated Java 项目提供的动画框架
- 感谢所有测试者和贡献者

---

**注意**：本数据包仍在开发中，API 可能会有变动。建议在正式项目中使用前进行充分测试。

**版本**: 1.0.0  
**Minecraft 版本**: 1.21.11  
**最后更新**: 2026-02-17