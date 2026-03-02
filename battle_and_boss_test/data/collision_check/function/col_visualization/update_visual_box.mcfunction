#生成并更新玩家AABB可视化碰撞箱

execute if score #aabb_visuable boolean matches 0 \
    run return run kill @e[type=minecraft:block_display,tag=aabb_visuable]

$execute in minecraft:overworld as @e[type=minecraft:block_display,tag=aabb_visuable,nbt={data:{player_uuid:$(UUID)}}] \
        store result entity @s transformation.scale[1] float 0.00001 \
        run scoreboard players get #aabb posY_max

$execute in minecraft:overworld if score @s status matches 2 \
        as @e[type=minecraft:block_display,tag=aabb_visuable,nbt={data:{player_uuid:$(UUID)}}] \
        run data modify entity @s transformation.translation[1] set value 0.8f

$execute in minecraft:overworld if score @s status matches ..1 \
        as @e[type=minecraft:block_display,tag=aabb_visuable,nbt={data:{player_uuid:$(UUID)}}] \
        run data modify entity @s transformation.translation[1] set value 0f

$execute in minecraft:overworld at @s as @e[type=minecraft:block_display,tag=aabb_visuable,nbt={data:{player_uuid:$(UUID)}}] \
        run return run tp ~ ~ ~

$execute at @s run summon minecraft:block_display ~ ~ ~ {Tags:[aabb_visuable],block_state:{Name:"minecraft:white_stained_glass"},data:{player_uuid:$(UUID)}}
data modify storage collision_check:temp_aabb transformation set value {scale:[1f,1f,1f],translation:[0f,0f,0f]}
execute store result storage collision_check:temp_aabb transformation.scale[0] float 0.00001 \
        run scoreboard players get #aabb posX_max
execute store result storage collision_check:temp_aabb transformation.scale[1] float 0.00001 \
        run scoreboard players get #aabb posY_max
execute store result storage collision_check:temp_aabb transformation.scale[2] float 0.00001 \
        run scoreboard players get #aabb posZ_max
execute store result storage collision_check:temp_aabb transformation.translation[0] float -0.000005 \
        run scoreboard players get #aabb posX_max
execute store result storage collision_check:temp_aabb transformation.translation[2] float -0.000005 \
        run scoreboard players get #aabb posX_max
#如果起跳，则上移动0.8格
execute if score @s status matches 2 \
    run data modify storage collision_check:temp_aabb transformation.translation[1] set value 0.8f

data modify entity @n[type=minecraft:block_display,tag=aabb_visuable] transformation \
        merge from storage collision_check:temp_aabb transformation