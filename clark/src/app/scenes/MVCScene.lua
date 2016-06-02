local MVCController = import("..controllers.MVCController")

local MVCScene = class("MVCScene",function()
	return display.newScene("MVCScene");
end);

function MVCScene:ctor()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 50,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"rotoZoom",0.7);
	end);

	display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(self);

	self:addChild(MVCController.new());

	local label = UICreator.createText("REFRESH",20,display.CENTER,display.cx,display.cy,0,0,0);
	self.m_pushBtn = UICreator.createBtnText("Button01.png",true,display.cx, display.bottom + 100,display.CENTER,200,80,label);
	self.m_pushBtn:addTo(self);

	self.m_pushBtn:onButtonPressed(function(event)
        event.target:setScale(1.1);
    end)
    self.m_pushBtn:onButtonRelease(function(event)
        event.target:setScale(1.0);
	end)
    self.m_pushBtn:onButtonClicked(function()
        app:enterScene("MainScene", nil, "flipy");
    end)
end

function MVCScene:onExit()
end

return MVCScene;