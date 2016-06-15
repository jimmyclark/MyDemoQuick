local ToolBase = require("app.map.ToolBase");
local GeneralTool = class("GeneralTool", ToolBase)

function GeneralTool:ctor(toolbar, map)
    GeneralTool.super.ctor(self, "GeneralTool", toolbar, map);

    self.buttons = {
        {
            name          = "DragMap",
            image         = "#DragMapButton.png",
            imageSelected = "#DragMapButtonSelected.png",
        },
        {
            name          = "SaveMap",
            image         = "#SaveMapButton.png",
            imageSelected = "#SaveMapButtonSelected.png",
        },
        {
            name          = "ToggleDebug",
            image         = "#ToggleDebugButton.png",
            imageSelected = "#ToggleDebugButtonSelected.png",
        },
        {
            name          = "ToggleBackground",
            image         = "#ToggleBackgroundButton.png",
            imageSelected = "#ToggleBackgroundButtonSelected.png",
        },
        {
            name          = "PlayMap",
            image         = "#PlayMapButton.png",
            imageSelected = "#PlayMapButtonSelected.png",
        },
    };

    if device.platform == "ios" or device.platform == "android" then
        table.remove(self.buttons, 2);
    end

    self.m_drag = nil;
    self.m_debugIsVisible = true;
end

function GeneralTool:selected(selectedButtonName)
    if selectedButtonName == "SaveMap" then
        self.m_toolBar:selectButton("GeneralTool", 1);
        if self.m_map:dumpToFile() then
            self.m_toolBar:showNotice("Save Map OK");
        end

    elseif selectedButtonName == "ToggleDebug" then
        local debugLayer = self.m_map:getDebugLayer()
        debugLayer:setVisible(not debugLayer:isVisible())
        self.m_toolBar:selectButton("GeneralTool", 1)

    elseif selectedButtonName == "ToggleBackground" then
        local backgroundLayer = self.m_map:getBackgroundLayer();
        local opacity = backgroundLayer:getOpacity();

        if opacity == 255 then
            opacity = 80;
        else
            opacity = 255;
        end

        backgroundLayer:setOpacity(opacity);
        self.m_toolBar:selectButton("GeneralTool", 1);

    elseif selectedButtonName == "PlayMap" then
        self.m_toolBar:dispatchEvent({name = "PLAY_MAP"});
        self.m_toolBar:selectButton("GeneralTool", 1);
    end
end

function GeneralTool:onIgnoredTouch(event, x, y, isDefaultTouch)
    if event == "began" then
        self.m_drag = {
            startX  = x,
            startY  = y,
            lastX   = x,
            lastY   = y,
            offsetX = 0,
            offsetY = 0,
        };
        return true;
    end

    if event == "moved" then
        self.m_drag.offsetX = x - self.m_drag.lastX;
        self.m_drag.offsetY = y - self.m_drag.lastY;
        self.m_drag.lastX = x;
        self.m_drag.lastY = y;
        self.m_map:getCamera():moveOffset(self.m_drag.offsetX, self.m_drag.offsetY);

    else -- "ended" or CCTOUCHCANCELLED
        self.m_drag = nil;

        if isDefaultTouch then
            return GeneralTool.DEFAULT_TOUCH_ENDED;
        end
    end
end

function GeneralTool:onTouch(event, x, y)
    return self:onIgnoredTouch(event, x, y);
end

function GeneralTool:setPlayerControlPanel(panel)
    self.m_panel = panel;
end

return GeneralTool;
