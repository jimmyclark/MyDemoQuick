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
                self:createDisplayTest();
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
	end
end

function TestScene:createDisplayTest()
    self.m_ReturnButton:setVisible(true);

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
end


return TestScene;