local c1 = cc.c3b(55,55,55);
local c2 = cc.c3b(255,51,103);
local c3 = cc.c3b(166,222,249);
local c4 = cc.c3b(100,100,100);

local boxSize = cc.size(90,90);
local objSize = cc.size(80,80);

require("app.logic.Utilities")

local DragScene = class("DragScene",function()
	return display.newScene("DragScene");
end);

function DragScene:ctor()
	self.m_backBtn = UICreator.createBtnText("close.png",true,display.left + 100,display.top - 100,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_backBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"slideInL", 0.6, display.COLOR_WHITE);
	end);

	 --背包格子数据
    self.t_data = {};
    --拖拽对象
    self.m_drag = nil;
    --索引
    self.m_index = 0;
    self.m_indexMax = 3;
    --加载ui
    self:initUI();
    self:addUI();
    --加载拖拽1
    -- self:loadDrag1()

end

--[[--
创建一个装备box
]]
function DragScene:createEquipmentBox(text,point)
    local box1 = cc.LayerColor:create(cc.c4b(c4.r,c4.g,c4.b,255),boxSize.width,boxSize.height);
    box1:setPosition(point);
    local lab1 = display.newTTFLabel({text=text,color=c3,align=cc.ui.TEXT_ALIGN_CENTER,size=30});
    lab1:setPosition(cc.p(box1:getContentSize().width/2,box1:getContentSize().height/2));
    box1:addChild(lab1);
    return box1;
end

function DragScene:initUI()
    self.box1 = self:createEquipmentBox("武器",cc.p(display.width/2/2-boxSize.width/2,display.height/10*7));
    self:addChild(self.box1);

    --衣服
    self.box2 = self:createEquipmentBox("衣服",cc.p(display.width/2/2/3-boxSize.width/2,display.height/10*4));
    self:addChild(self.box2);

    --头盔
    self.box3 = self:createEquipmentBox("头盔",cc.p(display.width/2/2*1.6666-boxSize.width/2,display.height/10*4));
    self:addChild(self.box3);

    --鞋子
    self.box4 = self:createEquipmentBox("鞋子",cc.p(display.width/2/2/2-boxSize.width/2,display.height/10));
    self:addChild(self.box4);

    --腰带
    self.box5 = self:createEquipmentBox("腰带",cc.p(display.width/2/2*1.5-boxSize.width/2,display.height/10));
    self:addChild(self.box5);

    --人物
    self.m_label = UICreator.createText("人物",60,display.CENTER,self.box1:getPositionX()+self.box1:getContentSize().width/2,self.box2:getPositionY()+self.box2:getContentSize().height/2,166,222,249);
    self.m_label:addTo(self);

    --背包
    local bg = cc.LayerColor:create(cc.c4b(100,100,100,255),400,500);
    self:addChild(bg);
    bg:setPosition(cc.p(display.width/2+(display.width/2-400)/2,(display.height-500)/2));

    local rect = cc.rect(0,0, bg:getContentSize().width, bg:getContentSize().height);
    self.m_view = UICreator.createScrollView(UIConfig.SCROLLVIEW.VERTICAL,rect);
    self.m_view:addTo(bg);
   
    self.t_data = {};

    for i = 1, 100 do
        local png = cc.LayerColor:create(cc.c4b(160,160,160,255),boxSize.width,boxSize.height);
        png:setTouchSwallowEnabled(false);
        --把layer当作精灵来处理
        png:ignoreAnchorPointForPosition(false);
        self.t_data[#self.t_data+1] = png;

        local text = UICreator.createText(i,30,display.CENTER,png:getContentSize().width/2, png:getContentSize().height/2,100,100,100);
        text:addTo(png);
    end
    self.m_view:fill(self.t_data, {itemSize = (self.t_data[#self.t_data]):getContentSize()});
    self:slide(self.m_view);
    S_XY(self.m_view:getScrollNode(),0,self.m_view:getViewRect().height-H(self.m_view:getScrollNode()));

end

function DragScene:onEnter()

end

function DragScene:run()

end

function DragScene:onExit()

end

function DragScene:slide(event)
    if event.name ~= "ended" or (event.name == "ended" and SCROLL_EVENT_STATUS == -1) then
        return true;
    end
end

function DragScene:addUI()
	self.m_closeBtn = UICreator.createBtnText("drag/close.png",true,display.width,display.bottom,display.RIGHT_BOTTOM,32,32);
 	self.m_closeBtn:addTo(self, 0);
    self.m_closeBtn:onButtonClicked(function()
		os.exit();
	end);

	local image = {
		normal = "b1.png",
		pressed = "b2.png"
	};

	self.m_prevBtn = UICreator.createBtnText(image,true,display.cx-100,display.bottom,display.BOTTOM_CENTER,79,46);
	self.m_prevBtn:addTo(self,0);

    self.m_prevBtn:onButtonClicked(function() 
            self.m_index = self.m_index-1  
            if self.m_index < 0 then 
            	self.m_index = self.m_indexMax;
            end
            self:changeLayer() ;
    end);

    image = {
		normal = "r1.png",
		pressed = "r2.png"
	};

	self.m_resetBtn = UICreator.createBtnText(image,true,display.cx, display.bottom,display.BOTTOM_CENTER,79,46);
	self.m_resetBtn:addTo(self,0);

    self.m_resetBtn:onButtonClicked(function() 
         self:changeLayer() ;
    end);

    mage = {
		normal = "f1.png",
		pressed = "f2.png"
	};

	self.m_nextBtn = UICreator.createBtnText(image,true,display.cx+100, display.bottom,display.BOTTOM_CENTER,79,46);
	self.m_nextBtn:addTo(self,0);

    self.m_nextBtn:onButtonClicked(function() 
         self.m_index = self.m_index+1;  
            if self.m_index > self.m_indexMax then 
            	self.m_index = 0;
			end
            self:changeLayer();
    end);

    self.m_nextBtn:onButtonClicked(function() 
        self.m_index = self.m_index+1  ;
        if self.m_index > self.m_indexMax then 
           self.m_index = 0 ;
        end
        self:changeLayer() ;
	end);

	self.m_title = UICreator.createText("Filters test",22,display.CENTER,display.cx,display.top-40,255,255,255);
	self.m_title:addTo(self,10);
end

function DragScene:changeLayer()
    if self._index == 0 then
        self:loadDrag1();
    elseif self._index == 1 then
        self:loadDrag2();
    elseif self._index == 2 then
        self:loadDrag3();
    elseif self._index == 3 then
        self:loadDrag4();
--    
--    elseif self._index == 0 then
--    
--    elseif self._index == 0 then
--    
    end
    
end

return DragScene;