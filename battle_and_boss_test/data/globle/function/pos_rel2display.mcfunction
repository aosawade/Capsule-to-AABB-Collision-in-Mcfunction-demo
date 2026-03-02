#将标记实体的坐标归零，然后与展示实体的朝向一致
#之后再根据展示实体的位移进行平移
$execute positioned 0.0 0.0 0.0 rotated as @s as 0-0-0-0-0 run tp @s ^$(px) ^$(py) ^$(pz)