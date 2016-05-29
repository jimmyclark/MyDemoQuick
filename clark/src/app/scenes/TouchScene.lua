local TouchScene = class("TouchScene",function()
	return display.newScene("TouchScene");
end)

function TouchScene:ctor()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 50,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"flipY",0.7,cc.TRANSITION_ORIENTATION_DOWN_OVER);
	end);

	self.m_title = {
		"单点触摸测试 - 响应触摸事件","单点触摸测试 - 事件穿透和事件捕获","单点触摸测试 - 在事件捕获阶段决定是否接受事件","单点触摸测试 - 容器的触摸区域由子对象决定",
		"多点触摸测试 - 响应触摸事件","多点触摸测试 - 在事件捕获阶段决定是否接受事件","多点触摸测试 - 容器的触摸区域由子对象决定",
	}

	self.m_titleLabel = UICreator.createText("",24,display.CENTER,display.cx, display.top-50,255,255,255);
	self.m_titleLabel:addTo(self);
	
	local label = UICreator.createText("Next",32,display.CENTER,0,0,255,255,255);
	self.m_nextBtn = UICreator.createBtnText("touch/BlueButton.png",true,display.right - 20, display.bottom + 20,display.RIGHT_BOTTOM,160,60,label);
	self.m_nextBtn:addTo(self);
	self.m_nextBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);
	self.m_nextBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);
	self.m_nextBtn:onButtonClicked(function(event)
		self.m_index = self.m_index + 1;
		if self.m_index == 1 then 
			self:createSingleTouchView();
			self:hideSingleTouchView2();
			self:hideSingleTouchView3();
			self:hideSingleTouchView4();
			self:hideMultiTouchView();
			self:hideMultiTouchView2();	
			self:hideMultiTouchView3();
		elseif self.m_index == 2 then
			self:hideSingleTouchView();
			self:createSingleTouchView2();
			self:hideSingleTouchView3();
			self:hideSingleTouchView4();
			self:hideMultiTouchView();
			self:hideMultiTouchView2();
			self:hideMultiTouchView3();
		elseif self.m_index == 3 then
			self:hideSingleTouchView();
			self:hideSingleTouchView2();
			self:createSingleTouchView3();
			self:hideSingleTouchView4();
			self:hideMultiTouchView();
			self:hideMultiTouchView2();
			self:hideMultiTouchView3();
		elseif self.m_index == 4 then 
			self:hideSingleTouchView();
			self:hideSingleTouchView2();
			self:hideSingleTouchView3();
			self:createSingleTouchView4();
			self:hideMultiTouchView();
			self:hideMultiTouchView2();
			self:hideMultiTouchView3();
		elseif self.m_index == 5 then
			self:hideSingleTouchView();
			self:hideSingleTouchView2();
			self:hideSingleTouchView3(); 
			self:hideSingleTouchView4();
			self:createMultiTouchView();
			self:hideMultiTouchView2();
			self:hideMultiTouchView3();
		elseif self.m_index == 6 then
			self:hideSingleTouchView();
			self:hideSingleTouchView2();
			self:hideSingleTouchView3(); 
			self:hideSingleTouchView4();
			self:hideMultiTouchView();
			self:createMultiTouchView2();
			self:hideMultiTouchView3();
		elseif self.m_index == 7 then 
			self:hideSingleTouchView();
			self:hideSingleTouchView2();
			self:hideSingleTouchView3(); 
			self:hideSingleTouchView4();
			self:hideMultiTouchView();
			self:hideMultiTouchView2();
			self:createMultiTouchView3();
		end


		self.m_titleLabel:setString(self.m_title[self.m_index]);

		if self.m_index == 7 then 
			self.m_index = 0;
		end
	end);


	self:createSingleTouchView();
	self.m_index = 1;
	self.m_titleLabel:setString(self.m_title[1]);

end

function TouchScene:run()

end

function TouchScene:exit()

end

-------------------------------------------单点触摸----------------------------------------------------
function TouchScene:createSingleTouchView()
	if self.m_sprite1 then 
		self.m_sprite1:setVisible(true);
		self.m_sprite1_box:setVisible(true);
		return;
	end
	self.m_sprite1 = UICreator.createImg("touch/WhiteButton.png",true,display.cx,display.cy,500,300);

	local contentSize = self.m_sprite1:getContentSize();
	self.m_label1 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite1:addTo(self);
	self.m_label1:addTo(self.m_sprite1);

    self.m_sprite1_box = UICreator.createBoundingBox(self, self.m_sprite1, cc.c4f(0, 1.0, 0, 1.0));

    self.m_sprite1:setTouchEnabled(true);
    -- 添加触摸事件处理函数
    self.m_sprite1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled
        -- event.x, event.y 是触摸点当前位置
        -- event.prevX, event.prevY 是触摸点之前的位置
        local label = string.format("sprite: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        self.m_label1:setString(label);

        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true;
    end);
end

function TouchScene:hideSingleTouchView()
	if self.m_sprite1 then 
		self.m_sprite1:setVisible(false);
		self.m_sprite1_box:setVisible(false);
	end
end

function TouchScene:createSingleTouchView2()
	if self.m_sprite2 then 
		self.m_sprite2:setVisible(true);
		self.m_label2:setVisible(true);
		self.m_sprite2_box:setVisible(true);

		self.m_sprite3:setVisible(true);
		self.m_label3:setVisible(true);
		self.m_sprite3_box:setVisible(true);
		self.m_sprite3_label:setVisible(true);

		self.m_sprite4:setVisible(true);
		self.m_label4:setVisible(true);
		self.m_sprite4_box:setVisible(true);
		self.m_sprite4_label:setVisible(true);
		self.m_sprite4_checkBox:setVisible(true);
		return;
	end

	self.m_sprite2 = UICreator.createImg("touch/WhiteButton.png",true,display.cx,display.cy,600,500);

	local contentSize = self.m_sprite2:getContentSize();
	self.m_label2 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite2:addTo(self);
	self.m_label2:addTo(self.m_sprite2);

    self.m_sprite2_box = UICreator.createBoundingBox(self, self.m_sprite2, cc.c4f(0, 1.0, 0, 1.0));

    self.m_sprite2:setTouchEnabled(true);
    -- 添加触摸事件处理函数
    self.m_sprite2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled
        -- event.x, event.y 是触摸点当前位置
        -- event.prevX, event.prevY 是触摸点之前的位置
        local label = string.format("sprite: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        self.m_label2:setString(label);

        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true;
    end);

	self.m_sprite3 = UICreator.createImg("touch/GreenButton.png",true,display.cx,200,400,160);

	local contentSize = self.m_sprite3:getContentSize();
	self.m_label3 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite3:addTo(self);
	self.m_label3:addTo(self.m_sprite3);

    self.m_sprite3_box = UICreator.createBoundingBox(self, self.m_sprite3, cc.c4f(1.0, 0, 0, 1.0));

    self.m_sprite3:setTouchEnabled(true);
    self.m_sprite3:setTouchSwallowEnabled(true);
    -- 添加触摸事件处理函数
    self.m_sprite3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled
        -- event.x, event.y 是触摸点当前位置
        -- event.prevX, event.prevY 是触摸点之前的位置
        local label = string.format("sprite: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        self.m_label3:setString(label);

        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true;
    end);    

    self.m_sprite3_label = UICreator.createText("SWALLOW = YES\n事件在当前对象处理后被吞噬",24,display.CENTER,display.cx - 250,100,0,0,0);
    self.m_sprite3_label:addTo(self.m_sprite3);

    self.m_sprite4 = UICreator.createImg("touch/PinkButton.png",true,display.cx,display.cy+150,400,160);

	local contentSize = self.m_sprite4:getContentSize();
	self.m_label4 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite4:addTo(self);
	self.m_label4:addTo(self.m_sprite4);

    self.m_sprite4_box = UICreator.createBoundingBox(self, self.m_sprite4,cc.c4f(0, 0, 1.0, 1.0));

    self.m_sprite4:setTouchEnabled(true);
    self.m_sprite4:setTouchSwallowEnabled(false);
    -- 添加触摸事件处理函数
    self.m_sprite4:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        -- event.name 是触摸事件的状态：began, moved, ended, cancelled
        -- event.x, event.y 是触摸点当前位置
        -- event.prevX, event.prevY 是触摸点之前的位置
        local label = string.format("sprite: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        self.m_label4:setString(label);

        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true;
    end);  

    self.m_sprite4_label = UICreator.createText("当不允许父对象捕获触摸事件\n时，父对象及其包含的所有\n子对象都将得不到触摸事件",24,display.CENTER,display.cx-250,100,0,0,0);
    self.m_sprite4_label:addTo(self.m_sprite4);

    local labels = {};
    labels[true] = "父对象【可以】捕获触摸事件";
    labels[false] = "父对象【不能】捕获触摸事件";

    local label = UICreator.createText(labels[true],24,display.CENTER,0,0,0,0,0);
	self.m_sprite4_checkBox = UICreator.createUICheckBox("touch/CheckBoxButton2Off.png","touch/CheckBoxButton2On.png",display.CENTER,display.cx - 160,display.cy,label);
	self.m_sprite4_checkBox:addTo(self);
	self.m_sprite4_checkBox:setButtonLabelOffset(40,0);
	self.m_sprite4_checkBox:setButtonSelected(true);
	self.m_sprite4_checkBox:onButtonStateChanged(function(event)
		event.target:setButtonLabelString(labels[event.target:isButtonSelected()]);
	end);

	self.m_sprite4_checkBox:onButtonClicked(function(event)
		self.m_sprite2:setTouchCaptureEnabled(event.target:isButtonSelected());
	end);

end

function TouchScene:hideSingleTouchView2()
	if self.m_sprite2 then 
		self.m_sprite2:setVisible(false);
		self.m_label2:setVisible(false);
		self.m_sprite2_box:setVisible(false);

		self.m_sprite3:setVisible(false);
		self.m_label3:setVisible(false);
		self.m_sprite3_box:setVisible(false);
		self.m_sprite3_label:setVisible(false);

		self.m_sprite4:setVisible(false);
		self.m_label4:setVisible(false);
		self.m_sprite4_box:setVisible(false);
		self.m_sprite4_label:setVisible(false);
		self.m_sprite4_checkBox:setVisible(false);
	end
end

function TouchScene:createSingleTouchView3()
	if self.m_sprite5 then
		self.m_sprite5:setVisible(true);
		self.m_label5:setVisible(true);
		self.m_sprite5_box:setVisible(true);
		self.m_label5_capture:setVisible(true);

		self.m_sprite6:setVisible(true);
		self.m_label6:setVisible(true);
		self.m_sprite6_box:setVisible(true);
		self.m_sprite6_label:setVisible(true);

		self.m_sprite7:setVisible(true);
		self.m_label7:setVisible(true);
		self.m_sprite7_box:setVisible(true);
		self.m_sprite7_label:setVisible(true);
		self.m_sprite7_checkBox:setVisible(true);
		return;
	end
	-- 这个标志变量用于在触摸事件捕获阶段决定是否接受事件
    self.isTouchCaptureEnabled_ = true;

	self.m_sprite5 = UICreator.createImg("touch/WhiteButton.png",true,display.cx,display.cy,600,500);

	local contentSize = self.m_sprite5:getContentSize();
	self.m_label5 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite5:addTo(self);
	self.m_label5:addTo(self.m_sprite5);

    self.m_sprite5_box = UICreator.createBoundingBox(self, self.m_sprite5, cc.c4f(0, 1.0, 0, 1.0));

    self.m_sprite5:setTouchEnabled(true);
    -- 添加触摸事件处理函数
    self.m_sprite5:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local label = string.format("m_sprite5: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y);
        self.m_label5:setString(label);
        printf("%s %s [TARGETING]", "m_sprite5", event.name);
        if event.name == "ended" or event.name == "cancelled" then
            print("-------------cancelled----------------");
        else
            print("");
        end
        return true;
    end);

    self.m_label5_capture = UICreator.createText("",24,display.CENTER, 300, 60,0,0,255);
    self.m_label5_capture:addTo(self.m_sprite5);

	-- 可以动态捕获触摸事件，并在捕获触摸事件开始时决定是否接受此次事件
    self.m_sprite5:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        if event.name == "began" then
            print("-----------------------------");
        end

        local label = string.format("m_sprite5 CAPTURE: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y);
        self.m_label5_capture:setString(label);
        printf("%s %s [CAPTURING]", "m_sprite5", event.name);
        if event.name == "began" or event.name == "moved" then
            return self.isTouchCaptureEnabled_;
        end
    end);

    self.m_sprite6 = UICreator.createImg("touch/GreenButton.png",true,display.cx,display.cy+140,400,200);

	local contentSize = self.m_sprite6:getContentSize();
	self.m_label6 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite6:addTo(self);
	self.m_label6:addTo(self.m_sprite6);

    self.m_sprite6_box = UICreator.createBoundingBox(self, self.m_sprite6, cc.c4f(1.0, 0, 0, 1.0));

    self.m_sprite6:setTouchEnabled(true);
    self.m_sprite6:setTouchSwallowEnabled(true);
    -- 添加触摸事件处理函数
    self.m_sprite6:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local label = string.format("button1: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y);
        self.m_label6:setString(label);
        printf("%s %s [TARGETING]", "button1", event.name);
        if event.name == "ended" or event.name == "cancelled" then
            print("-------------cancel----------------");
        else
            print("");
        end
        return true;
    end);    

    self.m_sprite6_label = UICreator.createText("SWALLOW = YES\n事件在当前对象处理后被吞噬",24,display.CENTER,display.cx - 250,100,0,0,0);
    self.m_sprite6_label:addTo(self.m_sprite6);

    self.m_sprite7 = UICreator.createImg("touch/PinkButton.png",true,display.cx,display.cy-80,400,160);

	local contentSize = self.m_sprite7:getContentSize();
	self.m_label7 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite7:addTo(self);
	self.m_label7:addTo(self.m_sprite7);

    self.m_sprite7_box = UICreator.createBoundingBox(self, self.m_sprite7,cc.c4f(0, 0, 1.0, 1.0));

    self.m_sprite7:setTouchEnabled(true);
    self.m_sprite7:setTouchSwallowEnabled(false);
    -- 添加触摸事件处理函数
    self.m_sprite7:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      	local label = string.format("m_sprite7: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y);
        self.m_label7:setString(label);
        printf("%s %s [TARGETING]", "m_sprite7", event.name);
        return true;
    end);  

    -- 即便父对象在捕获阶段阻止响应事件，但子对象仍然可以捕获到事件，只是不会触发事件
    self.m_sprite7:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        printf("%s %s [CAPTURING]", "m_sprite7", event.name);
        return true;
    end)

    local labels = {};
    labels[true] = "父对象【可以】捕获触摸事件";
    labels[false] = "父对象【不能】捕获触摸事件";

    local label = UICreator.createText(labels[true],24,display.CENTER,0,0,0,0,0);
	self.m_sprite7_checkBox = UICreator.createUICheckBox("touch/CheckBoxButton2Off.png","touch/CheckBoxButton2On.png",display.CENTER,display.cx - 160,display.cy+20,label);
	self.m_sprite7_checkBox:addTo(self);
	self.m_sprite7_checkBox:setButtonLabelOffset(40,0);
	self.m_sprite7_checkBox:setButtonSelected(true);
	self.m_sprite7_checkBox:onButtonStateChanged(function(event)
		event.target:setButtonLabelString(labels[event.target:isButtonSelected()]);
	end);

	self.m_sprite7_checkBox:onButtonClicked(function(event)
		self.isTouchCaptureEnabled_ = event.target:isButtonSelected();
	end);

    self.m_sprite7_label = UICreator.createText("事件处理流程：\n1. 【捕获】阶段：从父到子\n2. 【目标】阶段\n3. 【传递】阶段：尝试传递给下层对象",24,display.CENTER,display.cx-260,90,0,0,0);
    self.m_sprite7_label:addTo(self.m_sprite7);

end

function TouchScene:hideSingleTouchView3()
	if self.m_sprite5 then
		self.m_sprite5:setVisible(false);
		self.m_label5:setVisible(false);
		self.m_sprite5_box:setVisible(false);
		self.m_label5_capture:setVisible(false);

		self.m_sprite6:setVisible(false);
		self.m_label6:setVisible(false);
		self.m_sprite6_box:setVisible(false);
		self.m_sprite6_label:setVisible(false);

		self.m_sprite7:setVisible(false);
		self.m_label7:setVisible(false);
		self.m_sprite7_box:setVisible(false);
		self.m_sprite7_label:setVisible(false);
		self.m_sprite7_checkBox:setVisible(false);
	end
end

function TouchScene:createSingleTouchView4()
	if self.m_touchableNode then 
		self.m_touchableNode:setVisible(true);
		self.m_label8:setVisible(true);
		self.m_touchableNode_box:setVisible(true);
		return;
	end
	 -- touchableNode 是启用触摸的 Node
    self.m_touchableNode = display.newNode();
    self.m_touchableNode:setPosition(display.cx, display.cy);
    self.m_touchableNode:addTo(self);
    -- self:addChild(self.touchableNode);

    -- 在 touchableNode 中加入一些 sprite
    local count = math.random(3, 8);
    local images = {"touch/WhiteButton.png", "touch/BlueButton.png", "touch/GreenButton.png", "touch/PinkButton.png"};
    for i = 1, count do
    	local sprite = UICreator.createImg(images[math.random(1,4)],true,math.random(-200, 200), math.random(-200, 200),math.random(100, 200), math.random(100, 200));
        self.m_touchableNode:addChild(sprite);
    end

    self.m_label8 = UICreator.createText("",24,display.CENTER,display.cx, display.top - 100,255,255,255);
    self.m_label8:addTo(self);

    -- 启用触摸
    self.m_touchableNode:setTouchEnabled(true);
    -- 添加触摸事件处理函数
    self.m_touchableNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local label = string.format("touchableNode: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y);
        self.m_label8:setString(label);
        return true;
    end)
    self.m_touchableNode_box = UICreator.createBoundingBox(self, self.m_touchableNode, cc.c4f(0, 1.0, 0, 1.0));

end

function TouchScene:hideSingleTouchView4()
	if self.m_touchableNode then 
		self.m_touchableNode:setVisible(false);
		self.m_label8:setVisible(false);
		self.m_touchableNode_box:setVisible(false);
	end
end

--------------------------------------多点触摸------------------------------------------------------------
function TouchScene:createMultiTouchView()
	if self.m_sprite9 then 
		self.m_sprite9:setVisible(true);
		self.m_label9:setVisible(true);
		self.m_sprite9_box:setVisible(true);
		self.m_sprite9_label:setVisible(true);
		return;
	end
	self.cursors = {};
    self.touchIndex = 0;

	self.m_sprite9 = UICreator.createImg("touch/WhiteButton.png",true,display.cx,display.cy-80,500,600);

	local contentSize = self.m_sprite9:getContentSize();
	self.m_label9 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite9:addTo(self);
	self.m_label9:addTo(self.m_sprite9);

    self.m_sprite9_box = UICreator.createBoundingBox(self, self.m_sprite9,cc.c4f(0, 1.0, 0, 1.0));

    self.m_sprite9_label = UICreator.createText("",24,display.CENTER_TOP, display.cx, display.top - 120,0,0,255,255,255);
    self.m_sprite9_label:addTo(self);

    self.m_sprite9:setTouchEnabled(true);
     -- 设置触摸模式
    self.m_sprite9:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE) -- 多点
    -- self.sprite:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点（默认模式）
    -- 添加触摸事件处理函数
    self.m_sprite9:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      	local str = {};
        for id, point in pairs(event.points) do
            str[#str + 1] = string.format("id: %s, x: %0.2f, y: %0.2f", point.id, point.x, point.y);
        end
        local pointsCount = #str;
        table.sort(str);
        self.m_sprite9_label:setString(table.concat(str, "\n"));

        if event.name == "began" or event.name == "added" then
            self.touchIndex = self.touchIndex + 1;
            for id, point in pairs(event.points) do
                local cursor = display.newSprite("touch/Cursor.png")
                    :pos(point.x, point.y)
                    :scale(1.2)
                    :addTo(self);
                self.cursors[id] = cursor;
            end
        elseif event.name == "moved" then
            for id, point in pairs(event.points) do
                local cursor = self.cursors[id];
                local rect = self.m_sprite9:getBoundingBox();
                if cc.rectContainsPoint(rect, cc.p(point.x, point.y)) then
                    -- 检查触摸点的位置是否在矩形内
                    cursor:setPosition(point.x, point.y);
                    cursor:setVisible(true);
                else
                    cursor:setVisible(false);
                end
            end
        elseif event.name == "removed" then
            for id, point in pairs(event.points) do
                self.cursors[id]:removeSelf();
                self.cursors[id] = nil;
            end
        else
            for _, cursor in pairs(self.cursors) do
                cursor:removeSelf();
            end
            self.cursors = {};
        end

        local label = string.format("sprite: %s , count = %d, index = %d", event.name, pointsCount, self.touchIndex);
        self.m_label9:setString(label);

        if event.name == "ended" or event.name == "cancelled" then
            self.m_label9:setString("");
            self.m_sprite9_label:setString("");
        end

        -- 返回 true 表示要响应该触摸事件，并继续接收该触摸事件的状态变化
        return true;
    end);  
end

function TouchScene:hideMultiTouchView()
	if self.m_sprite9 then 
		self.m_sprite9:setVisible(false);
		self.m_label9:setVisible(false);
		self.m_sprite9_box:setVisible(false);
		self.m_sprite9_label:setVisible(false);
	end
end

function TouchScene:createMultiTouchView2()
	if self.m_sprite10 then
		self.m_sprite10:setVisible(true);
		self.m_label10:setVisible(true);
		self.m_sprite10_box:setVisible(true);
		self.m_sprite10_label:setVisible(true);

		self.m_sprite11:setVisible(true);
		self.m_label11:setVisible(true);
		self.m_sprite11_box:setVisible(true);
		self.m_sprite11_label:setVisible(true);

		self.m_sprite12:setVisible(true);
		self.m_label12:setVisible(true);
		self.m_sprite12_box:setVisible(true);
		self.m_sprite12_label:setVisible(true);
		self.m_sprite12_checkBox:setVisible(true);
		self.m_label_sprite12:setVisible(true);
		return;
	end

	 -- 这个标志变量用于在触摸事件捕获阶段决定是否接受事件
    self.isTouchCaptureEnabled_multi_ = true;

    self.m_sprite10 = UICreator.createImg("touch/WhiteButton.png",true,display.cx,display.cy,600,500);

	local contentSize = self.m_sprite10:getContentSize();
	self.m_label10 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite10:addTo(self);
	self.m_label10:addTo(self.m_sprite10);

    self.m_sprite10_box = UICreator.createBoundingBox(self, self.m_sprite10,cc.c4f(0, 1.0, 0, 1.0));

    self.m_sprite10:setTouchEnabled(true);
    -- self.m_sprite10:setTouchSwallowEnabled(false);
    -- 添加触摸事件处理函数
    self.m_sprite10:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      	local label = string.format("m_sprite10: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y);
        self.m_label10:setString(label);
        printf("%s %s [TARGETING]", "m_sprite10", event.name);
        return true;
    end);  

    -- 即便父对象在捕获阶段阻止响应事件，但子对象仍然可以捕获到事件，只是不会触发事件
    self.m_sprite10:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local label = string.format("sprite10: %s", event.name);
        self.m_label10:setString(label);
        printf("%s %s [TARGETING]", "sprite10", event.name);
        if event.name == "ended" or event.name == "cancelled" then
            print("-----------------------------");
        else
            print("");
        end
        return true;
    end);

    self.m_sprite10_label = UICreator.createText("",24,display.CENTER,500,60,0,0,255);
    self.m_sprite10_label:addTo(self);

    -- 可以动态捕获触摸事件，并在捕获触摸事件开始时决定是否接受此次事件
    self.m_sprite10:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        if event.name == "began" then
            print("-----------------------------");
        end

        local label = string.format("sprite10 CAPTURE: %s", event.name);
        self.m_sprite10_label:setString(label);
        printf("%s %s [CAPTURING]", "sprite10", event.name);
        if event.name == "began" or event.name == "moved" then
            return self.isTouchCaptureEnabled_multi_;
        end
    end);

    self.m_sprite11 = UICreator.createImg("touch/GreenButton.png",true,display.cx,200,400,160);

	local contentSize = self.m_sprite11:getContentSize();
	self.m_label11 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite11:addTo(self);

	self.m_sprite11:setTouchEnabled(true);
	self.m_sprite11:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE);
	self.m_sprite11:setTouchSwallowEnabled(true);

	self.m_label11:addTo(self.m_sprite11);

    self.m_sprite11_box = UICreator.createBoundingBox(self, self.m_sprite11, cc.c4f(1.0, 0, 0, 1.0));

    self.m_sprite11:setTouchEnabled(true);
    self.m_sprite11:setTouchSwallowEnabled(true);
    -- 添加触摸事件处理函数
    self.m_sprite11:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local label = string.format("button1: %s count: %d", event.name, table.nums(event.points));
        self.m_label11:setString(label);
        printf("%s %s [TARGETING]", "button1", event.name);
        if event.name == "ended" or event.name == "cancelled" then
            print("-----------------------------");
        else
            print("");
        end
        return true;
    end);    

    self.m_sprite11_label = UICreator.createText("SWALLOW = YES\n事件在当前对象处理后被吞噬",24,display.CENTER,200,90,0,0,0);
    self.m_sprite11_label:addTo(self.m_sprite11);

    self.m_sprite12 = UICreator.createImg("touch/PinkButton.png",true,display.cx,360,400,160);

	local contentSize = self.m_sprite12:getContentSize();
	self.m_label12 = UICreator.createText("Touch ME !",20,display.CENTER,contentSize.width/2,20,255,0,0);
	self.m_sprite12:addTo(self);
	self.m_label12:addTo(self.m_sprite12);

    self.m_sprite12_box = UICreator.createBoundingBox(self, self.m_sprite12,cc.c4f(0, 0, 1.0, 1.0));

    self.m_sprite12:setTouchEnabled(true);
    self.m_sprite12:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE);
    self.m_sprite12:setTouchSwallowEnabled(false);
    -- 添加触摸事件处理函数
    self.m_sprite12:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
       	local label = string.format("sprite12: %s count: %d", event.name, table.nums(event.points));
        self.m_label12:setString(label);
        printf("%s %s [TARGETING]", "sprite12", event.name);
        return true;
    end);  

     -- 即便父对象在捕获阶段阻止响应事件，但子对象仍然可以捕获到事件，只是不会触发事件
    self.m_sprite12:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        printf("%s %s [CAPTURING]", "sprite12", event.name);
        return true;
    end)

    self.m_sprite12_label = UICreator.createText("SWALLOW = NO\n事件会传递到下层对象",24,display.CENTER,200,90,0,0,0);
    self.m_sprite12_label:addTo(self.m_sprite12);

    local labels = {};
    labels[true] = "父对象【可以】捕获触摸事件";
    labels[false] = "父对象【不能】捕获触摸事件";

    local label = UICreator.createText(labels[true],24,display.CENTER,0,0,0,0,0);
	self.m_sprite12_checkBox = UICreator.createUICheckBox("touch/CheckBoxButton2Off.png","touch/CheckBoxButton2On.png",display.CENTER,display.cx - 160, display.top - 90,label);
	self.m_sprite12_checkBox:addTo(self);
	self.m_sprite12_checkBox:setButtonLabelOffset(40,0);
	self.m_sprite12_checkBox:setButtonSelected(true);
	self.m_sprite12_checkBox:onButtonStateChanged(function(event)
		event.target:setButtonLabelString(labels[event.target:isButtonSelected()]);
	end);

	self.m_sprite12_checkBox:onButtonClicked(function(event)
		self.isTouchCaptureEnabled_multi_ = event.target:isButtonSelected();
	end);

	self.m_label_sprite12 = UICreator.createText("事件处理流程：\n1. 【捕获】阶段：从父到子\n2. 【目标】阶段\n3. 【传递】阶段：尝试传递给下层对象",19,display.CENTER_TOP, display.cx, display.top - 110,0,0,0);
	self.m_label_sprite12:addTo(self);
end

function TouchScene:hideMultiTouchView2()
	if self.m_sprite10 then
		self.m_sprite10:setVisible(false);
		self.m_label10:setVisible(false);
		self.m_sprite10_box:setVisible(false);
		self.m_sprite10_label:setVisible(false);

		self.m_sprite11:setVisible(false);
		self.m_label11:setVisible(false);
		self.m_sprite11_box:setVisible(false);
		self.m_sprite11_label:setVisible(false);

		self.m_sprite12:setVisible(false);
		self.m_label12:setVisible(false);
		self.m_sprite12_box:setVisible(false);
		self.m_sprite12_label:setVisible(false);
		self.m_sprite12_checkBox:setVisible(false);
		self.m_label_sprite12:setVisible(false);
	end
end

function TouchScene:createMultiTouchView3()
	if self.m_touchableNode_multi then 
		self.m_touchableNode_multi:setVisible(true);
		self.m_touchableNode_multi_label:setVisible(true);
		self.m_touchableNode_multi_boundbox:setVisible(true);
		return;
	end
	 -- touchableNode 是启用触摸的 Node
    self.m_touchableNode_multi = display.newNode();
    self.m_touchableNode_multi:setPosition(display.cx, display.cy);
    self.m_touchableNode_multi:addTo(self);

    -- 在 touchableNode 中加入一些 sprite
    local count = math.random(3, 8);
    local images = {"touch/WhiteButton.png", "touch/BlueButton.png", "touch/GreenButton.png", "touch/PinkButton.png"};
    for i = 1, count do
    	local sprite = UICreator.createImg(images[math.random(1, 4)],true,math.random(-200, 200), math.random(-200, 200),math.random(100, 200), math.random(100, 200));
        self.m_touchableNode_multi:addChild(sprite);
    end

    self.m_touchableNode_multi_label = UICreator.createText("",24,display.CENTER,display.cx,display.top-100,255,255,255);
    self:addChild(self.m_touchableNode_multi_label);

    -- 启用触摸
    self.m_touchableNode_multi:setTouchEnabled(true);
    self.m_touchableNode_multi:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE); -- 多点
    -- 添加触摸事件处理函数
    self.m_touchableNode_multi:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local str = {};
        for id, point in pairs(event.points) do
            str[#str + 1] = string.format("id: %s, x: %0.2f, y: %0.2f", point.id, point.x, point.y);
        end
        self.m_touchableNode_multi_label:setString(table.concat(str, "\n"));
        return true
    end)
    self.m_touchableNode_multi_boundbox = UICreator.createBoundingBox(self, self.m_touchableNode_multi, cc.c4f(0, 1.0, 0, 1.0));

end

function TouchScene:hideMultiTouchView3()
	if self.m_touchableNode_multi then 
		self.m_touchableNode_multi:setVisible(false);
		self.m_touchableNode_multi_label:setVisible(false);
		self.m_touchableNode_multi_boundbox:setVisible(false);
	end
end

return TouchScene;