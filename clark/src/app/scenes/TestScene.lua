local gameState = require("framework.cc.utils.GameState");

local TestScene = class("TestScene",function()
	return display.newScene("TestScene");
end)

function TestScene:ctor()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 50,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"zoomFlipX",0.7,cc.TRANSITION_ORIENTATION_DOWN_OVER);
	end);

	self.m_items = {
		"framework.helper",
        "framework.native",
        "framework.display",
        "framework.crypto",
        "framework.network",
        "framework.luabinding",
        "framework.event",
        "framework.interface",
        "framework.socketTcp",
        "framework.timer",
        "framework.gamestate",
        "framework.transition",
        "framework.nvgdrawnode"
	};

	local rect = cc.rect(display.cx - 200, display.bottom + 100, 400, display.height - 200);
	self.m_listView = UICreator.createListView(UIConfig.LISTVIEW.VERTICAL,nil,rect);
	self.m_listView:addTo(self);

	self.bListViewMove = false;

	self.m_listView:onScroll(function(event)
		if "moved" == event.name then
        	self.bListViewMove = true;
		elseif "ended" == event.name then
            self.bListViewMove = false;
		end
    end);

    for i, v in ipairs(self.m_items) do
        local item = self.m_listView:newItem();
        local content;

        local label = UICreator.createText(v,24,display.CENTER,display.cx,display.cy,0,0,255);
        content = UICreator.createBtnText(nil,false,display.cx,display.cy,display.CENTER,200,40,label);
        content:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
        content:onButtonRelease(function(event)
        	event.target:setOpacity(255);
        end);
        content:onButtonClicked(function(event)
            if self.bListViewMove then
                return;
            end
			
			self.m_listView:setVisible(false);

			if i == 1 then
				self:createHelperTest();
			elseif i == 2 then 
				self:createNativeTest();
            elseif i == 3 then 
                display.setTexturePixelFormat("Coin0001.png", cc.TEXTURE2D_PIXEL_FORMAT_RGB565);
                display.setTexturePixelFormat("blocks9ss.png", cc.TEXTURE2D_PIXEL_FORMAT_RGB565);
                self:createDisplayTest();
            elseif i == 4 then 
                self:createCrypToTest();
            elseif i == 5 then
                self:createNetworkTest();
            elseif i == 6 then 
                self:createLuaBindingTest();
            elseif i == 7 then
                self:createEventTest();
            elseif i == 8 then
                self:createInterfaceTest();
            elseif i == 9 then 
                self:createLuaSocketTCPTest();
            elseif i == 10 then
                self:createTimerTest();
            elseif i == 11 then 
                self:createGameStateTest();
            elseif i == 12 then 
                self:createTransitionTest();
            elseif i == 13 then 
                self:createNvgdrawnodeTest();
			end            	
        end);

        content:setTouchSwallowEnabled(false);
        item:addContent(content);
        item:setItemSize(120, 40);

        self.m_listView:addItem(item);
    end
    self.m_listView:reload();

    local returnText = UICreator.createText("RETURN",24,display.CENTER,display.left,display.cy,0,0,255);
    local contentSize = returnText:getContentSize();
    self.m_ReturnButton = UICreator.createBtnText(nil,nil,display.left + contentSize.width,display.cy,display.CENTER,155,60,returnText);
    self.m_ReturnButton:addTo(self);

    self.m_ReturnButton:onButtonPressed(function(event)
      	event.target:setOpacity(128);
    end);
	self.m_ReturnButton:onButtonRelease(function(event)
       	event.target:setOpacity(255);
    end);
    self.m_ReturnButton:onButtonClicked(function(event)
    	self:showMainView();
    end); 

    self.m_ReturnButton:setVisible(false);
end

function TestScene:showMainView()
	self.m_listView:setVisible(true);
	self:hideHelperTest();
	self:hideNativeTest();
    self:hideDisplayTest();
    self:hideCrypToTest();
    self:hideNetworkTest();
    self:hideLuaBindingTest();
    self:hideEventTest();
    self:hideInterfaceTest();
    self:hideLuaSocketTCPTest();
    self:hideTimerTest();
    self:hideGameStateTest();
    self:hideTransitionTest();
    self:hideNvgdrawnodeTest();
end

function TestScene:run()
end

function TestScene:exit()
end

function TestScene:createHelperTest()
	self.m_ReturnButton:setVisible(true);

	if self.m_title then 
		self.m_title:setVisible(true);
		self.m_button1:setVisible(true);
		return;
	end

	self.m_title = UICreator.createText("getFileData",35,display.CENTER,display.cx,display.top - 80,255,255,255);
	self.m_title:addTo(self);

	local label = UICreator.createText("getFileData -- check console output",24,display.CENTER,display.cx,display.cy,255,255,0);
	self.m_button1 = UICreator.createBtnText(nil,false,display.cx,display.cy,display.CENTER,155,60,label);
	self.m_button1:addTo(self);

	self.m_button1:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_button1:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_button1:onButtonClicked(function(event)
    	cc.FileUtils:getInstance():addSearchPath("src/");
    	print(cc.HelperFunc:getFileData("config.lua"));   
    end); 

end

function TestScene:hideHelperTest()
	if self.m_title then 
		self.m_title:setVisible(false);
		self.m_button1:setVisible(false);
	end
	self.m_ReturnButton:setVisible(false);
end

function TestScene:createNativeTest()
	self.m_ReturnButton:setVisible(true);
    if self.m_title2 then 
        self.m_title2:setVisible(true);
        self.m_native_indicator:setVisible(true);
        self.m_native_alertBtn:setVisible(true);
        self.m_native_openBrowser:setVisible(true);
        self.m_native_callPhone:setVisible(true);
        self.m_native_sendEmail:setVisible(true);
        self.m_native_getInput:setVisible(true);
        self.m_native_viberate:setVisible(true);
        self.m_native_deviceName:setVisible(true);
        return ;
    end

	local param_distance = 50;

	local y = display.top - 150;

	self.m_title2 = UICreator.createText("NativeTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
	self.m_title2:addTo(self);

	local label = UICreator.createText("activityIndicator -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_indicator = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_indicator:addTo(self);

	self.m_native_indicator:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_indicator:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_indicator:onButtonClicked(function(event)
    	print("Hide activity indicator after 2s.");
    	device.showActivityIndicator();

    	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
	    function onTimer(dt)
	        device.hideActivityIndicator();
	        if self.handle then 
	            scheduler.unscheduleGlobal(self.handle);
	        end
	    end
    	self.handle = scheduler.scheduleGlobal(onTimer, 2.0, false);
    end); 

    y = y - param_distance;

    label = UICreator.createText("showAlert -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_alertBtn = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_alertBtn:addTo(self);

	self.m_native_alertBtn:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_alertBtn:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_alertBtn:onButtonClicked(function(event)
    	local function onButtonClicked(event)
	        if event.buttonIndex == 1 then
	            print("玩家选择了 YES 按钮");
	        else
	            print("玩家选择了 NO 按钮");
	        end
	    end

    	device.showAlert("Confirm ", "Are you sure ?", {"YES", "NO"}, onButtonClicked);
    end); 

    y = y - param_distance;

    label = UICreator.createText("openWebBrowser",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_openBrowser = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_openBrowser:addTo(self);

	self.m_native_openBrowser:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_openBrowser:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_openBrowser:onButtonClicked(function(event)
    	print("open browser");
    	device.openURL("http://www.baidu.com");
    end); 

    y = y - param_distance;

    label = UICreator.createText("callPhone",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_callPhone = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_callPhone:addTo(self);

	self.m_native_callPhone:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_callPhone:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_callPhone:onButtonClicked(function(event)
    	print("tel:000:000:000");
    	device.openURL("tel:123-456-7890");
    end); 

    y = y - param_distance;

    label = UICreator.createText("sendEmail",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_sendEmail = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_sendEmail:addTo(self);

	self.m_native_sendEmail:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_sendEmail:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_sendEmail:onButtonClicked(function(event)
    	-- 打开设备上的邮件程序，并创建新邮件，填入收件人地址
    	print("sendEmail");
    	-- 增加主题和内容
	    local subject = string.urlencode("Hello");
	    local body = string.urlencode("How are you ?");
	    device.openURL(string.format("mailto:nobody@mycompany.com?subject=%s&body=%s", subject, body));
    end); 

    y = y - param_distance;

    label = UICreator.createText("getInputText",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_getInput = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_getInput:addTo(self);

	self.m_native_getInput:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_getInput:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_getInput:onButtonClicked(function(event)
    	-- 打开设备上的邮件程序，并创建新邮件，填入收件人地址
    	print("getInputText");
    	-- 增加主题和内容
	    cc.Native:getInputText("Information", "How weight are you (KG)", "60");
    end); 

    y = y - param_distance;

    label = UICreator.createText("viberate",24,display.CENTER,display.cx,display.top - 100,255,255,0);
	self.m_native_viberate = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
	self.m_native_viberate:addTo(self);

	self.m_native_viberate:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_native_viberate:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_native_viberate:onButtonClicked(function(event)
    	-- 打开设备上的邮件程序，并创建新邮件，填入收件人地址
    	print("viberate");
    	-- 增加主题和内容
	    cc.Native:vibrate();
    end); 

    y = y - param_distance;

    label = UICreator.createText("device name",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_deviceName = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_deviceName:addTo(self);

    self.m_native_deviceName:onButtonPressed(function(event)
            event.target:setOpacity(128);
        end);
    self.m_native_deviceName:onButtonRelease(function(event)
            event.target:setOpacity(255);
    end);
    self.m_native_deviceName:onButtonClicked(function(event)
       print("The device name is: ", cc.Native:getDeviceName());
        print("The device uuid is: ", device.getOpenUDID());
    end); 
end

function TestScene:hideNativeTest()
	self.m_ReturnButton:setVisible(false);
	if self.m_title2 then 
		self.m_title2:setVisible(false);
		self.m_native_indicator:setVisible(false);
		self.m_native_alertBtn:setVisible(false);
		self.m_native_openBrowser:setVisible(false);
		self.m_native_callPhone:setVisible(false);
		self.m_native_sendEmail:setVisible(false);
		self.m_native_getInput:setVisible(false);
		self.m_native_viberate:setVisible(false);
        self.m_native_deviceName:setVisible(false);
	end
end

function TestScene:createDisplayTest()
    self.m_ReturnButton:setVisible(true);
    if self.m_title3 then 
       self.m_title3:setVisible(true);
       self.m_native_addImageAsync:setVisible(true);
       self.m_native_addSprite:setVisible(true);
       self.m_native_tileSprite:setVisible(true);
       self.m_native_tiledBatchNode:setVisible(true);
       self.m_native_drawNode:setVisible(true);
       self.m_native_progress:setVisible(true);
       self.m_native_layerMultiTouch:setVisible(true);
       return; 
   end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title3 = UICreator.createText("DisplayTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title3:addTo(self);

    local label = UICreator.createText("addImageAsync -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_addImageAsync = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_addImageAsync:addTo(self);

    self.m_native_addImageAsync:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_addImageAsync:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_addImageAsync:onButtonClicked(function(event)
        print("display.removeSpriteFrameByImageName(\"Coin0001.png\")");
        display.removeSpriteFrameByImageName("Coin0001.png");
        print("display.addImageAsync(\"Coin0001.png\")");
        display.addImageAsync("Coin0001.png", function(event, texture)
            printf("display.addImageAsync(\"Coin0001.png\") - event = %s, texture = %s", tostring(event), tostring(texture));
            self.m_coin = UICreator.createImg("Coin0001.png",true, display.left + 100, display.cy,96,96);
            self.m_coin:addTo(self);        
        end);
    end);

    y = y - param_distance;

    local label = UICreator.createText("scale9Sprite -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_addSprite = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_addSprite:addTo(self);

    self.m_native_addSprite:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_addSprite:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_addSprite:onButtonClicked(function(event)
        if self.m_sprite then
            self.m_sprite:setVisible(true);
            transition.fadeOut(self.m_sprite, {time = 1.5, delay = 1});
            transition.fadeIn(self.m_sprite, {time = 1.5, delay = 3});
            return;
        end
        self.m_sprite = UICreator.createImg("GreenButton.png",true,display.left+100,display.cy,140,300);
        self.m_sprite:addTo(self);

        transition.fadeOut(self.m_sprite, {time = 1.5, delay = 1});
        transition.fadeIn(self.m_sprite, {time = 1.5, delay = 3});
    end);

    y = y - param_distance;

    local label = UICreator.createText("tilesSprite -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_tileSprite = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_tileSprite:addTo(self);

    self.m_native_tileSprite:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_tileSprite:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_tileSprite:onButtonClicked(function(event)
        if self.m_tilesSprite then 
            self.m_tilesSprite:setVisible(true);
            return;
        end
        self.m_tilesSprite = display.newTilesSprite("close.png", cc.rect(10, 10, 100, 100))
        :pos(display.left + 10, display.bottom + 10)
        :addTo(self);
    end);

    y = y - param_distance;

    local label = UICreator.createText("tiledBatchNode -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_tiledBatchNode = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_tiledBatchNode:addTo(self);

    self.m_native_tiledBatchNode:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_tiledBatchNode:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_tiledBatchNode:onButtonClicked(function(event)
        if self.m_tiledBatchNode then
            self.m_tiledBatchNode:setVisible(true);
            return;
        end
        local cb = function(plist, image)
            self.m_tiledBatchNode = display.newTiledBatchNode("#blocks9.png", "blocks9ss.png", cc.size(170, 170), 10, 10)
                :pos(display.left + 10, display.bottom + 150)
                :addTo(self);
        end
        display.addSpriteFrames("blocks9ss.plist", "blocks9ss.png", cb);
    end);

    y = y - param_distance;

    local label = UICreator.createText("drawNode -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_drawNode = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_drawNode:addTo(self);

    self.m_native_drawNode:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_drawNode:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_drawNode:onButtonClicked(function(event)
        if self.m_drawNode then 
            self.m_drawNode:setVisible(true);
            return;
        end
        self.m_drawNode = display.newNode();
        self.m_drawNode:addTo(self);

        local solidCircle = display.newSolidCircle(20,
            {x = 30, y = 50, color = cc.c4f(1, 1, 1, 1)})
            :addTo(self.m_drawNode, 100, 101);

        local circle = display.newCircle(50,
            {x = display.right - 100, y = display.bottom + 100,
            fillColor = cc.c4f(1, 0, 0, 1),
            borderColor = cc.c4f(0, 1, 0, 1),
            borderWidth = 2})
            :addTo(self.m_drawNode, 100);

        local rect = display.newRect(cc.rect(30, 200, 80, 80),
            {fillColor = cc.c4f(1,0,0,1), borderColor = cc.c4f(0,1,0,1), borderWidth = 5})
            :addTo(self.m_drawNode, 100, 101);

        local line = display.newLine(
            {
                {10, 10},
                {200, 30}
            },
            {
                borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
                borderWidth = 1
            })
            :addTo(self.m_drawNode, 100, 101);

        local points = {
            {10, 120},  -- point 1
            {50, 160},  -- point 2
            {100, 120}, -- point 3
        };
        local polygon = display.newPolygon(points,
            {
                borderColor = cc.c4f(0, 1, 0, 1)
            })
            :addTo(self.m_drawNode, 100);

    end);

    y = y - param_distance;

    local label = UICreator.createText("progress -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_progress = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_progress:addTo(self);

    self.m_native_progress:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_progress:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_progress:onButtonClicked(function(event)
        if self.m_progress then 
            self.m_progress:setVisible(true);
            return;
        end
        self.m_progress = display.newProgressTimer("Coin0001.png", display.PROGRESS_TIMER_RADIAL)
            :pos(100, 100)
            :addTo(self);
        self.m_progress:setPercentage(60);
    end);

     y = y - param_distance;

    local label = UICreator.createText("layerMultiTouch -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_native_layerMultiTouch = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_native_layerMultiTouch:addTo(self);

    self.m_native_layerMultiTouch:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_native_layerMultiTouch:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_native_layerMultiTouch:onButtonClicked(function(event)
        local function onTouch(event, points)
            print("----------------------------------------");
            print(event);
            for i = 1, #points, 3 do
                local x = points[i];
                local y = points[i + 1];
                local id = points[i + 2];
                print(x, y, id);
            end
            self.m_layerTouch:setVisible(false);
            return true;
        end

        self.onTouch = onTouch;
        self.m_layerTouch = display.newLayer();
        self.m_layerTouch:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:onTouch(event.name, event.points);
        end)
        self.m_layerTouch:setTouchEnabled(true);
        self.m_layerTouch:addTo(self);
    end);

end

function TestScene:hideDisplayTest()
   self.m_ReturnButton:setVisible(false);
   if self.m_coin then     
       self.m_coin:setVisible(false);
   end
   if self.m_sprite then 
       self.m_sprite:setVisible(false);
   end
   if self.m_tiledBatchNode then
       self.m_tiledBatchNode:setVisible(false);
   end
   if self.m_tilesSprite then
       self.m_tilesSprite:setVisible(false);
   end
   if self.m_drawNode then 
       self.m_drawNode:setVisible(false);
   end
   if self.m_progress then
       self.m_progress:setVisible(false);
   end
   if self.m_layerTouch then 
       self.m_layerTouch:setVisible(false);
   end

   if self.m_title3 then 
       self.m_title3:setVisible(false);
       self.m_native_addImageAsync:setVisible(false);
       self.m_native_addSprite:setVisible(false);
       self.m_native_tileSprite:setVisible(false);
       self.m_native_tiledBatchNode:setVisible(false);
       self.m_native_drawNode:setVisible(false);
       self.m_native_progress:setVisible(false);
       self.m_native_layerMultiTouch:setVisible(false);
   end
end

function TestScene:createCrypToTest()
    self.m_ReturnButton:setVisible(true);

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title4 = UICreator.createText("CryptoTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title4:addTo(self);

    local label = UICreator.createText("AES256 -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_crypto_AES256 = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_crypto_AES256:addTo(self);

    self.m_crypto_AES256:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_crypto_AES256:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_crypto_AES256:onButtonClicked(function(event)
        local p = "Test123";
        local k = "KEYKEY";
        local c = crypto.encryptAES256(p, k);
        if not c then
            return;
        end
        printf("source: %s", p);
        printf("encrypt AES256: %s", self:bin2hex(c));
        printf("decrypt AES256: %s", crypto.decryptAES256(c, k));

        local p = string.rep("HELLO", 15);
        local c = crypto.encryptAES256(p, k);
        printf("source: %s", p);
        printf("encrypt AES256: %s", self:bin2hex(c));
        printf("decrypt AES256: %s", crypto.decryptAES256(c, k));
    end);

    y = y - param_distance;

    local label = UICreator.createText("XXTEA -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_crypto_XXTEA = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_crypto_XXTEA:addTo(self);

    self.m_crypto_XXTEA:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_crypto_XXTEA:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_crypto_XXTEA:onButtonClicked(function(event)
        local p = "Test123";
        local k = "KEYKEY";
        local c = crypto.encryptXXTEA(p, k);
        printf("source: %s", p);
        printf("encrypt XXTEA: %s", self:bin2hex(c));
        printf("decrypt XXTEA: %s", crypto.decryptXXTEA(c, k));

        local p = string.rep("HELLO", 15);
        local k = "keykey";
        local c = crypto.encryptXXTEA(p, k);
        printf("source: %s", p);
        printf("encrypt XXTEA: %s", self:bin2hex(c));
        printf("decrypt XXTEA: %s", crypto.decryptXXTEA(c, k));
    end);

    y = y - param_distance;

    local label = UICreator.createText("Base64 -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_crypto_Base64 = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_crypto_Base64:addTo(self);

    self.m_crypto_Base64:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_crypto_Base64:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_crypto_Base64:onButtonClicked(function(event)
        local p = "Test123";
        local c = crypto.encodeBase64(p);
        printf("source: %s", p);
        printf("encode Base64: %s", c);
        printf("decode Base64: %s", crypto.decodeBase64(c));

        local p = string.rep("HELLO", 15);
        local c = crypto.encodeBase64(p);
        printf("source: %s", p);
        printf("encode Base64: %s", c);
        printf("decode Base64: %s", crypto.decodeBase64(c));
    end);

    y = y - param_distance;

    local label = UICreator.createText("MD5File -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_cryptoMD5File = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_cryptoMD5File:addTo(self);

    self.m_cryptoMD5File:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_cryptoMD5File:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_cryptoMD5File:onButtonClicked(function(event)
        local file = cc.FileUtils:getInstance():fullPathForFilename("config.lua");
        printf("md5 file test: %s -> %s", file, crypto.md5file(file));
    end);

    y = y - param_distance;

    local label = UICreator.createText("MD5 -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_cryptoMD5 = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_cryptoMD5:addTo(self);

    self.m_cryptoMD5:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_cryptoMD5:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_cryptoMD5:onButtonClicked(function(event)
        local p = string.rep("HELLO", 5);-- HELLOHELLOHELLOHELLOHELLO
        printf("md5Test: %s -> %s", p, crypto.md5(p));
    end);

end

function TestScene:hideCrypToTest()
    if self.m_title4 then
        self.m_title4:setVisible(false);
        self.m_crypto_AES256:setVisible(false);
        self.m_crypto_XXTEA:setVisible(false);
        self.m_crypto_Base64:setVisible(false);
        self.m_cryptoMD5File:setVisible(false);
        self.m_cryptoMD5:setVisible(false);
    end
end

function TestScene:bin2hex(bin)
    local t = {};
    for i = 1, string.len(bin) do
        local c = string.byte(bin, i, i);
        t[#t + 1] = string.format("%02x", c);
    end
    return table.concat(t, " ");
end

function TestScene:createNetworkTest()
    self.m_ReturnButton:setVisible(true);
    if self.m_title5 then 
        self.m_title5:setVisible(true);
        self.m_network_createHTTPRequest:setVisible(true);
        self.m_network_createHTTPRequestBadDomain:setVisible(true);
        self.m_network_sendData:setVisible(true);
        self.m_network_wifiAvailable:setVisible(true);
        self.m_network_internetConnectionAvailable:setVisible(true);
        self.m_network_internetHostNameReachable:setVisible(true);
        self.m_network_getNetConnection:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title5 = UICreator.createText("NetworkTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title5:addTo(self);

    self.requestCount = 0;

    local label = UICreator.createText("createHTTPRequest -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_createHTTPRequest = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_createHTTPRequest:addTo(self);

    self.m_network_createHTTPRequest:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_createHTTPRequest:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_createHTTPRequest:onButtonClicked(function(event)
        local url = "http://baidu.com";
        self.requestCount = self.requestCount + 1;
        local index = self.requestCount;
        local request = network.createHTTPRequest(function(event)
            if tolua.isnull(self) then
                printf("REQUEST %d COMPLETED, BUT SCENE HAS QUIT", index);
                return
            end
            self:onResponse(event, index);
        end, url, "GET");
        printf("REQUEST START %d", index);
        request:start();
    end);

    y = y - param_distance;

    local label = UICreator.createText("createHTTPRequestBadDomain -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_createHTTPRequestBadDomain = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_createHTTPRequestBadDomain:addTo(self);

    self.m_network_createHTTPRequestBadDomain:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_createHTTPRequestBadDomain:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_createHTTPRequestBadDomain:onButtonClicked(function(event)
        self.requestCount = self.requestCount + 1;
        local index = self.requestCount;
        local request = network.createHTTPRequest(function(event)
            if tolua.isnull(self) then
                printf("REQUEST %d COMPLETED, BUT SCENE HAS QUIT", index);
                return;
            end
            self:onResponse(event, index);
        end, "http://quick-x.com.x.y.z.not/", "GET");
        printf("REQUEST START %d", index);
        request:start();
    end);

    y = y - param_distance;

    local label = UICreator.createText("send data to server -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_sendData = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_sendData:addTo(self);

    self.m_network_sendData:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_sendData:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_sendData:onButtonClicked(function(event)
        print("send data to server");
        self.requestCount = self.requestCount + 1;
        local index = self.requestCount;
        local request = network.createHTTPRequest(function(event)
            if tolua.isnull(self) then
                printf("REQUEST %d COMPLETED, BUT SCENE HAS QUIT", index);
                return;
            end
            self:onResponse(event, index, true);

            if event.name == "completed" then
                local cookie = network.parseCookie(event.request:getCookieString());
                dump(cookie, "GET COOKIE FROM SERVER");
            end
        end, "http://quick-x.com/tests/http_request_tests.php", "POST");
        request:addPOSTValue("username", "dualface");
        request:setCookieString(network.makeCookieString({C1 = "V1", C2 = "V2"}));
        printf("REQUEST START %d", index);
        request:start();
    end);

    y = y - param_distance;

    local label = UICreator.createText("isLocalWiFiAvailable -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_wifiAvailable = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_wifiAvailable:addTo(self);

    self.m_network_wifiAvailable:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_wifiAvailable:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_wifiAvailable:onButtonClicked(function(event)
       print("Is local wifi avaibable: ", network.isLocalWiFiAvailable());
    end);

    y = y - param_distance;

    local label = UICreator.createText("isInternetConnectionAvailable -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_internetConnectionAvailable = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_internetConnectionAvailable:addTo(self);

    self.m_network_internetConnectionAvailable:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_internetConnectionAvailable:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_internetConnectionAvailable:onButtonClicked(function(event)
       print("Is internet connection avaibable: ", network.isInternetConnectionAvailable());
    end);

    y = y - param_distance;

    local label = UICreator.createText("isHostNameReachable -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_internetHostNameReachable = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_internetHostNameReachable:addTo(self);

    self.m_network_internetHostNameReachable:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_internetHostNameReachable:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_internetHostNameReachable:onButtonClicked(function(event)
       print("Is www.cocos2d-x.org reachable: ", network.isHostNameReachable("www.cocos2d-x.org"));
    end);

    y = y - param_distance;

    local label = UICreator.createText("getInternetConnectionStatus -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_network_getNetConnection = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_network_getNetConnection:addTo(self);

    self.m_network_getNetConnection:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_network_getNetConnection:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_network_getNetConnection:onButtonClicked(function(event)
        local status = {
            [cc.kCCNetworkStatusNotReachable]     = "无法访问互联网",
            [cc.kCCNetworkStatusReachableViaWiFi] = "通过 WIFI",
            [cc.kCCNetworkStatusReachableViaWWAN] = "通过 3G 网络",
        }

        printf("Internet Connection Status: %s", status[network.getInternetConnectionStatus()]);
    end);
end

function TestScene:hideNetworkTest()
    if self.m_title5 then 
        self.m_title5:setVisible(false);
        self.m_network_createHTTPRequest:setVisible(false);
        self.m_network_createHTTPRequestBadDomain:setVisible(false);
        self.m_network_sendData:setVisible(false);
        self.m_network_wifiAvailable:setVisible(false);
        self.m_network_internetConnectionAvailable:setVisible(false);
        self.m_network_internetHostNameReachable:setVisible(false);
        self.m_network_getNetConnection:setVisible(false);
    end
end

function TestScene:onResponse(event, index, dumpResponse)
    local request = event.request;
    printf("REQUEST %d - event.name = %s", index, event.name);
    if event.name == "completed" then
        printf("REQUEST %d - getResponseStatusCode() = %d", index, request:getResponseStatusCode());
        -- printf("REQUEST %d - getResponseHeadersString() =\n%s", index, request:getResponseHeadersString())

        if request:getResponseStatusCode() ~= 200 then
        else
            printf("REQUEST %d - getResponseDataLength() = %d", index, request:getResponseDataLength());
            print("dump:" .. tostring(dumpResponse));
            if dumpResponse then
                printf("REQUEST %d - getResponseString() =\n%s", index, request:getResponseString());
            end
        end
    elseif event.name ~= "progress" then
        -- printf("REQUEST %d - getErrorCode() = %d, getErrorMessage() = %s", index, request:getErrorCode(), request:getErrorMessage())
        print("ErrorCode:" .. tostring(request:getErrorCode()));
        print("ErrowMsg:" .. tostring(request:getErrorMessage()));
    end

    print("----------------------------------------");
end

function TestScene:createLuaBindingTest()
    self.m_ReturnButton:setVisible(true);
    if self.m_title6 then
        self.m_title6:setVisible(true);
        self.m_createAvoidPeertableGc:setVisible(true);
        self.m_getCppFunctionTest:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title6 = UICreator.createText("LuaBindingTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title6:addTo(self);

    self.requestCount = 0;

    local label = UICreator.createText("avoidPeertableGC -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_createAvoidPeertableGc = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_createAvoidPeertableGc:addTo(self);

    self.m_createAvoidPeertableGc:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_createAvoidPeertableGc:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_createAvoidPeertableGc:onButtonClicked(function(event)
        if self.m_gc_node then
            self.m_gc_node:setVisible(true);
            return;
        end
        self.m_gc_node = display.newNode();
        self.m_gc_node:addNodeEventListener(cc.NODE_EVENT, function(event)
            printf("node event %s", event.name);
        end);
        self.m_gc_node.customVar = 1;
        self.m_gc_node:setTag(1);
        self:addChild(self.m_gc_node);

        printf("1. node.customVar = %s, expected = 1", tostring(self.m_gc_node.customVar)) ;-- 1
        collectgarbage();
        collectgarbage();
        printf("2. node.customVar = %s, expected = 1", tostring(self.m_gc_node.customVar)); -- 1

        self:performWithDelay(function()
            printf("3. node.customVar = %s, expected = 1", tostring(self:getChildByTag(1).customVar)); -- 1
            local node2 = self:getChildByTag(1);
            collectgarbage();
            collectgarbage();
            printf("4. node.customVar = %s, expected = 1", tostring(node2.customVar)); -- 1
            self:removeChildByTag(1);
            self.m_gc_node = nil;
            printf("5. node = %s, expected = nil", tostring(self:getChildByTag(1))); -- nil
            printf("6. node.customVar = %s, expected = nil", tostring(node2.customVar));-- nil
        end, 1.0);
    end);

    y = y - param_distance;

    local label = UICreator.createText("getCppFunction -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_getCppFunctionTest = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_getCppFunctionTest:addTo(self);

    self.m_getCppFunctionTest:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_getCppFunctionTest:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_getCppFunctionTest:onButtonClicked(function(event)
        function cc.Node:setPosition(x, y)
            printf("cc.Node:setPosition(%0.2f, %0.2f)", x, y);
            -- call origin C++ method
            local cfunction = tolua.getcfunction(cc.Node, "setPosition");
            cfunction(self, x, y);
        end

        local node = display.newNode();
        self:addChild(node);
        print("expected 'cc.Node:setPosition(100.00, 100.00)'");
        node:setPosition(100, 100); -- cc.Node:setPosition(100.00, 100.00)
        local x, y = node:getPosition();
        printf("x, y = %0.2f, %0.2f, expected 100.00, 100.00", x, y);

        -- restore C++ method
        cc.Node.setPosition = tolua.getcfunction(cc.Node, "setPosition");
        print("expected - no output");
        node:setPosition(100, 100);
    end);
end

function TestScene:hideLuaBindingTest()
    if self.m_gc_node then
        self.m_gc_node:setVisible(false);
        self:removeChildByTag(1);
        self.m_gc_node = nil;
    end

    if self.m_title6 then
        self.m_title6:setVisible(false);
        self.m_createAvoidPeertableGc:setVisible(false);
        self.m_getCppFunctionTest:setVisible(false);
    end


end

function TestScene:createEventTest()
    self.m_ReturnButton:setVisible(true);

    local param_distance = 50;

    local y = display.top - 150;

    self:initEventTest();
    if self.m_title7 then 
        self.m_title7:setVisible(true);
        self.m_addEventListener:setVisible(true);
        self.m_removeEventListener:setVisible(true);
        self.m_removeAllListener:setVisible(true);
        self.m_removeCoin:setVisible(true);
        self.m_sendEvent:setVisible(true);
        return;
    end

    self.m_title7 = UICreator.createText("EventTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title7:addTo(self);

    self.requestCount = 0;

    local label = UICreator.createText("addEventListener -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_addEventListener = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_addEventListener:addTo(self);

    self.m_addEventListener:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_addEventListener:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_addEventListener:onButtonClicked(function(event)
        self.eventProxy:addEventListener("EventTest3", function(event)
             print("event listener 3");
             dump(event);
        end, "tag3");
        self.eventProxy:addEventListener("EventTest4", function(event) 
            print("event listener 4");
            dump(event);
        end);
    end);

    y = y - param_distance;

    local label = UICreator.createText("removeEventListener -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_removeEventListener = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_removeEventListener:addTo(self);

    self.m_removeEventListener:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_removeEventListener:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_removeEventListener:onButtonClicked(function(event)
        self.eventProxy:removeEventListener(self.eventHandle2);
        local eventHandle1 = self.eventProxy:getEventHandle("EventTest1");
        self.eventProxy:removeEventListener(eventHandle1);
        self.eventProxy:removeAllEventListenersForEvent("EventTest3");
    end);

    y = y - param_distance;

    local label = UICreator.createText("removeAllListener -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_removeAllListener = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_removeAllListener:addTo(self);

    self.m_removeAllListener:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_removeAllListener:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_removeAllListener:onButtonClicked(function(event)
        self.eventProxy:removeAllEventListeners();
    end);

    y = y - param_distance;

    local label = UICreator.createText("removeCoin -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_removeCoin = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_removeCoin:addTo(self);

    self.m_removeCoin:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_removeCoin:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_removeCoin:onButtonClicked(function(event)
        self.coin:removeSelf();
    end);

     y = y - param_distance;

    local label = UICreator.createText("sendEvent -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_sendEvent = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_sendEvent:addTo(self);

    self.m_sendEvent:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_sendEvent:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_sendEvent:onButtonClicked(function(event)
        self.idx = self.idx + 1;
        if self.idx > 4 then
            self.idx = 1;
        end
        self.node:dispatchEvent({name = "EventTest" .. self.idx});
    end);

end

function TestScene:initEventTest()
    self.idx = 0;
    self.node = display.newNode();
    self.node:addTo(self);
    self.coin = display.newSprite("Coin0001.png",
        display.left + 100, display.cy,
        {size = cc.size(200, 200)})
    :addTo(self);

    cc(self.node):addComponent("components.behavior.EventProtocol"):exportMethods();
    self.node:removeComponent("components.behavior.EventProtocol");
    self.node:addComponent("components.behavior.EventProtocol"):exportMethods();
    self.eventProxy = cc.EventProxy.new(self.node, self.coin);
    local scene, eventHandle2 = self.eventProxy
        :addEventListener("EventTest1", function(event) 
            print("event listener 1");
            dump(event);
        end, "tag1")
        :addEventListener("EventTest2", function(event) 
            print("event listener 2");
            dump(event);
        end, 1001);
    self.eventHandle2 = eventHandle2;
end

function TestScene:hideEventTest()
    if self.m_title7 then 
        self.m_title7:setVisible(false);
        self.m_addEventListener:setVisible(false);
        self.m_removeEventListener:setVisible(false);
        self.m_removeAllListener:setVisible(false);
        self.m_removeCoin:setVisible(false);
        self.m_sendEvent:setVisible(false);
    end
end

function TestScene:createInterfaceTest()
    self.m_ReturnButton:setVisible(true);
    if self.m_title8 then 
        self.m_title8:setVisible(true);
        self.m_register_test:setVisible(true);
        self.m_modebase_test:setVisible(true);
        self.m_functions_test:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title8 = UICreator.createText("InterfaceTest",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title8:addTo(self);

    local label = UICreator.createText("register -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_register_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_register_test:addTo(self);

    self.m_register_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_register_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_register_test:onButtonClicked(function(event)
       local register = require("framework.cc.Registry");
       local eventProtocol = register.newObject("components.behavior.EventProtocol");
       if not eventProtocol then
           printError("ERROR some thing wrong please check Register");
       end
       register.setObject(eventProtocol, "cryptoTest1");
       if not register.isObjectExists("cryptoTest1") then
           printError("ERROR some thing wrong please check Register");
       end
       register.getObject("cryptoTest1");
       register.removeObject("cryptoTest1");
       if register.isObjectExists("cryptoTest1") then
           printError("ERROR some thing wrong please check Register");
       end

       if not register.exists("components.behavior.EventProtocol") then
          printError("ERROR some thing wrong please check Register");
       end
    end);

    y = y - param_distance;

    local label = UICreator.createText("modebase -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_modebase_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_modebase_test:addTo(self);

    self.m_modebase_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_modebase_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_modebase_test:onButtonClicked(function(event)
       local mvcBase = require("framework.cc.mvc.ModelBase");
    end);

    y = y - param_distance;

    local label = UICreator.createText("functions -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_functions_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_functions_test:addTo(self);

    self.m_functions_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_functions_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_functions_test:onButtonClicked(function(event)
        -- iskindof
        local Animal = class("Animal");
        local Duck = class("Duck", Animal);
        if not iskindof(Duck.new(), "Animal") then
            printError("ERROR somenthing wrong in iskindof()");
        end

        local subNode = class("subNode", function() 
            return display.newNode(); 
        end).new();
        if not iskindof(subNode, "subNode") then
            printError("ERROR somenthing wrong in iskindof()");
        end

        local val = math.round(0.1);
        print("val want 0, actual is " .. val);
        val = math.round(1.5);
        print("val want 2, actual is " .. val);
        val = math.round("string");
        print("val want 0, actual is " .. val);

        val = math.angle2radian(1);
        print("val want 0.017453292519943, actual is " .. val);
        val = math.radian2angle(1);
        print("val want 57.295779513082, actual is " .. val);

        local path = cc.FileUtils:getInstance():fullPathForFilename("testFile.dat");

        if not io.exists(path) then
            printError("ERROR somenthing wrong in io.exists()");
        end
        print("io.readfile content:" .. io.readfile(path));

        io.writefile(io.pathinfo(path).dirname .. "testFile1.dat", "1232kddk");

        val = io.filesize(path);
        print("io.filesize size:" .. val);

        -- table
        local table1 = {key1 = "val1", "val2", key3 = "val3"};
        local array = {45, 25, "name1", "name2", "same", "htl", "same"};
        val = table.nums(table1);
        print("table.nums want 3, actual " .. val);
        dump(table.keys(table1), "table.keys want {1, key1, key3}, actual:");
        dump(table.values(table1), "table.values want {val2, val1, val3}, actual:");
        
        local table2 = {3, key11 = "val11"};
        table.merge(table2, table1);
        dump(table2, "tabel.merge want {val2, key1 = val1, key11 = val11, key3 = val3, actual:");

        local src = {4, 5};
        local dest = {1, 2};
        table.insertto(dest, src, 4);
        dump(dest, "tabel.insertto want {1, 2, 4, 5, actual:");

        val = table.indexof(dest, 2);
        print("table.indexof want 2, actual " .. val);
        val = table.keyof(table2, "val11");
        print("table.keyof want key11, actual " .. val);

        val = table.removebyvalue(array, "same", true);
        print("table.removebyvalue want 2, actual " .. val);

        local t = {name = "dualface", comp = "chukong"};
        table.map(table2, function(v, k)
            return "[" .. v .. "]";
        end);

        table.walk(table2, function(v, k)
            print(v);
        end)

        table.filter(table2, function(v, k)
            return v ~= "[val11]";
        end)

        table.walk(table2, function(v, k)
            print(v);
        end)

        table2[102] = "same";
        table2[103] = "same";

        table2 = table.unique(table2);
        dump(table2, "should just have one \"same\" value:");

        print(string.htmlspecialchars("<ABC>"));
        print(string.restorehtmlspecialchars(string.htmlspecialchars("<ABC>")));
        print(string.nl2br("Hello\nWorld"));
        print(string.text2html("<Hello>\nWorld"));

        local input = "Hello-+-World-+-Quick";
        local res = string.split(input, "-+-");
        dump(res, "string.split :");

        print(string.ltrim("   ABC"));
        print(string.rtrim("ABC   "));
        print(string.trim("   ABC   "));

        print(string.ucfirst("aBC"));

        print(string.urlencode("ABC ABC"));
        print(string.urldecode(string.urlencode("ABC ABC")));
        print(string.utf8len("你好World"));
        print(string.formatnumberthousands(1924235));
    end);
end

function TestScene:hideInterfaceTest()
    if self.m_title8 then 
        self.m_title8:setVisible(false);
        self.m_register_test:setVisible(false);
        self.m_modebase_test:setVisible(false);
        self.m_functions_test:setVisible(false);
    end
end

function TestScene:createLuaSocketTCPTest()
    self.m_ReturnButton:setVisible(true);
    self:initSocketTCP();
    if self.m_title9 then 
        self.m_title9:setVisible(true);
        self.m_connect_test:setVisible(true);
        self.m_sendData_test:setVisible(true);
        self.m_closeSocket_test:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title9 = UICreator.createText("LuaSocketTCP Test",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title9:addTo(self);

    local label = UICreator.createText("Connect -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_connect_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_connect_test:addTo(self);

    self.m_connect_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_connect_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_connect_test:onButtonClicked(function(event)
        self.m_socket:connect("www.baidu.com", 80, true);
    end);

    y = y - param_distance;

    local label = UICreator.createText("SendData -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_sendData_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_sendData_test:addTo(self);

    self.m_sendData_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_sendData_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_sendData_test:onButtonClicked(function(event)
        self.m_socket:send("TcpSendContent");
    end);

    y = y - param_distance;

    label = UICreator.createText("Close -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_closeSocket_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_closeSocket_test:addTo(self);

    self.m_closeSocket_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_closeSocket_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_closeSocket_test:onButtonClicked(function(event)
        if self.m_socket.isConnected then
            self.m_socket:close();
        end
    end);
end

function TestScene:hideLuaSocketTCPTest()
    if self.m_title9 then 
        self.m_title9:setVisible(false);
        self.m_connect_test:setVisible(false);
        self.m_sendData_test:setVisible(false);
        self.m_closeSocket_test:setVisible(false);
    end
end

function TestScene:initSocketTCP()
    local net = require("framework.cc.net.init");
    local time = net.SocketTCP.getTime();
    print("socket time:" .. time);
    self.m_socket = net.SocketTCP.new();
    self.m_socket:setName("TestSocketTcp");
    self.m_socket:setTickTime(1);
    self.m_socket:setReconnTime(6);
    self.m_socket:setConnFailTime(4);

    self.m_socket:addEventListener(net.SocketTCP.EVENT_DATA, handler(self, self.tcpData));
    self.m_socket:addEventListener(net.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose));
    self.m_socket:addEventListener(net.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed));
    self.m_socket:addEventListener(net.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected));
    self.m_socket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.tcpConnectedFail));
end

function TestScene:tcpData(event)
    print("SocketTCP receive data:" .. event.data);
end

function TestScene:tcpClose()
    print("SocketTCP close");
end

function TestScene:tcpClosed()
    print("SocketTCP closed");
end

function TestScene:tcpConnected()
    print("SocketTCP connect success");
end

function TestScene:tcpConnectedFail()
    print("SocketTCP connect fail");
end

function TestScene:createTimerTest()
    self.m_ReturnButton:setVisible(true);
    if self.m_title10 then
        self.m_title10:setVisible(true);
        self.m_timer_test:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title10 = UICreator.createText("Timer Test",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title10:addTo(self);

    local label = UICreator.createText("Timer -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_timer_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_timer_test:addTo(self);

    self.m_timer_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_timer_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_timer_test:onButtonClicked(function(event)
        if self.m_timer then
            return;
        end

        local Timer = require("framework.cc.utils.Timer");
        self.m_timer = Timer.new();

        -- 响应 CITYHALL_UPGRADE_TIMER 事件
        local function onCityHallUpgradeTimer(event)
            if event.countdown > 0 then
                -- 倒计时还未结束，更新用户界面上显示的时间
                print("timer counting");
            else
                -- 倒计时已经结束，更新用户界面显示升级后的城防大厅
                print("timer over");
                if self.m_timer then
                    self.m_timer:stop();
                    self.m_timer = nil;
                end
            end
        end

        -- 注册事件
        self.m_timer:addEventListener("CITYHALL_UPGRADE_TIMER", onCityHallUpgradeTimer);
        -- 城防大厅升级需要 3600 秒，每 30 秒更新一次界面显示
        self.m_timer:addCountdown("CITYHALL_UPGRADE_TIMER", 600, 10);

        self.m_timer:start();
    end);

end

function TestScene:hideTimerTest()
    if self.m_timer then
        self.m_timer:stop();
        self.m_timer = nil;
    end

    if self.m_title10 then
        self.m_title10:setVisible(false);
        self.m_timer_test:setVisible(false);
    end
end

function TestScene:createGameStateTest()
    self.m_ReturnButton:setVisible(true);

    self:initGameState();
    if self.m_title11 then
        self.m_title11:setVisible(true);
        self.m_load_test:setVisible(true);
        self.m_save_test:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title11 = UICreator.createText("GameState Test",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title11:addTo(self);

    local label = UICreator.createText("Load -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_load_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_load_test:addTo(self);

    self.m_load_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_load_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_load_test:onButtonClicked(function(event)
        gameState.load();
    end);

     y = y - param_distance;

    label = UICreator.createText("Save -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_save_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_save_test:addTo(self);

    self.m_save_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_save_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_save_test:onButtonClicked(function(event)
        local data = {
            appName = "这是游戏名",
            description = "这是一个Quick制作的游戏",
            gate = 2, --已玩到第二关
            topScore = 15862, --玩家达到的最高分值
        }

        gameState.save(data);
    end);


end

function TestScene:hideGameStateTest()
    if self.m_title11 then
        self.m_title11:setVisible(false);
        self.m_load_test:setVisible(false);
        self.m_save_test:setVisible(false);
    end
end

function TestScene:initGameState()
    local stateListener = function(event)
        if event.errorCode then
            print("ERROR, load:" .. event.errorCode);
            return;
        end

        if "load" == event.name then
            local str = crypto.decryptXXTEA(event.values.data, "scertKey");
            local gameData = json.decode(str);
            dump(gameData, "gameData:");
        elseif "save" == event.name then
            local str = json.encode(event.values);
            if str then
                str = crypto.encryptXXTEA(str, "scertKey");
                returnValue = {data = str};
            else
                print("ERROR, encode fail");
                return;
            end

            return {data = str};
        end
    end
    
    gameState.init(stateListener, "gameState.dat", "keyHTL");
end

function TestScene:createTransitionTest()
    self.m_ReturnButton:setVisible(true);
    display.addSpriteFrames("grossini_blue.plist", "grossini_blue.png");
    if self.m_title12 then
        self.m_title12:setVisible(true);
        self.m_start_test:setVisible(true);
        self.m_stop_test:setVisible(true);
        self.m_pause_test:setVisible(true);
        self.m_resume_test:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title12 = UICreator.createText("Transition Test",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title12:addTo(self);

    local label = UICreator.createText("Start -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_start_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_start_test:addTo(self);

    self.m_start_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_start_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_start_test:onButtonClicked(function(event)
        if self.m_coins then
            for i,v in ipairs(self.m_coins) do
                v:removeSelf();
            end
            self.m_coins = nil;
        end

        if self.m_animate then
            for i,v in ipairs(self.m_animate) do
                v:removeSelf();
            end
            self.m_animate = nil;
        end

        self.m_coins = {};
        local coinsCount = 10;

        for i=1, coinsCount do
            self.m_coins[i] = display.newSprite("Coin0001.png"):addTo(self);
            self.m_coins[i]:setPositionX(display.width/coinsCount * (i - 0.5));
        end

        transition.execute(self.m_coins[1], cc.MoveTo:create(1.5, cc.p(display.cx, display.cy)), {
            delay = 1.0,
            easing = "backout",
            onComplete = function()
                print("move completed")
            end,
        });

        -- 耗时 0.5 秒将 sprite 旋转到 180 度
        transition.rotateTo(self.m_coins[2], {rotate = 180, time = 3});

        -- 移动到屏幕上边，不改变 x
        transition.moveTo(self.m_coins[3], {y = display.top, time = 3});

        -- 向右移动 100 点，向上移动 100 点
        transition.moveBy(self.m_coins[4], {x = 200, y = 400, time = 3});

        self.m_coins[5]:setOpacity(0);
        transition.fadeIn(self.m_coins[5], {time = 3});

        transition.fadeOut(self.m_coins[6], {time = 3});

        -- 不管显示对象当前的透明度是多少，最终设置为 128
        transition.fadeTo(self.m_coins[7], {opacity = 128, time = 3});

        -- 整体缩放为 50%
        transition.scaleTo(self.m_coins[8], {scale = 0.5, time = 3});

        local sequence = transition.sequence({
            cc.MoveTo:create(1.0, cc.p(display.cx, display.cy)),
            cc.FadeOut:create(0.8),
            cc.DelayTime:create(0.2),
            cc.FadeIn:create(1.0)
        });
        self.m_coins[9]:runAction(sequence);

        local action = transition.moveTo(self.m_coins[10], {time = 4.0, x = 100, y = 300});
        local scheduler = require("framework.scheduler");
        scheduler.performWithDelayGlobal(
            function()
                transition.removeAction(action);
                print("action removed");
            end,2);

        self.m_animate = {};
        local frames = display.newFrames("grossini_blue_%02d.png", 1, 4);
        self.m_animate[1] = display.newSprite(frames[1])
                        :pos(300, 350)
                        :addTo(self);
        -- playAnimationOnce() 第二个参数为 true 表示动画播放完后删除 boom 这个 Sprite 对象
        self.m_animate[1]:playAnimationOnce(display.newAnimation(frames, 0.3/ 4));

        frames = display.newFrames("grossini_blue_%02d.png", 1, 4);
        self.m_animate[2] = display.newSprite(frames[1])
                        :pos(400, 350)
                        :addTo(self);
        self.m_animate[2]:playAnimationForever(display.newAnimation(frames, 0.5 / 4));

    end);

     y = y - param_distance;

    label = UICreator.createText("Stop -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_stop_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_stop_test:addTo(self);

    self.m_stop_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_stop_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_stop_test:onButtonClicked(function(event)
        for i,v in ipairs(self.m_coins) do
            transition.stopTarget(v);
        end

        for i,v in ipairs(self.m_animate) do
            transition.stopTarget(v);
        end
    end);

    y = y - param_distance;

    label = UICreator.createText("Pause -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_pause_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_pause_test:addTo(self);

    self.m_pause_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_pause_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_pause_test:onButtonClicked(function(event)
        for i,v in ipairs(self.m_coins) do
            transition.pauseTarget(v);
        end

        for i,v in ipairs(self.m_animate) do
            transition.pauseTarget(v);
        end
    end);

    y = y - param_distance;

    label = UICreator.createText("Resume -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_resume_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_resume_test:addTo(self);

    self.m_resume_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_resume_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_resume_test:onButtonClicked(function(event)
        for i,v in ipairs(self.m_coins) do
            transition.resumeTarget(v);
        end

        for i,v in ipairs(self.m_animate) do
            transition.resumeTarget(v);
        end
    end);
end

function TestScene:hideTransitionTest()
     if self.m_coins then
        for i,v in ipairs(self.m_coins) do
            v:removeSelf();
        end
        self.m_coins = nil;
    end

    if self.m_animate then
        for i,v in ipairs(self.m_animate) do
            v:removeSelf();
        end
        self.m_animate = nil;
    end

    if self.m_title12 then
        self.m_title12:setVisible(false);
        self.m_start_test:setVisible(false);
        self.m_stop_test:setVisible(false);
        self.m_pause_test:setVisible(false);
        self.m_resume_test:setVisible(false);
    end
end

function TestScene:createNvgdrawnodeTest()
    self.m_ReturnButton:setVisible(true);
    if self.m_title13 then 
        self.m_title13:setVisible(true);
        self.m_nvdDrawNode_test:setVisible(true);
        return;
    end

    local param_distance = 50;

    local y = display.top - 150;

    self.m_title13 = UICreator.createText("nvgdrawnode Test",35,display.CENTER,display.cx,display.top - 80,255,255,255);
    self.m_title13:addTo(self);

    local label = UICreator.createText("create -- check console output",24,display.CENTER,display.cx,display.top - 100,255,255,0);
    self.m_nvdDrawNode_test = UICreator.createBtnText(nil,false,display.cx,y,display.CENTER,155,60,label);
    self.m_nvdDrawNode_test:addTo(self);

    self.m_nvdDrawNode_test:onButtonPressed(function(event)
        event.target:setOpacity(128);
        end);
    self.m_nvdDrawNode_test:onButtonRelease(function(event)
        event.target:setOpacity(255);
    end);
    self.m_nvdDrawNode_test:onButtonClicked(function(event)
        if self.m_drawNode1 then 
            self.m_drawNode1:setVisible(true);
            self.m_drawNode2:setVisible(true);
            self.m_drawNode3:setVisible(true);
            self.m_drawNode4:setVisible(true);
            self.m_drawNode5:setVisible(true);
            self.m_drawNode6:setVisible(true);
            self.m_drawNode7:setVisible(true);
            self.m_drawNode8:setVisible(true);
            self.m_drawNode9:setVisible(true);
            self.m_drawNode10:setVisible(true);
            self.m_drawNode11:setVisible(true);
            self.m_drawNode12:setVisible(true);
            self.m_drawNode13:setVisible(true);
            return;
        end
        local quarLB = cc.p(display.cx/2, display.cy/2);
        local quarRT = cc.p(display.width - quarLB.x, display.height - quarLB.y);

        self.m_drawNode1 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode1);
        self.m_drawNode1:drawPoint(cc.p(display.cx - 100, display.cy), cc.c4f(1, 0, 0, 1));

        local points = {};
        for i=1,10 do
            points[i] = cc.p(display.width/10*i, 10);
        end

        self.m_drawNode2 = cc.NVGDrawNode:create():addTo(self);
        self.m_drawNode2:drawPoints(points, 10, cc.c4f(0, 1, 0, 1));

        self.m_drawNode3 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode3);
        self.m_drawNode3:drawLine(quarLB, quarRT, cc.c4f(0, 0, 1, 1));
        
        self.m_drawNode4 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode4);
        self.m_drawNode4:drawRect(quarLB, quarRT, cc.c4f(1, 1, 0, 1));

        points = {};
        points[1] = cc.p(100, 200);
        points[2] = cc.p(100, 100);
        points[3] = cc.p(200, 100);
        points[4] = cc.p(300, 150);
        self.m_drawNode5 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode5);
        self.m_drawNode5:drawPolygon(points, 4, true, cc.c4f(0, 1, 1, 1));
        
        self.m_drawNode6 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode6);
        self.m_drawNode6:drawCircle(cc.p(display.cx, display.cy), 20, cc.c4f(1, 0, 1, 1));

        self.m_drawNode7 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode7);
        self.m_drawNode7:drawQuadBezier(quarLB, cc.p(quarRT.x, quarLB.y), quarRT, cc.c4f(1, 1, 1,1));

        self.m_drawNode8 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode8);
        self.m_drawNode8:drawCubicBezier(cc.p(300, 400), cc.p(350, 500), cc.p(500, 300), cc.p(600, 400), cc.c4f(0.5, 0, 0, 1));
        
        self.m_drawNode9 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode9);
        self.m_drawNode9:drawDot(cc.p(display.cx, display.cy), 5, cc.c4f(0, 0.5, 0, 1));
        
        self.m_drawNode10 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode10);
        self.m_drawNode10:setColor(cc.c4f(1, 1, 1, 1));
        self.m_drawNode10:drawSolidRect(cc.p(330, 120), cc.p(430, 220), cc.c4f(0, 0, 0.5, 1));

        points = {};
        points[1] = cc.p(500, 400);
        points[2] = cc.p(600, 400);
        points[3] = cc.p(550, 500);
        self.m_drawNode11 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode11);
        self.m_drawNode11:drawSolidPolygon(points, 3, cc.c4f(0.5, 0.5, 0, 1));
        
        self.m_drawNode12 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode12);
        self.m_drawNode12:setFill(true);
        self.m_drawNode12:setFillColor(cc.c4f(1, 1, 1, 1));
        self.m_drawNode12:drawArc(cc.p(50, 200), 50, 30, 200, 1, cc.c4f(0, 0.5, 0.5, 1));

        points = {};
        points[1] = cc.p(10, 300);
        points[2] = cc.p(200, 320);
        points[3] = cc.p(180, 350);
        points[4] = cc.p(220, 410);
        self.m_drawNode13 = cc.NVGDrawNode:create();
        self:addChild(self.m_drawNode13);
        self.m_drawNode13:setLineWidth(4);
        self.m_drawNode13:setColor(cc.c4f(0, 0.5, 0.5, 1));
        self.m_drawNode13:drawSolidPolygon(points, 4, cc.c4f(0.5, 0, 0.5, 1));
    end);
end

function TestScene:hideNvgdrawnodeTest()
    if self.m_drawNode1 then 
        self.m_drawNode1:setVisible(false);
        self.m_drawNode2:setVisible(false);
        self.m_drawNode3:setVisible(false);
        self.m_drawNode4:setVisible(false);
        self.m_drawNode5:setVisible(false);
        self.m_drawNode6:setVisible(false);
        self.m_drawNode7:setVisible(false);
        self.m_drawNode8:setVisible(false);
        self.m_drawNode9:setVisible(false);
        self.m_drawNode10:setVisible(false);
        self.m_drawNode11:setVisible(false);
        self.m_drawNode12:setVisible(false);
        self.m_drawNode13:setVisible(false);
    end
    if self.m_title13 then 
        self.m_title13:setVisible(false);
        self.m_nvdDrawNode_test:setVisible(false);
    end
end

return TestScene;