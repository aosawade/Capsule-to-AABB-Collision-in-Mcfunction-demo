#检测输入参数是否存在
execute unless score @s box_dx matches 1.. run return run say 参数未配置完全！
execute unless score @s box_dy matches 1.. run return run say 参数未配置完全！
execute unless score @s box_dz matches 1.. run return run say 参数未配置完全！

#生成玻璃展示实体，以可视化AABB的范围
summon minecraft:block_display ~ ~ ~ {Tags:[testbox],block_state:{Name:"minecraft:white_stained_glass"}}
#将设定好的长宽高配置到展示实体，并平面居中
data modify storage collision_check:test_box transformation set value {scale:[1f,1f,1f],translation:[0f,0f,0f]}
execute store result storage collision_check:test_box transformation.scale[0] float 0.01 \
        run scoreboard players get @s box_dx
execute store result storage collision_check:test_box transformation.scale[1] float 0.01 \
        run scoreboard players get @s box_dy
execute store result storage collision_check:test_box transformation.scale[2] float 0.01 \
        run scoreboard players get @s box_dz
execute store result storage collision_check:test_box transformation.translation[0] float -0.005 \
        run scoreboard players get @s box_dx
execute store result storage collision_check:test_box transformation.translation[2] float -0.005 \
        run scoreboard players get @s box_dz
data modify entity @n[type=minecraft:block_display,tag=testbox] transformation \
        merge from storage collision_check:test_box transformation