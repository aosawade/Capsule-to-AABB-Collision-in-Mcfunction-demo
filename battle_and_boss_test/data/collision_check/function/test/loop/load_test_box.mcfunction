#将方块展示实体的缩放、位置存入计算用计分板
#先存到命令存储中
data modify storage collision_check:detected_box Pos set from entity @s Pos
data modify storage collision_check:detected_box scale set from entity @s transformation.scale
#存一份数据进射线命令存储中，取反，随后获取射线相对坐标要用
execute store result storage collision_check:detected_ray rel_box.X double -0.01 \
    run data get storage collision_check:detected_box Pos[0] 100
execute store result storage collision_check:detected_ray rel_box.Y double -0.01 \
    run data get storage collision_check:detected_box Pos[1] 100
execute store result storage collision_check:detected_ray rel_box.Z double -0.01 \
    run data get storage collision_check:detected_box Pos[2] 100

#再将命令存储的数据变换后存入计分板，只存最大点
execute store result score #box posX_max run data get storage collision_check:detected_box scale[0] 100000
execute store result score #box posY_max run data get storage collision_check:detected_box scale[1] 100000
execute store result score #box posZ_max run data get storage collision_check:detected_box scale[2] 100000