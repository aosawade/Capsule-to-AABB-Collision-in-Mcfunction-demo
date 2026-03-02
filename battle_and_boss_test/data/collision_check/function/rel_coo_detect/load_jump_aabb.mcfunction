#当玩家正常时（状态为2），加载上半身的AABB

#取玩家原点以上0.8格为AABB原点，坐标存到命令存储中
execute positioned as @s run tp 0-0-0-0-0 ~ ~0.8 ~
data modify storage collision_check:detected_aabb Pos set from entity 0-0-0-0-0 Pos
tp 0-0-0-0-0 0 0 0
#存一份数据进胶囊体命令存储中，取反，随后获取射线相对坐标要用
execute store result storage collision_check:detected_cap rel_box.X double -0.01 \
    run data get storage collision_check:detected_aabb Pos[0] 100
execute store result storage collision_check:detected_cap rel_box.Y double -0.01 \
    run data get storage collision_check:detected_aabb Pos[1] 100
execute store result storage collision_check:detected_cap rel_box.Z double -0.01 \
    run data get storage collision_check:detected_aabb Pos[2] 100

#aabb直接取常量，只存最大点，其中y轴减去脚的高度
scoreboard players operation #aabb posX_max = #player_wide int
scoreboard players operation #aabb posY_max = #player_hight int
scoreboard players operation #aabb posY_max -= #player_jump int
scoreboard players operation #aabb posZ_max = #player_wide int