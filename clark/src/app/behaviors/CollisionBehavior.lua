local BehaviorBase = require("app.behaviors.BehaviorBase");

local CollisionBehavior = class("CollisionBehavior", BehaviorBase);

function CollisionBehavior:ctor()
    CollisionBehavior.super.ctor(self, "CollisionBehavior", nil, 1);
end

function CollisionBehavior:bind(object)
    object.collisionLock = 0;
    object.collisionEnabled = object.state.collisionEnabled;
    if type(object.collisionEnabled) ~= "boolean" then
        object.collisionEnabled = true;
    end

    local function isCollisionEnabled(object)
        return object.collisionEnabled;
    end

    object:bindMethod(self, "isCollisionEnabled", isCollisionEnabled);

    local function setCollisionEnabled(object, enabled)
        object.collisionEnabled = enabled;
    end

    object:bindMethod(self, "setCollisionEnabled", setCollisionEnabled);

    local function addCollisionLock(object)
        object.collisionLock = object.collisionLock + 1;
    end

    object:bindMethod(self, "addCollisionLock", addCollisionLock);

    local function removeCollisionLock(object)
        object.collisionLock = object.collisionLock - 1;
        assert(object.collisionLock >= 0,
               "CollisionBehavior.removeCollisionLock() - object.collisionLock_ must >= 0");
    end
    object:bindMethod(self, "removeCollisionLock", removeCollisionLock);

    local function vardump(object, state)
        state.collisionEnabled = object.collisionEnabled;
        return state;
    end
    object:bindMethod(self, "vardump", vardump);
end

function CollisionBehavior:unbind(object)
    object.collisionEnabled = nil;
    object:unbindMethod(self, "isCollisionEnabled");
    object:unbindMethod(self, "setCollisionEnabled");
    object:unbindMethod(self, "addCollisionLock");
    object:unbindMethod(self, "removeCollisionLock");
    object:unbindMethod(self, "vardump");
end

return CollisionBehavior;
