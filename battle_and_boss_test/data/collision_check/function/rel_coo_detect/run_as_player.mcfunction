#异常处理，当前执行者未玩家则返回0
execute unless entity @s[type=player] run return fail

#重置判定状态
scoreboard players set #is_collision boolean 0

execute if score @s status matches 1 run return fail
execute if score @s status matches 0 run function collision_check:rel_coo_detect/load_defual_aabb
execute if score @s status matches 2 run function collision_check:rel_coo_detect/load_jump_aabb
#用于计算相对坐标的坐标轴坐标，存储于collision_check:detected_cap rel_box:{x,y,z}

#渲染可视化碰撞箱
function collision_check:col_visualization/update_visual_box with entity @s

#以当前玩家为坐标轴，检索附件一定范围内的胶囊实体，进行数据加载和检测
execute in minecraft:overworld as @e[distance=..160,type=minecraft:item_display,tag=collision_check_capsule] \
    run function collision_check:rel_coo_detect/run_as_capsule

#显示碰撞结果
function collision_check:col_visualization/aabb_col_display with entity @s