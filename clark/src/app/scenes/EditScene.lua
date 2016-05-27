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

	local listener = function(event, editbox)
        if event == "began" then
           self:onEditBoxBegan(editbox)
        elseif event == "ended" then
           self:onEditBoxEnded(editbox)
        elseif event == "return" then
           self:onEditBoxReturn(editbox)
        elseif event == "changed" then
           self:onEditBoxChanged(editbox)
        else
           printf("EditBox event %s", tostring(event))
        end
    end
	self.m_editBox = UICreator.createEditBox(1,"EditBoxBg.png",nil,nil,display.cx,display.cy,400,60,listener,
												"AV","请输入名称",nil,3);
	self.m_editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
	self.m_editBox:addTo(self);

	self.m_editBox2 = UICreator.createEditBox(2,"EditBoxBg.png",nil,nil,display.cx,display.cy - 100,400,96,listener,
												"AV","请输入名称",nil,14,4,true,"*");
	self.m_editBox2:addTo(self); 

	self.m_editBoxBtn2 = UICreator.createBtnText("EditBoxBg.png",true,display.cx + 100, display.cy,display.CENTER,120,160);
	self.m_editBoxBtn2:addTo(self);

	self.m_editBoxBtn2:onButtonPressed(function(event)
		self.m_editBoxBtn2:setOpacity(128);
	end);

	self.m_editBoxBtn2:onButtonRelease(function(event)
		self.m_editBoxBtn2:setOpacity(255);
	end);
end

function EditScene:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
end

function EditScene:onEditBoxEnded(editbox)
    printf("editBox1 event ended : %s", editbox:getText())
end

function EditScene:onEditBoxReturn(editbox)
    printf("editBox1 event return : %s", editbox:getText())
end

function EditScene:onEditBoxChanged(editbox)
    printf("editBox1 event changed : %s", editbox:getText())
end


return EditScene;