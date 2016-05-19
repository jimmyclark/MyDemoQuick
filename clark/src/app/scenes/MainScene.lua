require("utils.UICreator")


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self.m_text = UICreator.createText("2048",40,display.CENTER,display.cx,display.cy,255,0,0,"Marker Felt");
    -- self.m_text:addTo(self);

    local image = {
    	normal = "GreenButton.png",
    	pressed = "GreenScale9Block.png",
    	disabled = "GreenButton.png",
	};
	self.m_button = UICreator.createBtnText(image,true,display.cx,display.cy+60,display.CENTER,200,100,self.m_text);
	self.m_button:addTo(self);
	
	self.m_button:onButtonClicked(function(event)
		self:enterTo2048();
	end)
	-- local sceneTOFE = require("app.scenes.SceneTOFE").new();
    -- display.replaceScene(sceneTOFE,"fade", 0.6, display.COLOR_WHITE);
end

function MainScene:enterTo2048()
	local sceneTOFE = require("app.scenes.SceneTOFE").new();
    display.replaceScene(sceneTOFE,"fade", 0.6, display.COLOR_WHITE);
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
