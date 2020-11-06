# LuaKit

## 支持面向对象
``` lua

--[[--描述信息
@Author: myc
@Date:   2019-06-17 10:39:37
@Last Modified by   YuchengMo
@Last Modified time 2019-06-17 11:03:23
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

```

## 常用辅助类
### dump
```lua

local player = {};
player.money = 100;
player.uid = "12dcc1dcxfsdfdvdvg";
player.name = "myc"

dump(player)--打印玩家数据

dumpToFile("player",player)--打印玩家数据


```

### 性能检测工具profiler
```lua

local player = {};
player.money = 100;
player.uid = "12dcc1dcxfsdfdvdvg";
player.name = "myc"


local profiler = newProfiler("call") --
profiler:start() --开启性能分析

dump(player) --要测试的代码

profiler:stop() --结束分析

profiler:dumpReportToFile( "profiler.txt" ) --输出报告保存到文件


```

