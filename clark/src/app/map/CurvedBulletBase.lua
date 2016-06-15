local math2d          = require("app.math2d");
local radians4point   = math2d.radians4point;
local radians2degrees = math2d.radians2degrees;
local degrees2radians = math2d.degrees2radians;
local pointAtCircle   = math2d.pointAtCircle;
local dist            = math2d.dist;

local BulletBase = require("app.map.BulletBase");
local CurvedBulletBase = class("CurvedBulletBase", BulletBase);

function CurvedBulletBase:ctor(source, target, sprite, params)
    CurvedBulletBase.super.ctor(self, source, target, sprite, params.delay);
    self.m_flyTime = checknumber(params.flyTime);
    self.m_g  = checknumber(params.g);
    self.m_isRotation = checkbool(params.isRotation);
end

function CurvedBulletBase:fireBegan()
    CurvedBulletBase.super.fireBegan(self);

    local target = self.m_target;
    local targetX, targetY;
    if target:hasBehavior("MovableBehavior") and target:isMoving() then
        targetX, targetY = target:getFuturePosition(self.m_flyTime + self.m_delay);
    else
        targetX, targetY = target.m_x, target.m_y;
    end
    targetX = targetX + target.m_radiusOffsetX + target.m_hitOffsetX;
    targetY = targetY + target.m_radiusOffsetY + target.m_hitOffsetY;

    -- 子弹会落在目标中心点的一定范围内
    local radius = target.m_radius;
    local offset = radius * (math.random(0, 70) / 100);
    if math.random(1, 2) % 2 == 0 then
        targetX = targetX + offset;
    else
        targetX = targetX - offset;
    end

    offset = radius * (math.random(0, 70) / 100) * 0.7;
    if math.random(1, 2) % 2 == 0 then
        targetY = targetY + offset * 0.5;
    else
        targetY = targetY - offset * 0.5;
    end

    self.m_targetX = targetX;
    self.m_targetY = targetY;
    self.m_timeOffset = self.m_delay;
    local ft = self.m_flyTime;

    self.m_offsetX = (self.m_targetX - self.m_startX) / ft;
    self.m_offsetY = ((self.m_targetY - self.m_startY) - ((self.m_g * ft) * (ft / 2))) / ft;

    self.m_sprite:setPosition(self.m_startX, self.m_startY);
end

function CurvedBulletBase:tickBullet(dt)
    local time = self.m_time - self.m_timeOffset;

    local x = self.m_startX + time * self.m_offsetX;
    local y = self.m_startY + time * self.m_offsetY + self.m_g * time * time / 2;
    self.m_sprite:setPosition(x, y);

    if self.m_isRotation then
        local degrees = radians2degrees(radians4point(self.m_prevX, self.m_prevY, x, y));
        self.m_prevX, self.m_prevY = x, y;
        self.m_sprite:setRotation(degrees);
    end

    if time >= self.m_flyTime then
        self.m_over = true;
    end
end

return CurvedBulletBase;
