#从标记为胶囊体的物品展示实体中，加载起点相对坐标、方向分量、长度、半径

#展示实体的绝对坐标、长度、半径（存于data.param中）存入命令存储
#data modify storage collision_check:detected_cap Pos set from entity @s Pos
data modify storage collision_check:detected_cap param set from entity @s data.param
#长度、半径正常存入（缩放100倍）
execute store result score #cap lenght run data get storage collision_check:detected_cap param.lenght 100
execute store result score #cap radius run data get storage collision_check:detected_cap param.radius 100

#旧方案作废
#将胶囊体默认方向(0,1,0)进行展示实体变换，得到变换后的坐标分量
#tp 0-0-0-0-0 0.0 1.0 0.0
#function globle:transform_vec

function globle:get_locator with entity @s data.param
function globle:vec_rel2display with storage globle_locator_temp locator
#调试用
#data modify entity @n[tag=test111] Rotation set from entity 0-0-0-0-0 Rotation
#execute positioned 0.0 64.0 0.0 as @n[tag=test111] rotated as @s run tp @s ^ ^ ^10
execute positioned 0.0 0.0 0.0 as 0-0-0-0-0 rotated as @s run tp @s ^ ^ ^10
data modify storage collision_check:detected_cap vec.Pos set from entity 0-0-0-0-0 Pos
execute store result score #cap vec_dx run data get storage collision_check:detected_cap vec.Pos[0] 100
execute store result score #cap vec_dy run data get storage collision_check:detected_cap vec.Pos[1] 100
execute store result score #cap vec_dz run data get storage collision_check:detected_cap vec.Pos[2] 100
tp 0-0-0-0-0 0.0 0.0 0.0

#旧方案作废
#获取相对起点坐标
#tp 0-0-0-0-0 0.0 0.0 0.0
#function globle:transform_pos

function globle:pos_rel2display with storage globle_locator_temp locator
data modify storage collision_check:detected_cap Pos set from entity 0-0-0-0-0 Pos
execute store result score #cap posX_0 run data get storage collision_check:detected_cap Pos[0] 100000
execute store result score #cap posY_0 run data get storage collision_check:detected_cap Pos[1] 100000
execute store result score #cap posZ_0 run data get storage collision_check:detected_cap Pos[2] 100000
tp 0-0-0-0-0 0.0 0.0 0.0

#将展示实体的坐标转相对坐标
$execute positioned as @s run tp 0-0-0-0-0 ~$(X) ~$(Y) ~$(Z)
data modify storage collision_check:detected_cap Pos set from entity 0-0-0-0-0 Pos
execute store result score #temp_d int run data get storage collision_check:detected_cap Pos[0] 100000
scoreboard players operation #cap posX_0 += #temp_d int
execute store result score #temp_d int run data get storage collision_check:detected_cap Pos[1] 100000
scoreboard players operation #cap posY_0 += #temp_d int
execute store result score #temp_d int run data get storage collision_check:detected_cap Pos[2] 100000
scoreboard players operation #cap posZ_0 += #temp_d int

#加上AABB模型脚中心到原点的偏差量
scoreboard players operation #temp int = #aabb posX_max
scoreboard players operation #temp int /= #half int
scoreboard players operation #cap posX_0 += #temp int
scoreboard players operation #temp int = #aabb posZ_max
scoreboard players operation #temp int /= #half int
scoreboard players operation #cap posZ_0 += #temp int