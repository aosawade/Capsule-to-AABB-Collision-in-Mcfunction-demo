#将方块展示实体的缩放、位置存入计算用计分板
#先存到命令存储中
data modify storage collision_check:detected_box Pos set from entity @s Pos
data modify storage collision_check:detected_box scale set from entity @s transformation.scale
#再将命令存储的数据变换后存入计分板
execute store result score #box posX_min run data get storage collision_check:detected_box Pos[0] 100000
execute store result score #box posX_max run data get storage collision_check:detected_box Pos[0] 100000
execute store result score #box posY_min run data get storage collision_check:detected_box Pos[1] 100000
execute store result score #box posY_max run data get storage collision_check:detected_box Pos[1] 100000
execute store result score #box posZ_min run data get storage collision_check:detected_box Pos[2] 100000
execute store result score #box posZ_max run data get storage collision_check:detected_box Pos[2] 100000
#变换后得到aabb参数
execute store result score #temp int run data get storage collision_check:detected_box scale[0] 50000
scoreboard players operation #box posX_min -= #temp int
scoreboard players operation #box posX_max += #temp int
execute store result score #temp int run data get storage collision_check:detected_box scale[1] 100000
scoreboard players operation #box posY_max += #temp int
execute store result score #temp int run data get storage collision_check:detected_box scale[2] 50000
scoreboard players operation #box posZ_min -= #temp int
scoreboard players operation #box posZ_max += #temp int
