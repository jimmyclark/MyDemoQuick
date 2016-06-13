local behaviorsClass = {
    CollisionBehavior          = require("app.behaviors.CollisionBehavior"),
    CampBehavior               = require("app.behaviors.CampBehavior"),
    DecorateBehavior           = require("app.behaviors.DecorateBehavior"),
    BuildingBehavior           = require("app.behaviors.BuildingBehavior"),
    FireBehavior               = require("app.behaviors.FireBehavior"),
    MovableBehavior            = require("app.behaviors.MovableBehavior"),
    DestroyedBehavior          = require("app.behaviors.DestroyedBehavior"),
    TowerBehavior              = require("app.behaviors.TowerBehavior"),
    NPCBehavior                = require("app.behaviors.NPCBehavior"),

    PathEditorBehavior         = require("app.behaviors.PathEditorBehavior"),
    RangeEditorBehavior        = require("app.behaviors.RangeEditorBehavior"),
    StaticObjectEditorBehavior = require("app.behaviors.StaticObjectEditorBehavior"),
}

local BehaviorFactory = {};

function BehaviorFactory.createBehavior(behaviorName)
    local class = behaviorsClass[behaviorName];
    assert(class ~= nil, string.format("BehaviorFactory.createBehavior() - Invalid behavior name \"%s\"", tostring(behaviorName)));
    return class.new();
end

local allStaticObjectBehaviors = {
    BuildingBehavior  = true,
    CampBehavior      = true,
    CollisionBehavior = true,
    DecorateBehavior  = true,
    DestroyedBehavior = true,
    FireBehavior      = true,
    MovableBehavior   = true,
    NPCBehavior       = true,
    TowerBehavior     = true,
};

function BehaviorFactory.getAllStaticObjectBehaviorsName()
    return table.keys(allStaticObjectBehaviors);
end

function BehaviorFactory.isStaticObjectBehavior(behaviorName)
    return allStaticObjectBehaviors[behaviorName];
end

return BehaviorFactory;
