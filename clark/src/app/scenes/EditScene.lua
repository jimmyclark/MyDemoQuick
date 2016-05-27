local EditScene = class("EditScene",function()
	return display.newScene("EditScene");
end);

function EditScene:ctor()
	self:createEditBox();
end

function EditScene:run()

end

function EditScene:exit()

end

function EditScene:createEditBox()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 100,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"fadeUp", 0.6, display.COLOR_WHITE);
	end);

	self.m_editBoxBtn = UICreator.createBtnText("EditBoxBg.png",true,display.cx - 100, display.cy,display.CENTER,120,160);
	self.m_editBoxBtn:addTo(self);

	self.m_editBoxBtn:onButtonPressed(function(event)
		self.m_editBoxBtn:setOpacity(128);
	end);

	self.m_editBoxBtn:onButtonRelease(function(event)
		self.m_editBoxBtn:setOpacity(255);
	end);

	self.m_editBoxBtn2 = UICreator.createBtnText("EditBoxBg.png",true,display.cx + 100, display.cy,display.CENTER,120,160);
	self.m_editBoxBtn2:addTo(self);

	self.m_editBoxBtn2:onButtonPressed(function(event)
		self.m_editBoxBtn2:setOpacity(128);
	end);

	self.m_editBoxBtn2:onButtonRelease(function(event)
		self.m_editBoxBtn2:setOpacity(255);
	end);
end

return EditScene;