local StateMachineScene = class("StateMachineScene",function()
	return display.newScene("StateMachineScene");
end);

function StateMachineScene:ctor()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 50,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"jumpZoom",0.7);
	end);
end

function StateMachineScene:exit()

end

return StateMachineScene;