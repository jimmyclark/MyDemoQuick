local math2d = require("math2d");
local BulletBase = class("BulletBase");

BulletBase.FLAG_NORMAL     = 0;
BulletBase.FLAG_FROM_SKILL = 1;

function BulletBase:ctor(source, target, sprite, delay)
    self.m_source = source;
    self.m_target = target;
    self.m_sprite = sprite;
    self.m_delay = checknumber(delay);
    self.m_flag = 0;

    self.m_damage = math.random(source.m_minDamage, source.m_maxDamage);
    self.m_damageScale = 1;

    self.m_hit = math.random(100) <= source.m_hitrate;
    self.m_critical = math.random(100) <= source.m_critical;
    self.m_startX = source.m_x + source.m_radiusOffsetX + source.m_fireOffsetX;
    self.m_startY = source.m_y + source.m_radiusOffsetY + source.m_fireOffsetY;
    self.m_prevX = self.m_startX;
    self.m_prevY = self.m_startY;

    self.m_time = 0;
    self.m_over = false;
    self.m_isBegan = false;
end

function BulletBase:setFlag(flag)
    self.m_flag = flag;
end

function BulletBase:getView()
    return self.m_sprite;
end

function BulletBase:removeView()
    self.m_sprite:removeSelf();
end

function BulletBase:tick(dt)
    if not self.m_isBegan then
        if self.m_delay <= 0 then
            self:fireBegan();
        else
            self.m_delay = self.m_delay - dt;
            return;
        end
    end

    self.m_time = self.m_time + dt;
    self:tickBullet(dt);
end

function BulletBase:fireBegan()
    if self.m_source.destroyed_ then
        self.time_    = 0
        self.over_    = true
        self.isBegan_ = false
        return
    end

    local source = self.m_source
    self.startX_  = source.x_ + source.m_radiusOffsetX + source.m_fireOffsetX
    self.startY_  = source.y_ + source.m_radiusOffsetY + source.m_fireOffsetY;
    self.prevX_   = self.startX_
    self.prevY_   = self.startY_
    self.isBegan_ = true
end

function BulletBase:tickBullet(dt)
end

function BulletBase:checkHit()
    if not self.m_hit then
        self:miss();
        return false;
    end

    local target = self.m_target;
    if target and (target.m_collisionLock > 0 or not target.m_collisionEnabled or target.m_destroyed) then
        self:miss();
        return false;
    end

    local x, y = self.m_sprite:getPosition();
    local targetX = target.m_x + target.m_radiusOffsetX;
    local targetY = target.m_y + target.m_radiusOffsetY;

    if math2d.dist(x, y, targetX, targetY) <= target.m_radius then
        self:hit();
        return true;
    end

    self:miss();
    return false;
end

function BulletBase:hit()
end

function BulletBase:miss()
end

function BulletBase:isOver()
    return self.m_over;
end

return BulletBase;
