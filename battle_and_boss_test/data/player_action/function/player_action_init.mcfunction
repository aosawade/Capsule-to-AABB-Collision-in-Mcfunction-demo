#设置准则为玩家跳跃的计分板，并重置所有玩家的分数为0
scoreboard objectives add player_jump minecraft.custom:minecraft.jump jump_test
scoreboard players set @a player_jump 0

#设置玩家的跳跃下半身无敌帧剩余时间，默认为10t
scoreboard objectives add jump_time dummy
scoreboard players set @a jump_time 10

#设置玩家闪避无敌帧计时器和冷却时间计时器，并配置默认值
scoreboard objectives add dodge_effect_time dummy
scoreboard objectives add dodge_cd dummy
scoreboard players set @a dodge_effect_time 0
scoreboard players set @a dodge_cd 10

#玩家各项魔咒效果发动载体
item replace entity @a armor.body with minecraft:leather_horse_armor[minecraft:enchantments={"player_action:dodge_effect":1,"player_action:dodge_motion":5},minecraft:equippable={slot:"body",equip_sound:"minecraft:intentionally_empty"},custom_name="玩家魔咒效果器"] 1

scoreboard objectives add motionx dummy
scoreboard objectives add motiony dummy
scoreboard objectives add motionz dummy