--[[--描述信息
@Author: myc
@Date:   2019-06-17 10:39:37
@Last Modified by   YuchengMo
@Last Modified time 2019-06-17 11:06:52
]]

require("LuaKit");
local Test = class("Test") --类名

function Test:ctor( ... ) --构造函数
	dump("ctor")
end

function Test:dtor( ... ) --析构函数
	dump("Test:dtor")
end

function Test:print( ... ) --测试接口
	dump(...)
end


local TestA = class("Test",Test);--类名，父类

function TestA:ctor( ... )
	self.super.ctor(self); --先调用父类构造函数
	dump({...},"TestA:ctor")

end

function TestA:dtor( ... )
	dump("TestA:dtor") --析构自身
	self.super.dtor(self);--析构父类
end

function TestA:print( ... )
	dump({...})
end

local t = new(TestA,"myc")
t:print("myc","is","man")
delete(t)


local player = {};
player.money = 100;
player.uid = "12dcc1dcxfsdfdvdvg";
player.name = "myc"

dump(play)