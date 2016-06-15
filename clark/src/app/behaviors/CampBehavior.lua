local MapConstants = require("app.map.MapConstants");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local CampBehavior = class("CampBehavior", BehaviorBase);

function CampBehavior:ctor()
    CampBehavior.super.ctor(self, "CampBehavior", nil, 1);
end

function CampBehavior:bind(object)
    object.m_campId = checkint(object.state_.campId);
    if object.m_campId ~= MapConstants.ENEMY_CAMP and object.m_campId ~= MapConstants.PLAYER_CAMP then
        object.m_campId = MapConstants.ENEMY_CAMP;
    end

    local function getCampId(object)
        return object.m_campId;
    end

    object:bindMethod(self, "getCampId", getCampId);

    local function vardump(object, state)
        state.campId = object.m_campId;
        return state;
    end

    object:bindMethod(self, "vardump", vardump);
end

function CampBehavior:unbind(object)
    object.m_campId = nil;
    object:unbindMethod(self, "getCampId");
    object:unbindMethod(self, "vardump");
end

return CampBehavior
