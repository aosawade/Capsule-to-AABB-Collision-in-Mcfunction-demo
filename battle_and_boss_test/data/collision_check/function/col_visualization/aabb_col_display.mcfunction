#用来显示被命中的AABB碰撞箱

$execute if score #is_collision boolean matches 1 \
    run return run data modify entity @n[type=minecraft:block_display,tag=aabb_visuable,nbt={data:{player_uuid:$(UUID)}}] block_state.Name set value "minecraft:red_stained_glass"
$execute if score #is_collision boolean matches 0 \
    run data modify entity @n[type=minecraft:block_display,tag=aabb_visuable,nbt={data:{player_uuid:$(UUID)}}] block_state.Name set value "minecraft:white_stained_glass"