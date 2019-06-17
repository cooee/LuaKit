--[[--ldoc 框架加载入口
@module _load
@author YuchengMo

Date   2017-12-20 11:47:08
Last Modified by   YuchengMo
Last Modified time 2019-06-17 10:59:50
]]

local strLogo = [[


 __       __    __       ___       __  ___  __  .___________.
|  |     |  |  |  |     /   \     |  |/  / |  | |           |
|  |     |  |  |  |    /  ^  \    |  '  /  |  | `---|  |----`
|  |     |  |  |  |   /  /_\  \   |    <   |  |     |  |     
|  `----.|  `--'  |  /  _____  \  |  .  \  |  |     |  |     
|_______| \______/  /__/     \__\ |__|\__\ |__|     |__|     


]]


print(strLogo)

local startMem = collectgarbage("count")
LuaKit = {}

local root = "LuaKit."
require("lib.init");
require(".utils.init");
require("core.object");


local endMem = collectgarbage("count")

print(string.format("加载LuaKit结束，内存变化 开始：%s, 结束: %s，差值: %s",startMem,endMem,endMem - startMem));

-- require("test")