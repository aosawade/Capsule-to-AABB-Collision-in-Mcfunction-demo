#这个函数用来将输入的坐标进行展示实体的矩阵变换，返回变换后的坐标
#采用相对坐标，即相对展示实体原点的坐标
#上下文执行者必须为展示实体
#变换矩阵以宏参数的形式传入
#输出以标记实体0-0-0-0-0的坐标输出

#将变换矩阵拆分存入命令存储
data modify storage globle_transform_temp transformation set from entity @s transformation
data modify storage globle_transform_temp translation.px set from storage globle_transform_temp transformation.translation[0]
data modify storage globle_transform_temp translation.py set from storage globle_transform_temp transformation.translation[1]
data modify storage globle_transform_temp translation.pz set from storage globle_transform_temp transformation.translation[2]

function globle:pos_rel2display with storage globle_transform_temp translation



