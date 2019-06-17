--[[--描述信息
@Author: myc
@Date:   2019-06-17 10:39:37
@Last Modified by   YuchengMo
@Last Modified time 2019-06-17 10:59:14
]]

require("init");
local Test = class("Test")

function Test:ctor( ... )
	dump("ctor")
end

function Test:dtor( ... )
	dump("Test:dtor")
end

function Test:print( ... )
	dump(...)
end


local TestA = class("Test",Test);

function TestA:ctor( ... )
	self.super.ctor(self);
	dump({...},"TestA:ctor")

end

function TestA:dtor( ... )
	dump("TestA:dtor")
	self.super.dtor(self);
end

function TestA:print( ... )
	dump({...})
end

local t = new(TestA,"myc")
t:print("myc","is","lua")
delete(t)
