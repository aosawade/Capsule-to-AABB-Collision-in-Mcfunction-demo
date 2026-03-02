#创建用于玩家录入长方体的长宽高计分板
scoreboard objectives add box_dx trigger "长方体dx"
scoreboard objectives add box_dy trigger "长方体dy"
scoreboard objectives add box_dz trigger "长方体dz"
scoreboard players enable @a box_dx
scoreboard players enable @a box_dy
scoreboard players enable @a box_dz

#创建用于玩家录入射线的长度
scoreboard objectives add ray_l trigger "射线lenght"
scoreboard players enable @a ray_l

#创建用于玩家录入胶囊体的半径
scoreboard objectives add ray_r trigger "胶囊体半径"
scoreboard players enable @a ray_r