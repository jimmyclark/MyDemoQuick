local math2d = require("math2d");
local EditorConstants = require("app.map.EditorConstant");

local BehaviorBase = require("app.behaviors.BehaviorBase");

local RangeEditorBehavior = class("RangeEditorBehavior", BehaviorBase);

RangeEditorBehavior.SELECTED_COLOR          = {0, 0, 255, 255};
RangeEditorBehavior.SELECTED_LABEL_COLOR    = {0, 0, 255};
RangeEditorBehavior.UNSELECTED_COLOR        = {150, 90, 150, 255};
RangeEditorBehavior.UNSELECTED_LABEL_COLOR  = {120, 30, 120};

function RangeEditorBehavior:ctor()
    RangeEditorBehavior.super.ctor(self, "RangeEditorBehavior", nil, 0);
end

function RangeEditorBehavior:bind(object)
    object.m_isSelected  = false;

    local function isSelected(object)
        return object.m_isSelected;
    end

    object:bindMethod(self, "isSelected", isSelected);

    local function setSelected(object, isSelected)
        object.m_isSelected = isSelected;
    end

    object:bindMethod(self, "setSelected", setSelected);

    local function isViewCreated(object)
        return object.m_idLabel ~= nil;
    end

    object:bindMethod(self, "isViewCreated", isViewCreated);

    local function createView(object, batch, marksLayer, debugLayer)
        object.m_idLabel = cc.ui.UILabel.new({
            text  = object:getId(),
            font  = EditorConstants.LABEL_FONT,
            size  = EditorConstants.LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_CENTER,
        })
        :align(display.CENTER);
        debugLayer:addChild(object.m_idLabel, EditorConstants.LABEL_ZORDER);

        object.m_radiusCircle = utils.drawCircle(object.m_radius);
        debugLayer:addChild(object.m_radiusCircle, EditorConstants.CIRCLE_ZORDER);

        object.m_flagSprite = display.newSprite("#RangeFlag.png");
        debugLayer:addChild(object.m_flagSprite, EditorConstants.FLAG_ZORDER);

        object.m_handler = display.newSprite("#RangeHandler.png");
        object.m_handler:setVisible(false);
        debugLayer:addChild(object.m_handler, EditorConstants.RANGE_HANDLER_ZORDER);
    end

    object:bindMethod(self, "createView", createView);

    local function removeView(object)
        object.m_idLabel:removeSelf();
        object.m_idLabel = nil;

        object.m_radiusCircle:removeSelf();
        object.m_radiusCircle = nil;

        object.m_flagSprite:removeSelf();
        object.m_flagSprite = nil;

        object.m_handler:removeSelf();
        object.m_handler = nil;
    end

    object:bindMethod(self, "removeView", removeView, true);

    local function updateView(object)
        local scale = object.m_debugLayer:getScale();

        if scale > 1 then 
            scale = 1 / scale; 
        end

        local x, y = math.floor(object.m_x), math.floor(object.m_y);
        object.m_idLabel:setPosition(x, y - EditorConstants.LABEL_FONT_SIZE - 10);
        object.m_idLabel:setScale(scale);

        object.m_radiusCircle:setPosition(x, y);
        object.m_radiusCircle:setRadius(object.m_radius);
        object.m_flagSprite:setPosition(x, y);
        object.m_flagSprite:setScale(scale);

        object.m_handler:setPosition(x + object.m_radius, y);
        object.m_handler:setVisible(object.m_isSelected);
        object.m_handler:setScale(scale);

        if object.m_isSelected then
            object.m_idLabel:setColor(cc.c3b(unpack(RangeEditorBehavior.SELECTED_LABEL_COLOR)));
            object.m_radiusCircle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(RangeEditorBehavior.SELECTED_COLOR))));
        else
            object.m_idLabel:setColor(cc.c3b(unpack(RangeEditorBehavior.UNSELECTED_LABEL_COLOR)));
            object.m_radiusCircle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(RangeEditorBehavior.UNSELECTED_COLOR))));
        end
    end

    object:bindMethod(self, "updateView", updateView);

    local function checkPointIn(object, x, y)
        return math2d.dist(x, y, object.m_x, object.m_y) <= object.m_radius;
    end

    object:bindMethod(self, "checkPointIn", checkPointIn);

    local function checkPointInHandler(object, x, y)
        local hx, hy = object.m_x, object.m_y;
        hx = hx + object.m_radius;
        return math2d.dist(x, y, hx, hy) <= EditorConstants.CHECK_POINT_DIST;
    end

    object:bindMethod(self, "checkPointInHandler", checkPointInHandler);
end

function RangeEditorBehavior:unbind(object)
    object.m_isSelected = nil;

    object:unbindMethod(self, "isSelected");
    object:unbindMethod(self, "setSelected");
    object:unbindMethod(self, "isViewCreated");
    object:unbindMethod(self, "createView");
    object:unbindMethod(self, "removeView");
    object:unbindMethod(self, "updateView");
    object:unbindMethod(self, "checkPointIn");
    object:unbindMethod(self, "checkPointInHandler");
end

return RangeEditorBehavior;
