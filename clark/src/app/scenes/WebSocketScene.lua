local WebSockets = require("app.WebSocket");

local WebSocketScene = class("WebSocketScene", function()
    return display.newScene("WebSocketScene");
end)

function WebSocketScene:ctor()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 100,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"flipAngular",0.7,cc.TRANSITION_ORIENTATION_DOWN_OVER);
	end);

	local connectText = UICreator.createText("connect",32,display.CENTER,0,0,255,255,255);
	self.m_connectBtn = UICreator.createBtnText(nil,nil,display.cx, display.top - 32,display.CENTER,nil,nil,connectText);
	self.m_connectBtn:addTo(self);
	self.m_connectBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);
	self.m_connectBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);
	self.m_connectBtn:onButtonClicked(function(event)
		self:setAllEnabled(false);
		self:onConnectedClicked();
		
	end);


	local sendText = UICreator.createText("send text",32,display.CENTER,0,0,255,255,255);
	self.m_sendTextBtn = UICreator.createBtnText(nil,nil,display.cx, display.top - 64,display.CENTER,nil,nil,sendText);
	self.m_sendTextBtn:addTo(self);
	self.m_sendTextBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);
	self.m_sendTextBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);
	self.m_sendTextBtn:onButtonClicked(function(event)
		self:setAllEnabled(false);
		self:onSendClicked();
	end);

	local sendBinary = UICreator.createText("send binary",32,display.CENTER,0,0,255,255,255);
	self.m_sendBinaryBtn = UICreator.createBtnText(nil,nil,display.cx, display.top - 96,display.CENTER,nil,nil,sendBinary);
	self.m_sendBinaryBtn:addTo(self);
	self.m_sendBinaryBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);
	self.m_sendBinaryBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);
	self.m_sendBinaryBtn:onButtonClicked(function(event)
		self:setAllEnabled(false);
		self:onSendBinaryClicked();
	end);

end

function WebSocketScene:exit()

end

function WebSocketScene:onConnectedClicked()
	if self.m_websocket then 
		self:setAllEnabled(true);
		return; 
	end

	self.m_url = "ws://echo.websocket.org";

    self.websocket = WebSockets.new(self.m_url);
    self.websocket:addEventListener(WebSockets.OPEN_EVENT, handler(self, self.onOpen));
    self.websocket:addEventListener(WebSockets.MESSAGE_EVENT, handler(self, self.onMessage));
    self.websocket:addEventListener(WebSockets.CLOSE_EVENT, handler(self, self.onClose));
    self.websocket:addEventListener(WebSockets.ERROR_EVENT, handler(self, self.onError));

end

function WebSocketScene:onSendClicked()
    if not self.websocket then
        print("not connected");
        self:setAllEnabled(true);
        return;
    end

    local text = "hello mellow";
    if self.websocket:send(text) then
        printf("send text msg: %s", text);
    end
end

function WebSocketScene:onSendBinaryClicked()
	if not self.websocket then
        print("not connected");
        self:setAllEnabled(true);
        return;
    end

    local t = {};
    for i = 1, math.random(4, 8) do
        t[#t + 1] = string.char(math.random(0, 31));
    end
    local binary = table.concat(t);
    if self.websocket:send(binary, WebSockets.BINARY_MESSAGE) then
        printf("send binary msg: len = %d, binary = %s", string.len(binary), self:bin2hex(binary));
    end
end

function WebSocketScene:onOpen(event)
	self:setAllEnabled(true);
	print("connected" .. self.m_url);
end

function WebSocketScene:onMessage(event)
	self:setAllEnabled(true);
    if WebSockets.BINARY_MESSAGE == event.messageType then
        printf("receive binary msg: len = %s, binary = %s", string.len(event.message),self:bin2hex(event.message));
    else
        printf("receive text msg: %s", event.message);
    end
end

function WebSocketScene:bin2hex(binary)
    local t = {}
    for i = 1, string.len(binary) do
        t[#t + 1] = string.format("0x%02x", string.byte(binary, i))
    end
    return table.concat(t, " ")
end

function WebSocketScene:onClose(event)
	print("onClose")
	self:setAllEnabled(true);
    self.websocket = nil;
end

function WebSocketScene:onError(event)
	self:setAllEnabled(true);
    printf("error %s", event.error);
    self.websocket = nil;
end

function WebSocketScene:setAllEnabled(isEnabled)
	local opacity = 255;
	if not isEnabled then 
		opacity = 128;
	end
	self.m_connectBtn:setOpacity(opacity);
	self.m_connectBtn:setButtonEnabled(isEnabled);
	self.m_sendTextBtn:setOpacity(opacity);
	self.m_sendTextBtn:setButtonEnabled(isEnabled);
	self.m_sendBinaryBtn:setOpacity(opacity);
	self.m_sendBinaryBtn:setButtonEnabled(isEnabled);
end

return WebSocketScene;