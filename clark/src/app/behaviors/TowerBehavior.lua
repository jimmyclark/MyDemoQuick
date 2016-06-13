local TowerProperties = require("app.properties.TowerProperties");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local TowerBehavior = class("TowerBehavior", BehaviorBase);

function TowerBehavior:ctor()
    local depends = {
        "DestroyedBehavior",
        "FireBehavior",
        "DecorateBehavior",
    };
    TowerBehavior.super.ctor(self, "TowerBehavior", depends, 100);
end

function TowerBehavior:bind(object)
    object.m_towerId = object.m_state.towerId;
    if type(object.m_towerId) ~= "string" then 
        object.m_towerId = "";
    end

    local function getTowerId(object)
        return object.m_towerId;
    end

    object:bindMethod(self, "getTowerId", getTowerId);

    local function setTowerId(object, towerId)
        object.m_towerId = towerId;

        local define = TowerProperties.get(object.m_towerId);

        if not define then
            object.m_towerId = object.m_defineId .. "L01";
            define = TowerProperties.get(object.m_towerId);
        end

        if define then
            for k, v in pairs(define) do
                local kn = "m_" .. k;
                object[kn] = v;
                object.m_state[k] = v;
            end
        end

        if object.m_staticIndex then
            local index = object.m_staticIndex;

            if type(object.m_state.offsetX) == "table" then
                object.m_offsetX = object.m_state.offsetX[index];
            end

            if type(object.m_state.offsetY) == "table" then
                object.m_offsetY = object.m_state.offsetY[index];
            end

            if type(object.m_state.radiusOffsetX) == "table" then
                object.m_radiusOffsetX = object.m_state.radiusOffsetX[index];
            end

            if type(object.m_state.radiusOffsetY) == "table" then
                object.m_radiusOffsetY = object.m_state.radiusOffsetY[index];
            end

            if type(object.m_state.radius) == "table" then
                object.m_radius = object.m_state.radius[index];
            end

            if type(object.m_state.imageName)  == "table" then
                object.m_imageName = object.m_state.imageName[index];
            end

            if type(object.m_state.fireOffsetX) == "table" then
                object.m_fireOffsetX = object.m_state.fireOffsetX[index];
            end

            if type(object.m_state.fireOffsetY) == "table" then
                object.m_fireOffsetY = object.m_state.fireOffsetY[index];
            end
        end
    end

    object:bindMethod(self, "setTowerId", setTowerId);

    local function showDestroyedStatus(object, skipAnim)
        object:getView():setVisible(false);
        object:getDecoration(object.m_defineId .. "Destroyed"):getView():setVisible(true);

        local decorationName = object:getDefineId() .. "Fire";

        if object:isDecorationExists(decorationName) then
            local decoration = object:getDecoration(decorationName);
            decoration:setVisible(false);
        end

        local decorationName = object:getDefineId() .. "Fire2";

        if object:isDecorationExists(decorationName) then
            local decoration = object:getDecoration(decorationName);
            decoration:setVisible(false);
        end
    end

    object:bindMethod(self, "showDestroyedStatus", showDestroyedStatus);

    local function hideDestroyedStatus(object, skipAnim)
        object:getView():setVisible(true);
        object:getDecoration(object.m_defineId .. "Destroyed"):getView():setVisible(false);
    end

    object:bindMethod(self, "hideDestroyedStatus", hideDestroyedStatus);

    local function vardump(object, state)
        state.towerId = object.m_towerId;
        return state;
    end

    object:bindMethod(self, "vardump", vardump);
end

function TowerBehavior:unbind(object)
    object.m_towerId = nil;

    object:unbindMethod(self, "getTowerId");
    object:unbindMethod(self, "setTowerId");
    object:unbindMethod(self, "showDestroyedStatus");
    object:unbindMethod(self, "hideDestroyedStatus");
    object:unbindMethod(self, "vardump");
end

function TowerBehavior:reset(object)
    object:setTowerId(object:getTowerId());
end

return TowerBehavior;
