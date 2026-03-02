#将射线展示实体的起点、方向、长度存入计算用计分板
data modify storage collision_check:detected_ray Pos set from entity @s Pos
data modify storage collision_check:detected_ray scale set from entity @s transformation.scale
execute store result score #ray posX_0 run data get storage collision_check:detected_ray Pos[0] 100000
execute store result score #ray posY_0 run data get storage collision_check:detected_ray Pos[1] 100000
execute store result score #ray posZ_0 run data get storage collision_check:detected_ray Pos[2] 100000
execute store result score #ray lenght run data get storage collision_check:detected_ray scale[2] 100
#朝向转换为分量dx dy dz
execute rotated as @s positioned 0 0 0 run tp 0-0-0-0-0 ^ ^ ^10
data modify storage collision_check:detected_ray vec.Pos set from entity 0-0-0-0-0 Pos
execute store result score #ray vec_dx run data get storage collision_check:detected_ray vec.Pos[0] 100
execute store result score #ray vec_dy run data get storage collision_check:detected_ray vec.Pos[1] 100
execute store result score #ray vec_dz run data get storage collision_check:detected_ray vec.Pos[2] 100