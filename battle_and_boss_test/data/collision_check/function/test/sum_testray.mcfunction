#检测输入参数是否存在
execute unless score @s ray_l matches 1.. run return run say 参数未配置完全！

#生成竹子展示实体，以可视化射线的范围
summon minecraft:block_display ~ ~ ~ \
    {\
        Tags:[testray],\
        block_state:{Name:"minecraft:bamboo"},\
        transformation:{\
            right_rotation:{angle:1.570796f,axis:[1,0,0]},\
            scale:[0.5f,0.5f,1f],\
            left_rotation:{angle:0f,axis:[0,0,0]},\
            translation:[-0.25f,0.25f,0f]\
        }\
    }
execute store result entity @n[type=minecraft:block_display,tag=testray] transformation.scale[2] float 0.01 \
        run scoreboard players get @s ray_l
execute at @s anchored eyes positioned ^ ^ ^ \
        run tp @n[type=minecraft:block_display,tag=testray] ~ ~ ~ ~ ~