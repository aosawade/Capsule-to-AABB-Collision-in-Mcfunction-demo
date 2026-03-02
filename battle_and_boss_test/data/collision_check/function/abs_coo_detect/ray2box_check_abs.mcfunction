#本函数用于绝对坐标下的检测定长射线ray是否与轴对齐长方体box相交

#快速排除结果

#每次判断初始化
scoreboard players set #in_box int 0
#判断射线起点是否在AABB X轴上下限内，如果不在且平行于X轴（dx=0），直接判负
#范围之外其一，x0>xmax
execute unless score #ray posX_0 <= #box posX_max if score #ray vec_dx matches 0 run return fail
#范围之外其二，x0<xmin
execute unless score #ray posX_0 >= #box posX_min if score #ray vec_dx matches 0 run return fail
#范围之内，将结果累加在#in_box中
execute if score #ray posX_0 <= #box posX_max if score #ray posX_0 >= #box posX_min \
        run scoreboard players add #in_box int 1

#判断射线起点是否在AABB Y轴上下限内，如果不在且平行于Y轴（dy=0），直接判负
execute unless score #ray posY_0 <= #box posY_max if score #ray vec_dy matches 0 run return fail
execute unless score #ray posY_0 >= #box posY_min if score #ray vec_dy matches 0 run return fail
execute if score #ray posY_0 <= #box posY_max if score #ray posY_0 >= #box posY_min \
        run scoreboard players add #in_box int 1

#判断射线起点是否在AABB Z轴上下限内，如果不在且平行于Z轴（dz=0），直接判负
execute unless score #ray posZ_0 <= #box posZ_max if score #ray vec_dz matches 0 run return fail
execute unless score #ray posZ_0 >= #box posZ_min if score #ray vec_dz matches 0 run return fail
execute if score #ray posZ_0 <= #box posZ_max if score #ray posZ_0 >= #box posZ_min \
        run scoreboard players add #in_box int 1

#起点在AABB内，直接判成功
execute if score #in_box int matches 3.. run return run function collision_check:colli_success_func

#正式判断算法
#计算x方向上的进出点
#计算(Xmin-X0)/dx
scoreboard players operation #temp_en int = #box posX_min
scoreboard players operation #temp_en int -= #ray posX_0
scoreboard players operation #temp_en int /= #ray vec_dx
#计算(Xmax-X0)/dx
scoreboard players operation #temp_ex int = #box posX_max
scoreboard players operation #temp_ex int -= #ray posX_0
scoreboard players operation #temp_ex int /= #ray vec_dx
#根据大小判断进出点
execute if score #temp_en int > #temp_ex int run scoreboard players operation #temp_en int >< #temp_ex int
scoreboard players operation #intersect_en int = #temp_en int
scoreboard players operation #intersect_ex int = #temp_ex int

#计算y方向上的进出点
#计算(Ymin-Y0)/dy
scoreboard players operation #temp_en int = #box posY_min
scoreboard players operation #temp_en int -= #ray posY_0
scoreboard players operation #temp_en int /= #ray vec_dy
#计算(Ymax-Y0)/dy
scoreboard players operation #temp_ex int = #box posY_max
scoreboard players operation #temp_ex int -= #ray posY_0
scoreboard players operation #temp_ex int /= #ray vec_dy
#根据大小判断进出点
execute if score #temp_en int > #temp_ex int run scoreboard players operation #temp_en int >< #temp_ex int
#存入更大的进点，更小的出点
scoreboard players operation #intersect_en int > #temp_en int
scoreboard players operation #intersect_ex int < #temp_ex int

#计算z方向上的进出点
#计算(Zmin-Z0)/dz
scoreboard players operation #temp_en int = #box posZ_min
scoreboard players operation #temp_en int -= #ray posZ_0
scoreboard players operation #temp_en int /= #ray vec_dz
#计算(Zmax-Z0)/dz
scoreboard players operation #temp_ex int = #box posZ_max
scoreboard players operation #temp_ex int -= #ray posZ_0
scoreboard players operation #temp_ex int /= #ray vec_dz
#根据大小判断进出点
execute if score #temp_en int > #temp_ex int run scoreboard players operation #temp_en int >< #temp_ex int
#存入最大的进点，最小的出点
scoreboard players operation #intersect_en int > #temp_en int
scoreboard players operation #intersect_ex int < #temp_ex int

#集合存在，且大于0，且不超出射线长度（0<en<ex&&en<lenght）,则碰撞成立
execute if score #intersect_en int matches 0.. \
        if score #intersect_en int < #intersect_ex int \
        if score #intersect_en int < #ray lenght \
        run function collision_check:colli_success_func

#其余情况为判负
return fail