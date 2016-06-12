cc.utils = require("framework.cc.utils.init");
local ByteArray = cc.utils.ByteArray;
local ByteArrayVarint = cc.utils.ByteArrayVarint;

local ByteArrayScene = class("ByteArrayScene",function()
	return display.newScene("ByteArrayScene");
end);

function ByteArrayScene:ctor()
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
		display.replaceScene(mainScene,"splitRows", 0.6, display.COLOR_WHITE);
	end);

	local label = UICreator.createText("Compare lpack and ByteArray",32,display.CENTER,display.cx,display.cy,255,255,255);
	self.m_test1Btn = UICreator.createBtnText(nil,false, display.cx, display.top - 32,display.CENTER,nil,nil,label);
	self.m_test1Btn:addTo(self);

	self.m_test1Btn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_test1Btn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_test1Btn:onButtonClicked(function(event)
		self:onTest1BtnClicked();
	end);

	label = UICreator.createText("Test bug 1",32,display.CENTER,display.cx,display.cy,255,255,255);
	self.m_test2Btn = UICreator.createBtnText(nil,false, display.cx, display.top - 64,display.CENTER,nil,nil,label);
	self.m_test2Btn:addTo(self);

	self.m_test2Btn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_test2Btn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_test2Btn:onButtonClicked(function(event)
		self:onTest2BtnClicked();
	end);

	label = UICreator.createText("Test length of long",32,display.CENTER,display.cx,display.cy,255,255,255);
	self.m_test3Btn = UICreator.createBtnText(nil,false, display.cx, display.top - 96,display.CENTER,nil,nil,label);
	self.m_test3Btn:addTo(self);

	self.m_test3Btn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_test3Btn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_test3Btn:onButtonClicked(function(event)
		self:onTest3BtnClicked();
	end);

end

function ByteArrayScene:onTest1BtnClicked()
	local __pack = self:getDataByLpack();
	local __ba1 = ByteArray.new():writeBuf(__pack)
					:setPos(1);
	print("ba1.len:", __ba1:getLen());
	print("ba1.readByte:", __ba1:readByte());
	print("ba1.readInt:", __ba1:readInt());
	print("ba1.readShort:", __ba1:readShort());
	print("ba1.readString:", __ba1:readStringUShort());
	print("ba1.readString:", __ba1:readStringUShort());
	print("ba1.available:", __ba1:getAvailable());
	print("ba1.toString(16):", __ba1:toString(16));
	print("ba1.toString(10):", __ba1:toString(10));

	local __ba2 = self:getByteArray();
	print("ba2.toString(10):", __ba2:toString(10));


	local __ba3 = ByteArray.new();
	local __str = "";
	for i=1,20 do
		__str = __str.."ABCDEFGHIJ";
	end
	__ba3:writeStringSizeT(__str);
	__ba3:setPos(1);
	print("__ba3:readUInt:", __ba3:readUInt());
	-- print("__ba3.readStringSizeT:", __ba3:readStringUInt());
end

function ByteArrayScene:onTest2BtnClicked()
	print("test2");
	local ba = ByteArrayVarint.new(ByteArrayVarint.ENDIAN_BIG)
		:writeInt(34);
	print(ba:toString(), ba:getLen());
	print(string.format("buf all bytes:%s, %d", 
		ByteArray.toString(ba:getBytes(), 16), 
		ba:getLen()));
end

function ByteArrayScene:onTest3BtnClicked()
	print("test3");
	local l = string.pack("l", 32333);
	print(#l)
	local L = string.pack("L", 33333);
	print(#L);
	local i = string.pack("i", 32333);
	print(#i);
	local I = string.pack("I", 33333);
	print(#I);
end

function ByteArrayScene:run()
end

function ByteArrayScene:onEnter()
end

function ByteArrayScene:onExit()
end

function ByteArrayScene:getDataByLpack()
	local pack = string.pack("<bihP2", 0x59, 11, 1101, "", "中文");
	print(pack);
	return pack;
end

function ByteArrayScene:getByteArray()
	return ByteArray.new()
		:writeByte(0x59)
		:writeInt(11)
		:writeShort(1101)
		:writeStringUShort("")
		:writeStringUShort("中文");
end


return ByteArrayScene;