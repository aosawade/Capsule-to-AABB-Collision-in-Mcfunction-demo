#循环检测开关没开，则不检测
execute if score #enable_detect_loop boolean matches 0 run return fail

execute in minecraft:overworld as @a[tag=aabb] \
    run function collision_check:rel_coo_detect/run_as_player