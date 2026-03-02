#本函数用于相对坐标下的检测j胶囊体cap是否与aabb碰撞箱相交

#先进行问题转换，将cap2aabb转ray2box
scoreboard players operation #box posX_max = #aabb posX_max
scoreboard players operation #box posX_max += #cap radius
scoreboard players operation #box posX_max += #cap radius
scoreboard players operation #box posY_max = #aabb posY_max
scoreboard players operation #box posY_max += #cap radius
scoreboard players operation #box posY_max += #cap radius
scoreboard players operation #box posZ_max = #aabb posZ_max
scoreboard players operation #box posZ_max += #cap radius
scoreboard players operation #box posZ_max += #cap radius

scoreboard players operation #ray posX_0 = #cap posX_0
scoreboard players operation #ray posX_0 += #cap radius
scoreboard players operation #ray posY_0 = #cap posY_0
scoreboard players operation #ray posY_0 += #cap radius
scoreboard players operation #ray posZ_0 = #cap posZ_0
scoreboard players operation #ray posZ_0 += #cap radius

scoreboard players operation #ray vec_dx = #cap vec_dx
scoreboard players operation #ray vec_dy = #cap vec_dy
scoreboard players operation #ray vec_dz = #cap vec_dz

scoreboard players operation #ray lenght = #cap lenght

#进行ray2box检测
function collision_check:rel_coo_detect/ray2box_check