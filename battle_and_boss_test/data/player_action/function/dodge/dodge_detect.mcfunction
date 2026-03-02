execute as @a if score @s dodge_effect_time matches 1.. \
    run scoreboard players remove @s dodge_effect_time 1
execute as @a if score @s dodge_effect_time matches 0 \
    run scoreboard players set @s status 0
execute as @a if score @s dodge_cd matches ..9 unless score @s dodge_effect_time matches 1.. \
    run scoreboard players add @s dodge_cd 1

execute as @a if score @s dodge_cd matches 0 \
    run item replace entity @s armor.body with minecraft:leather_horse_armor\
    [minecraft:enchantments={"player_action:dodge_effect":1,"player_action:dodge_motion":1},minecraft:equippable={slot:"body",equip_sound:"minecraft:intentionally_empty"},custom_name="玩家魔咒效果器"] 1
execute as @a if score @s dodge_cd matches 4 \
    run item replace entity @s armor.body with minecraft:leather_horse_armor\
    [minecraft:enchantments={"player_action:dodge_effect":1,"player_action:dodge_motion":2},minecraft:equippable={slot:"body",equip_sound:"minecraft:intentionally_empty"},custom_name="玩家魔咒效果器"] 1
execute as @a if score @s dodge_cd matches 7 \
    run item replace entity @s armor.body with minecraft:leather_horse_armor\
    [minecraft:enchantments={"player_action:dodge_effect":1,"player_action:dodge_motion":3},minecraft:equippable={slot:"body",equip_sound:"minecraft:intentionally_empty"},custom_name="玩家魔咒效果器"] 1
execute as @a if score @s dodge_cd matches 9 \
    run item replace entity @s armor.body with minecraft:leather_horse_armor\
    [minecraft:enchantments={"player_action:dodge_effect":1,"player_action:dodge_motion":5},minecraft:equippable={slot:"body",equip_sound:"minecraft:intentionally_empty"},custom_name="玩家魔咒效果器"] 1