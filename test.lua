--[[--描述信息
@Author: myc
@Date:   2019-06-17 10:39:37
@Last Modified by   YuchengMo
@Last Modified time 2020-11-06 09:36:51
]]
require("LuaKit")


local mt = getmetatable("");
mt.__add = function(t1, t2)
	return t1 .. t2
end

mt.__sub = function(t1, t2)
	return t1:remove(t2)
end

local str = "123"

local a = "1234";

local b = a(2,3)

print(b)