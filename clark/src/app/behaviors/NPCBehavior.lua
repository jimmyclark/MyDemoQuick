local NPCProperties = require("app.properties.NPCProperties");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local NPCBehavior = class("NPCBehavior", BehaviorBase);

function NPCBehavior:ctor()
    local depends = {
        "DestroyedBehavior",
        "FireBehavior",
        "MovableBehavior",
        "DecorateBehavior",
    };

    NPCBehavior.super.ctor(self, "NPCBehavior", depends, 100);
end

function NPCBehavior:bind(object)
    object.m_npcId = object.m_state.npcId;
    
    if type(object.m_npcId) ~= "string" then 
        object.m_npcId = ""; 
    end

    local function getNPCId(object)
        return object.m_npcId;
    end

    object:bindMethod(self, "getNPCId", getNPCId);

    local function setNPCId(object, npcId)
        object.m_npcId = npcId;

        local define = NPCProperties.get(object.m_npcId);

        if not define then
            object.m_npcId = "NPC001";
            define = NPCProperties.get(object.m_npcId);
        end

        for k, v in pairs(define) do
            local kn = "m_" .. k;
            object[kn] = v;
            object.m_state[k] = v;
        end
    end

    object:bindMethod(self, "setNPCId", setNPCId);

    local function showDestroyedStatus(object, skipAnim)
        local shipWavesUp = object:getDecoration("ShipWavesUp");
        local shipWaves = object:getDecoration("ShipWaves");

        if skipAnim then
            object:getView():setVisible(false);
            shipWavesUp:setVisible(false);
            shipWaves:setVisible(false);
        else
            transition.fadeOut(object:getView(), {time = 1.0});
            transition.stopTarget(shipWavesUp:getView());
            shipWavesUp:setVisible(false);
            transition.stopTarget(shipWaves:getView());
            shipWaves:setVisible(false);
        end
    end

    object:bindMethod(self, "showDestroyedStatus", showDestroyedStatus);

    local function showBornStatus(object)
        transition.fadeIn(object:getView(), {delay = 0.3, time = 0.5});
        transition.fadeIn(object:getDecoration("ShipWavesUp"):getView(), {delay = 0.3, time = 1.0});
        transition.fadeIn(object:getDecoration("ShipWaves"):getView(), {delay = 0.3, time = 1.0});
    end

    object:bindMethod(self, "showBornStatus", showBornStatus);

    local function vardump(object, state)
        state.npcId = object.m_npcId;
        return state;
    end

    object:bindMethod(self, "vardump", vardump);
end

function NPCBehavior:unbind(object)
    object.m_npcId = nil;

    object:unbindMethod(self, "getNPCId");
    object:unbindMethod(self, "setNPCId");
    object:unbindMethod(self, "showDestroyedStatus");
    object:unbindMethod(self, "showBornStatus");
    object:unbindMethod(self, "vardump");
end

function NPCBehavior:reset(object)
    object:setNPCId(object:getNPCId());
end

return NPCBehavior;
