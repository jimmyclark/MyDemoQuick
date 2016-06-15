local EditorConstants = require("app.map.EditorConstant");
local BehaviorBase = require("app.behaviors.BehaviorBase");

local PathEditorBehavior = class("PathEditorBehavior", BehaviorBase);

PathEditorBehavior.SELECTED_COLOR = {255, 255, 0, 255};
PathEditorBehavior.UNSELECTED_COLOR = {0, 0, 0, 255};

function PathEditorBehavior:ctor()
    PathEditorBehavior.super.ctor(self, "PathEditorBehavior", nil, 0);
end

function PathEditorBehavior:bind(object)
    object.m_isSelected  = false
    object.m_groupName   = object.m_state.m_groupName;

    if type(object.m_groupName) ~= "string" then
        object.m_groupName = "default";
    end

    object.m_flagsSprite = {};

    local function isSelected(object)
        return object.m_isSelected;
    end

    object:bindMethod(self, "isSelected", isSelected);

    local function setSelected(object, isSelected)
        object.m_isSelected = isSelected;
    end

    object:bindMethod(self, "setSelected", setSelected);

    local function getGroupName(object)
        return object.m_groupName;
    end

    object:bindMethod(self, "getGroupName", getGroupName);

    local function setGroupName(object, groupName)
        object.m_groupName = tostring(groupName);
    end

    object:bindMethod(self, "setGroupName", setGroupName);

    local function isViewCreated(object)
        return object.m_idLabel ~= nil
    end
    object:bindMethod(self, "isViewCreated", isViewCreated)

    local function createView(object, batch, marksLayer, debugLayer)
        object.m_idLabel = cc.ui.UILabel.new({
            text  = object:getId(),
            font  = EditorConstants.LABEL_FONT,
            size  = EditorConstants.LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_CENTER,
        })
        :align(display.CENTER)
        debugLayer:addChild(object.m_idLabel, EditorConstants.LABEL_ZORDER);
    end

    object:bindMethod(self, "createView", createView);

    local function removeView(object)
        object.m_idLabel:removeSelf();
        object.m_idLabel = nil;

        object.m_polygon:removeSelf();
        object.m_polygon = nil;

        for i, flag in ipairs(object.m_flagsSprite) do
            flag:removeSelf();
        end
        object.m_flagsSprite = nil;
    end
    object:bindMethod(self, "removeView", removeView, true)

    local function updateView(object)
        if object.m_polygon then
            object.m_polygon:removeSelf();
            object.m_polygon = nil;
        end

        if #object.m_points < 1 then 
            return;
        end

        object.m_polygon = utils.drawPolygon(object.m_points);
        -- object.m_polygon:setLineStipple(checknumber("0101010101010101", 2))
        -- object.m_polygon:setLineStippleEnabled(true)
        object.m_debugLayer:addChild(object.m_polygon, EditorConstants.m_POLYGONZORDER);

        if object.m_isSelected then
            object.m_polygon:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(PathEditorBehavior.SELECTED_COLOR))));
            object.m_idLabel:setColor(cc.c3b(unpack(EditorConstants.SELECTED_LABEL_COLOR)));
            -- object.m_polygon:setLineStippleEnabled(false)
        else
            object.m_polygon:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(PathEditorBehavior.UNSELECTED_COLOR))));
            object.m_idLabel:setColor(cc.c3b(unpack(EditorConstants.UNSELECTED_LABEL_COLOR)));
            -- object.m_polygon:setLineStippleEnabled(true)
        end

        local scale = object.m_debugLayer:getScale();

        if scale > 1 then 
            scale = 1 / scale;
        end

        for index, point in ipairs(object.m_points) do
            local x, y = unpack(point);

            if index == 1 then
                object.m_idLabel:setPosition(x, y - 10 - EditorConstants.LABEL_OFFSET_Y);
                object.m_idLabel:setScale(scale);
                object.m_x, object.m_y = x, y;
            end

            if not object.m_flagsSprite then 
                object.m_flagsSprite = {};
            end

            local flag = object.m_flagsSprite[index];

            if not flag then
                flag = display.newSprite("#PointFlag.png");
                object.m_debugLayer:addChild(flag, EditorConstants.FLAG_ZORDER);
                object.m_flagsSprite[index] = flag;
            end

            flag:setPosition(x, y);
            flag:setScale(scale);
        end

        for index = #object.m_points + 1, #object.m_flagsSprite do
            object.m_flagsSprite[index]:removeSelf();
            object.m_flagsSprite[index] = nil;
        end
    end

    object:bindMethod(self, "updateView", updateView);
end

function PathEditorBehavior:unbind(object)
    object.m_isSelected = nil;
    object.m_groupName = nil;
    object.m_flagsSprite = nil;

    object:unbindMethod(self, "isSelected");
    object:unbindMethod(self, "setSelected");
    object:unbindMethod(self, "getGroupName");
    object:unbindMethod(self, "setGroupName");
    object:unbindMethod(self, "isViewCreated");
    object:unbindMethod(self, "createView");
    object:unbindMethod(self, "removeView");
    object:unbindMethod(self, "updateView");
end

return PathEditorBehavior;
