#判断箱碰撞子系统初始化函数，主要用于初始化所需的计分板积分项

#射线起点坐标
scoreboard objectives add posX_0 dummy
scoreboard objectives add posY_0 dummy
scoreboard objectives add posZ_0 dummy

#射线方向矢量
scoreboard objectives add vec_dx dummy
scoreboard objectives add vec_dy dummy
scoreboard objectives add vec_dz dummy

#射线长度
scoreboard objectives add lenght dummy

#胶囊体的半径
scoreboard objectives add radius dummy

#AABB计算参数，三轴最大、最小值
scoreboard objectives add posX_min dummy
scoreboard objectives add posY_min dummy
scoreboard objectives add posZ_min dummy
scoreboard objectives add posX_max dummy
scoreboard objectives add posY_max dummy
scoreboard objectives add posZ_max dummy

#计算用临时计分板
scoreboard objectives add int dummy
scoreboard objectives add boolean dummy
scoreboard objectives add max dummy
scoreboard objectives add min dummy

#玩家当前状态 0正常 1全身无敌 2下半身无敌 用来决定玩家AABB碰撞箱的大小
scoreboard objectives add status dummy
scoreboard players set @a status 0

#暂时不需要#玩家是否被命中计分板
#scoreboard objectives add be_collision dummy

#计算常用常数
scoreboard players set #half int 2
#玩家默认的aabb碰撞箱子
scoreboard players set #player_wide int 60000
scoreboard players set #player_hight int 180000
scoreboard players set #player_jump int 80000

#循环检测碰撞总开关
scoreboard players set #enable_detect_loop boolean 1