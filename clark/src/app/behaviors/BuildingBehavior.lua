local BuildingProperties = require("app.properties.BuildingProperties");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local BuildingBehavior = class("BuildingBehavior", BehaviorBase);

function BuildingBehavior:ctor()
    local depends = {
        "DestroyedBehavior",
        "CollisionBehavior",
        "DecorateBehavior",
    }
    BuildingBehavior.super.ctor(self, "BuildingBehavior", depends, 100);
end

function BuildingBehavior:bind(object)
    object.m_buildingId = object.m_state.buildingId;
    if type(object.m_buildingId) ~= "string" then 
        object.m_buildingId = "";
    end

    local function getBuildingId(object)
        return object.m_buildingId;
    end

    object:bindMethod(self, "getBuildingId", getBuildingId);

    local function setBuildingId(object, buildingId)
        object.m_buildingId = buildingId;

        local define = BuildingProperties.get(object.m_buildingId);
        
        if not define then
            if object.m_campId == 1 then
                object.m_buildingId = "BuildingP001";
            else
                object.m_buildingId = "BuildingN001";
            end

            define = BuildingProperties.get(object.m_buildingId);
        end
        for k, v in pairs(define) do
            local kn = "m_" .. k;
            object[kn] = v;
            object.m_state[k] = v;
        end
    end

    object:bindMethod(self, "setBuildingId", setBuildingId);

    local function showDestroyedStatus(object, skipAnim)
        object:getView():setVisible(false);
        object:getDecoration(object.m_defineId .. "Destroyed"):getView():setVisible(true);
    end

    object:bindMethod(self, "showDestroyedStatus", showDestroyedStatus);

    local function vardump(object, state)
        state.buildingId = object.m_buildingId;
        return state;
    end

    object:bindMethod(self, "vardump", vardump);
end

function BuildingBehavior:unbind(object)
    object.m_buildingId = nil;
    object:unbindMethod(self, "getBuildingId");
    object:unbindMethod(self, "setBuildingId");
    object:unbindMethod(self, "showDestroyedStatus");
    object:unbindMethod(self, "vardump");
end

function BuildingBehavior:reset(object)
    object:setBuildingId(object:getBuildingId());
end

return BuildingBehavior;
