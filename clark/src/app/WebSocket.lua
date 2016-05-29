local WebSocket = class("WebSocket");

WebSocket.OPEN_EVENT    = "open";
WebSocket.MESSAGE_EVENT = "message";
WebSocket.CLOSE_EVENT   = "close";
WebSocket.ERROR_EVENT   = "error";

WebSocket.TEXT_MESSAGE = 0;
WebSocket.BINARY_MESSAGE = 1;
WebSocket.BINARY_ARRAY_MESSAGE = 2;

function WebSocket:ctor(url)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods();
    self.m_socket = cc.WebSocket:create(url);

    if self.m_socket then
        self.m_socket:registerScriptHandler(handler(self, self.onOpen), cc.WEBSOCKET_OPEN);
        self.m_socket:registerScriptHandler(handler(self, self.onMessage), cc.WEBSOCKET_MESSAGE);
        self.m_socket:registerScriptHandler(handler(self, self.onClose), cc.WEBSOCKET_CLOSE);
        self.m_socket:registerScriptHandler(handler(self, self.onError), cc.WEBSOCKET_ERROR);
    end
end

function WebSocket:isReady()
    return self.m_socket and self.m_socket:getReadyState() == cc.WEBSOCKET_STATE_OPEN;
end

function WebSocket:send(data, messageType)
    if not self:isReady() then
        printError("WebSocket:send() - socket is't ready");
        return false;
    end

    messageType = checkint(messageType);
    self.messageType = messageType;
    if messageType == WebSocket.TEXT_MESSAGE then
        self.m_socket:sendString(tostring(data));
    elseif messageType == WebSocket.BINARY_ARRAY_MESSAGE then
        data = checktable(data)
        self.m_socket:sendString(data, table.nums(data));
    else
        self.m_socket:sendString(tostring(data));
    end
    return true;
end

function WebSocket:onOpen()
    self:dispatchEvent({name = WebSocket.OPEN_EVENT});
end

function WebSocket:onMessage(message)
    local params = {
        name = WebSocket.MESSAGE_EVENT,
        message = message,
        messageType = self.messageType
    }

    self:dispatchEvent(params);
end

function WebSocket:onClose()
    self:dispatchEvent({name = WebSocket.CLOSE_EVENT});
    self:close();
end

function WebSocket:onError(error)
    self:dispatchEvent({name = WebSocket.ERROR_EVENT, error = error});
end

function WebSocket:close()
	-- print("close xxx")
    if self.m_socket then
        self.m_socket:close();
        self.m_socket = nil;
    end
    self:removeAllEventListeners();
end

return WebSocket;