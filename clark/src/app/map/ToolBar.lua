local AutoLayout = require("app.map.AutoLayout");
local ToolBase   = require("app.map.ToolBase");

local ToolBar = class("ToolBar");

function ToolBar:ctor(map)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods();

    self.m_map = map;
    self.m_tools = {};
    self.m_toolsName = {};

    self.m_ToolBarHeight = 0;
    self.m_defaultTouchTool = nil;

    self.m_currentToolName = nil;
    self.m_currentButtonIndex = nil;
    self.m_sprite = nil;

    self.m_isDefaultTouch = false;
end

function ToolBar:onTouch(event, x, y)
    if y > self.m_ToolBarHeight then
        local ret;

        if self.m_isDefaultTouch then
            ret = self.m_tools[self.m_defaultTouchTool]:onIgnoredTouch(event, x, y, true);

            if ret == ToolBase.DEFAULT_TOUCH_ENDED then
                self.m_isDefaultTouch = false;
                ret = false;
            end
        else
            ret = self.m_tools[self.m_currentToolName]:onTouch(event, x, y);
            if ret == ToolBase.TOUCH_IGNORED and self.m_defaultTouchTool then
                ret = self.m_tools[self.m_defaultTouchTool]:onIgnoredTouch(event, x, y, true);
                if ret == true then
                    self.m_isDefaultTouch = true;
                end
            end
        end

        return ret;
    end
end

function ToolBar:onButtonTap(selectedTool, selectedButton)
    for toolName, tool in pairs(self.m_tools) do
        if tool ~= selectedTool then
            for i, buttonSprite in ipairs(tool.buttonsSprite) do
                buttonSprite:setButtonSelected(false);
            end
        end

        for buttonIndex, button in ipairs(tool.buttons) do
            if button == selectedButton then
                self.m_currentButtonIndex = buttonIndex;
            elseif button.sprite:isButtonEnabled() then
                button.sprite:setButtonSelected(false);
            end
        end
    end

    self.m_currentToolName = selectedTool:getName();
    selectedButton.sprite:setButtonSelected(true);
    selectedTool:selected(selectedButton.name);

    self:dispatchEvent({
        name       = "SELECT_TOOL",
        toolName   = self.m_currentToolName,
        buttonName = selectedButton.name,
    });
end

function ToolBar:createView(parent, bgImageName, padding, scale, ToolBarLines)
    if self.m_sprite then 
        return ;
    end

    self.m_sprite = display.newNode();
    local bg = display.newSprite(bgImageName);
    bg:setScaleX((display.width / bg:getContentSize().width) * 2);
    bg:setScaleY(scale * ToolBarLines);
    bg:align(display.CENTER_BOTTOM, display.cx, 0);
    self.m_ToolBarHeight = bg:getContentSize().height * scale;
    self.m_sprite:addChild(bg);

    local menu = display.newNode();
    local items = {};
    for toolIndex, toolName in ipairs(self.m_toolsName) do
        if ToolBarLines > 1 and toolIndex == 3 then
            items[#items + 1] = "#";
        elseif toolIndex > 1 then
            items[#items + 1] = "-";
        end

        local tool = self.m_tools[toolName];
        tool.buttonsSprite = {};
        for buttonIndex, button in ipairs(tool.buttons) do
            button.sprite = cc.ui.UICheckBoxButton.new({
                off = button.image,
                on = button.imageSelected,
            });
            button.sprite:onButtonClicked(function() self:onButtonTap(tool, button) end)
            button.sprite:setScale(scale);
            menu:addChild(button.sprite);
            tool.buttonsSprite[#tool.buttonsSprite + 1] = button.sprite;
            items[#items + 1] = button.sprite;
        end
    end

    self.m_sprite:addChild(menu);
    AutoLayout.alignItemsHorizontally(items, padding * scale, self.m_ToolBarHeight / 2, padding * scale, ToolBarLines);

    -- 放大缩小按钮
    cc.ui.UIPushButton.new("#ZoomInButton.png")
        :onButtonClicked(function(event)
            local scale = self.m_map:getCamera():getScale()
            if scale < 2.0 then
                scale = scale + 0.5
                if scale > 2.0 then scale = 2.0 end
                self.m_map:getCamera():setScale(scale)
                self.m_map:updateView()
                self.m_scaleLabel:setString(string.format("%0.2f", scale))
            end
        end)
        :align(display.CENTER, display.right - 72 * scale, self.m_ToolBarHeight / 2)
        :addTo(self.m_sprite)
        :setScale(scale);

    cc.ui.UIPushButton.new("#ZoomOutButton.png")
        :onButtonClicked(function(event)
            local scale = self.m_map:getCamera():getScale();
            if scale > 0.5 then
                scale = scale - 0.5;
                
                if scale < 0.5 then 
                    scale = 0.5;
                end

                self.m_map:getCamera():setScale(scale);
                self.m_map:updateView();
                self.m_scaleLabel:setString(string.format("%0.2f", scale));
            end
        end)
        :align(display.CENTER, display.right - 28 * scale, self.m_ToolBarHeight / 2)
        :addTo(self.m_sprite)
        :setScale(scale);

    -- local zoomInButton = ui.newImageMenuItem({
    --     image    = "#ZoomInButton.png",
    --     x        = display.right - 72 * scale,
    --     y        = self.m_ToolBarHeight / 2,
    --     listener = function()
    --         local scale = self.m_map:getCamera():getScale()
    --         if scale < 2.0 then
    --             scale = scale + 0.5
    --             if scale > 2.0 then scale = 2.0 end
    --             self.m_map:getCamera():setScale(scale)
    --             self.m_map:updateView()
    --             self.m_scaleLabel:setString(string.format("%0.2f", scale))
    --         end
    --     end
    -- })
    -- zoomInButton:setScale(scale)

    -- local zoomOutButton = ui.newImageMenuItem({
    --     image    = "#ZoomOutButton.png",
    --     x        = display.right - 28 * scale,
    --     y        = self.m_ToolBarHeight / 2,
    --     listener = function()
    --         local scale = self.m_map:getCamera():getScale()
    --         if scale > 0.5 then
    --             scale = scale - 0.5
    --             if scale < 0.5 then scale = 0.5 end
    --             self.m_map:getCamera():setScale(scale)
    --             self.m_map:updateView()
    --             self.m_scaleLabel:setString(string.format("%0.2f", scale))
    --         end
    --     end
    -- })
    -- zoomOutButton:setScale(scale)

    -- local zoombar = ui.newMenu({zoomInButton, zoomOutButton})
    -- self.m_sprite:addChild(zoombar)

    self.m_scaleLabel = cc.ui.UILabel.new({
        text  = "1.00",
        font  = display.DEFAULT_TTF_FONT,
        size  = 24 * scale,
        color = cc.c3b(255, 255, 255),
        align = cc.ui.TEXT_ALIGN_RIGHT,
        x     = display.right - 96 * scale,
        y     = self.m_ToolBarHeight / 2,
    }):align(display.CENTER);
    self.m_scaleLabel:align(display.CENTER_RIGHT, display.right - 96 * scale, self.m_ToolBarHeight / 2);
    self.m_sprite:addChild(self.m_scaleLabel);
    parent:addChild(self.m_sprite);

    self.m_sprite:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "exit" then
            self:removeAllEventListeners();
        end
    end)

    return self.m_sprite;
end

function ToolBar:getView()
    return self.m_sprite;
end

function ToolBar:addTool(tool)
    self.m_tools[tool:getName()] = tool;
    self.m_toolsName[#self.m_toolsName + 1] = tool:getName();
end

function ToolBar:setDefaultTouchTool(toolName)
    self.m_defaultTouchTool = toolName;
end

function ToolBar:selectButton(toolName, buttonIndex)
    assert(self.m_sprite, "ToolBar sprites not created");
    self:onButtonTap(self.m_tools[toolName], self.m_tools[toolName].buttons[buttonIndex]);
end

function ToolBar:getSelectedButtonName()
    return self.m_tools[self.m_currentToolName].buttons[self.m_currentButtonIndex].name;
end

function ToolBar:showNotice(text, fontsize, delay)
    local label = cc.ui.UILabel.new({
        text = "Save map ok",
        size = fontsize or 96,
        color = cc.c3b(100, 255, 100),
        align = cc.ui.TEXT_ALIGN_CENTER,
    }):align(display.CENTER);

    label:setPosition(display.cx, display.cy);
    self:getView():addChild(label);

    transition.moveBy(label, {y = 20, time = 1.0, delay = delay or 0.5});
    transition.fadeOut(label, {time = 1.0, delay = delay or 0.5, onComplete = function()
        label:removeSelf();
    end});
end

return ToolBar;
