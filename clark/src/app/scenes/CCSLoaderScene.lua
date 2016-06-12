local CCSLoaderScene = class("CCSLoaderScene",function()
	return display.newScene("CCSLoaderScene");
end);

function CCSLoaderScene:ctor()
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


	self.m_title = UICreator.createText("Select Loader",24,display.CENTER, display.cx, display.top - 20,255,0,255);
	self.m_title:addTo(self,1000);

	local text = UICreator.createText("Use CCSLoader",18,display.CENTER,0,0,0,0,0);
	self.m_loaderBtn = UICreator.createBtnText("ccs/GreenButton.png",true,display.cx,display.cy + 40,display.CENTER,200,60,text);
	self.m_loaderBtn:onButtonPressed(function(event)
		event.target:setScale(1.2);
	end);
	self.m_loaderBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
	end);
	self.m_loaderBtn:onButtonClicked(function(event)
		self:onLoadBtnClick();
	end);

	self.m_loaderBtn:addTo(self);

	local text = UICreator.createText("Use CCSReader",18,display.CENTER,0,0,0,0,0);
	self.m_readerBtn = UICreator.createBtnText("ccs/GreenButton.png",true,display.cx,display.cy - 40,display.CENTER,200,60,text);
	self.m_readerBtn:onButtonPressed(function(event)
		event.target:setScale(1.2);
	end);
	self.m_readerBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
	end);
	self.m_readerBtn:onButtonClicked(function(event)
		self:onReadBtnClick();
	end);

	self.m_readerBtn:addTo(self);
end

function CCSLoaderScene:onLoadBtnClick()
	self:hideMenuBtn();
	self.m_titles = {"CCSLoader1","CCSLoader2","CCSLoader3","CCSLoader4","CCSLoader5","CCSLoader6"};
	self:showFirstLoadScene();
	self:createNextBtn();
end

function CCSLoaderScene:onReadBtnClick()
	self:hideMenuBtn();
	self.m_read_titles = {"CCSReader1","CCSReader2","CCSReader3","CCSReader4","CCSReader5","CCSReader6"};
	self:showFirstReadScene();
	self.m_index = 8;
	self:createNextBtn();
end

function CCSLoaderScene:run()
end

function CCSLoaderScene:onEnter()
end

function CCSLoaderScene:onExit()
end

function CCSLoaderScene:hideMenuBtn()
	if self.m_readerBtn then 
		self.m_readerBtn:setVisible(false);
		self.m_loaderBtn:setVisible(false);
	end
end

function CCSLoaderScene:createNextBtn()
	self.m_nextBtn = UICreator.createBtnText("NextButton.png",true,display.right - 20, display.bottom + 20,display.RIGHT_BOTTOM);
	self.m_nextBtn:addTo(self,10);
	self.m_nextBtn:onButtonPressed(function(event)
        event.target:setScale(1.2);
	end);
    self.m_nextBtn:onButtonRelease(function(event)
		event.target:setScale(1.0);
    end);
    self.m_nextBtn:onButtonClicked(function(event)
    	self:showNextBtn();
    end);
end

function CCSLoaderScene:showNextBtn()
	if not self.m_index then 
		self.m_index = 2;
	end
	if self.m_index == 1 then
		self:hideSecondLoadScene();
		self:hideThirdLoadScene();
		self:hideForthLoadScene();
		self:hideFifthLoadScene();
		self:hideSixthLoadScene();
		self:showFirstLoadScene();
	elseif self.m_index == 2 then
		self:hideFirstLoadScene();
		self:hideThirdLoadScene();
		self:hideForthLoadScene();
		self:hideFifthLoadScene();
		self:hideSixthLoadScene();
		self:showSecondLoadScene();
	elseif self.m_index == 3 then 
		self:hideFirstLoadScene();
		self:hideSecondLoadScene();
		self:hideForthLoadScene();
		self:hideFifthLoadScene();
		self:hideSixthLoadScene();
		self:showThirdLoadScene();
	elseif self.m_index == 4 then 
		self:hideFirstLoadScene();
		self:hideSecondLoadScene();
		self:hideThirdLoadScene();
		self:hideFifthLoadScene();
		self:hideSixthLoadScene();
		self:showForthLoadScene();
	elseif self.m_index == 5 then 
		self:hideFirstLoadScene();
		self:hideSecondLoadScene();
		self:hideThirdLoadScene();
		self:hideForthLoadScene();
		self:hideSixthLoadScene();
		self:showFifthLoadScene();
	elseif self.m_index == 6 then 
		self:hideFirstLoadScene();
		self:hideSecondLoadScene();
		self:hideThirdLoadScene();
		self:hideForthLoadScene();
		self:hideFifthLoadScene();
		self:showSixthLoadScene();
		self.m_index = 1;
		return;
	elseif self.m_index == 7 then 
		self:showFirstReadScene();
		self:hideSecondReadScene();
		self:hideThirdReadScene();
		self:hideForthReadScene();
		self:hideFifthReadScene();
		self:hideSixthReadScene();
	elseif self.m_index == 8 then 
		self:hideFirstReadScene();
		self:hideThirdReadScene();
		self:hideForthReadScene();
		self:hideFifthReadScene();
		self:hideSixthReadScene();
		self:showSecondReadScene();
	elseif self.m_index == 9 then 
		self:hideFirstReadScene();
		self:hideSecondReadScene();
		self:hideForthReadScene();
		self:hideFifthReadScene();
		self:hideSixthReadScene();
		self:showThirdReadScene();
	elseif self.m_index == 10 then 
		self:hideFirstReadScene();
		self:hideSecondReadScene();
		self:hideThirdReadScene();
		self:hideFifthReadScene();
		self:hideSixthReadScene();
		self:showForthReadScene();
	elseif self.m_index == 11 then
		self:hideFirstReadScene();
		self:hideSecondReadScene();
		self:hideThirdReadScene();
		self:hideForthReadScene();
		self:hideSixthReadScene();
		self:showFifthReadScene();
	elseif self.m_index == 12 then 
		self:hideFirstReadScene();
		self:hideSecondReadScene();
		self:hideThirdReadScene();
		self:hideForthReadScene();
		self:hideFifthReadScene();
		self:showSixthReadScene();
		self.m_index = 7;
		return;
	end
	self.m_index = self.m_index + 1;
end

function CCSLoaderScene:showFirstLoadScene()
	self.m_title:setString(self.m_titles[1]);
	--效率尼玛也太慢了
	-- self.m_loadScene1 = cc.uiloader:load("BattleScene.csb");
	-- self.m_loadScene1:addTo(self);
end

function CCSLoaderScene:hideFirstLoadScene()
	if self.m_loadScene1 then 
		self.m_loadScene1:setVisible(false);
	end
end

function CCSLoaderScene:showSecondLoadScene()
	self.m_title:setString(self.m_titles[2]);
	self.m_loadScene2 = ccs.GUIReader:getInstance():widgetFromJsonFile("DemoLogin/DemoLogin.ExportJson");
	self.m_loadScene2:addTo(self);

	local editBox = self.m_loadScene2:getChildByName("name_TextField");
	editBox:addEventListener(function(editbox, eventType)
		print("CCSSample2Scene editbox input");
	end);
end

function CCSLoaderScene:hideSecondLoadScene()
	if self.m_loadScene2 then 
		self.m_loadScene2:setVisible(false);
	end
end

function CCSLoaderScene:showThirdLoadScene()
	self.m_title:setString(self.m_titles[3]);

	self.m_loadScene3 = ccs.GUIReader:getInstance():widgetFromJsonFile("DemoMap/DemoMap.ExportJson");
	self.m_loadScene3:addTo(self);

	local scrollView = self.m_loadScene3:getChildByName("DragPanel");
	scrollView:setDirection(ccui.ScrollViewDir.both);
	scrollView:addEventListener(function(sender, eventType)
		print("CCSSample2Scene scroll");
	end)
end

function CCSLoaderScene:hideThirdLoadScene()
	if self.m_loadScene3 then 
		self.m_loadScene3:setVisible(false);
	end
end

function CCSLoaderScene:showForthLoadScene()
	self.m_title:setString(self.m_titles[4]);

	self.m_loadScene4 = ccs.GUIReader:getInstance():widgetFromJsonFile("DemoShop/DemoShop.ExportJson");
	self.m_loadScene4:addTo(self);

end

function CCSLoaderScene:hideForthLoadScene()
	if self.m_loadScene4 then
		self.m_loadScene4:setVisible(false);
	end
end

function CCSLoaderScene:showFifthLoadScene()
	self.m_title:setString(self.m_titles[5]);

	cc.FileUtils:getInstance():addSearchPath("res/GameFightScene/");
	self.m_loadScene5 = ccs.SceneReader:getInstance()
		:createNodeWithSceneFile("publish/FightScene.json");
	self.m_loadScene5:addTo(self);
end

function CCSLoaderScene:hideFifthLoadScene()
	if self.m_loadScene5 then 
		self.m_loadScene5:setVisible(false);
	end
end

function CCSLoaderScene:showSixthLoadScene()
	self.m_title:setString(self.m_titles[6]);
	-- self.m_title:setColor(cc.c3b(0,0,0));

	cc.FileUtils:getInstance():addSearchPath("res/GameRPG/");
	self.m_loadScene6 = ccs.SceneReader:getInstance()
		:createNodeWithSceneFile("publish/RPGGame.json");
	self.m_loadScene6:addTo(self);
end

function CCSLoaderScene:hideSixthLoadScene()
	if self.m_loadScene6 then 
		self.m_loadScene6:setVisible(false);
	end
end

function CCSLoaderScene:loadCCSJsonFile(scene, jsonFile)
    local node, width, height = cc.uiloader:load(jsonFile);
    width = width or display.width;
    height = height or display.height;
    if node then
        node:setPosition((display.width - width)/2, (display.height - height)/2);
        node:setTag(105);
        scene:addChild(node);
        return node,scene;
    end
end

function CCSLoaderScene:showFirstReadScene()
	self.m_title:setString(self.m_read_titles[1]);

	cc.FileUtils:getInstance():addSearchPath("res/DemoHead_UI/");
	self.m_readScene1 = self:loadCCSJsonFile(self, "DemoHead_UI.ExportJson");
end

function CCSLoaderScene:hideFirstReadScene()
	if self.m_readScene1 then
		self.m_readScene1:setVisible(false);
	end
end

function CCSLoaderScene:showSecondReadScene()
	self.m_title:setString(self.m_read_titles[2]);

	cc.FileUtils:getInstance():addSearchPath("res/DemoLogin/");
	self.m_readScene2 = self:loadCCSJsonFile(self, "DemoLogin.ExportJson");

	-- register function on node
	-- path为传入除要结点node名字外的路径
	local ccsNode = self:getChildByTag(105);
	--下面方法测试无效，不知道原因
	-- local loginNode = cc.uiloader:seekNodeByPath(ccsNode, "Panel/login_Button");
	-- if loginNode then
	-- 	loginNode:onButtonClicked(function(event)
	-- 		print("CCSSample2Scene login button clicked");
	-- 		-- dump(event, "login button:")
	-- 	end);
	-- end

	-- local editBox = cc.uiloader:seekNodeByNameFast(ccsNode, "name_TextField");
	-- if editBox then 
	-- 	editBox:addEventListener(function(editbox, eventType)
	-- 		print("CCSSample2Scene editbox input");
	-- 	end);
	-- end
end

function CCSLoaderScene:hideSecondReadScene()
	if self.m_readScene2 then
		self.m_readScene2:setVisible(false);
	end
end

function CCSLoaderScene:showThirdReadScene()
	self.m_title:setString(self.m_read_titles[3]);

	self.m_readScene3 = ccs.GUIReader:getInstance():widgetFromJsonFile("DemoMap/DemoMap.ExportJson");
	self.m_readScene3:addTo(self);

	local scrollView = self.m_readScene3:getChildByName("DragPanel");
	scrollView:setDirection(ccui.ScrollViewDir.both);
	scrollView:addEventListener(function(sender, eventType)
		print("CCSSample2Scene scroll");
	end)
end

function CCSLoaderScene:hideThirdReadScene()
	if self.m_readScene3 then 
		self.m_readScene3:setVisible(false);
	end
end

function CCSLoaderScene:showForthReadScene()
	self.m_title:setString(self.m_read_titles[4]);

	self.m_readScene4 = ccs.GUIReader:getInstance():widgetFromJsonFile("DemoShop/DemoShop.ExportJson");
	self.m_readScene4:addTo(self);
end

function CCSLoaderScene:hideForthReadScene()
	if self.m_readScene4 then
		self.m_readScene4:setVisible(false);
	end
end

function CCSLoaderScene:showFifthReadScene()
	self.m_title:setString(self.m_read_titles[5]);

	cc.FileUtils:getInstance():addSearchPath("res/GameFightScene/");
	self.m_readScene5 = ccs.SceneReader:getInstance():createNodeWithSceneFile("publish/FightScene.json");
	self.m_readScene5:addTo(self);	
end

function CCSLoaderScene:hideFifthReadScene()
	if self.m_readScene5 then
		self.m_readScene5:setVisible(false);
	end
end

function CCSLoaderScene:showSixthReadScene()
	self.m_title:setString(self.m_read_titles[6]);

	cc.FileUtils:getInstance():addSearchPath("res/GameRPG/");
	self.m_readScene6 = ccs.SceneReader:getInstance()
		:createNodeWithSceneFile("publish/RPGGame.json");
	self.m_readScene6:addTo(self);
end

function CCSLoaderScene:hideSixthReadScene()
	if self.m_readScene6 then
		self.m_readScene6:setVisible(false);
	end
end


return CCSLoaderScene;