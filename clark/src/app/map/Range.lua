local ObjectBase = require("app.map.ObjectBase");
local Range = class("Range", ObjectBase);

Range.DEFAULT_RADIUS = 80;
Range.MIN_RADIUS     = 16;
Range.MAX_RADIUS     = 500;

function Range:ctor(id, state, map)
    Range.super.ctor(self, id, state, map);
    self.m_valid = true;
    self.m_collisionEnabled = true;
    self.m_radius = checkint(self.m_radius);
    if self.m_radius <= 0 then
        self.m_radius = Range.DEFAULT_RADIUS;
    end
end

--[[
    返回区域半径
]]
function Range:getRadius()
    return self.m_radius;
end

--[[
    设置区域半径
]]
function Range:setRadius(radius)
    if radius < Range.MIN_RADIUS then 
        radius = Range.MIN_RADIUS;
    end

    if radius > Range.MAX_RADIUS then 
        radius = Range.MAX_RADIUS;
    end

    self.m_radius = math.round(radius);
end

--[[
    导出 Range 对象的状态
]]
function Range:vardump()
    local state = Range.super.vardump(self);
    state.radius = self.m_radius;
    return state;
end

return Range;
