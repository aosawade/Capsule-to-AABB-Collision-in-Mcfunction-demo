# API 参考文档

本文档详细介绍了 Battle & Boss Test 数据包的所有函数、计分板、存储路径和标签接口。

## 目录
1. [函数接口](#函数接口)
2. [计分板系统](#计分板系统)
3. [存储路径](#存储路径)
4. [实体标签](#实体标签)
5. [魔咒与物品](#魔咒与物品)
6. [配置参数](#配置参数)

## 函数接口

### 初始化函数

#### `collision_check:collision_sys_init`
初始化碰撞检测系统。

**功能**：
- 创建碰撞检测所需的计分板
- 设置默认的玩家 AABB 尺寸
- 初始化系统状态变量

**调用方式**：
```mcfunction
function collision_check:collision_sys_init
```

#### `player_action:player_action_init`
初始化玩家动作系统。

**功能**：
- 创建玩家动作相关的计分板
- 注册魔咒效果
- 设置默认的冷却时间

**调用方式**：
```mcfunction
function player_action:player_action_init
```

#### `globle:globle_init`
初始化全局工具函数。

**功能**：
- 创建全局工具所需的计分板和存储
- 初始化坐标变换系统

**调用方式**：
```mcfunction
function globle:globle_init
```

### 碰撞检测函数

#### `collision_check:loop`
主循环检测函数（每 tick 执行）。

**功能**：
- 检查碰撞检测开关状态
- 遍历所有带有 `aabb` 标签的玩家
- 执行相对坐标碰撞检测

**调用方式**：
```mcfunction
function collision_check:loop
```

**依赖条件**：
- 需要设置 `#enable_detect_loop boolean 1` 才能执行检测

#### `collision_check:rel_coo_detect/run_as_player`
以玩家为坐标轴执行检测。

**功能**：
- 加载玩家的 AABB 数据
- 遍历附近带有 `collision_check_capsule` 标签的胶囊体
- 调用胶囊体检测函数

**调用上下文**：
- 执行者必须是玩家
- 玩家必须带有 `aabb` 标签

#### `collision_check:rel_coo_detect/run_as_capsule`
以胶囊体为执行者进行检测。

**功能**：
- 加载胶囊体的参数数据
- 调用 `cap2aabb_check` 进行碰撞检测

**调用上下文**：
- 执行者必须是 `item_display` 类型的实体
- 实体必须带有 `collision_check_capsule` 标签

#### `collision_check:rel_coo_detect/cap2aabb_check`
胶囊体到 AABB 的碰撞检测。

**功能**：
- 将胶囊体检测转换为射线检测
- 扩展 AABB 以包含胶囊体半径
- 调用 `ray2box_check` 进行最终检测

**输入参数**（通过计分板）：
- `#cap` 系列计分板：胶囊体参数
- `#aabb` 系列计分板：AABB 参数

#### `collision_check:rel_coo_detect/ray2box_check`
射线到 AABB 的碰撞检测。

**功能**：
- 实现 Slab Method 算法
- 计算射线与 AABB 的相交区间
- 判断是否发生碰撞

**算法细节**：
1. 快速排除：检查起点是否在 AABB 内
2. 计算各坐标轴的进出点
3. 取最大进点和最小出点
4. 判断相交区间是否有效

### 可视化函数

#### `collision_check:col_visualization/update_visual_box`
更新玩家 AABB 的可视化显示。

**功能**：
- 根据玩家状态显示不同颜色的碰撞箱
- 状态 0（正常）：绿色
- 状态 1（全身无敌）：蓝色
- 状态 2（下半身无敌）：黄色

**调用方式**：
```mcfunction
execute as @a[tag=aabb] run function collision_check:col_visualization/update_visual_box
```

#### `collision_check:col_visualization/aabb_col_display`
显示碰撞检测结果。

**功能**：
- 显示碰撞成功/失败的视觉效果
- 用于调试和可视化

### 测试函数

#### `collision_check:test/sum_testbox`
生成测试用 AABB 碰撞箱。

**功能**：
- 生成一个可调整的测试碰撞箱
- 附带调整用的木棍

#### `collision_check:test/sum_testray`
生成测试用射线。

**功能**：
- 生成一个可调整的测试射线
- 用于验证碰撞检测算法

#### `collision_check:test/give_stick`
给予调整碰撞箱用的木棍。

**功能**：
- 给予玩家特殊的调整木棍
- 左键调整位置，右键切换模式

#### `collision_check:test/holding_box`
手持木棍时调整碰撞箱。

#### `collision_check:test/holding_ray`
手持木棍时调整射线。

### 玩家动作函数

#### `player_action:jump/detect_jump`
检测玩家跳跃动作。

**功能**：
- 检测 `player_jump` 计分板变化
- 设置跳跃无敌状态
- 管理无敌时间倒计时

**执行频率**：每 tick

#### `player_action:jump/jump_end`
结束跳跃无敌状态。

**功能**：
- 重置玩家状态为正常
- 恢复完整的 AABB 高度

#### `player_action:dodge/dodge_detect`
检测和管理闪避状态。

**功能**：
- 管理闪避无敌时间倒计时
- 管理冷却进度恢复
- 更新魔咒效果器的显示

**执行频率**：每 tick

#### `player_action:dodge/dodge_activate`
激活闪避无敌。

**功能**：
- 设置玩家为全身无敌状态
- 重置闪避冷却时间
- 播放闪避特效

#### `player_action:dodge/dodge_sfx`
播放闪避特效。

**功能**：
- 播放粒子效果
- 播放音效

### 全局工具函数

#### `globle:transform_pos`
位置坐标的矩阵变换。

**功能**：
- 将输入坐标进行展示实体的矩阵变换
- 返回变换后的相对坐标

**输入**：
- 执行者：展示实体（提供变换矩阵）
- 输入坐标：通过标记实体 `0-0-0-0-0` 的 `Pos` NBT

**输出**：
- 变换后坐标：通过标记实体 `0-0-0-0-0` 的 `Pos` NBT 返回

#### `globle:transform_vec`
方向矢量的矩阵变换。

**功能**：
- 将输入矢量进行展示实体的矩阵变换
- 返回变换后的单位矢量

**输入**：
- 执行者：展示实体（提供变换矩阵）
- 输入矢量：通过标记实体 `0-0-0-0-0` 的 `Pos` NBT（放大100倍）

**输出**：
- 变换后矢量：通过标记实体 `0-0-0-0-1` 的方向返回

#### `globle:pos_rel2display`
相对坐标到展示实体坐标的转换。

**功能**：
- 将相对坐标转换为展示实体坐标系中的坐标

#### `globle:vec_rel2display`
相对矢量到展示实体坐标的转换。

#### `globle:get_locator`
获取定位器函数。

## 计分板系统

### 碰撞检测计分板

#### 系统状态计分板
| 计分板 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| `#enable_detect_loop` | boolean | 0 | 碰撞检测总开关（0=关闭，1=开启） |
| `#is_collision` | boolean | 0 | 当前检测周期是否发生碰撞 |
| `#player_wide` | int | 60 | 玩家 AABB 宽度（0.6格×100） |
| `#player_hight` | int | 180 | 玩家 AABB 高度（1.8格×100） |

#### 玩家状态计分板
| 计分板 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| `@s status` | int | 0 | 玩家状态：0=正常，1=全身无敌，2=下半身无敌 |
| `@s aabb_tag` | boolean | 0 | 玩家是否有 AABB 标签（内部使用） |

#### 胶囊体参数计分板
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#cap posX_0` | int | 胶囊体起点 X 坐标（相对坐标×100） |
| `#cap posY_0` | int | 胶囊体起点 Y 坐标（相对坐标×100） |
| `#cap posZ_0` | int | 胶囊体起点 Z 坐标（相对坐标×100） |
| `#cap vec_dx` | int | 胶囊体方向 X 分量（×100） |
| `#cap vec_dy` | int | 胶囊体方向 Y 分量（×100） |
| `#cap vec_dz` | int | 胶囊体方向 Z 分量（×100） |
| `#cap lenght` | int | 胶囊体长度（×100） |
| `#cap radius` | int | 胶囊体半径（×100） |

#### AABB 参数计分板
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#aabb posX_max` | int | AABB X 轴最大值（相对坐标×100） |
| `#aabb posY_max` | int | AABB Y 轴最大值（相对坐标×100） |
| `#aabb posZ_max` | int | AABB Z 轴最大值（相对坐标×100） |

#### 射线参数计分板
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#ray posX_0` | int | 射线起点 X 坐标（相对坐标×100） |
| `#ray posY_0` | int | 射线起点 Y 坐标（相对坐标×100） |
| `#ray posZ_0` | int | 射线起点 Z 坐标（相对坐标×100） |
| `#ray vec_dx` | int | 射线方向 X 分量（×100） |
| `#ray vec_dy` | int | 射线方向 Y 分量（×100） |
| `#ray vec_dz` | int | 射线方向 Z 分量（×100） |
| `#ray lenght` | int | 射线长度（×100） |

#### 扩展 AABB 计分板
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#box posX_max` | int | 扩展后 AABB X 轴最大值 |
| `#box posY_max` | int | 扩展后 AABB Y 轴最大值 |
| `#box posZ_max` | int | 扩展后 AABB Z 轴最大值 |

#### 计算临时计分板
| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#temp_en` | int | 临时计算：进入点 |
| `#temp_ex` | int | 临时计算：退出点 |
| `#intersect_en` | int | 最终进入点（各轴最大值） |
| `#intersect_ex` | int | 最终退出点（各轴最小值） |
| `#in_box` | int | 起点在 AABB 内的轴数 |

### 玩家动作计分板

#### 跳跃系统
| 计分板 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| `@s player_jump` | int | 0 | 跳跃检测（1=正在跳跃） |
| `@s jump_time` | int | 10 | 跳跃无敌剩余时间（tick） |

#### 闪避系统
| 计分板 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| `@s dodge_effect_time` | int | 0 | 闪避无敌剩余时间（tick） |
| `@s dodge_cd` | int | 0 | 闪避冷却进度（0-9，0=可用） |

#### 全局动作计分板
| 计分板 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| `#jump_inv_time` | int | 10 | 跳跃无敌默认时长（tick） |
| `#dodge_inv_time` | int | 10 | 闪避无敌默认时长（tick） |
| `#dodge_cd_time` | int | 10 | 闪避冷却总时长（tick） |

### 全局工具计分板

| 计分板 | 类型 | 描述 |
|--------|------|------|
| `#temp_x` | int | 临时 X 坐标 |
| `#temp_y` | int | 临时 Y 坐标 |
| `#temp_z` | int | 临时 Z 坐标 |
| `#output` | int | 变换输出值 |
| `#matrix_1` | int | 矩阵计算临时值 |

## 存储路径

### 碰撞检测存储

#### `collision_check:detected_aabb`
玩家 AABB 数据存储。

**结构**：
```json
{
  "Pos": [0.0, 0.0, 0.0],  // 玩家绝对坐标
  "rel_box": {
    "X": 0.0,              // 相对坐标 X（取反值）
    "Y": 0.0,              // 相对坐标 Y（取反值）
    "Z": 0.0               // 相对坐标 Z（取反值）
  }
}
```

#### `collision_check:detected_cap`
胶囊体相对坐标和参数存储。

**结构**：
```json
{
  "rel_box": {
    "X": 0.0,              // 相对坐标 X
    "Y": 0.0,              // 相对坐标 Y
    "Z": 0.0               // 相对坐标 Z
  },
  "param": {
    "cap": {
      "posX_0": 0,         // 起点 X（×100）
      "posY_0": 0,         // 起点 Y（×100）
      "posZ_0": 0,         // 起点 Z（×100）
      "vec_dx": 0,         // 方向 X（×100）
      "vec_dy": 0,         // 方向 Y（×100）
      "vec_dz": 0,         // 方向 Z（×100）
      "lenght": 0,         // 长度（×100）
      "radius": 0          // 半径（×100）
    }
  }
}
```

#### `collision_check:temp`
临时计算存储。

**用途**：
- 中间计算结果
- 临时变量存储

### 全局工具存储

#### `globle_transform_temp`
坐标变换临时存储。

**结构**：
```json
{
  "transformation": [0.0, 0.0, 0.0, 0.0, ...],  // 变换矩阵（16个元素）
  "translation": {
    "px": 0.0,                                   // 平移 X
    "py": 0.0,                                   // 平移 Y
    "pz": 0.0                                    // 平移 Z
  },
  "output_pos": [0.0, 0.0, 0.0]                  // 输出坐标
}
```

### 实体数据存储

#### 胶囊体实体 NBT 路径
胶囊体参数存储在实体 NBT 的以下路径：
```
data.param.cap
```

**示例**：
```json
{
  "data": {
    "param": {
      "cap": {
        "posX_0": 0,
        "posY_0": 0,
        "posZ_0": 0,
        "vec_dx": 100,
        "vec_dy": 0,
        "vec_dz": 0,
        "lenght": 100,
        "radius": 50
      }
    }
  }
}
```

## 实体标签

### 系统标签

#### `aabb`
**用途**：标记参与碰撞检测的玩家。

**添加方式**：
```mcfunction
/tag @s add aabb
```

**移除方式**：
```mcfunction
/tag @s remove aabb
```

#### `collision_check_capsule`
**用途**：标记参与碰撞检测的胶囊体实体。

**实体类型**：`item_display`

**添加方式**：
```mcfunction
/tag @e[type=item_display,limit=1] add collision_check_capsule
```

### 内部标签

#### `#visual_box`
**用途**：标记可视化碰撞箱实体。

**实体类型**：`marker`

#### `#visual_ray`
**用途**：标记可视化射线实体。

**实体类型**：`marker`

## 魔咒与物品

### 魔咒系统

数据包使用自定义魔咒来管理玩家状态和效果。

#### `player_action:dodge_effect`
**用途**：闪避无敌效果魔咒。

**载体**：皮革马铠

**魔咒等级**：始终为 1（表示效果激活）

#### `player_action:dodge_motion`
**用途**：闪避冷却显示魔咒。

**载体**：皮革马铠

**魔咒等级**：
- 1：冷却 0%（可用）
- 2：冷却 40%
- 3：冷却 70%
- 5：冷却 90%
- 其他：冷却 100%

#### `player_action:test_effect`
**用途**：测试效果魔咒。

**载体**：皮革马铠

### 特殊物品

#### 调整木棍
**物品**：`minecraft:stick`

**NBT**：
```json
{
  "CustomModelData": 1001,
  "display": {
    "Name": "调整木棍"
  },
  "minecraft:item_description": {
    "lines": ["左键：调整位置", "右键：切换模式"]
  }
}
```

**功能**：
- 左键：微调碰撞箱/射线位置
- 右键：切换调整模式（位置/方向/尺寸）

#### 魔咒效果器
**物品**：`minecraft:leather_horse_armor`

**用途**：承载玩家状态魔咒。

**NBT**：
```json
{
  "minecraft:enchantments": {
    "player_action:dodge_effect": 1,
    "player_action:dodge_motion": 1
  },
  "minecraft:equippable": {
    "slot": "body",
    "equip_sound": "minecraft:intentionally_empty"
  },
  "custom_name": "玩家魔咒效果器"
}
```

## 配置参数

### 碰撞检测配置

#### 玩家 AABB 尺寸
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 玩家宽度 | 0.6格 | 玩家碰撞箱宽度 | `scoreboard players set #player_wide int 60` |
| 玩家高度 | 1.8格 | 玩家碰撞箱高度 | `scoreboard players set #player_hight int 180` |
| 跳跃高度 | 1.2格 | 跳跃时下半身高度 | 修改 `load_jump_aabb.mcfunction` |

#### 检测范围
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 胶囊体检测距离 | 160格 | 玩家检测胶囊体的最大距离 | 修改 `run_as_player.mcfunction` 第16行 |

#### 系统开关
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 碰撞检测开关 | 关闭 | 总开关 | `scoreboard players set #enable_detect_loop boolean 1` |

### 玩家动作配置

#### 跳跃系统
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 无敌时长 | 10 tick | 跳跃无敌持续时间 | `scoreboard players set @s jump_time 20` |
| 检测灵敏度 | 1 | 跳跃检测阈值 | 修改计分板 `player_jump` 的检测逻辑 |

#### 闪避系统
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 无敌时长 | 10 tick | 闪避无敌持续时间 | `scoreboard players set #dodge_inv_time int 15` |
| 冷却时间 | 10 tick | 闪避冷却总时间 | `scoreboard players set #dodge_cd_time int 15` |
| 冷却分段 | [0,4,7,9] | 冷却恢复的关键点 | 修改 `dodge_detect.mcfunction` |

### 性能配置

#### 优化参数
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 检测频率 | 每 tick | 碰撞检测执行频率 | 修改 `minecraft:tick.json` |
| 可视距离 | 160格 | 胶囊体检测距离 | 修改 `run_as_player.mcfunction` |
| 最大玩家数 | 无限制 | 同时检测的玩家数量 | 通过标签 `aabb` 控制 |

### 可视化配置

#### 显示设置
| 参数 | 默认值 | 描述 | 修改方式 |
|------|--------|------|----------|
| 碰撞箱颜色 | 状态相关 | 根据玩家状态显示不同颜色 | 修改 `update_visual_box.mcfunction` |
| 显示大小 | 0.1格 | 可视化碰撞箱的线宽 | 修改可视化实体的 `scale` NBT |
| 显示距离 | 256格 | 可视化效果的显示距离 | 修改可视化实体的 `view_range` NBT |

## 错误代码与调试

### 常见错误

#### 碰撞检测未执行
**可能原因**：
1. `#enable_detect_loop` 未设置为 1
2. 玩家没有 `aabb` 标签
3. 没有胶囊体带有 `collision_check_capsule` 标签

**调试命令**：
```mcfunction
# 检查开关状态
scoreboard players get #enable_detect_loop boolean

# 检查玩家标签
tag @s list

# 检查胶囊体数量
execute as @e[type=item_display,tag=collision_check_capsule] run say 我是胶囊体
```

#### 碰撞检测不准确
**可能原因**：
1. 胶囊体参数单位错误（需要×100）
2. 相对坐标计算错误
3. AABB 尺寸配置错误

**调试命令**：
```mcfunction
# 检查胶囊体参数
data get entity @e[type=item_display,tag=collision_check_capsule,limit=1] data.param.cap

# 检查玩家 AABB 尺寸
scoreboard players get #player_wide int
scoreboard players get #player_hight int

# 使用可视化工具
function collision_check:col_visualization/update_visual_box
```

#### 玩家动作失效
**可能原因**：
1. 魔咒未正确注册
2. 计分板未初始化
3. 玩家未穿着魔咒效果器

**调试命令**：
```mcfunction
# 检查魔咒效果器
item get entity @s armor.body

# 检查计分板值
scoreboard players get @s dodge_cd
scoreboard players get @s dodge_effect_time
```

### 调试工具

#### 调试函数
```mcfunction
# 显示所有计分板值
function collision_check:test/debug_scores

# 显示所有存储内容
function collision_check:test/debug_storage

# 重置系统状态
function collision_check:test/debug_reset
```

#### 可视化调试
```mcfunction
# 显示碰撞箱
function collision_check:col_visualization/update_visual_box

# 显示检测结果
function collision_check:col_visualization/aabb_col_display

# 生成测试对象
function collision_check:test/sum_testbox
function collision_check:test/sum_testray
```

## 版本兼容性

### Minecraft 版本
- **最低版本**：1.21.11（pack format 94）
- **推荐版本**：1.21.11+

### 数据包格式
- **pack.mcmeta**：`{"min_format":[94,1],"max_format":94}`

### 依赖项
- **必需**：无外部依赖
- **可选**：Animated Java 数据包（用于动画集成）

### 已知限制
1. 仅支持主世界（overworld）的碰撞检测
2. 胶囊体数量过多可能影响性能
3. 玩家数量建议控制在 20 人以内

## 更新日志

### v1.0.0（当前版本）
- 实现相对坐标胶囊体 ↔ AABB 碰撞检测
- 添加玩家跳跃下半身无敌系统
- 添加玩家闪避无敌系统
- 集成 Animated Java 支持
- 添加可视化调试工具
- 添加完整的测试函数

---

**文档版本**：1.0.0  
**最后更新**：2026-02-17  
**对应数据包版本**：1.0.0