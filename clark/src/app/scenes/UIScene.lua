local UIScene = class("UIScene",function()
	return display.newScene("UIScene");
end)

function UIScene:ctor()
	local layer = display.newColorLayer(cc.c4b(255,255,255,255));
	layer:addTo(self);

	self.m_titles = {"UIPageView","UIListView","UIScrollView","UIImage","UIButtons"};

	self.m_index = 1;

	self:createGridView();

	self:showFirstUI();

	self:createNextButtons();
end

function UIScene:showFirstUI()
	self:createPageView();
	self:createFirstTitle();
end

function UIScene:createGridView()
	for y=display.bottom,display.top,40 do
		local line = UICreator.createLine(display.left,y,display.right,y,0.9,0.9,0.9,1.0,1);
		line:addTo(self);
	end

	for x = display.left, display.right, 40 do
		local line = UICreator.createLine(x,display.top,x,display.bottom,0.9,0.9,0.9,1.0,1);
		line:addTo(self);
    end

    local line = UICreator.createLine(display.left,display.cy + 1,display.right,display.cy + 1,1.0,0.75,0.75,1.0,1);
    line:addTo(self);

    local line = UICreator.createLine(display.cx,display.top,display.cx,display.bottom,1.0,0.75,0.75,1.0,1);
    line:addTo(self);
end

function UIScene:run()
end

function UIScene:exit()

end

function UIScene:createNextButtons()
	local button = UICreator.createBtnText("NextButton.png",false,display.right - 20,display.bottom+20,display.RIGHT_BOTTOM);
	button:addTo(self);
    button:onButtonPressed(function(event)
            event.target:setScale(1.2);
        end)
    button:onButtonRelease(function(event)
            event.target:setScale(1.0);
        end)
    button:onButtonClicked(function(event)
            self:enterNextScene();
        end)

end

function UIScene:enterNextScene()
	self.m_index = self.m_index + 1;
	local index = self.m_index%10;
	if index == 1 then
		self:showFirstUI(); 
		self:hideSecondUI();
		self:hideThirdUI();
		self:hideUIImg();
	elseif index == 2 then 
		self:hidePageView();
		self:showSecondUI();
		self:hideThirdUI();
		self:hideUIImg();
	elseif index == 3 then 
		self:hidePageView();
		self:hideSecondUI();
		self:showThirdUI();
		self:hideUIImg();
	elseif index == 4 then 
		self:hidePageView();
		self:hideSecondUI();
		self:hideThirdUI();
		self:showUIImage();
	elseif index == 5 then 
		self:hideUIImg();
		self:hidePageView();
		self:hideSecondUI();
		self:hideThirdUI();
		self:showUIButtons();
	end
	self.m_title:setString(self.m_titles[index]);

end

---------------------------------------------PageView-------------------------------------------------------------------------------
function UIScene:createPageView()
	if self.m_pv then 
		self.m_pv:setVisible(true);
		return;
	end

	local viewRect = cc.rect(80,80,780,480);
	local padding = {left=20,right=20,top=20,bottom=20};
	self.m_pv = UICreator.createPageView(viewRect,3,3,padding,10,10,false);
	self.m_pv:onTouch(handler(self,self.touchListener));
	self.m_pv:addTo(self);

	 for i=1,19 do
        local item = self.m_pv:newItem();
        local content;

        -- content = cc.ui.UILabel.new(
        --             {text = "item"..i,
        --             size = 20,
        --             align = cc.ui.TEXT_ALIGN_CENTER,
        --             color = display.COLOR_BLACK})
        content = cc.LayerColor:create(
            cc.c4b(math.random(250),
                math.random(250),
                math.random(250),
                250));
        content:setContentSize(240, 140);
        content:setTouchEnabled(false);
        item:addChild(content);
        self.m_pv:addItem(item);        
    end
    self.m_pv:reload();
end

function UIScene:touchListener(event)
    dump(event, "TestUIPageViewScene - event:");
    local listView = event.listView;
    -- if 3 == event.itemPos then
    --     listView:removeItem(event.item, true);
    --     -- event.item:setItemSize(120, 80)
    -- end
end

function UIScene:hidePageView()
	if self.m_pv then 
		self.m_pv:setVisible(false);
	end
end

function UIScene:createFirstTitle()
	if self.m_title then 
		self.m_title:setString(self.m_titles[1]);
		return;
	end
   	self.m_title = UICreator.createText(self.m_titles[1],40,display.CENTER,display.cx,display.top-50,0,0,0);
   	self.m_title:addTo(self);
end
---------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------ListView-----------------------------------------------------------------------------------
function UIScene:showSecondUI()
	self:createVerticalListView();
	self:createHorizontalListView();
	self:createGridListView();
	self:createVerticalView();
	self:createHorizontalView();
end

function UIScene:createVerticalListView()
	if self.m_label1 then
		self.m_label1:setVisible(true);
	end

	if self.m_lv then 
		self.m_lv:setVisible(true);
		return;
	end

    self.m_label1 = UICreator.createText("vertical listView",24,display.CENTER,120,520,0,0,0);
    self.m_label1:addTo(self);

    local viewRect = cc.rect(40,80,120,400);

    self.m_lv = UICreator.createListView(UIConfig.LISTVIEW.VERTICAL,nil,viewRect,nil,"bar.png","sunset.png",true,200,200,200,120);
    self.m_lv:addTo(self);
    self.m_lv:onTouch(handler(self,self.m_listViewOnTouchListener));

    -- add items
    for i=1,20 do
        local item = self.m_lv:newItem();
        local content;
        if i == 2 then
        	local label = UICreator.createText("点击大小改变".. i,16,display.CENTER,0,0,0,0,255);
        	content = UICreator.createBtnText("GreenButton.png",true,0,0,display.CENTER,120,40,label);
        	content:onButtonPressed(function(event)
                event.target:getButtonLabel():setColor(display.COLOR_RED)
			end)
            content:onButtonRelease(function(event)
                event.target:getButtonLabel():setColor(display.COLOR_BLUE)
            end)
            content:onButtonClicked(function(event)
                if self.bListViewMove then
                    return;
                end

                local _,h = item:getItemSize();
                if 40 == h then
                	item:setItemSize(120, 80);
                else
                	item:setItemSize(120, 40);
                end
            end)
            content:setTouchSwallowEnabled(false);-- 不往下传递
        elseif i == 3 then 
        	content = UICreator.createText("点击删除它" .. i,20,display.CENTER,0,0,0,0,0);
        elseif i == 4 then 
        	content = UICreator.createText("有背景图" .. i,20,display.CENTER,0,0,0,0,0);
        	item:setBg("YellowBlock.png");
        else
        	content = UICreator.createText("item" .. i,20,display.CENTER,0,0,0,0,0);
        end
  
        item:addContent(content);
        item:setItemSize(120, 40);

        self.m_lv:addItem(item);
    end
    self.m_lv:reload()
end

function UIScene:m_listViewOnTouchListener(event)
	local listView = event.listView;
    if "clicked" == event.name then
        if 3 == event.itemPos then
            listView:removeItem(event.item, true)
        else
            -- event.item:setItemSize(120, 80)
        end
    elseif "moved" == event.name then
        self.bListViewMove = true;
    elseif "ended" == event.name then
        self.bListViewMove = false;
    else
        print("event name:" .. event.name)
    end
end

function UIScene:createHorizontalListView()
	if self.m_label2 then
		self.m_label2:setVisible(true);
	end

	if self.m_lv2 then 
		self.m_lv2:setVisible(true);
		return;
	end

	self.m_label2 = UICreator.createText("horizontal listView",24,display.CENTER,640,260,0,0,0)
	self.m_label2:addTo(self);

	local rect = cc.rect(360,160,560,80);
	self.m_lv2 = UICreator.createListView(UIConfig.LISTVIEW.HORIZONTAL,nil,rect,"barH.png",nil,nil,false,200,200,200,120);
	self.m_lv2:addTo(self);
	self.m_lv2:onTouch(handler(self,self.m_listViewOnTouchListener));

    -- add items
    for i=1,10 do
        local item = self.m_lv2:newItem()
        local content;
        if i == 2 then
        	local label = UICreator.createText("点击大小改变".. i,16,display.CENTER,0,0,0,0,255);
        	content = UICreator.createBtnText("GreenButton.png",true,0,0,display.CENTER,120,40,label);
        	content:onButtonPressed(function(event)
                event.target:getButtonLabel():setColor(display.COLOR_RED)
			end)
            content:onButtonRelease(function(event)
                event.target:getButtonLabel():setColor(display.COLOR_BLUE)
            end)
            content:onButtonClicked(function(event)
                if self.bListViewMove then
                    return;
                end

                local w, _ = item:getItemSize();
                if 120 == w then
                	item:setItemSize(160, 80);
                else
                    item:setItemSize(120, 80);
				end
            end)
            content:setTouchSwallowEnabled(false);-- 不往下传递
        elseif i == 3 then 
        	content = UICreator.createText("点击删除它" .. i,20,display.CENTER,0,0,0,0,0);
        elseif i == 4 then 
        	content = UICreator.createText("有背景图" .. i,20,display.CENTER,0,0,0,0,0);
        	item:setBg("YellowBlock.png");
        else
        	content = UICreator.createText("item" .. i,20,display.CENTER,0,0,0,0,0);
        end
        item:addContent(content);
        item:setItemSize(120, 80);

        self.m_lv2:addItem(item);
    end
    self.m_lv2:reload();
end

function UIScene:createGridListView()
	if self.m_label3 then 
		self.m_label3:setVisible(true);
	end

	if self.m_lv3 then
		self.m_lv3:setVisible(true);
		return;
	end

	self.m_label3 = UICreator.createText("grid in fact it's a listView",24,display.CENTER,680,560,0,0,0)
	self.m_label3:addTo(self);

	local rect = cc.rect(560, 280, 240, 240);
	self.m_lv3 = UICreator.createListView(UIConfig.LISTVIEW.VERTICAL,nil,rect);
	self.m_lv3:addTo(self);
	self.m_lv3:onTouch(handler(self,self.onTouchListener2));

	for i=1,3 do
        local item = self.m_lv3:newItem();
        local content;

        content = display.newNode();
        for count = 1, 3 do
            local idx = (i-1)*3 + count;
            local label = UICreator.createText("Button" .. idx,16,display.CENTER,nil,nil,0,0,255);
            local content_btn = UICreator.createBtnText("Button01.png",true,80*count-40,40,display.CENTER,80,80,label);
            content_btn:onButtonPressed(function(event)
                event.target:getButtonLabel():setColor(display.COLOR_RED);
			end);
            content_btn:onButtonRelease(function(event)
                event.target:getButtonLabel():setColor(display.COLOR_BLUE);
            end);
            content_btn:onButtonClicked(function(event)
                print("TestUIListViewScene - Button " .. idx .. " clicked, jude in botton call back");
            end);
   			content_btn:addTo(content);
        
        end
        content:setContentSize(240, 80);
        item:addContent(content);
        item:setItemSize(240, 80);

        self.m_lv3:addItem(item);
    end

    self.m_lv3:reload();

end

function UIScene:onTouchListener2(event)
	if "clicked" == event.name then
        local column = math.ceil(event.point.x/80);
        local idx = (event.itemPos - 1)*3 + column;
        print("TestUIListViewScene - Boutton " .. idx .. " clicked, judge in list touch listener");
    end
end

function UIScene:createVerticalView()
	if self.m_label4 then 
		self.m_label4:setVisible(true);
	end

	if self.m_lv4 then
		self.m_lv4:setVisible(true);
		return;
	end

	self.m_label4 = UICreator.createText("vertical listView2",24,display.CENTER,320,520,0,0,0)
	self.m_label4:addTo(self);

	local rect = cc.rect(260,280,120,200);

	self.m_lv4 = UICreator.createListView(UIConfig.LISTVIEW.VERTICAL,nil,rect,nil,"bar.png","sunset.png",true,0,0,0,0,true);
	self.m_lv4:onTouch(handler(self,self.onTouchListener3));
	self.m_lv4:addTo(self);

    self.m_lv4:setDelegate(handler(self, self.sourceDelegate));

    self.m_lv4:reload()
end

function UIScene:onTouchListener3(event)
	local listView = event.listView;
    if "clicked" == event.name then
        print("async list view clicked idx:" .. event.itemPos);
    end
end

function UIScene:sourceDelegate(listView, tag, idx)
    if cc.ui.UIListView.COUNT_TAG == tag then
        return 50;
    elseif cc.ui.UIListView.CELL_TAG == tag then
        local item;
        local content;

        item = self.m_lv4:dequeueItem();
        if not item then
            item = self.m_lv4:newItem();
            content = UICreator.createText("item".. idx,20,display.CENTER,0,0,255,255,255);
            item:addContent(content);
        else
            content = item:getContent();
        end
        content:setString("item:" .. idx);
        item:setItemSize(120, 80);
        return item;
    end
end

function UIScene:createHorizontalView()
	if self.m_lv5 then 
		self.m_lv5:setVisible(true);
		return;
	end
	local rect = cc.rect(360,40,400,80);
	self.m_lv5 = UICreator.createListView(UIConfig.LISTVIEW.HORIZONTAL,nil,rect,"barH.png",nil,"sunset.png",true,0,0,0,0,0,true);
	self.m_lv5:addTo(self);
	self.m_lv5:onTouch(handler(self,self.onTouchListener4));

	self.m_lv5:setDelegate(handler(self,self.sourceDelegate));
	self.m_lv5:reload();
end

function UIScene:onTouchListener4(event)
	local listView = event.listView;
    if "clicked" == event.name then
        print("async list view clicked idx:" .. event.itemPos);
    end
end

function UIScene:hideSecondUI()
	if self.m_label1 then
		self.m_label1:setVisible(false);
		self.m_lv:setVisible(false);
		self.m_label2:setVisible(false);
		self.m_lv2:setVisible(false);
		self.m_label3:setVisible(false);
		self.m_lv3:setVisible(false);
		self.m_label4:setVisible(false);
		self.m_lv4:setVisible(false);
		self.m_lv5:setVisible(false);
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------UIScrollView-------------------------------------------------------------------------------
function UIScene:showThirdUI()
	self:createScrollView1();
	self:createScrollView2();
	self:createScrollView3();
end

function UIScene:createScrollView1()
	if self.m_svTitle then 
		self.m_svTitle:setVisible(true);
	end

	if self.m_svImg then 
		self.m_svImg:setVisible(true);
		return;
	end

	self.m_svTitle = UICreator.createText("原始图",24,display.CENTER,240,480,0,0,0);
	self.m_svTitle:addTo(self);

	self.m_svImg = UICreator.createImg("sunset.png",true,240,300,380,285);
	self.m_svImg:addTo(self);
end

function UIScene:createScrollView2()
	if self.m_svTitle2 then 
		self.m_svTitle2:setVisible(true);
	end

	if self.m_svImg2 then 
		self.m_svImg2:setVisible(true);
		return;
	end

	self.m_svTitle2 = UICreator.createText("可滚动的图",24,display.CENTER,720,580,0,0,0);
	self.m_svTitle2:addTo(self);

    -- local viewRect = cc.rect(580,360,300,200);

    -- self.m_svImg2 = UICreator.createScrollView(UIConfig.SCROLLVIEW.BOTH,viewRect,nil,nil,"sunset.png",true);
    -- self.m_svImg2:onScroll(handler(self, self.onScrollListener));
    -- self.m_svImg2:addTo(self);

    local image = UICreator.createImg("sunset.png",true,720,460,300,200);
    local emptyNode = cc.Node:create();
    emptyNode:addChild(image);

    local bound = image:getBoundingBox();
    bound.width = 300;
    bound.height = 200;
    self.m_svImg2 = UICreator.createScrollView(UIConfig.SCROLLVIEW.BOTH,bound);
    self.m_svImg2:addScrollNode(emptyNode);
    self.m_svImg2:onScroll(handler(self, self.onScrollListener));
    self.m_svImg2:addTo(self);
end

function UIScene:onScrollListener()
end

function UIScene:createScrollView3()
	if self.m_svTitle3 then 
		self.m_svTitle3:setVisible(true);
	end

	if self.m_svImg3 then 
		self.m_svImg3:setVisible(true);
		return;
	end

	self.m_svTitle3 = UICreator.createText("可拖动的图",24,display.CENTER,720,300,0,0,0);
	self.m_svTitle3:addTo(self);

	self.m_svImg3 = UICreator.createImg("sunset.png",true,720,180,300,200);
    self.m_svImg3:addTo(self);

    cc(self.m_svImg3):addComponent("components.ui.DraggableProtocol")
        :exportMethods()
        :setDraggableEnable(true);
end

function UIScene:hideThirdUI()
	if self.m_svTitle then
		self.m_svTitle:setVisible(false);
		self.m_svImg:setVisible(false);
		self.m_svTitle2:setVisible(false);
		self.m_svImg2:setVisible(false);
		self.m_svTitle3:setVisible(false);
		self.m_svImg3:setVisible(false);
	end
end
---------------------------------------------------------------------------------------------------------------------

-------------------------------------------UIImage-------------------------------------------------------------------
function UIScene:showUIImage()
	self:showUIImg1();
	self:showUIImg2();
	self:showUIImg3();
end

function UIScene:showUIImg1()
	if self.m_uiImage1 then
		self.m_uiImage1:setVisible(true);
		self.m_uiText1:setVisible(true);
	end

	if self.m_uiImage2 then 
		self.m_uiImage2:setVisible(true);
		self.m_uiText2:setVisible(true);
		return;
	end

	self.m_uiImage1 = UICreator.createUIImage("PinkScale9Block.png",display.cx - 400,display.cy + 285,nil,nil,display.LEFT_TOP);
    self.m_uiImage1:addTo(self);

    self.m_uiText1 = UICreator.createText("fixed size",16,display.CENTER,display.cx - 350,display.cy + 170, 0,0,0);
    self.m_uiText1:addTo(self);

    self.m_uiImage2 = UICreator.createUIImage("PinkScale9Block.png",display.cx + 400,display.cy + 285,nil,nil,display.RIGHT_TOP);
    self.m_uiImage2:addTo(self);

    self.m_uiText2 = UICreator.createText("fixed size",16,display.CENTER,display.cx + 350,display.cy + 170, 0,0,0);
    self.m_uiText2:addTo(self);
end

function UIScene:showUIImg2()
	if self.m_uiImage3 then
		self.m_uiImage3:setVisible(true);
		self.m_uiText3:setVisible(true);
	end

	if self.m_uiImage4 then 
		self.m_uiImage4:setVisible(true);
		self.m_uiText4:setVisible(true);
	end

	if self.m_uiImage5 then 
		self.m_uiImage5:setVisible(true);
		self.m_uiText5:setVisible(true);
		return;
	end

	self.m_uiImage3 = UICreator.createUIImage("PinkScale9Block.png",display.cx - 400,display.cy + 45,200,100,display.LEFT_CENTER,true);
    self.m_uiImage3:addTo(self);

    self.m_uiText3 = UICreator.createText("use scale9sprite",16,display.CENTER,display.cx - 300, display.cy - 20,0,0,0);
    self.m_uiText3:addTo(self);

    self.m_uiImage4 = UICreator.createUIImage("PinkScale9Block.png",display.cx + 400,display.cy + 45,200,100,display.RIGHT_CENTER,true);
    self.m_uiImage4:addTo(self);

    self.m_uiText4 = UICreator.createText("use scale9sprite",16,display.CENTER,display.cx + 300, display.cy - 20,0,0,0);
    self.m_uiText4:addTo(self);

    self.m_uiImage5 = UICreator.createUIImage("PinkScale9Block.png",display.cx,display.cy + 70,200,150,display.CENTER,true);
    self.m_uiImage5:addTo(self);

    self.m_uiText5 = UICreator.createText("use scale9sprite",16,display.CENTER,display.cx, display.cy - 20,0,0,0);
    self.m_uiText5:addTo(self);

end

function UIScene:showUIImg3()
	if self.m_uiImage6 then 
		self.m_uiImage6:setVisible(true);
		self.m_uiText6:setVisible(true);
	end

	if self.m_uiImage7 then 
		self.m_uiImage7:setVisible(true);
		self.m_uiText7:setVisible(true);
	end

	if self.m_uiImage8 then 
		self.m_uiImage8:setVisible(true);
		self.m_uiText8:setVisible(true);
		return;
	end

	self.m_uiImage6 = UICreator.createUIImage("PinkScale9Block.png",display.cx - 400,display.cy - 225,200,100,display.LEFT_BOTTOM);
    self.m_uiImage6:addTo(self);

    self.m_uiText6 = UICreator.createText("use scaleX, scaleY",16,display.CENTER,display.cx - 300, display.cy - 240,0,0,0);
    self.m_uiText6:addTo(self);

    self.m_uiImage7 = UICreator.createUIImage("PinkScale9Block.png",display.cx + 400,display.cy - 225,200,100,display.RIGHT_BOTTOM);
    self.m_uiImage7:addTo(self);

    self.m_uiText7 = UICreator.createText("use scaleX, scaleY",16,display.CENTER,display.cx + 300, display.cy - 240,0,0,0);
    self.m_uiText7:addTo(self);

    self.m_uiImage8 = UICreator.createUIImage("PinkScale9Block.png",display.cx,display.cy - 150,200,150,display.CENTER);
    self.m_uiImage8:addTo(self);

    self.m_uiText8 = UICreator.createText("use scaleX, scaleY",16,display.CENTER,display.cx, display.cy - 240,0,0,0);
    self.m_uiText8:addTo(self);
end

function UIScene:hideUIImg()
	if self.m_uiImage1 then
		self.m_uiImage1:setVisible(false);
		self.m_uiText1:setVisible(false); 
		self.m_uiImage2:setVisible(false);
		self.m_uiText2:setVisible(false); 
		self.m_uiImage3:setVisible(false);
		self.m_uiText3:setVisible(false); 
		self.m_uiImage4:setVisible(false);
		self.m_uiText4:setVisible(false); 
		self.m_uiImage5:setVisible(false);
		self.m_uiText5:setVisible(false); 
		self.m_uiImage6:setVisible(false);
		self.m_uiText6:setVisible(false); 
		self.m_uiImage7:setVisible(false);
		self.m_uiText7:setVisible(false); 
		self.m_uiImage8:setVisible(false);
		self.m_uiText8:setVisible(false); 
	end
end

------------------------------------------------------------------------------------------------------------------------

------------------------------------------- UIButtons ------------------------------------------------------------------
function UIScene:showUIButtons()
	local label = UICreator.createText("",22,display.CENTER,0,0,255,96,255)
	-- self.m_checkBoxBtn1 = cc.ui.UICheckBoxButton.new(TestUIButtonScene.CHECKBOX_BUTTON_IMAGES)
 --        :setButtonLabelOffset(0, -40)
 --   	self.m_checkBoxBtn1:onButtonStateChanged(function(event)
 --        self:updateCheckBoxButtonLabel(event.target);
 --    end)
 --        :align(display.LEFT_CENTER, display.left + 40, display.top - 80)
 --        :addTo(self)
    -- updateCheckBoxButtonLabel(checkBoxButton1)

end

function UIScene:updateCheckBoxButtonLabel(checkbox)
	local state = "";
    if checkbox:isButtonSelected() then
    	state = "on";
	else
    	state = "off";
	end
    if not checkbox:isButtonEnabled() then
        state = state .. " (disabled)";
    end
    checkbox:setButtonLabelString(string.format("state is %s", state));
end












return UIScene;