local MapConstants  = require("app.map.MapConstant");
local BulletType    = require("app.map.BulletType");
local BulletFactory = require("app.map.BulletFactory");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local FireBehavior = class("FireBehavior", BehaviorBase);

function FireBehavior:ctor()
    FireBehavior.super.ctor(self, "FireBehavior", nil, 1);
end

function FireBehavior:bind(object)
    object.m_fireLock = 0;

    local function getFireRange(object)
        return object.m_fireRange;
    end

    object:bindMethod(self, "getFireRange", getFireRange);

    local function getCooldown(object)
        return object.m_cooldown;
    end

    object:bindMethod(self, "getCooldown", getFireRange);

    local function addFireLock(object)
        object.m_fireLock = object.m_fireLock + 1;
    end

    object:bindMethod(self, "addFireLock", addFireLock);

    local function removeFireLock(object)
        object.m_fireLock = object.m_fireLock - 1;
        assert(object.m_collisionLock >= 0,
               "FireBehavior.removeFireLock() - object.m_fireLock must >= 0");
    end

    object:bindMethod(self, "removeFireLock", removeFireLock);

    local function getFireEnabled(object)
        return object.m_fireEnabled;
    end

    object:bindMethod(self, "getFireEnabled", getFireEnabled);

    local function setFireEnabled(object, enabled)
        object.m_fireEnabled = enabled;
    end

    object:bindMethod(self, "setFireEnabled", setFireEnabled);

    local function fire(object, target)
        if not object.m_fireEnabled then
            echoError("FireBehavior.fire() - fire disabled");
            return;
        end

        if object.m_fireCooldown > 0 then
            echoError("FireBehavior.fire() - cooldown must equal zero");
            return;
        end

        if object:hasBehavior("DecorateBehavior") then
            local decorationName = object:getDefineId() .. "Fire";
            if object:isDecorationExists(decorationName) then
                local decoration = object:getDecoration(decorationName);
                local autoHide = decoration.m_visible == false;
                
                if autoHide then
                    decoration:setVisible(true);
                end
                
                decoration:playAnimationOnce(function()
                    if autoHide then 
                        decoration:setVisible(false);
                    end

                    decoration:setDisplayFrameIndex(1);
                end);
            end

            local decorationName = object:getDefineId() .. "Fire2";

            if object:isDecorationExists(decorationName) then
                local decoration = object:getDecoration(decorationName);
                local autoHide = decoration.m_visible == false;
                
                if autoHide then 
                    decoration:setVisible(true);
                end

                decoration:playAnimationOnce(function()
                    if autoHide then 
                        decoration:setVisible(false);
                    end

                    decoration:setDisplayFrameIndex(1);
                end);
            end
        end

        object.m_fireCooldown; = object.m_cooldown * math.random(80, 120) / 100;
        local delay = nil;
        if object:hasBehavior("NPCBehavior") or object:hasBehavior("PlayerBehavior") then
            delay = 0;
        end

        return BulletFactory.newBullets(object.bulletType_, object, target, delay);
    end
    object:bindMethod(self, "fire", fire);

    local function tick(object, dt)
        local fireCooldown = object.m_fireCooldown;
        if fireCooldown > 0 then
            fireCooldown = fireCooldown - dt;
            if fireCooldown <= 0 then fireCooldown = 0 end
            object.m_fireCooldown = fireCooldown;
        end
    end
    object:bindMethod(self, "tick", tick);

    self:reset(object);
end

function FireBehavior:unbind(object)
    object.m_fireOffsetX = nil;
    object.m_fireOffsetY = nil;
    object.m_fireRange = nil;
    object.m_cooldown = nil;
    object.m_fireCooldown = nil;
    object.m_fireEnabled   = nil;

    object.m_minDamage = nil;
    object.m_maxDamage = nil;
    object.m_hitrate = nil;
    object.m_critical = nil;
    object.m_criticalPower = nil;

    object:unbindMethod(self, "getFireRange");
    object:unbindMethod(self, "getCooldown");
    object:unbindMethod(self, "addFireLock");
    object:unbindMethod(self, "removeFireLock");
    object:unbindMethod(self, "getFireEnabled");
    object:unbindMethod(self, "setFireEnabled");
    object:unbindMethod(self, "fire");
    object:unbindMethod(self, "tick");
end

function FireBehavior:reset(object)
    object.m_fireOffsetX = checkint(object.m_state.fireOffsetX);
    object.m_fireOffsetY = checkint(object.m_state.fireOffsetY);
    if object.m_staticIndex then
        local index = object.m_staticIndex;
        if type(object.m_state.fireOffsetX) == "table" then
            object.m_fireOffsetX = object.m_state.fireOffsetX[index];
        end
        if type(object.m_state.fireOffsetY) == "table" then
            object.m_fireOffsetY = object.m_state.fireOffsetY[index];
        end
    end
    object.m_fireRange = checkint(object.m_state.fireRange);
    object.m_cooldown = checknumber(object.m_state.cooldown);
    object.m_fireCooldown = 0;
    object.m_fireEnabled = object.m_state.fireEnabled;

    object.m_minDamage = checkint(object.m_state.minDamage);
    object.m_maxDamage = checkint(object.m_state.maxDamage);
    object.m_hitrate = checkint(object.m_state.hitrate);
    object.m_critical = checkint(object.m_state.critical);
    object.m_criticalPower = checknumber(object.m_state.criticalPower);

    if type(object.m_fireEnabled) ~= "boolean" then
        object.m_fireEnabled = true;
    end
end

return FireBehavior;
