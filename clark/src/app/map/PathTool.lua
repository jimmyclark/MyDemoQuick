local EditorConstants = require("app.map.EditorConstant");
local ToolBase = require("app.map.ToolBase");

local PathTool = class("PathTool", ToolBase);

PathTool.LINK_CHECK_DIST = 12;

function PathTool:ctor(toolbar, map)
    PathTool.super.ctor(self, "PathTool", toolbar, map);

    self.m_currentPath = nil;
    self.m_currentPointIndex = nil;
    self.m_currentPointLabel = nil
    self.m_link = nil;

    self.buttons = {
        {
            name          = "CreatePath",
            image         = "#CreatePathButton.png",
            imageSelected = "#CreatePathButtonSelected.png",
        },
        {
            name          = "SelectPathPoint",
            image         = "#SelectPathPointButton.png",
            imageSelected = "#SelectPathPointButtonSelected.png",
        },
        {
            name          = "AddPathPoint",
            image         = "#AddPathPointButton.png",
            imageSelected = "#AddPathPointButtonSelected.png",
            imageDisabled = "#AddPathPointButtonDisabled.png",
        },
        {
            name          = "RemovePathPoint",
            image         = "#RemovePathPointButton.png",
            imageSelected = "#RemovePathPointButtonSelected.png",
            imageDisabled = "#RemovePathPointButtonDisabled.png",
        },
    };

end

function PathTool:selected(selectedButtonName)
    PathTool.super.selected(self, selectedButtonName);

    if selectedButtonName == "CreatePath" then
        self:setCurrentPath();
    end

    self:setMoreButtonsEnabled(self.m_currentPath ~= nil);

    if self.m_currentPointLabel then
        self.m_currentPointLabel:setVisible(false);
    end
end

function PathTool:unselected()
    self:setMoreButtonsEnabled(false);
    self:setCurrentPath();
end

function PathTool:setMoreButtonsEnabled(isEnabled)
    self.buttons[3].sprite:setButtonEnabled(isEnabled);
    self.buttons[4].sprite:setButtonEnabled(isEnabled);
end

function PathTool:setCurrentPath(path, pointIndex)
    if self.m_currentPath and self.m_currentPath ~= path then
        self.m_currentPath:setSelected(false);
        self.m_currentPath:updateView();
        self:removePointLabel();
    end

    self.m_currentPath = path;
    self.m_currentPointIndex = pointIndex;

    if path then
        path:setSelected(true);
        path:updateView();
        local x, y = path:getPoint(pointIndex);
        self:showPointLabel(x + 10, y + 20, tostring(pointIndex));
    end
end

function PathTool:showPointLabel(x, y, text)
    if not self.m_currentPointLabel then
        self.m_currentPointLabel = cc.ui.UILabel.new({
            text = "000",
            font = EditorConstants.LABEL_FONT,
            size = EditorConstants.LABEL_FONT_SIZE + 10,
            color = cc.c3b(255, 0, 0),
            align = cc.ui.TEXT_ALIGN_CENTER,
        }):align(display.CENTER);
        self.m_currentPointLabel:enableOutline(cc.c4b(255, 255, 255, 255), 2);
        self.m_map:getDebugLayer():addChild(self.m_currentPointLabel, EditorConstants.LABEL_ZORDER);
    else
        self.m_currentPointLabel:setVisible(true);
    end

    self.m_currentPointLabel:setString(text);
    self.m_currentPointLabel:setPosition(x, y);
end

function PathTool:removePointLabel()
    if self.m_currentPointLabel then
        self.m_currentPointLabel:removeSelf();
        self.m_currentPointLabel = nil;
    end
end

function PathTool:movePoint(x, y)
    self.m_currentPath:movePoint(self.m_currentPointIndex, x, y);
    self.m_currentPath:updateView();
    self.m_currentPointLabel:setPosition(x + 10, y + 20);
end

function PathTool:checkPointAtPath(x, y)
    for id, path in pairs(self.m_map:getObjectsByClassId("path")) do
        local index = path:checkPointAtPoint(x, y, EditorConstants.CHECK_POINT_DIST);
        
        if index then
        	return path, index ;
        end

    end
end

function PathTool:onTouch(event, x, y)
    local x, y = self.m_map:getCamera():convertToMapPosition(x, y);

    if self.m_selectedButtonName == "CreatePath" then
        return self:onTouchCreatePath(event, x, y);

    elseif self.m_selectedButtonName == "AddPathPoint" then
        return self:onTouchAddPathPoint(event, x, y);

    elseif self.m_selectedButtonName == "SelectPathPoint" then
        return self:onTouchSelectPathPoint(event, x, y);

    elseif self.m_selectedButtonName == "RemovePathPoint" then
        return self:onTouchRemovePathPoint(event, x, y);
    end
end

function PathTool:onTouchCreatePath(event, x, y)
    if event == "began" then
        local state = {points = {{x, y}}};
        self:setCurrentPath(self.m_map:newObject("path", state), 1);
        self:setMoreButtonsEnabled(true);
        self.m_toolBar:selectButton("PathTool", 3); -- AddPathPoint;
        return true;
    end
end

function PathTool:onTouchAddPathPoint(event, x, y)
    if event == "began" then
        local index = self.m_currentPath:checkPointAtPoint(x, y, EditorConstants.CHECK_POINT_DIST);

        if index then
            -- 如果点击已有的点，则移动这个点
            self:setCurrentPath(self.m_currentPath, index);
        else
            local index = self.m_currentPath:checkPointAtSegment(x, y, EditorConstants.CHECK_POINT_DIST);
            
            if index then
                -- 如果点击在路径上，则插入一个点
                self.m_currentPath:insertPointAfterIndex(index, x, y);
                self:setCurrentPath(self.m_currentPath, index + 1);
            else
                -- 否则追加一个点
                self.m_currentPath:appendPoint(x, y);
                self:setCurrentPath(self.m_currentPath, self.m_currentPath:getPointsCount());
            end

            self.m_currentPath:updateView();
        end

        return true;

    elseif event == "moved" then
        self:movePoint(x, y);

    else
        self.m_currentPointIndex = nil;

        if self.m_currentPointLabel then
            self.m_currentPointLabel:setVisible(false);
        end

    end
end

function PathTool:onTouchSelectPathPoint(event, x, y)
    if event == "began" then
        -- 检查是否选中了某条路径上的点
        local path, index = self:checkPointAtPath(x, y);

        if path then
            local isDragBegin = self.m_currentPath == path;
            self:setCurrentPath(path, index);
            self:setMoreButtonsEnabled(true);
            return isDragBegin;
        end

        return PathTool.TOUCH_IGNORED;

    elseif event == "moved" then
        self:movePoint(x, y);

    else
        self.m_currentPointIndex = nil;

        if self.m_currentPointLabel then
            self.m_currentPointLabel:setVisible(false);
        end

    end
end

function PathTool:onTouchRemovePathPoint(event, x, y)
    if event == "began" then
        local index = self.m_currentPath:checkPointAtPoint(x, y, EditorConstants.CHECK_POINT_DIST);

        if index then
            -- 删除选中的点
            self.m_currentPath:removePoint(index);

            if self.m_currentPath:getPointsCount() < 1 then
                -- 如果路径上所有点都已经被删除，则删除该路径
                self.m_map:removeObject(self.m_currentPath);
                self:setCurrentPath();
                self.m_toolBar:selectButton("PathTool", 2);
            else
                self.m_currentPath:updateView();
            end

            return false;
        end

        return PathTool.TOUCH_IGNORED;
    end
end

return PathTool;
