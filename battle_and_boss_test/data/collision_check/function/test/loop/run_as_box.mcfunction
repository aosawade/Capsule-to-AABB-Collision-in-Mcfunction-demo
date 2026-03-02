#重置判定状态
scoreboard players set #is_collision boolean 0

function collision_check:test/loop/load_test_box
execute in minecraft:overworld as @e[type=minecraft:block_display,tag=testray] \
    run function collision_check:test/loop/run_as_ray

#判定成功，则当事AABB变红
execute if score #is_collision boolean matches 1 \
    run return run data modify entity @s block_state.Name set value "minecraft:red_stained_glass"
execute if score #is_collision boolean matches 0 \
    run data modify entity @s block_state.Name set value "minecraft:white_stained_glass"