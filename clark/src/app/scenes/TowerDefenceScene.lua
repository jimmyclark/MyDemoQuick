local TowerDefenceScene = class("TowerDefenceScene",function()
	return display.newScene("TowerDefenceScene");
end);

local EditorConstants = require("app.map.EditorConstant");
local LEVEL_ID = "A0002";

function TowerDefenceScene:ctor()
	self.m_backBtn = UICreator.createBtnText("close.png",true,display.left + 100,display.top - 100,display.CENTER);
	self.m_backBtn:addTo(self,10);

	self.m_backBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_backBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene);
	end);

    display.addSpriteFrames("SheetMapBattle.plist", "SheetMapBattle.png");
    display.addSpriteFrames("SheetEditor.plist", "SheetEditor.png");
    --根据设备类型确定工具栏的缩放比例
    self.toolbarLines = 1;
    self.editorUIScale = 1;
    self.statusCount_ = 1;

    if (device.platform == "ios" and device.model == "iphone") or device.platform == "android" then
        self.editorUIScale = 2;
        self.toolbarLines = 2;
    end

    self.m_bg = display.newTilesSprite("EditorBg.png");
    self.m_bg:addTo(self);

    -- mapLayer 包含地图的整个视图
    self.m_mapLayer = display.newNode();
    self.m_mapLayer:align(display.LEFT_BOTTOM, 0, 0);
    self.m_mapLayer:addTo(self);

    -- touchLayer 用于接收触摸事件
    self.m_touchLayer = display.newLayer();
    self:addChild(self.m_touchLayer);

    -- uiLayer 用于显示编辑器的 UI（工具栏等）
    self.m_uiLayer = display.newNode();
    self.m_uiLayer:setPosition(display.cx, display.cy);
    self:addChild(self.m_uiLayer);

    -- 创建地图对象
    self.m_map = require("app.map.Map").new(LEVEL_ID, true); -- 参数：地图ID, 是否是编辑器模式
    self.m_map:init();
    self.m_map:createView(self.m_mapLayer);

    -- 创建工具栏
    self.m_toolBar = require("app.map.ToolBar").new(self.m_map);
    self.m_toolBar:addTool(require("app.map.GeneralTool").new(self.m_toolBar, self.m_map));
    self.m_toolBar:addTool(require("app.map.ObjectTool").new(self.m_toolBar, self.m_map));
    self.m_toolBar:addTool(require("app.map.PathTool").new(self.m_toolBar, self.m_map));
    self.m_toolBar:addTool(require("app.map.RangeTool").new(self.m_toolBar, self.m_map));

    -- 创建工具栏的视图
    self.m_toolbarView = self.m_toolBar:createView(self.m_uiLayer, "#ToolbarBg.png", EditorConstants.TOOLBAR_PADDING, self.editorUIScale, self.toolbarLines);
    self.m_toolbarView:setPosition(display.c_left, display.c_bottom);
    self.m_toolBar:setDefaultTouchTool("GeneralTool");
    self.m_toolBar:selectButton("GeneralTool", 1);

    -- 创建对象信息面板
    local objectInspectorScale = 1;
    if self.editorUIScale > 1 then
        objectInspectorScale = 1.5;
    end
    self.m_objectInspector = require("app.map.ObjectInspector").new(self.m_map, objectInspectorScale, self.toolbarLines);
    self.m_objectInspector:addEventListener("UPDATE_OBJECT", function(event)
        self.m_toolBar:dispatchEvent(event);
    end)
    self.m_objectInspector:createView(self.m_uiLayer);
    -- self.m_toolBar:addTool(require("editor.GeneralTool").new(self.m_toolBar, self.map_))
    -- self.m_toolBar:addTool(require("editor.ObjectTool").new(self.m_toolBar, self.map_))
    -- self.m_toolBar:addTool(require("editor.PathTool").new(self.m_toolBar, self.map_))
    -- self.m_toolBar:addTool(require("editor.RangeTool").new(self.m_toolBar, self.map_))

    -- -- 创建工具栏的视图
    -- self.toolbarView_ = self.toolbar_:createView(self.uiLayer_, "#ToolbarBg.png", EditorConstants.TOOLBAR_PADDING, self.editorUIScale, self.toolbarLines)
    -- self.toolbarView_:setPosition(display.c_left, display.c_bottom)
    -- self.toolbar_:setDefaultTouchTool("GeneralTool")
    -- self.toolbar_:selectButton("GeneralTool", 1)

    -- -- 创建对象信息面板
    -- local objectInspectorScale = 1
    -- -- if self.editorUIScale > 1 then
    -- --     objectInspectorScale = 1.5
    -- -- end
    -- self.objectInspector_ = require("editor.ObjectInspector").new(self.map_, objectInspectorScale, self.toolbarLines)
    -- self.objectInspector_:addEventListener("UPDATE_OBJECT", function(event)
    --     self.toolbar_:dispatchEvent(event)
    -- end)
    -- self.objectInspector_:createView(self.uiLayer_)

    -- -- 创建地图名称文字标签
    -- self.mapNameLabel_ = cc.ui.UILabel.new({
    --     text  = string.format("module: %s, image: %s", self.map_.mapModuleName_, self.map_.imageName_),
    --     size  = 16 * self.editorUIScale,
    --     align = cc.ui.TEXT_ALIGN_LEFT,
    --     x     = display.left + 10,
    --     y     = display.bottom + EditorConstants.MAP_TOOLBAR_HEIGHT * self.editorUIScale * self.toolbarLines + 20,
    -- }):align(display.CENTER)
    -- self.mapNameLabel_:enableOutline(cc.c4b(255, 0, 0), 2)
    -- self.mapLayer_:addChild(self.mapNameLabel_)

    -- -- 注册工具栏事件
    -- self.toolbar_:addEventListener("SELECT_OBJECT", function(event)
    --     self.objectInspector_:setObject(event.object)
    -- end)
    -- self.toolbar_:addEventListener("UPDATE_OBJECT", function(event)
    --     self.objectInspector_:setObject(event.object)
    -- end)
    -- self.toolbar_:addEventListener("UNSELECT_OBJECT", function(event)
    --     self.objectInspector_:removeObject()
    -- end)
    -- self.toolbar_:addEventListener("PLAY_MAP", function()
    --     self:playMap()
    -- end)

    -- -- 创建运行地图时的工具栏
    -- self.playToolbar_ = display.newNode()
    -- if (device.platform == "mac" or device.platform == "windows") then

    -- cc.ui.UIPushButton.new({normal = "#ToggleDebugButton.png", pressed = "#ToggleDebugButtonSelected.png"})
    --     :onButtonClicked(function(event)
    --         self.map_:setDebugViewEnabled(not self.map_:isDebugViewEnabled())
    --     end)
    --     :align(display.CENTER, display.left + 32 * self.editorUIScale, display.top - 32 * self.editorUIScale)
    --     :addTo(self.playToolbar_)
    --     :setScale(self.editorUIScale)

    -- cc.ui.UIPushButton.new({normal = "#StopMapButton.png", pressed = "#StopMapButtonSelected.png"})
    --     :onButtonClicked(function(event)
    --         self:editMap()
    --     end)
    --     :align(display.CENTER, display.left + 88 * self.editorUIScale, display.top - 32 * self.editorUIScale)
    --     :addTo(self.playToolbar_)
    --     :setScale(self.editorUIScale)

    -- else

    -- self.recordBtnBg_ = cc.LayerColor:create(cc.c4b(255, 255, 255, 120)):addTo(self)
    -- self.recordBtnBg_:setTouchEnabled(false)
    -- self.recordBtn_ = cc.ui.UIPushButton.new("GreenButton.png", {scale9 = true})
    --     :setButtonLabel(cc.ui.UILabel.new({text = "开始性能测试", size = 20, color = display.COLOR_BLACK}))
    --     :setButtonSize(130, 40)
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self.recordBtnBg_)  
    --     :onButtonClicked(function()
    --         self.mapLayer_:setPositionY(60)
    --         -- self.mapRuntime_:setPositionY(60)
    --         self.mapRuntime_:startPlay()

    --         self:disabelResult()
    --         self:disableStatus()

    --         self:showStatusCurve()
    --         self:statusTimerBegin()

    --         self.recordBtnBg_:removeSelf()
    --         self.recordBtnBg_ = nil
    --     end)

    -- end

    -- -- local toggleDebugButton = ui.newImageMenuItem({
    -- --     image         = "#ToggleDebugButton.png",
    -- --     imageSelected = "#ToggleDebugButtonSelected.png",
    -- --     x             = display.left + 32 * self.editorUIScale,
    -- --     y             = display.top - 32 * self.editorUIScale,
    -- --     listener      = function()
    -- --         self.map_:setDebugViewEnabled(not self.map_:isDebugViewEnabled())
    -- --     end
    -- -- })
    -- -- toggleDebugButton:setScale(self.editorUIScale)

    -- -- local stopMapButton = ui.newImageMenuItem({
    -- --     image         = "#StopMapButton.png",
    -- --     imageSelected = "#StopMapButtonSelected.png",
    -- --     x             = display.left + 88 * self.editorUIScale,
    -- --     y             = display.top - 32 * self.editorUIScale,
    -- --     listener      = function() self:editMap() end
    -- -- })
    -- -- stopMapButton:setScale(self.editorUIScale)

    -- -- self.playToolbar_ = ui.newMenu({toggleDebugButton, stopMapButton})
    -- self.playToolbar_:setVisible(false)
    -- self:addChild(self.playToolbar_)

    -- if (device.platform == "mac" or device.platform == "windows") then
    --     self:editMap()
    -- else
    --     self:playMap()
    -- end
end

function TowerDefenceScene:run()

end

function TowerDefenceScene:onEnter()
	
end

function TowerDefenceScene:onExit()

end


return TowerDefenceScene;