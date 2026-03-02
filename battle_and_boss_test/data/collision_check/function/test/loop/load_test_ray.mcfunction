#将射线的绝对坐标、缩放存入命令存储中
data modify storage collision_check:detected_ray Pos set from entity @s Pos
data modify storage collision_check:detected_ray scale set from entity @s transformation.scale
#长度正常存入
execute store result score #ray lenght run data get storage collision_check:detected_ray scale[2] 100
#朝向转换为分量dx dy dz
execute rotated as @s positioned 0 0 0 run tp 0-0-0-0-0 ^ ^ ^10
data modify storage collision_check:detected_ray vec.Pos set from entity 0-0-0-0-0 Pos
execute store result score #ray vec_dx run data get storage collision_check:detected_ray vec.Pos[0] 100
execute store result score #ray vec_dy run data get storage collision_check:detected_ray vec.Pos[1] 100
execute store result score #ray vec_dz run data get storage collision_check:detected_ray vec.Pos[2] 100

#获取起点相对坐标
$execute positioned as @s run tp 0-0-0-0-0 ~$(X) ~$(Y) ~$(Z)
data modify storage collision_check:detected_ray Pos set from entity 0-0-0-0-0 Pos
execute store result score #ray posX_0 run data get storage collision_check:detected_ray Pos[0] 100000
execute store result score #ray posY_0 run data get storage collision_check:detected_ray Pos[1] 100000
execute store result score #ray posZ_0 run data get storage collision_check:detected_ray Pos[2] 100000
#加上AABB模型脚中心到原点的偏差量
scoreboard players operation #temp int = #box posX_max
scoreboard players operation #temp int /= #half int
scoreboard players operation #ray posX_0 += #temp int
scoreboard players operation #temp int = #box posZ_max
scoreboard players operation #temp int /= #half int
scoreboard players operation #ray posZ_0 += #temp int