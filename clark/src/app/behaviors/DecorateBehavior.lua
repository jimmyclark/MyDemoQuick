local MapConstants = require("app.map.MapConstant");
local Decoration = require("app.map.Decoration");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local DecorateBehavior = class("DecorateBehavior", BehaviorBase);

function DecorateBehavior:ctor()
    DecorateBehavior.super.ctor(self, "DecorateBehavior", nil, 1);
end

function DecorateBehavior:bind(object)
    object.m_decorations = {};
    for i,k in ipairs(checktable(object.m_state.decorations)) do
        object.m_decorations[k] = false;
    end

    object.m_decorationsMore = {};
    for i,k in ipairs(checktable(object.m_state.decorationsMore)) do
        object.m_decorationsMore[k] = false;
    end

    local function isDecorationExists(object, decorationName)
        return object.m_decorations[decorationName] ~= nil;
    end

    object:bindMethod(self, "isDecorationExists", isDecorationExists);

    local function getDecoration(object, decorationName)
        return object.m_decorations[decorationName];
    end

    object:bindMethod(self, "getDecoration", getDecoration);

    local function updateView(object)
        local objectZOrder = object:getView():getLocalZOrder();
        local batch        = object.m_batch;
        local x, y         = object.m_x, object.m_y;
        local flip         = object.m_flipSprite;

        local function updateView(source)
            if not source then 
                return;
            end

            for decorationName, decoration in pairs(source) do
                if not decoration then
                    decoration = Decoration.new(decorationName, object.staticIndex);
                    source[decorationName] = decoration;
                    decoration:createView(batch);
                end

                local view = decoration:getView();
                batch:reorderChild(view, objectZOrder + decoration.m_zorder);
                view:setPosition(x + decoration.m_offsetX, y + decoration.m_offsetY);
                view:setFlippedX(flip);
            end
        end

        updateView(object.m_decorations);
        updateView(object.m_decorationsMore);
    end

    object:bindMethod(self, "updateView", updateView);

    local function fastUpdateView(source, x, y, objectZOrder, batch)
        if not source then 
            return;
        end

        for decorationName, decoration in pairs(source) do
            local view = decoration:getView();
            batch:reorderChild(view, objectZOrder + decoration.m_zorder);
            view:setPosition(x + decoration.m_offsetX, y + decoration.m_offsetY);
            view:setFlippedX(flip);
        end
    end

    local function fastUpdateView(object)
        if not object.m_updated then 
            return;
        end

        local objectZOrder = object:getView():getLocalZOrder();
        local batch = object.m_batch;
        local x, y  = object.m_x, object.m_y;
        local flip = object.m_flipSprite;

        fastUpdateView(object.m_decorations, x, y, objectZOrder, batch, flip);
        fastUpdateView(object.m_decorationsMore, x, y, objectZOrder, batch, flip);
    end

    object:bindMethod(self, "fastUpdateView", fastUpdateView);

    local function removeView(object)
        local function removeView(source)
            if not source then 
                return;
            end
            for decorationName, decoration in pairs(source) do
                if decoration then 
                    decoration:removeView();
                end
                
                source[decorationName] = false;
            end
        end
        removeView(object.m_decorations);
        removeView(object.m_decorationsMore);
    end

    object:bindMethod(self, "removeView", removeView);

    local function setVisible(object, visible)
        for decorationName, decoration in pairs(object.m_decorations) do
            if decoration then
                local view = decoration:getView();
                view:setVisible(decoration.m_visible and visible);
            end
        end
    end

    object:bindMethod(self, "setVisible", setVisible);

    local function fadeTo(object, opacity, time)
        transition.fadeTo(object:getView(), {opacity = opacity, time = time});
        for decorationName, decoration in pairs(object.m_decorations) do
            if decoration then
                local view = decoration:getView();
                if view:isVisible() then
                    transition.fadeTo(view, {opacity = opacity, time = time});
                end
            end
        end
    end

    object:bindMethod(self, "fadeTo", fadeTo);

    local function vardump(object, state)
        if object.m_decorationsMore then
            state.decorationsMore = table.keys(object.m_decorationsMore);
        end
        return state;
    end

    object:bindMethod(self, "vardump", vardump);
end

function DecorateBehavior:unbind(object)
    object.m_decorations = nil;

    object:unbindMethod(self, "isDecorationExists");
    object:unbindMethod(self, "getDecoration");
    object:unbindMethod(self, "updateView");
    object:unbindMethod(self, "fastUpdateView");
    object:unbindMethod(self, "removeView");
    object:unbindMethod(self, "setVisible");
    object:unbindMethod(self, "fadeTo");
    object:unbindMethod(self, "vardump");
end

return DecorateBehavior;
