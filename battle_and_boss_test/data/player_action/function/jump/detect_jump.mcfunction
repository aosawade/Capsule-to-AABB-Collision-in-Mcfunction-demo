execute as @a if score @s player_jump matches 1 run scoreboard players set @s status 2
execute as @a if score @s status matches 2 run scoreboard players remove @s jump_time 1
execute as @a if score @s jump_time matches ..0 run function player_action:jump/jump_end