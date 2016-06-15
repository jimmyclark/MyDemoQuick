local MapConstants    = require("app.map.MapConstants");
local BehaviorFactory = require("app.behaviors.BehaviorFactory");
local EditorConstants = require("app.map.EditorConstant");

local ObjectInspector = class("ObjectInspector");

ObjectInspector.EditButtonSize        = 16;

ObjectInspector.POSITION_LEFT_TOP     = "LEFT_TOP";
ObjectInspector.POSITION_RIGHT_TOP    = "RIGHT_TOP";
ObjectInspector.POSITION_LEFT_BOTTOM  = "LEFT_BOTTOM";
ObjectInspector.POSITION_RIGHT_BOTTOM = "RIGHT_BOTTOM";

ObjectInspector.ALL_POSITIONS = {
    ObjectInspector.POSITION_LEFT_TOP,
    ObjectInspector.POSITION_RIGHT_TOP,
    ObjectInspector.POSITION_RIGHT_BOTTOM,
    ObjectInspector.POSITION_LEFT_BOTTOM,
};

function ObjectInspector:ctor(map, scale, toolbarLines)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods();

    self.m_map = map;
    self.m_sprite = nil;
    self.m_bg = nil;
    self.m_size = {0, 0};
    self.m_position = ObjectInspector.POSITION_RIGHT_BOTTOM;
    self.m_behaviorsLabel = {};
    self.m_object = nil;
    self.m_editButtons = {};
    self.m_isVisible = true;
    self.m_scale = scale;
    self.m_toolbarLines = toolbarLines;

    if device.platform == "ios" or device.platform == "android" then
        self.m_position = ObjectInspector.POSITION_RIGHT_TOP;
    end
end

function ObjectInspector:checkPointIn(x, y)
    local worldPosition = self.m_sprite:convertToWorldSpace(cc.p(0, 0));
    local wx, wy = worldPosition.x, worldPosition.y;

    return x >= wx
            and x <= wx + self.m_size[1] * self.m_scale
            and y <= wy
            and y >= wy - self.m_size[2] * self.m_scale;
end

function ObjectInspector:onTouch(event, x, y)
    if event ~= "began" then 
        return false;
    end

    local worldPosition = self.m_sprite:convertToWorldSpace(cc.p(0, 0));
    local wx, wy = worldPosition.x, worldPosition.y;
    x = x - wx;
    y = y - wy;

    local width, height = unpack(self.m_size);
    width = width * self.m_scale;
    height = height * self.m_scale;
    local offset = EditorConstants.PANEL_BUTTON_OFFSET * self.m_scale;
    local size = EditorConstants.PANEL_BUTTON_SIZE * self.m_scale;

    if x >= offset and x <= offset + size and y <= -offset and y >= -offset - size then
        self.m_sprite:setVisible(false);
        self.m_isVisible = false;
        return false;

    elseif device.platform ~= "ios" and device.platform ~= "android" and x >= width - size - offset and x <= width - offset and y <= -offset and y >= -offset - size then
        
        for i, pos in ipairs(ObjectInspector.ALL_POSITIONS) do

            if self.m_position == pos then
                i = i + 1;

                if i > #ObjectInspector.ALL_POSITIONS then
                    i = 1;
                end

                self.m_position = ObjectInspector.ALL_POSITIONS[i];
                self:setPosition();
                break;
            end
        end

        return false;
    end

    local function updateObject(changeFunction)
        self.m_object:removeView();
        changeFunction();
        self.m_object:resetAllBehaviors();
        self.m_object:createView(self.m_map:getBatchLayer(),
                                self.m_map:getMarksLayer(),
                                self.m_map:getDebugLayer());
        self.m_object:updateView();
        self:setObject(self.m_object);

        self:dispatchEvent({name = "UPDATE_OBJECT", object = self.m_object});
    end

    for i, behavior in ipairs(BehaviorFactory.getAllStaticObjectBehaviorsName()) do
        local label = self.m_behaviorsLabel[i];
        local lx, ly = label.x * self.m_scale, label.y * self.m_scale;

        if x >= lx and x <= lx + label.width * self.m_scale and y <= ly and y >= ly - label.height * self.m_scale then
            if label.isLocked then 
                return false;
            end

            updateObject(function()
                if self.m_object:hasBehavior(behavior) then
                    self.m_object:unbindBehavior(behavior);
                    label.sprite:setOpacity(64);

                else
                    self.m_object:bindBehavior(behavior);
                    label.sprite:setOpacity(255);
                end

                self.m_object:validate();
            end)

            return false;
        end
    end

    local bsize = ObjectInspector.EditButtonSize / 2 * self.m_scale;
    for i, button in pairs(self.m_editButtons) do
        local bx, by = button.x * self.m_scale, button.y * self.m_scale;

        if x >= bx - bsize and x <= bx + bsize and y <= by + bsize and y >= by - bsize then
            local message = string.format("Enter new [%s] value.\nNOTE: %s", button.name, tostring(button.editNote));
            local value = device.showInputBox("Change object property", message, tostring(button.value));

            if value ~= "" then
                updateObject(function()
                    button.editFunction(self.m_object, value);
                end);
            end
        end
    end
end

function ObjectInspector:getView()
    return self.m_sprite;
end

function ObjectInspector:createView(parent, object)
    local layer = display.newNode();
    local bg = display.newSprite("#EditorPanelBg.png");
    local size = bg:getContentSize();
    bg:align(display.LEFT_TOP, 0, 0);
    bg:getTexture():setAliasTexParameters();
    layer:addChild(bg);
    layer:setVisible(false);
    layer:setScale(self.m_scale);
    parent:addChild(layer)

    local closeButton = display.newSprite("#EditorPanelCloseButton.png");
    local offset = EditorConstants.PANEL_BUTTON_SIZE / 2 + EditorConstants.PANEL_BUTTON_OFFSET;
    closeButton:setPosition(offset, -offset);
    layer:addChild(closeButton);

    self.m_positionButton = display.newSprite("#EditorPanelPositionButton.png");
    self.m_positionButton:setPosition(0, -offset);
    layer:addChild(self.m_positionButton);

    if device.platform == "ios" or device.platform == "android" then
        self.m_positionButton:setVisible(false);
    end

    self.m_bg = bg;
    self.m_sprite = layer;
    return layer;
end

function ObjectInspector:removeView()
    if self.m_sprite then
        self.m_sprite:removeSelf();
        self.m_sprite = nil;
    end
end

function ObjectInspector:setPosition()
    local width, height = unpack(self.m_size);

    local size = self.m_bg:getContentSize();
    self.m_bg:setScaleX(width / size.width);
    self.m_bg:setScaleY(height / size.height);

    width = width * self.m_scale
    height = height * self.m_scale

    local offset = EditorConstants.PANEL_OFFSET * self.m_scale

    if self.m_position == ObjectInspector.POSITION_LEFT_TOP then
        self.m_sprite:align(display.LEFT_TOP,
                           display.c_left + offset,
                           display.c_top - offset);

    elseif self.m_position == ObjectInspector.POSITION_RIGHT_TOP then
        self.m_sprite:align(display.LEFT_TOP,
                           display.c_right - width - offset,
                           display.c_top - offset);

    elseif self.m_position == ObjectInspector.POSITION_LEFT_BOTTOM then
        local y = display.c_bottom + height + offset;

        if self.m_scale == 1 then
            y = y + EditorConstants.MAP_TOOLBAR_HEIGHT * self.m_toolbarLines;
        end

        self.m_sprite:align(display.LEFT_TOP, display.c_left + offset, y);

    else
        local y = display.c_bottom + height + offset;

        if self.m_scale == 1 then
            y = y + EditorConstants.MAP_TOOLBAR_HEIGHT * self.m_toolbarLines;
        end

        self.m_sprite:align(display.LEFT_TOP, display.c_right - width - offset, y);
    end

    local offset = EditorConstants.PANEL_BUTTON_SIZE / 2 + EditorConstants.PANEL_BUTTON_OFFSET;
    self.m_positionButton:setPositionX(width / self.m_scale - offset);
end

function ObjectInspector:setObject(object)
    local isVisible = self.m_isVisible;
    local changeVisible = self.m_object ~= object;
    
    if self.m_panel then 
        self:removeObject();
    end

    if not changeVisible then
        self.m_isVisible = isVisible;
    end

    local panel = display.newNode();
    self.m_sprite:addChild(panel);
    self.m_panel = panel;

    -- add properties label
    local lines = {};
    lines[#lines + 1] = {
        name  = "Id",
        value = object:getId(),
    };

    lines[#lines + 1] = {
        name  = "defineId",
        value = object:getDefineId(),
    };

    -- if object.behaviors_ and table.nums(object.behaviors_) > 0 then
    --     lines[#lines + 1] = {"behaviors", table.concat(table.keys(object.behaviors_), ", ")}
    -- end

    lines[#lines + 1] = {
        name  = "radius",
        value = string.format("%0.2f", object:getRadius()),
    };

    lines[#lines + 1] = {
        name  = "flipSprite",
        value = string.format("%s", tostring(object:isFlipSprite())),
        edit  = true,
        editNote = "\"true, yes, 1\" = true, others = false",
        editFunction = function(object, newvalue)
            newvalue = string.lower(tostring(newvalue));

            if newvalue == "1" or newvalue == "true" or newvalue == "yes" then
                newvalue = true;
            else
                newvalue = false;
            end

            object:setFlipSprite(newvalue);
        end
    };

    if object:hasBehavior("CollisionBehavior") then
        lines[#lines + 1] = {
            name  = "collisionEnabled",
            value = string.format("%s", tostring(object:isCollisionEnabled())),
            edit  = true,
            editNote = "\"true, yes, 1\" = true, others = false",
            editFunction = function(object, newvalue)
                newvalue = string.lower(tostring(newvalue));

                if newvalue == "1" or newvalue == "true" or newvalue == "yes" then
                    newvalue = true;
                else
                    newvalue = false;
                end

                object:setCollisionEnabled(newvalue);
            end
        };
    end

    if object:hasBehavior("NPCBehavior") then
        lines[#lines + 1] = {
            name  = "npcId",
            value = object:getNPCId(),
            edit  = true,
            editNote = "npcId is string",
            editFunction = function(object, newvalue)
                object:setNPCId(newvalue);
            end
        };
    end

    if object:hasBehavior("TowerBehavior") then
        lines[#lines + 1] = {
            name  = "towerId",
            value = object:getTowerId(),
            edit  = true,
            editNote = "towerId is string",
            editFunction = function(object, newvalue)
                object:setTowerId(newvalue);
            end
        };
    end

    if object:hasBehavior("BuildingBehavior") then
        lines[#lines + 1] = {
            name  = "buildingId",
            value = object:getBuildingId(),
            edit  = true,
            editNote = "buildingId is string",
            editFunction = function(object, newvalue)
                object:setBuildingId(newvalue);
            end
        };
    end

    if object:hasBehavior("FireBehavior") then
        lines[#lines + 1] = {
            name  = "fireRange",
            value = object:getFireRange(),
        };
    end

    if object:hasBehavior("DecorateBehavior") then
        local v = object.m_decorationsMore;
        
        if v then
            v = table.concat(table.keys(v), ",");
        else
            v = "";
        end

        lines[#lines + 1] = {
            name  = "decorationsMore",
            value = v,
            edit  = true,
            editNote = "decorationsMore is string",
            editFunction = function(object, newvalue)
                newvalue = string.split(newvalue, ",");
                object.m_decorationsMore = {};
                for i, name in ipairs(newvalue) do
                    object.m_decorationsMore[name] = false;
                end
            end
        };
    end

    lines[#lines + 1] = {
        name  = "x, y",
        value = string.format("%0.2f, %0.2f", object:getPosition()),
        edit  = true,
        editNote = "position format is x, y",
        editFunction = function(object, newvalue)
            newvalue = string.split(newvalue, ",");

            if #newvalue == 2 then
                local x = checkint(string.trim(newvalue[1]));
                local y = checkint(string.trim(newvalue[2]));
                object:setPosition(x, y);
            end

        end
    };

    if object:hasBehavior("CampBehavior") then
        lines[#lines + 1] = {
            name  = "campId",
            value = object:getCampId(),
            edit  = true,
            editNote = "campId is integer",
            editFunction = function(object, newvalue)
                object.m_campId = checkint(newvalue);
            end
        };
    end

    if object:hasBehavior("DestroyedBehavior") then
        lines[#lines + 1] = {
            name  = "maxHp",
            value = object:getMaxHp(),
        };
    end

    if object:hasBehavior("MovableBehavior") then
        lines[#lines + 1] = {
            name  = "bindingPathId",
            value = object:getBindingPathId(),
        };

        lines[#lines + 1] = {
            name  = "bindingPointIndex",
            value = tostring(object:getBindingPointIndex()),
        };

        lines[#lines + 1] = {
            name  = "bindingMovingForward",
            value = tostring(object:isMovingForward()),
            edit  = true,
            editNote = "\"true, yes, 1\" = true, others = false",
            editFunction = function(object, newvalue)
                newvalue = string.lower(tostring(newvalue));

                if newvalue == "1" or newvalue == "true" or newvalue == "yes" then
                    newvalue = true;
                else
                    newvalue = false;
                end

                object:setMovingForward(newvalue);
            end
        };
    end

    self.m_editButtons = {};
    local maxWidth = 0;
    local labelX = 26;
    local labelY = -14;

    for i, pair in ipairs(lines) do
        local prefix = string.rep(" ", EditorConstants.PROPERTY_PREFIX_LEN - string.len(pair.name)) .. pair.name;
        local text   = string.format("%s = %s", tostring(prefix), tostring(pair.value));
        local label  = cc.ui.UILabel.new({
            text  = text,
            font  = EditorConstants.PANEL_LABEL_FONT,
            size  = EditorConstants.PANEL_LABEL_FONT_SIZE,
            align = cc.ui.TEXT_ALIGN_LEFT,
            x     = labelX,
            y     = labelY,
        }):align(display.CENTER_LEFT);
        panel:addChild(label);

        if pair.edit and device.platform ~= "ios" and device.platform ~= "android" then
            local editButton = display.newSprite("#EditButton.png", labelX - 10, labelY);
            panel:addChild(editButton);
            pair.x, pair.y = labelX - 10, labelY;
            self.m_editButtons[#self.m_editButtons + 1] = pair;
        end

        labelY = labelY - EditorConstants.PANEL_LABEL_FONT_SIZE - 3;
        local size = label:getContentSize();

        if size.width > maxWidth then
            maxWidth = size.width;
        end

    end

    local panelWidth  = maxWidth + 30;

    if panelWidth < EditorConstants.INSPECTOR_WIDTH then
        panelWidth = EditorConstants.INSPECTOR_WIDTH;
    end

    -- labelY = labelY
    local allStaticObjectBehaviorsName = BehaviorFactory.getAllStaticObjectBehaviorsName();
    local numCols = math.floor(panelWidth / EditorConstants.BEHAVIOR_LABEL_WIDTH);
    local numRows = math.ceil(#allStaticObjectBehaviorsName / numCols);
    local panelHeight = -labelY + 54 + (numRows - 1) * 26;
    local column = 0;
    labelY = labelY - 20;
    self.m_behaviorsLabel = {};

    for i, behavior in ipairs(allStaticObjectBehaviorsName) do
        local sprite = display.newSprite("#BehaviorLabelBackground.png");
        local size = sprite:getContentSize();

        local text = cc.ui.UILabel.new({
            text = string.upper(string.sub(behavior, 1, -9)),
            size = 10,
            align = cc.ui.TEXT_ALIGN_LEFT,
            x = 20,
            y = 12,
        }):align(display.CENTER_LEFT);
        sprite:addChild(text);

        local label = {
            x        = labelX + EditorConstants.BEHAVIOR_LABEL_WIDTH * column,
            y        = labelY,
            width    = size.width,
            height   = size.height,
            isLocked = false,
        };

        sprite:align(display.LEFT_TOP, label.x, label.y);

        label.sprite = sprite;
        self.m_behaviorsLabel[i] = label;

        if not object:hasBehavior(behavior) then
            sprite:setOpacity(80);
        else
            local selected = display.newSprite("#BehaviorLabelSelected.png");
            selected:align(display.LEFT_BOTTOM, 0, 0);
            sprite:addChild(selected);
        end

        if object.m_behaviorDepends and object.m_behaviorDepends[behavior] then
            label.isLocked = true;
            local lock = display.newSprite("#BehaviorLabelLocked.png");
            lock:align(display.LEFT_BOTTOM, 0, 0);
            sprite:addChild(lock);
        end

        panel:addChild(sprite);

        column = column + 1;

        if column == numCols then
            column = 0;
            labelY = labelY - 26;
        end
    end

    self.m_object = object;
    self.m_size = {panelWidth, panelHeight};
    self:setPosition();
    self.m_sprite:setVisible(self.m_isVisible);
end

function ObjectInspector:removeObject()
    if self.m_panel then
        self.m_sprite:setVisible(false);
        self.m_panel:removeSelf();
        self.m_panel = nil;
        self.m_object = nil;
        self.m_isVisible = true;
    end
end

return ObjectInspector;
