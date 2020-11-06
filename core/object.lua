--[[--描述信息
@Author: myc
@Date:   2019-06-17 10:34:04
@Last Modified by   YuchengMo
@Last Modified time 2019-06-25 11:38:45
]]

function class(super,name)
    local classType = {};

    if super then
        classType.super = super;
        setmetatable(classType, { __index = super});
    end

    if name then
        classType._className_ = name;
    end


    return classType;
end


function new(class,...)
    local obj = {};
    setmetatable(obj, {__index = class})

    if obj.ctor then
        obj:ctor(...)
    end

    return obj;
end


function typeof(obj, classType)
    if type(obj) ~= type(table) or type(classType) ~= type(table) then
        return type(obj) == type(classType);
    end

    while obj do
        if obj == classType then
            return true;
        end
        obj = getmetatable(obj) and getmetatable(obj).__index;
    end
    return false;
end


function delete(obj)
    if obj then
        if obj.dtor then
            obj:dtor()
        end
        setmetatable(obj, {})
    end
end