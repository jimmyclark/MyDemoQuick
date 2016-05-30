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

return TestScene;