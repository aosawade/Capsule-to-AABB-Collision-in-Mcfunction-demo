scoreboard players operation @s dodge_effect_time = @s dodge_cd
scoreboard players set @s dodge_cd 0
scoreboard players set @s status 1
execute if score @s dodge_effect_time matches 9.. run function player_action:dodge/dodge_sfx