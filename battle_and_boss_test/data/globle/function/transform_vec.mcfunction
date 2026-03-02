#这个函数用来将输入的方向向量进行展示实体的矩阵变换，返回变换后的方向分量坐标（单位向量）
#采用相对坐标，即相对展示实体原点的坐标
#变换矩阵以上下文执行者（必须为展示实体）的nbt形式传入
#原坐标以标记实体0-0-0-0-0的坐标输入
#输出以标记实体0-0-0-0-0的坐标输出，倍率10

#将变换矩阵存入命令存储
data modify storage globle_transform_temp transformation set from entity @s transformation
#将传参的xyz存入计分板
execute store result score #temp_x int run data get entity 0-0-0-0-0 Pos[0] 100
execute store result score #temp_y int run data get entity 0-0-0-0-0 Pos[1] 100
execute store result score #temp_z int run data get entity 0-0-0-0-0 Pos[2] 100

data modify storage globle_transform_temp output_pos set value [0,0,0]
#计算输出x
scoreboard players set #output int 0
scoreboard players set #matrix_1 int 0
execute if score #temp_x int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[0] 1000
execute if score #temp_x int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_x int
scoreboard players operation #output int += #matrix_1 int
scoreboard players set #matrix_1 int 0
execute if score #temp_y int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[1] 1000
execute if score #temp_y int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_y int
scoreboard players operation #output int += #matrix_1 int
scoreboard players set #matrix_1 int 0
execute if score #temp_z int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[2] 1000
execute if score #temp_z int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_z int
scoreboard players operation #output int += #matrix_1 int
execute store result storage globle_transform_temp output_pos[0] double 0.00001 \
    run scoreboard players get #output int

#计算输出y
scoreboard players set #output int 0
scoreboard players set #matrix_1 int 0
execute if score #temp_x int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[4] 1000
execute if score #temp_x int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_x int
scoreboard players operation #output int += #matrix_1 int
scoreboard players set #matrix_1 int 0
execute if score #temp_y int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[5] 1000
execute if score #temp_y int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_y int
scoreboard players operation #output int += #matrix_1 int
scoreboard players set #matrix_1 int 0
execute if score #temp_z int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[6] 1000
execute if score #temp_z int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_z int
scoreboard players operation #output int += #matrix_1 int
execute store result storage globle_transform_temp output_pos[1] double 0.00001 \
    run scoreboard players get #output int

#计算输出z
scoreboard players set #output int 0
scoreboard players set #matrix_1 int 0
execute if score #temp_x int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[8] 1000
execute if score #temp_x int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_x int
scoreboard players operation #output int += #matrix_1 int
scoreboard players set #matrix_1 int 0
execute if score #temp_y int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[9] 1000
execute if score #temp_y int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_y int
scoreboard players operation #output int += #matrix_1 int
scoreboard players set #matrix_1 int 0
execute if score #temp_z int matches 1.. store result score #matrix_1 int \
    run data get storage globle_transform_temp transformation[10] 1000
execute if score #temp_z int matches 1.. run scoreboard players operation #matrix_1 int *= #temp_z int
scoreboard players operation #output int += #matrix_1 int
execute store result storage globle_transform_temp output_pos[2] double 0.00001 \
    run scoreboard players get #output int

#将输出计分板转为0-0-0-0-1的坐标
data modify entity 0-0-0-0-1 Pos set from storage globle_transform_temp output_pos
execute positioned 0 0 0 facing entity 0-0-0-0-1 feet as 0-0-0-0-0 run tp ^ ^ ^10