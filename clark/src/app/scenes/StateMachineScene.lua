local StateMachineScene = class("StateMachineScene",function()
	return display.newScene("StateMachineScene");
end);

function StateMachineScene:ctor()
	display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME);

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

	display.newColorLayer(cc.c4b(255, 255, 255, 255))
        :addTo(self);

    self.m_title = UICreator.createText("Finite State Machine",32,display.CENTER,display.cx, display.top - 60,0,0,0);
    self.m_title:addTo(self);

    self.m_paddingLabel = UICreator.createText("",32,display.CENTER,display.cx,display.top - 620,0,0,0);
    self.m_paddingLabel:addTo(self);

    self.stateImage_ = display.newSprite("#GreenState.png")
        :pos(display.cx, display.top - 300)
        :scale(1.5)
        :addTo(self);
    self.m_logCount = 0;
    self:initStateMachine();

    local clearText = UICreator.createText("clear",32,display.CENTER,display.cx,0,0,0,0);
    self.m_clearBtn = UICreator.createBtnText(nil,nil, display.cx, display.top - 120,display.CENTER,100,32,clearText);
    self.m_clearBtn:addTo(self);

    self.m_clearBtn:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_clearBtn:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_clearBtn:onButtonClicked(function(event)
    	self:onClearBtnClicked(event);
    end); 

	local calmText = UICreator.createText("calm",32,display.CENTER,display.cx,0,0,0,0);
    self.m_calmBtn = UICreator.createBtnText(nil,nil, display.left+50, display.cy,display.CENTER,100,32,calmText);
    self.m_calmBtn:addTo(self);

    self.m_calmBtn:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_calmBtn:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_calmBtn:onButtonClicked(function(event)
    	self:onCalmBtnClicked(event);
    end); 

    local warnText = UICreator.createText("warn",32,display.CENTER,display.cx,0,0,0,0);
    self.m_warnBtn = UICreator.createBtnText(nil,nil, display.cx, display.bottom + 50,display.CENTER,100,32,warnText);
    self.m_warnBtn:addTo(self);

    self.m_warnBtn:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_warnBtn:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_warnBtn:onButtonClicked(function(event)
    	self:onWarnBtnClicked(event);
    end); 

    local panicText = UICreator.createText("panic",32,display.CENTER,display.cx,0,0,0,0);
    self.m_panicBtn = UICreator.createBtnText(nil,nil, display.right - 50, display.cy,display.CENTER,100,32,panicText);
    self.m_panicBtn:addTo(self);

    self.m_panicBtn:onButtonPressed(function(event)
        	event.target:setOpacity(128);
        end);
	self.m_panicBtn:onButtonRelease(function(event)
        	event.target:setOpacity(255);
    end);
    self.m_panicBtn:onButtonClicked(function(event)
    	self:onPanicBtnClicked(event);
    end); 


end

function StateMachineScene:exit()

end

function StateMachineScene:onClearBtnClicked(event)
	if self.m_fsm:canDoEvent("clear") then
        self.m_fsm:doEvent("clear");
    end
end

function StateMachineScene:onCalmBtnClicked(event)
	if self.m_fsm:canDoEvent("calm") then
        self.m_fsm:doEvent("calm");
    end
end

function StateMachineScene:onWarnBtnClicked(event)
	if self.m_fsm:canDoEvent("warn") then
        self.m_fsm:doEvent("warn");
    end
end

function StateMachineScene:onPanicBtnClicked(event)
	if self.m_fsm:canDoEvent("panic") then
        self.m_fsm:doEvent("panic");
    end
end

function StateMachineScene:initStateMachine()
	self.m_fsm = {};
    cc.GameObject.extend(self.m_fsm)
        :addComponent("components.behavior.StateMachine")
        :exportMethods();

    self.m_fsm:setupState({
        events = {
            {name = "start", from = "none",   to = "green" },
            {name = "warn",  from = "green",  to = "yellow"},
            {name = "panic", from = "green",  to = "red"   },
            {name = "panic", from = "yellow", to = "red"   },
            {name = "calm",  from = "red",    to = "yellow"},
            {name = "clear", from = "red",    to = "green" },
            {name = "clear", from = "yellow", to = "green" },
        },

        callbacks = {
            onbeforestart = function(event)
            	 self:log("[FSM] STARTING UP");
           	end,
            onstart = function(event) 
            	self:log("[FSM] READY");
            end,
            onbeforewarn  = function(event) 
            	self:log("[FSM] START   EVENT: warn!", true);
            end,
            onbeforepanic = function(event)
            	self:log("[FSM] START   EVENT: panic!", true);
			end,
            onbeforecalm  = function(event) 
            	self:log("[FSM] START   EVENT: calm!",  true);
           	end,
            onbeforeclear = function(event)
            	self:log("[FSM] START   EVENT: clear!", true);
            end,
            onwarn = function(event) 
            	self:log("[FSM] FINISH  EVENT: warn!");
            end,
            onpanic = function(event) 
            	self:log("[FSM] FINISH  EVENT: panic!");
            end,
            oncalm = function(event) 
            	self:log("[FSM] FINISH  EVENT: calm!");
            end,
            onclear = function(event)
            	self:log("[FSM] FINISH  EVENT: clear!");
            end,
            onleavegreen  = function(event) 
            	self:log("[FSM] LEAVE   STATE: green");
            end,
            onleaveyellow = function(event) 
            	self:log("[FSM] LEAVE   STATE: yellow");
            end,
            onleavered = function(event)
                self:log("[FSM] LEAVE   STATE: red");
                self:pending(event, 3);
                self:performWithDelay(function()
                    self:pending(event, 2);
	                self:performWithDelay(function()
	                    self:pending(event, 1);
		                self:performWithDelay(function()
		                    self.m_paddingLabel:setString("");
		                    event.transition();
						end, 1);
                    end, 1);
                end, 1);
                return "async";
            end,
            ongreen = function(event) 
            	self:log("[FSM] ENTER   STATE: green");
            end,
            onyellow = function(event) 
            	self:log("[FSM] ENTER   STATE: yellow");
            end,
            onred = function(event) 
            	self:log("[FSM] ENTER   STATE: red");
            end,
            onchangestate = function(event) 
            	self:log("[FSM] CHANGED STATE: " .. event.from .. " to " .. event.to);
            end,
        },
    })
end

function StateMachineScene:pending(event,n)
    local msg = event.to .. " in ..." .. n;
    self:log("[FSM] PENDING STATE: " .. msg);
    self.m_paddingLabel:setString(msg);
end

function StateMachineScene:log(msg, separate)
    if separate then 
    	self.m_logCount = self.m_logCount + 1;
    end
    if separate then 
    	print(""); 
    end
    printf("%d: %s", self.m_logCount, msg);

    local state = self.m_fsm:getState();
    if state == "green" then
        self.stateImage_:setSpriteFrame(display.newSpriteFrame("GreenState.png"));
    elseif state == "red" then
        self.stateImage_:setSpriteFrame(display.newSpriteFrame("RedState.png"));
    elseif state == "yellow" then
        self.stateImage_:setSpriteFrame(display.newSpriteFrame("YellowState.png"));
    end

    -- self.clearButton_:setEnabled(self.fsm_:canDoEvent("clear"))
    -- self.calmButton_:setEnabled(self.fsm_:canDoEvent("calm"))
    -- self.warnButton_:setEnabled(self.fsm_:canDoEvent("warn"))
    -- self.panicButton_:setEnabled(self.fsm_:canDoEvent("panic"))
end

function StateMachineScene:onEnter()
    self.m_fsm:doEvent("start");
end


return StateMachineScene;