require("utils.UICreator")


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self.m_title = {"2048","ui测试","Edit","WebSocket","touch","test","State","Sprite3D","physics","mvc","filter","drag","ccsLoader",
	"byteArray","benchmark","armature","nightclub","towfence","coinflip"};

    -- self.m_text = UICreator.createText(self.m_title[2],40,display.CENTER,display.cx,display.cy,255,0,0,"Marker Felt");
    -- self.m_text:addTo(self);

    local image = {
    	normal = "GreenButton.png",
    	pressed = "GreenScale9Block.png",
    	disabled = "GreenButton.png",
	};

	local viewRect = cc.rect(display.cx/4,display.cy/4,display.width - 50,display.height-50);
	local padding = {left=60,right=60,top=60,bottom=60};
	self.m_btnGroup = UICreator.createPageView(viewRect,4,4,padding,false);
	self.m_btnGroup:addTo(self);
	local x,y;

	for i=1,#self.m_title do
        local item = self.m_btnGroup:newItem();
        local content;
		
  		local m_label = UICreator.createText(self.m_title[i],20,display.CENTER,display.cx,display.cy,255,0,0,"Marker Felt");
  		local m_button = UICreator.createBtnText(image,true,x,y,display.CENTER,100,100,m_label);
		
		m_button:onButtonClicked(function(event)
			if i == 1 then 
				self:enterTo2048();
			elseif i== 2 then
				self:enterToUIScene();
			elseif i == 3 then 
				self:enterToEditBox();
			elseif i == 4 then 
				self:enterToWebSocketView();
			elseif i == 5 then
				self:enterToTouchView();
			elseif i == 6 then 
				self:enterToTestView();
			elseif i == 7 then 
				self:enterToStateMachineView();
			elseif i == 8 then
				self:enterToSprite3DView();
			elseif i == 9 then 
				self:enterToPhysicalView();
			elseif i == 10 then 
				self:enterToMVCView();
			elseif i == 11 then
				self:enterToFilterView();
			elseif i == 12 then 
				self:enterToDragView();
			elseif i == 13 then 
				self:enterToCCSLoaderView();
			elseif i == 14 then
				self:enterByteArrayView();
			elseif i == 15 then
				self:enterToBenchMarkView();
			elseif i == 16 then 
				self:enterToAmatureView();
			elseif i == 17 then 
				self:enterToNightClubView();
			elseif i == 18 then 
				self:enterToTowerDefenceView();
			end
		end)
        item:addChild(m_button);
        self.m_btnGroup:addItem(item); 


    end
    self.m_btnGroup:reload();
end

function MainScene:enterTo2048()
	local sceneTOFE = require("app.scenes.SceneTOFE").new();
    display.replaceScene(sceneTOFE,"fade", 0.6, display.COLOR_WHITE);
end

function MainScene:enterToUIScene()
	local sceneUi = require("app.scenes.UIScene").new();
	display.replaceScene(sceneUi,"fade", 0.3, display.COLOR_WHITE);
end

function MainScene:enterToEditBox()
	local sceneEditBox = require("app.scenes.EditScene").new();
	display.replaceScene(sceneEditBox,"fadeTR",0.3,display.COLOR_WHITE);
end

function MainScene:enterToWebSocketView()
	local sceneToWebSocket = require("app.scenes.WebSocketScene").new();
	display.replaceScene(sceneToWebSocket,"flipAngular",0.2,cc.TRANSITION_ORIENTATION_LEFT_OVER);
end

function MainScene:enterToTouchView()
	local sceneToTouch = require("app.scenes.TouchScene").new();
	display.replaceScene(sceneToTouch,"flipX",0.2,cc.TRANSITION_ORIENTATION_LEFT_OVER);
end

function MainScene:enterToTestView()
	local sceneToTest = require("app.scenes.TestScene").new();
	display.replaceScene(sceneToTest,"zoomFlipAngular",0.2,cc.TRANSITION_ORIENTATION_LEFT_OVER);
end

function MainScene:enterToStateMachineView()
	local sceneToStateMachine = require("app.scenes.StateMachineScene").new();
	display.replaceScene(sceneToStateMachine,"moveInB",0.2);
end

function MainScene:enterToSprite3DView()
	local sceneToSprite3D = require("app.scenes.Sprite3DScene").new();
	display.replaceScene(sceneToSprite3D,"moveInL",0.2);
end

function MainScene:enterToPhysicalView()
	local sceneToPhysical = require("app.scenes.PhysicalScene").new();
	display.replaceScene(sceneToPhysical,"moveInT",0.2);
end

function MainScene:enterToMVCView()
	local sceneToMVC = require("app.scenes.MVCScene").new();
	display.replaceScene(sceneToMVC,"pageTurn",0.4,false);
end

function MainScene:enterToFilterView()
	local sceneToFilter = require("app.scenes.FilterScene").new();
	display.replaceScene(sceneToFilter,"rotoZoom",0.4,false);
end

function MainScene:enterToDragView()
	local sceneToDrag = require("app.scenes.DragScene").new();
	display.replaceScene(sceneToDrag,"slideInB",0.4,false);
end

function MainScene:enterToCCSLoaderView()
	local sceneToDrag = require("app.scenes.CCSLoaderScene").new();
	display.replaceScene(sceneToDrag,"splitCols",0.4,false);
end

function MainScene:enterByteArrayView()
	local sceneToDrag = require("app.scenes.ByteArrayScene").new();
	display.replaceScene(sceneToDrag,"turnOffTiles",0.4,false);
end

function MainScene:enterToBenchMarkView()
	local sceneToBenchMark = require("app.scenes.BenchMark").new();
	display.replaceScene(sceneToBenchMark,"turnOffTiles",0.4,false);
end

function MainScene:enterToAmatureView()
	local sceneToAmature = require("app.scenes.AmatureScene").new();
	display.replaceScene(sceneToAmature);
end

function MainScene:enterToNightClubView()
	local sceneToNightClub = require("app.scenes.NightClubScene").new();
	display.replaceScene(sceneToNightClub);
end

function MainScene:enterToTowerDefenceView()
	local sceneToTowerDefence = require("app.scenes.TowerDefenceScene").new();
	display.replaceScene(sceneToTowerDefence);
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
