local StaticObjectsProperties = require("app.properties.StaticObjectProperties");
local StaticObject = require("app.map.StaticObject");
local MapConstants = require("app.map.MapConstants");
local EditorConstants = require("app.map.EditorConstant");

local ToolBase = require("app.map.ToolBase");

local ObjectTool = class("ObjectTool", ToolBase);

ObjectTool.m_TOOLBOXPADDING     = 98;
ObjectTool.m_TOOLBOXICON_SIZE   = 96;
ObjectTool.m_TOOLBOXMAX_COLUMNS = 8;
ObjectTool.m_TOOLBOXZORDER      = 20000;
ObjectTool.BREAK_BINDING_DIST  = 20;

function ObjectTool:ctor(toolbar, map)
    ObjectTool.super.ctor(self, "ObjectTool", toolbar, map);

    self.m_currentObject = nil;
    self.m_currentObjectBindingPathId = nil;
    self.m_drag = nil;
    self.m_bindLabel = nil;

    self.buttons = {
        {
            name          = "CreateObject",
            image         = "#CreateObjectButton.png",
            imageSelected = "#CreateObjectButtonSelected.png",
        },
        {
            name          = "SelectObject",
            image         = "#SelectObjectButton.png",
            imageSelected = "#SelectObjectButtonSelected.png",
        },
        {
            name          = "RemoveObject",
            image         = "#RemoveObjectButton.png",
            imageSelected = "#RemoveObjectButtonSelected.png",
        },
        {
            name          = "BindObjectToPath",
            image         = "#BindObjectToPathButton.png",
            imageSelected = "#BindObjectToPathButtonSelected.png",
            imageDisabled = "#BindObjectToPathButtonDisabled.png",
        },
    };

    self.m_toolBar:addEventListener("UPDATE_OBJECT", function(event)
        self:setMoreButtonsEnabled(true);
    end)
end

function ObjectTool:selected(selectedButtonName)
    ObjectTool.super.selected(self, selectedButtonName);

    if selectedButtonName == "BindObjectToPath" then
        self.m_currentObject:updateView();
        self:createObjectBindingLabel("选择要绑定的路径点", "static");
    else
        self:removeObjectBindingLabel();
        if selectedButtonName == "CreateObject" or selectedButtonName == "RemoveObject" then
            self:setCurrentObject();
        end
    end
    self:removeToolbox();
end

function ObjectTool:unselected()
    self:setCurrentObject();
    self:removeToolbox();
end

function ObjectTool:setMoreButtonsEnabled(isEnabled)
    if isEnabled and self.m_currentObject and self.m_currentObject:hasBehavior("MovableBehavior") then
        self.buttons[4].sprite:setButtonEnabled(true);
    else
        self.buttons[4].sprite:setButtonEnabled(false);
    end
end

function ObjectTool:removeToolbox()
    if self.m_toolbox then
        self.m_toolbox:removeSelf();
        self.m_toolbox = nil;
    end
end

function ObjectTool:setCurrentObject(object)
    if self.m_currentObject and self.m_currentObject ~= object then
        self.m_currentObject:setSelected(false);
        self.m_currentObject:updateView();
        self.m_toolBar:dispatchEvent({name = "UNSELECT_OBJECT"});
    end

    self.m_currentObject = object;
    self.m_currentObjectResize = nil;

    if object then
        object:setSelected(true);
        object:updateView();
        self:setMoreButtonsEnabled(true);
        self.m_toolBar:dispatchEvent({name = "SELECT_OBJECT", object = object});
    else
        self:setMoreButtonsEnabled(false);
    end
end

function ObjectTool:createObjectBindingLabel(text, isStaticLabel)
    self:removeObjectBindingLabel();

    local x, y = self.m_currentObject:getPosition();
    local label = cc.ui.UILabel.new({
        text         = text,
        size         = 20,
        align        = cc.ui.TEXT_ALIGN_CENTER,
        color        = cc.c3b(255, 100, 100),
        x            = labelX,
        y            = labelY,
    }):align(display.CENTER);
    label:enableOutline(cc.c4b(255, 255, 255, 255), 2);
    label:setPosition(x, y + 100);
    self.m_map:getDebugLayer():addChild(label, EditorConstants.BINDING_LABEL_ZORDER);

    if not isStaticLabel then
        transition.moveBy(label, {y = 10, time = 0.5})
        transition.fadeOut(label, {time = 0.5, delay = 1.7, onComplete = function()
            label:removeSelf();
        end})
    else
        self.m_bindLabel = label;
    end
end

function ObjectTool:removeObjectBindingLabel()
    if self.m_bindLabel then
        self.m_bindLabel:removeSelf();
        self.m_bindLabel = nil;
    end
end

function ObjectTool:onTouchCreateObject(event, x, y)
    if event == "began" then
        if not self.m_toolbox then
            self:removeToolbox();
            self:showToolbox(x, y);
            return false;

        else
            local object = self.m_toolbox:checkPoint(x, y);

            if object then
                self:setCurrentObject(object);
                self:removeToolbox();
                self.m_toolBar:selectButton("ObjectTool", 2);
                return false;
            end

            return ObjectTool.TOUCH_IGNORED;
        end
    end
end

function ObjectTool:onTouchSelectObject(event, x, y)
    if event == "began" then
        for id, object in pairs(self.m_map:getAllObjects()) do
            local classId = object:getClassId();
            if (classId == "static" or classId == "entity") and object:checkPointIn(x, y) then
                local isDragBegin = self.m_currentObject == object;
                self:setCurrentObject(object);

                self.m_currentObjectBindingPathId = nil;

                if object:hasBehavior("MovableBehavior") then
                    self.m_currentObjectBindingPathId = object:getBindingPathId();
                end

                local objectX, objectY = object:getPosition();

                self.m_drag = {
                    startX  = objectX,
                    startY  = objectY,
                    offsetX = objectX - x,
                    offsetY = objectY - y
                };
                self.m_map:setAllObjectsZOrder();

                return isDragBegin;
            end
        end

        return ObjectTool.TOUCH_IGNORED;

    elseif event == "moved" then
        local nx, ny = x + self.m_drag.offsetX, y + self.m_drag.offsetY;

        if self.m_currentObject:hasBehavior("MovableBehavior") and self.m_currentObjectBindingPathId then
            local path = self.m_map:getObject(self.m_currentObjectBindingPathId);
            local pointIndex = path:checkPointAtPoint(nx, ny, ObjectTool.BREAK_BINDING_DIST);

            if pointIndex then
                self.m_currentObject:bindPath(path, pointIndex);
            else
                self.m_currentObject:unbindPath();
                self.m_currentObject:setPosition(nx, ny);
            end

        else
            self.m_currentObject:setPosition(nx, ny);
        end

        self.m_currentObject:updateView();
        self.m_map:setAllObjectsZOrder();

    else
        self.m_toolBar:dispatchEvent({name = "UPDATE_OBJECT", object = self.m_currentObject});

        if self.m_currentObjectBindingPathId and not self.m_currentObject:isBinding() then
            self:createObjectBindingLabel("对象已经解除绑定");
        end

        self.m_currentObjectBindingPathId = nil;
    end
end

function ObjectTool:onTouchRemoveObject(event, x, y)
    if event == "began" then
        for id, object in pairs(self.m_map:getAllObjects()) do
            local classId = object:getClassId();

            if (classId == "static" or classId == "entity") and object:checkPointIn(x, y) then
                self:setCurrentObject();
                self.m_map:removeObject(object);
                return false;
            end

        end
        return ObjectTool.TOUCH_IGNORED;
    end
end

function ObjectTool:onTouchBindObjectToPath(event, x, y)
    if event == "began" then
        for id, path in pairs(self.m_map:getObjectsByClassId("path")) do
            local index = path:checkPointAtPoint(x, y, EditorConstants.CHECK_POINT_DIST);

            if index then
                -- 连接对象到指定路径
                self.m_currentObject:bindPath(path, index);
                self:setCurrentObject(self.m_currentObject);

                self.m_toolBar:selectButton("ObjectTool", 2);
                self:createObjectBindingLabel("对象已经绑定到路径");
                return false;
            end

        end

        return ObjectTool.TOUCH_IGNORED;
    end
end

function ObjectTool:onTouch(event, x, y)
    local x, y = self.m_map:getCamera():convertToMapPosition(x, y);

    if self.m_selectedButtonName == "CreateObject" then
        return self:onTouchCreateObject(event, x, y);

    elseif self.m_selectedButtonName == "SelectObject" then
        return self:onTouchSelectObject(event, x, y);

    elseif self.m_selectedButtonName == "RemoveObject" then
        return self:onTouchRemoveObject(event, x, y);

    elseif self.m_selectedButtonName == "BindObjectToPath" then
        return self:onTouchBindObjectToPath(event, x, y);
    end
end

function ObjectTool:showToolbox(mapX, mapY)
    assert(self.m_toolbox == nil);
    local layer = display.newNode();
    layer:setPosition(mapX, mapY);

    local allIds = StaticObjectsProperties.getAllIds();
    local count = #allIds;
    local maxColumns = math.ceil(math.sqrt(count));

    if maxColumns > ObjectTool.m_TOOLBOXMAX_COLUMNS then
        maxColumns = ObjectTool.m_TOOLBOXMAX_COLUMNS;
    end

    local rows = math.ceil(count / maxColumns);
    local columns = maxColumns;
    
    if count < maxColumns then
        columns = count;
    end

    local x = -(columns / 2) * ObjectTool.m_TOOLBOXPADDING + ObjectTool.m_TOOLBOXPADDING / 2;
    local y = (rows / 2) * ObjectTool.m_TOOLBOXPADDING - ObjectTool.m_TOOLBOXPADDING / 2;
    local width, height = self.m_map:getSize();

    local minX = ObjectTool.m_TOOLBOXPADDING / 2;
    
    if mapX + x < minX then 
        x = minX - mapX;
    end

    local maxX = width - (columns - 0.5) * ObjectTool.m_TOOLBOXPADDING;

    if mapX + x > maxX then 
        x = maxX - mapX;
    end

    local minY = (rows - 0.5) * ObjectTool.m_TOOLBOXPADDING;

    if mapY + y < minY then 
        y = minY - mapY;
     end

    local maxY = height - ObjectTool.m_TOOLBOXPADDING / 2;

    if mapY + y > maxY then 
        y = maxY - mapY;
    end

    local left = mapX + x - ObjectTool.m_TOOLBOXPADDING / 2;
    local top = mapY + y + ObjectTool.m_TOOLBOXPADDING / 2;

    local bgWidth = columns * ObjectTool.m_TOOLBOXPADDING + 4;
    local bgHeight = rows * ObjectTool.m_TOOLBOXPADDING + 4;
    local rect = utils.drawRect(
                    cc.rect(x - ObjectTool.m_TOOLBOXPADDING / 2 - 2,
                        y - bgHeight + ObjectTool.m_TOOLBOXPADDING / 2 + 2,
                        bgWidth,
                        bgHeight),
                    {fillColor = cc.c4f(1,1,1,80/255),
                    borderColor = cc.c4f(0.5,0.5,0.5,80/255)});
    -- rect:setFill(true)
    -- rect:setLineColor(cc.c4fFromc4b(cc.c4b(120, 120, 120, 80)))
    -- rect:setOpacity(80)
    -- rect:setPosition(x + bgWidth / 2 - ObjectTool.m_TOOLBOXPADDING / 2 - 2,
    --                  y - bgHeight / 2 + ObjectTool.m_TOOLBOXPADDING / 2 + 2)
    layer:addChild(rect);

    local col = 0;

    for i, id in ipairs(allIds) do
        local define = StaticObjectsProperties.get(id);
        local sprite;

        if define.framesName then
            sprite = display.newSprite("#" .. string.format(define.framesName, define.framesBegin));
        else
            local imageName = define.imageName;

            if type(imageName) == "table" then
                imageName = imageName[1];
            end

            sprite = display.newSprite(imageName);
        end

        local size   = sprite:getContentSize();
        local scale  = 1;

        if size.width > ObjectTool.m_TOOLBOXICON_SIZE then
            scale = ObjectTool.m_TOOLBOXICON_SIZE / size.width;
        end

        if size.height * scale > ObjectTool.m_TOOLBOXICON_SIZE then
            scale = ObjectTool.m_TOOLBOXICON_SIZE / size.height;
        end

        sprite:setScale(scale);

        local rect = utils.drawRect(
                    cc.rect(x - ObjectTool.m_TOOLBOXICON_SIZE/2,
                        y - ObjectTool.m_TOOLBOXICON_SIZE/2,
                        ObjectTool.m_TOOLBOXICON_SIZE,
                        ObjectTool.m_TOOLBOXICON_SIZE),
                    {fillColor = cc.c4f(1,1,1,70/255),
                    borderColor = cc.c4f(32/255, 32/255, 32/255, 120/255)});
        -- rect:setFill(true)
        -- rect:setLineColor(cc.c4fFromc4b(cc.c4b(32, 32, 32, 120)))
        -- rect:setOpacity(70)
        -- rect:setPosition(x, y)
        layer:addChild(rect);

        layer:addChild(sprite);
        sprite:setPosition(x, y);

        col = col + 1;

        if col >= columns then
            x = x - ObjectTool.m_TOOLBOXPADDING * (columns - 1);
            y = y - ObjectTool.m_TOOLBOXPADDING;
            col = 0;
        else
            x = x + ObjectTool.m_TOOLBOXPADDING;
        end
    end

    local map = self.m_map;

    function layer:checkPoint(x, y)
        local col = math.floor((x - left) / ObjectTool.m_TOOLBOXPADDING) + 1;
        local row = math.floor((top - y) / ObjectTool.m_TOOLBOXPADDING) + 1;
        if col < 1 or col > columns or row < 1 or row > rows then
            return;
        end

        local index = (row - 1) * columns + col;
        
        if not allIds[index] then 
            return ;
        end

        local defineId = allIds[index];
        local define = StaticObjectsProperties.get(defineId);
        local state = {x = mapX, y = mapY, defineId = defineId};
        local object = map:newObject(define.classId, state);
        map:setAllObjectsZOrder();
        return object;
    end

    self.m_toolbox = layer;
    self.m_map:getMarksLayer():addChild(self.m_toolbox, ObjectTool.m_TOOLBOXZORDER);
end

return ObjectTool;
