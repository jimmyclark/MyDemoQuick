local math2d = require("app.math2d");
local MapConstants    = require("app.map.MapConstants");
local EditorConstants = require("app.map.EditorConstant");

local BehaviorBase = require("app.behaviors.BehaviorBase");

local StaticObjectEditorBehavior = class("StaticObjectEditorBehavior", BehaviorBase);

StaticObjectEditorBehavior.FIRE_CIRCLE_SELECTED_COLOR = {0, 0, 0, 255};
StaticObjectEditorBehavior.FIRE_CIRCLE_UNSELECTED_COLOR = {90, 0, 0, 180};

function StaticObjectEditorBehavior:ctor()
    StaticObjectEditorBehavior.super.ctor(self, "StaticObjectEditorBehavior", nil, 0);
end

function StaticObjectEditorBehavior:bind(object)
    object.m_isSelected = false;

    local function isSelected(object)
        return object.m_isSelected;
    end

    object:bindMethod(self, "isSelected", isSelected);

    local function setSelected(object, isSelected)
        object.m_isSelected = isSelected;
    end

    object:bindMethod(self, "setSelected", setSelected);

    local function checkPointIn(object, x, y)
        return math2d.dist(x,
                           y,
                           object.m_x + object.m_radiusOffsetX,
                           object.m_y + object.m_radiusOffsetY) <= object.m_radius;
    end

    object:bindMethod(self, "checkPointIn", checkPointIn);

    local function createView(object, batch, marksLayer, debugLayer)
        object.m_idLabel = cc.ui.UILabel.new({
            text  = object:getId(),
            font  = EditorConstants.LABEL_FONT,
            size  = EditorConstants.LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_CENTER,
        })
        :align(display.CENTER);
        object.m_idLabel.offsetY = math.floor(-object.m_radius - EditorConstants.LABEL_OFFSET_Y);
        debugLayer:addChild(object.m_idLabel, EditorConstants.LABEL_ZORDER);

        object.m_radiusCircle = utils.drawCircle(object.m_radius);
        -- object.m_radiusCircle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(EditorConstants.UNSELECTED_COLOR))))
        -- object.m_radiusCircle:setLineStipple(checknumber("1111000011110000", 2))
        -- object.m_radiusCircle:setLineStippleEnabled(true)
        debugLayer:addChild(object.m_radiusCircle, EditorConstants.CIRCLE_ZORDER);

        object.m_flagSprite = display.newSprite("#CenterFlag.png");
        debugLayer:addChild(object.m_flagSprite, EditorConstants.FLAG_ZORDER);

        if object:hasBehavior("FireBehavior") then
            object.m_fireRangeCircle = utils.drawCircle(object.m_fireRange);
            -- object.m_fireRangeCircle:setScaleY(MapConstants.RADIUS_CIRCLE_SCALE_Y);
            -- object.m_fireRangeCircle:setLineStipple(checknumber("1111000011110000", 2));
            -- object.m_fireRangeCircle:setLineStippleEnabled(true);
            debugLayer:addChild(object.m_fireRangeCircle);
        end

        if object:hasBehavior("UpgradableBehavior") then
            object.m_levelLabel = cc.ui.UILabel.new({
                text = "00",
                font  = MapConstants.LEVEL_LABEL_FONT,
                size  = MapConstants.LEVEL_LABEL_FONT_SIZE,
                align = cc.ui.TEXT_ALIGN_CENTER,
            })
            :align(display.CENTER);
            debugLayer:addChild(object.m_levelLabel);
        end

        if object:hasBehavior("PlayerBehavior") then
            object.m_playerIdLabel = cc.ui.UILabel.new({
                text         = "Player",
                size         = 24,
                color        = cc.c3b(255, 255, 255),
                align        = cc.ui.TEXT_ALIGN_CENTER,
            })
            :align(display.CENTER);
            object.m_playerIdLabel:enableOutline(cc.c4b(10, 115, 107, 255), 2);
            debugLayer:addChild(object.m_playerIdLabel);
        end
    end

    object:bindMethod(self, "createView", createView);

    local function removeView(object)
        object.m_idLabel:removeSelf();
        object.m_idLabel = nil;

        object.m_radiusCircle:removeSelf()
        object.m_radiusCircle = nil

        object.m_flagSprite:removeSelf();
        object.m_flagSprite = nil;

        if object.m_fireRangeCircle then
            object.m_fireRangeCircle:removeSelf();
            object.m_fireRangeCircle = nil;
        end

        if object.m_bindingFlagSprite then
            object.m_bindingFlagSprite:removeSelf();
            object.m_bindingFlagSprite = nil;
        end

        if object.m_bindingMovingForwardFlagSprite then
            object.m_bindingMovingForwardFlagSprite:removeSelf();
            object.m_bindingMovingForwardFlagSprite = nil;
        end

        if object.m_levelLabel then
            object.m_levelLabel:removeSelf();
            object.m_levelLabel = nil;
        end

        if object.m_playerIdLabel then
            object.m_playerIdLabel:removeSelf();
            object.m_playerIdLabel = nil;
        end
    end

    object:bindMethod(self, "removeView", removeView);

    local function updateView(object)
        if not object.m_debugLayer then
            return;
        end
        
        local x, y = math.floor(object.m_x), math.floor(object.m_y);

        local scale = object.m_debugLayer:getScale();

        if scale > 1 then
            scale = 1 / scale;
        end

        local idString = {object:getId(), "/"};
        if object:hasBehavior("NPCBehavior") then
            idString[#idString + 1] = object:getNPCId();
        elseif object:hasBehavior("TowerBehavior") then
            idString[#idString + 1] = object:getTowerId();
        elseif object:hasBehavior("BuildingBehavior") then
            idString[#idString + 1] = object:getBuildingId();
        elseif object:hasBehavior("PlayerBehavior") then
            idString[#idString + 1] = object:getPlayerTestId();
        end

        idString = table.concat(idString);
        object.m_idLabel:setString(idString);
        object.m_idLabel:setPosition(x, y + object.m_idLabel.offsetY + object.m_radiusOffsetY);
        object.m_idLabel:setScale(scale);

        object.m_radiusCircle:setPosition(x + object.m_radiusOffsetX, y + object.m_radiusOffsetY);

        object.m_flagSprite:setPosition(x, y);

        if object.m_isSelected then
            object.m_idLabel:setColor(cc.c3b(unpack(EditorConstants.SELECTED_LABEL_COLOR)));
            object.m_radiusCircle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(EditorConstants.SELECTED_COLOR))));
        else
            object.m_idLabel:setColor(cc.c3b(unpack(EditorConstants.UNSELECTED_LABEL_COLOR)));
            object.m_radiusCircle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(EditorConstants.UNSELECTED_COLOR))));
        end

        object.m_flagSprite:setScale(scale);

        if object:hasBehavior("CollisionBehavior") then
            -- if object:isCollisionEnabled() then
            --     object.m_radiusCircle:setLineStippleEnabled(false)
            -- else
            --     object.m_radiusCircle:setLineStippleEnabled(true)
            -- end
        end

        if object:hasBehavior("FireBehavior") then
            local circle = object.m_fireRangeCircle;
            circle:setPosition(x + object.m_radiusOffsetX, y + object.m_radiusOffsetY);

            if object.m_isSelected then
                circle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(StaticObjectEditorBehavior.FIRE_CIRCLE_SELECTED_COLOR))));
                -- object.m_fireRangeCircle:setLineStippleEnabled(false);
            else
                circle:setLineColor(cc.c4fFromc4b(cc.c4b(unpack(StaticObjectEditorBehavior.FIRE_CIRCLE_UNSELECTED_COLOR))));
                -- object.m_fireRangeCircle:setLineStippleEnabled(true);
            end
        end

        if object:hasBehavior("UpgradableBehavior") then
            object.m_levelLabel:setString(tostring(object.m_level));
            local x2 = x + object.m_radiusOffsetX;
            local y2 = y + object.m_radiusOffsetY + object.m_radius + MapConstants.LEVEL_LABEL_OFFSET_Y;
            object.m_levelLabel:setPosition(x2, y2);
        end

        if object:hasBehavior("MovableBehavior") then
            if object.m_bindingFlagSprite then
                object.m_bindingFlagSprite:removeSelf();
            end
            
            if object:isBinding() then
                object.m_bindingFlagSprite = display.newSprite("#ObjectBindingEnabled.png");
            else
                object.m_bindingFlagSprite = display.newSprite("#ObjectBindingDisabled.png");
            end

            object.m_bindingFlagSprite:setPosition(x + 20, y + 20);
            object.m_bindingFlagSprite:setScale(scale);
            object.m_debugLayer:addChild(object.m_bindingFlagSprite, EditorConstants.FLAG_ZORDER);

            if object.m_bindingMovingForwardFlagSprite then
                object.m_bindingMovingForwardFlagSprite:removeSelf();
            end

            if object:isMovingForward() then
                object.m_bindingMovingForwardFlagSprite = display.newSprite("#ObjectMovingForwardFlag.png");
            else
                object.m_bindingMovingForwardFlagSprite = display.newSprite("#ObjectMovingBackwardFlag.png");
            end

            object.m_bindingMovingForwardFlagSprite:setPosition(x - 20, y + 20);
            object.m_bindingMovingForwardFlagSprite:setScale(scale);
            object.m_debugLayer:addChild(object.m_bindingMovingForwardFlagSprite, EditorConstants.FLAG_ZORDER);
        end

        if object:hasBehavior("PlayerBehavior") then
            local label = object.m_playerIdLabel;
            local x = math.floor(object.m_x + object.m_radiusOffsetX);
            local y = math.floor(object.m_y + object.m_radiusOffsetY + object.m_radius + 36);
            label:setPosition(x, y);
            label:setScale(scale);
        end
    end

    object:bindMethod(self, "updateView", updateView);

    local function fastUpdateView(object)
        if object.m_debugViewEnabled then
            updateView(object);
        end
    end

    object:bindMethod(self, "fastUpdateView", fastUpdateView);
end

function StaticObjectEditorBehavior:unbind(object)
    object.m_isSelected = nil;

    object:unbindMethod(self, "isSelected");
    object:unbindMethod(self, "setSelected");
    object:unbindMethod(self, "checkPointIn");
    object:unbindMethod(self, "createView");
    object:unbindMethod(self, "removeView");
    object:unbindMethod(self, "updateView");
    object:unbindMethod(self, "fastUpdateView");
end

return StaticObjectEditorBehavior;
