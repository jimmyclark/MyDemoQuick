local ToolBase = require("app.map.ToolBase");
local RangeTool = class("RangeTool", ToolBase);

function RangeTool:ctor(toolbar, map)
    RangeTool.super.ctor(self, "RangeTool", toolbar, map);

    self.m_currentRange = nil;
    self.m_drag = nil;

    self.buttons = {
        {
            name          = "CreateRange",
            image         = "#CreateRangeButton.png",
            imageSelected = "#CreateRangeButtonSelected.png",
        },
        {
            name          = "SelectRange",
            image         = "#SelectRangeButton.png",
            imageSelected = "#SelectRangeButtonSelected.png",
        },
        {
            name          = "RemoveRange",
            image         = "#RemoveRangeButton.png",
            imageSelected = "#RemoveRangeButtonSelected.png",
        }
    };
end

function RangeTool:selected(selectedButtonName)
    RangeTool.super.selected(self, selectedButtonName);

    if selectedButtonName ~= "SelectRange" then
        self:setCurrentRange();
    end
end

function RangeTool:unselected()
    self:setCurrentRange();
end

function RangeTool:setCurrentRange(range)
    if self.m_currentRange and self.m_currentRange ~= range then
        self.m_currentRange:setSelected(false);
        self.m_currentRange:updateView();
    end

    self.m_currentRange = range;
    self.m_currentRangeResize = nil;

    if range then
        range:setSelected(true);
        range:updateView();
    end
end

function RangeTool:onTouchCreateRange(event, x, y)
    if event == "began" then
        local range = self.m_map:newObject("range", {x = x, y = y});
        self:setCurrentRange(range);
        self.m_toolBar:selectButton("RangeTool", 2);
        return true;
    end
end

function RangeTool:onTouchSelectRange(event, x, y)
    if event == "began" then

        if self.m_currentRange and self.m_currentRange:checkPointInHandler(x, y) then
            self.m_currentRangeResize = {lastX = x};
            return true;
        end

        for id, range in pairs(self.m_map:getObjectsByClassId("range")) do
            if range:checkPointIn(x, y) then
                self:setCurrentRange(range);
                local rangeX, rangeY = range:getPosition();
                self.m_drag = {
                    startX  = rangeX,
                    startY  = rangeY,
                    offsetX = rangeX - x,
                    offsetY = rangeY - y
                };
                return true;
            end
        end

        return RangeTool.TOUCH_IGNORED

    elseif event == "moved" then

        if not self.m_currentRangeResize then
            local nx, ny = x + self.m_drag.offsetX, y + self.m_drag.offsetY;
            self.m_currentRange:setPosition(nx, ny);
            self.m_currentRange:updateView();
        else
            local offset = x - self.m_currentRangeResize.lastX;
            self.m_currentRangeResize.lastX = x;
            self.m_currentRange:setRadius(self.m_currentRange:getRadius() + offset);
            self.m_currentRange:updateView();
        end
    end
end

function RangeTool:onTouchRemoveRange(event, x, y)
    if event == "began" then
        
        for id, range in pairs(self.m_map:getObjectsByClassId("range")) do

            if range:checkPointIn(x, y) then
                self:setCurrentRange();
                self.m_map:removeObject(range);
                return false;
            end
        end

        return RangeTool.TOUCH_IGNORED;
    end
end

function RangeTool:onTouch(event, x, y)
    local x, y = self.m_map:getCamera():convertToMapPosition(x, y)

    if self.m_selectedButtonName == "CreateRange" then
        return self:onTouchCreateRange(event, x, y);

    elseif self.m_selectedButtonName == "SelectRange" then
        return self:onTouchSelectRange(event, x, y);

    elseif self.m_selectedButtonName == "RemoveRange" then
        return self:onTouchRemoveRange(event, x, y);
    end
end

return RangeTool;
