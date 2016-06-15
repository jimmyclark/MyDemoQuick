local ToolBase = class("ToolBase");

ToolBase.TOUCH_IGNORED       = "ignored";
ToolBase.DEFAULT_TOUCH_ENDED = "ended";

function ToolBase:ctor(name, toolbar, map)
    self.m_name = name;
    self.m_toolBar = toolbar;
    self.m_map = map;
    self.m_selectedButtonName = nil;
end

function ToolBase:getName()
    return self.m_name;
end

function ToolBase:selected(selectedButtonName)
    self.m_selectedButtonName = selectedButtonName;
end

function ToolBase:unselected()
end

function ToolBase:onTouch(event, x, y)
    return ToolBase.TOUCH_IGNORED;
end

return ToolBase;
