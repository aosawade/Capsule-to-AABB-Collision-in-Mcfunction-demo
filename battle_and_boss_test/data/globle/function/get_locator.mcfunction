#这个函数用来获取AJ定位器的参数
#定位器关联的展示实体的data以宏参数的形式传入
#以命令存储globle_locator_temp输出

$execute on vehicle on passengers as @s[tag=aj.global.data] \
    run data modify storage globle_locator_temp locator merge from entity @s data.locators.$(locator)
#data modify entity 0-0-0-0-0 Rotation[0] set from storage 