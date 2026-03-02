#生成并更新胶囊体可视化碰撞箱

execute if score #capsule_visuable boolean matches 0 \
    run return run kill @e[type=minecraft:block_display,tag=capsule_visuable]

#胶囊体起点坐标来源：
#1.胶囊体相对坐标#cap posX_0 posY_0 posZ_0
#1.相对坐标轴的绝对坐标：collision_check:detected_cap rel_box，存入计分板并取反，用于相对坐标转绝对坐标
data modify storage collision_check:temp_capsule Pos set value [0d,0d,0d]
execute store result score #temp_pos posX_0 run data get storage collision_check:detected_cap rel_box.X -100000
execute store result score #temp_pos posY_0 run data get storage collision_check:detected_cap rel_box.Y -100000
execute store result score #temp_pos posZ_0 run data get storage collision_check:detected_cap rel_box.Z -100000
scoreboard players operation #temp_pos posX_0 += #cap posX_0
scoreboard players operation #temp_pos posY_0 += #cap posY_0
scoreboard players operation #temp_pos posZ_0 += #cap posZ_0
#消去AABB模型脚中心到原点的偏差量
scoreboard players operation #temp int = #aabb posX_max
scoreboard players operation #temp int /= #half int
scoreboard players operation #temp_pos posX_0 -= #temp int
scoreboard players operation #temp int = #aabb posZ_max
scoreboard players operation #temp int /= #half int
scoreboard players operation #temp_pos posZ_0 -= #temp int
#将运算好的坐标存入命令存储
execute store result storage collision_check:temp_capsule Pos[0] double 0.00001 run scoreboard players get #temp_pos posX_0
execute store result storage collision_check:temp_capsule Pos[1] double 0.00001 run scoreboard players get #temp_pos posY_0
execute store result storage collision_check:temp_capsule Pos[2] double 0.00001 run scoreboard players get #temp_pos posZ_0
#获取胶囊体转向
data modify storage collision_check:temp_capsule vec set value [0d,0d,0d]
execute store result storage collision_check:temp_capsule vec[0] double 0.01 run scoreboard players get #cap vec_dx
execute store result storage collision_check:temp_capsule vec[1] double 0.01 run scoreboard players get #cap vec_dy
execute store result storage collision_check:temp_capsule vec[2] double 0.01 run scoreboard players get #cap vec_dz
data modify entity 0-0-0-0-0 Pos set from storage collision_check:temp_capsule vec
tp 0-0-0-0-1 0.0 0.0 0.0
rotate 0-0-0-0-1 facing entity 0-0-0-0-0
tp 0-0-0-0-0 0.0 0.0 0.0

#当胶囊体碰撞箱实体已经生成，则直接变换坐标和专线后退出
$data modify entity @n[distance=..160,tag=capsule_visuable,nbt={data:{cap_uuid:$(UUID)}}] Pos \
    set from storage collision_check:temp_capsule Pos
$execute in minecraft:overworld as @e[distance=..160,tag=capsule_visuable,nbt={data:{cap_uuid:$(UUID)}}] rotated as 0-0-0-0-1 positioned as @s \
    run return run tp @s ~ ~ ~ ~ ~

#生成胶囊体碰撞箱实体
$execute at @s run summon minecraft:block_display ~ ~ ~ {Tags:[capsule_visuable],block_state:{Name:"minecraft:green_stained_glass"},data:{cap_uuid:$(UUID)}}
data modify storage collision_check:temp_capsule transformation set value {scale:[1f,1f,1f],translation:[0f,0f,0f]}
execute store result storage collision_check:temp_capsule transformation.scale[0] float 0.02 \
    run scoreboard players get #cap radius
execute store result storage collision_check:temp_capsule transformation.scale[1] float 0.02 \
    run scoreboard players get #cap radius
execute store result storage collision_check:temp_capsule transformation.scale[2] float 0.01 \
    run scoreboard players get #cap lenght
execute store result storage collision_check:temp_capsule transformation.translation[0] float -0.01 \
    run scoreboard players get #cap radius
execute store result storage collision_check:temp_capsule transformation.translation[1] float -0.01 \
    run scoreboard players get #cap radius
data modify entity @n[type=minecraft:block_display,tag=capsule_visuable] transformation \
    merge from storage collision_check:temp_capsule transformation

$data modify entity @n[distance=..160,tag=capsule_visuable,nbt={data:{cap_uuid:$(UUID)}}] Pos \
    set from storage collision_check:temp_capsule Pos
$execute in minecraft:overworld as @e[distance=..160,tag=capsule_visuable,nbt={data:{cap_uuid:$(UUID)}}] rotated as 0-0-0-0-1 positioned as @s \
    run return run tp @s ~ ~ ~ ~ ~