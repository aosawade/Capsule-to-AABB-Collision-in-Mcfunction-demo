#循环检测开关没开，则不检测
execute if score #enable_detect_loop boolean matches 0 run return fail

execute in minecraft:overworld as @e[type=minecraft:block_display,tag=testbox] \
    run function collision_check:test/loop/run_as_box