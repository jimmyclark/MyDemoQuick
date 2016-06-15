local MapConstants = require("app.map.MapConstants");
local BehaviorBase = require("app.behaviors.BehaviorBase");

local DestroyedBehavior = class("DestroyedBehavior", BehaviorBase);

function DestroyedBehavior:ctor()
    DestroyedBehavior.super.ctor(self, "DestroyedBehavior", {"CampBehavior", "CollisionBehavior"}, 1);
end

function DestroyedBehavior:bind(object)
    local function isDestroyed(object)
        return object.m_destroyed;
    end

    object:bindMethod(self, "isDestroyed", isDestroyed);

    local function getMaxHp(object)
        return object.m_maxHp;
    end

    object:bindMethod(self, "getMaxHp", getMaxHp);

    local function setMaxHp(object, maxHp)
        maxHp = checkint(maxHp);
        assert(maxHp > 0, string.format("DestroyedBehavior.setMaxHp() - invalid maxHp %s", tostring(maxHp)));
        object.m_maxHp = maxHp;
    end

    object:bindMethod(self, "setMaxHp", setMaxHp);

    local function getHp(object)
        return object.m_hp;
    end

    object:bindMethod(self, "getHp", getHp);

    local function setHp(object, hp)
        hp = checknumber(hp);
        assert(hp >= 0 and hp <= object.m_maxHp,
               string.format("DestroyedBehavior.setHp() - invalid hp %s", tostring(hp)));
        object.m_hp = hp;
        object.m_destroyed = object.m_hp <= 0;
        object.hp__ = nil;
    end

    object:bindMethod(self, "setHp", setHp);

    local function decreaseHp(object, amount)
        amount = checknumber(amount);
        assert(amount >= 0, string.format("DestroyedBehavior.decreaseHp() - invalid amount %s", tostring(amount)));
        object.m_hp = object.m_hp - amount;

        if object.m_hp <= 0 then
            object.m_hp = 0;
        end

        object.m_destroyed = object.m_hp <= 0;
    end

    object:bindMethod(self, "decreaseHp", decreaseHp);

    local function increaseHp(object, amount)
        amount = checknumber(amount);
        assert(amount >= 0, string.format("DestroyedBehavior.increaseHp() - invalid amount %s", tostring(amount)));
        object.m_hp = object.m_hp + amount;

        if object.m_hp >= object.m_maxHp then
            object.m_hp = object.m_maxHp;
        end

        object.m_destroyed = object.m_hp <= 0;
    end

    object:bindMethod(self, "increaseHp", increaseHp);

    local function createView(object, batch, marksLayer, debugLayer)
        object.m_hpOutlineSprite = display.newSprite(string.format("#ObjectHpOutline.png"));
        batch:addChild(object.m_hpOutlineSprite, MapConstants.HP_BAR_ZORDER);

        if object:getCampId() == MapConstants.PLAYER_CAMP then
            object.m_hpSprite = display.newSprite("#FriendlyHp.png");
        else
            object.m_hpSprite = display.newSprite("#EnemyHp.png");
        end
        object.m_hpSprite:align(display.LEFT_CENTER, 0, 0);
        batch:addChild(object.m_hpSprite, MapConstants.HP_BAR_ZORDER + 1);
    end

    object:bindMethod(self, "createView", createView);

    local function removeView(object)
        object.m_hpOutlineSprite:removeSelf();
        object.m_hpOutlineSprite = nil;
        object.m_hpSprite:removeSelf();
        object.m_hpSprite = nil;
    end

    object:bindMethod(self, "removeView", removeView, true);

    local function updateView(object)
        object.hp__ = object.m_hp;
        if object.m_hp > 0 then
            local x, y = object.m_x, object.m_y;
            local radiusOffsetX, radiusOffsetY = object.m_radiusOffsetX, object.m_radiusOffsetY;
            local x2 = x + radiusOffsetX - object.m_hpSprite:getContentSize().width / 2;
            local y2 = y + radiusOffsetY + object.m_radius + MapConstants.HP_BAR_OFFSET_Y;
            object.m_hpSprite:setPosition(x2, y2);
            object.m_hpSprite:setScaleX(object.m_hp / object.m_maxHp);
            object.m_hpSprite:setVisible(true);
            object.m_hpOutlineSprite:setPosition(x + radiusOffsetX, y2);
            object.m_hpOutlineSprite:setVisible(true);
        else
            object.m_hpSprite:setVisible(false);
            object.m_hpOutlineSprite:setVisible(false);
        end
    end

    object:bindMethod(self, "updateView", updateView);

    local function fastUpdateView(object)
        if not object.updated__ and object.hp__ == object.m_hp then 
            return; 
        end

        updateView(object);
    end

    object:bindMethod(self, "fastUpdateView", fastUpdateView);
    self:reset(object);
end

function DestroyedBehavior:unbind(object)
    object.m_hitOffsetX = nil;
    object.m_hitOffsetY = nil;
    object.m_maxHp = nil;
    object.m_destroyed = nil;
    object.m_hp = nil;

    object:unbindMethod(self, "isDestroyed");
    object:unbindMethod(self, "setDestroyed");
    object:unbindMethod(self, "getMaxHp");
    object:unbindMethod(self, "setMaxHp");
    object:unbindMethod(self, "getHp");
    object:unbindMethod(self, "setHp");
    object:unbindMethod(self, "decreaseHp");
    object:unbindMethod(self, "increaseHp");
    object:unbindMethod(self, "createView");
    object:unbindMethod(self, "removeView");
    object:unbindMethod(self, "updateView");
    object:unbindMethod(self, "fastUpdateView");
end

function DestroyedBehavior:reset(object)
    object.m_hitOffsetX = checkint(object.m_state.hitOffsetX);
    object.m_hitOffsetY = checkint(object.m_state.hitOffsetY);
    object.m_maxHp = checkint(object.m_state.maxHp);

    if object.m_maxHp < 1 then 
        object.m_maxHp = 1;
    end

    object.m_hp = object.m_maxHp;
    object.m_destroyed = object.m_hp <= 0;
    object.hp__ = nil;
end

return DestroyedBehavior;
