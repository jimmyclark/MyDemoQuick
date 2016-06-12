local AmatureScene = class("AmatureScene",function()
	return display.newScene("AmatureScene");
end);

local scheduler = require("framework.scheduler");
local Hero = require("app.models.Hero2");

function AmatureScene:ctor()
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
		display.replaceScene(mainScene);
	end);

	self.m_bg = display.newSprite("armature/bg.jpg", display.cx, display.cy);
    local scaleX = display.width / self.m_bg:getContentSize().width;
    local scaleY = display.height / self.m_bg:getContentSize().height;
    self.m_bg:setScaleX(scaleX);
    self.m_bg:setScaleY(scaleY);
    self.m_bg:addTo(self);

    self.m_titles = {"TestAsynchronousLoading","TestDirectLoading","TestCSWithSkeleton","TestDragonBones20","TestPerformance",
    "TestChangeZorder","TestAnimationEvent","TestFrameEvent","TestParticleDisplay","TestUseMutiplePicture","TestAnchorPoint",
    "TestArmatureNesting","TestArmatureNesting2"};
    self.m_index = 12;

    self.m_title = UICreator.createText(self.m_titles[self.m_index],18,display.CENTER,display.cx,display.top-50,0,0,0,"armature/fonts/arial.ttf");
    self.m_title:addTo(self);

    self.m_subTitle = UICreator.createText("current percent :" .. 0.0,18,display.CENTER,display.cx,display.top - 90,0,0,0 );
    self.m_subTitle:addTo(self);

    local preImage = {
		normal = "armature/Images/b1.png",
		pressed = "armature/Images/b2.png"
	};

    self.m_preBtn = UICreator.createBtnText(preImage,true,display.cx -100,display.bottom+ 50,display.BOTTOM_CENTER,79,46);
	self.m_preBtn:addTo(self, 0);
	self.m_preBtn:onButtonClicked(handler(self, self.onPrev));
	self.m_preBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_preBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	local resetImage = {
		normal = "armature/Images/r1.png",
		pressed = "armature/Images/r2.png"
	};

	self.m_resetBtn = UICreator.createBtnText(resetImage,true,display.cx,display.bottom+50,display.BOTTOM_CENTER,49,47);
	self.m_resetBtn:addTo(self, 0)
	self.m_resetBtn:onButtonClicked(handler(self, self.onReset));
	self.m_resetBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
		event.target:setScale(1.2);
	end);

	self.m_resetBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
		event.target:setScale(1.0);
	end);

	local nextImage = {
		normal="armature/Images/f1.png",
		pressed="armature/Images/f2.png"
	};

	self.m_nextBtn = UICreator.createBtnText(nextImage,true,display.cx +100,display.bottom+50,display.BOTTOM_CENTER,79,46);
	self.m_nextBtn:addTo(self, 0)
	self.m_nextBtn:onButtonClicked(handler(self, self.onNext));
	self.m_nextBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_nextBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

    self.m_preBtn:setButtonEnabled(false);
	self.m_resetBtn:setButtonEnabled(false);
    self.m_nextBtn:setButtonEnabled(false);
	local function dataLoaded(percent)
        local subInfo = "current percent : ".. (percent * 100);
        self.m_subTitle:setString(subInfo);
        
        if percent >= 1 and self.m_preBtn and self.m_resetBtn and self.m_nextBtn then
            self.m_preBtn:setButtonEnabled(true);
            self.m_resetBtn:setButtonEnabled(true);
            self.m_nextBtn:setButtonEnabled(true);
        end
    end

    local manager = ccs.ArmatureDataManager:getInstance();
    manager:addArmatureFileInfoAsync("armature/knight.png", "armature/knight.plist", "armature/knight.xml", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/weapon.png", "armature/weapon.plist", "armature/weapon.xml", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/robot.png", "armature/robot.plist", "armature/robot.xml", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/cyborg.png", "armature/cyborg.plist", "armature/cyborg.xml", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/Dragon.png", "armature/Dragon.plist", "armature/Dragon.xml", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/Cowboy.ExportJson", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/hero.ExportJson", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/horse.ExportJson", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/bear.ExportJson", dataLoaded);
    manager:addArmatureFileInfoAsync("armature/HeroAnimation.ExportJson", dataLoaded);

end

function AmatureScene:onReset()
	self.m_index = 2;
	self:showMyArmatureScene();
end

function AmatureScene:onNext()
	self.m_index = self.m_index + 1;
	self:showMyArmatureScene();
end

function AmatureScene:onPrev()
	self.m_index = self.m_index - 1;
	self:showMyArmatureScene();
end

function AmatureScene:showMyArmatureScene()
	if self.m_index == 2 then 
    	self:showFirstArmature();
    	self:hideSecondArmature();
    	self:hideThirdArmature();
    	self:hideFourthArmature();
    	self:hideFifthArmature();
    	self:hideSixthAmature();
    	self:hideSeventhAmature();
    	self:hideEighthAmature();
    	self:hideNinthAmature();
    	self:hideTenthAmature();
    	self:hideEleventhAmature();
    	self:hideTwelvthAmature();
   	elseif self.m_index == 3 then 
   		self:hideFirstArmature();
   		self:hideThirdArmature();
   		self:hideFourthArmature();
   		self:hideFifthArmature();
   		self:hideSixthAmature();
   		self:hideSeventhAmature();
   		self:hideEighthAmature();
   		self:hideNinthAmature();
   		self:hideTenthAmature();
   		self:hideEleventhAmature();
   		self:hideTwelvthAmature();
   		self:showSecondArmature();
	elseif self.m_index == 4 then
		self:hideFirstArmature();
		self:hideSecondArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature();
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showThirdArmature();
	elseif self.m_index == 5 then
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFifthArmature();
		self:hideSixthAmature();
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showFourthArmature();
	elseif self.m_index == 6 then 
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideSixthAmature();
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showFifthArmature();
	elseif self.m_index == 7 then
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature();
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showSixthArmature();
	elseif self.m_index == 8 then
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showSeventhAmature();
	elseif self.m_index == 9 then
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature(); 
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showEighthAmature();
	elseif self.m_index == 10 then 
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature(); 
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showNinthAmature();
	elseif self.m_index == 11 then
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature(); 
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showTenthAmature();
	elseif self.m_index == 12 then 
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature(); 
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideTwelvthAmature();
		self:showEleventhAmature();
	elseif self.m_index == 13 then 
		self:hideFirstArmature();
		self:hideSecondArmature(); 
		self:hideThirdArmature();
		self:hideFourthArmature();
		self:hideFifthArmature();
		self:hideSixthAmature(); 
		self:hideSeventhAmature();
		self:hideEighthAmature();
		self:hideNinthAmature();
		self:hideTenthAmature();
		self:hideEleventhAmature();
		self:hideEleventhAmature();
		self:showTwelvthAmature();
		self.m_index = 1;
	end

end

function AmatureScene:showFirstArmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	local manager = ccs.ArmatureDataManager:getInstance();
    manager:removeArmatureFileInfo("armature/bear.ExportJson");
    manager:addArmatureFileInfo("armature/bear.ExportJson");
    if self.m_armature then 
		self.m_armature:setVisible(true);
		return;
	end
   	self.m_armature = ccs.Armature:create("bear");
    self.m_armature :getAnimation():playWithIndex(0);
    self.m_armature :setPosition(cc.p(display.cx, display.cy));
    self:addChild(self.m_armature );
end

function AmatureScene:hideFirstArmature()
	if self.m_armature then
		self.m_armature:setVisible(false);
	end
end

function AmatureScene:showSecondArmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature2 then 
		self.m_armature2:setVisible(true);
		return;
	end
	self.m_armature2 = ccs.Armature:create("Cowboy");
    self.m_armature2:getAnimation():playWithIndex(0);
    self.m_armature2:setScale(0.2);
    self.m_armature2:setAnchorPoint(cc.p(0.5, 0.5));
    self.m_armature2:setPosition(cc.p(display.cx, display.cy));
    self:addChild(self.m_armature2);
end

function AmatureScene:hideSecondArmature()
	if self.m_armature2 then
		self.m_armature2:setVisible(false);
	end
end

function AmatureScene:showThirdArmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature3 then
		self.m_armature3:setVisible(true);
		return ;
	end

	self.m_armature3 = ccs.Armature:create("Dragon");
    self.m_armature3:getAnimation():playWithIndex(1);
    self.m_armature3:getAnimation():setSpeedScale(0.4);
    self.m_armature3:setPosition(cc.p(display.cx, display.cy * 0.5));
    self.m_armature3:setScale(0.6);
    self:addChild(self.m_armature3);

end

function AmatureScene:hideThirdArmature()
	if self.m_armature3 then
		self.m_armature3:setVisible(false);
	end
end

function AmatureScene:showFourthArmature()
	local num = 4;
	self.m_subTitle:setString("Current Armature Count : " .. num);
	self.m_subTitle:setVisible(true);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature4 then
		for i=1,#self.m_armature4 do
			self.m_armature4[i]:setVisible(true);
		end
		return;
	end

	self.m_armature4 = {};
	self.m_count = 10;
	for i = 1, num do
        self.m_armature4[i] = ccs.Armature:create("Knight_f/Knight");
        self.m_armature4[i]:getAnimation():playWithIndex(0);
        self.m_armature4[i]:setPosition(50 + self.m_count * 2, 150);
        self.m_armature4[i]:setScale(0.6);
        self:addChild(self.m_armature4[i], 0);
    end
end

function AmatureScene:hideFourthArmature()
	if self.m_armature4 then
		for i=1,#self.m_armature4 do
			self.m_armature4[i]:setVisible(false);
		end
	end
end

function AmatureScene:showFifthArmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature5 then
		self.m_armature5:setVisible(true);
		self.m_armature6:setVisible(true);
		self.m_armature7:setVisible(true);
		return;
	end

	self.m_armature5 = ccs.Armature:create("Knight_f/Knight");
    self.m_armature5:getAnimation():playWithIndex(0);
    self.m_armature5:setPosition(cc.p(display.cx, display.top - 120 ));
    -- armature:setScale(0.6)
     self.currentTag = -1;
    self.currentTag = self.currentTag + 1;
    self:addChild(self.m_armature5, self.currentTag, self.currentTag);

    self.m_armature6 = ccs.Armature:create("Cowboy");
    self.m_armature6:getAnimation():playWithIndex(0);
    self.m_armature6:setScale(0.24);
    self.m_armature6:setPosition(cc.p(display.cx, display.top - 250));
    self.currentTag = self.currentTag + 1;
    self:addChild(self.m_armature6, self.currentTag, self.currentTag);

    self.m_armature7 = ccs.Armature:create("Dragon");
    self.m_armature7:getAnimation():playWithIndex(0);
    self.m_armature7:setPosition(cc.p(display.cx, display.top - 400));
    self.m_armature7:setScale(0.6);
    self.currentTag = self.currentTag + 1;
    self:addChild(self.m_armature7, self.currentTag, self.currentTag);

    local function changeZorder()
        local node = self:getChildByTag(self.currentTag);
        node:setLocalZOrder(math.random(0,1) * 3);
        self.currentTag = (self.currentTag + 1) % 3;
    end

    self.handle = scheduler.scheduleGlobal(changeZorder, 1.0);
end

function AmatureScene:hideFifthArmature()
	if self.m_armature5 then
		self.m_armature5:setVisible(false);
		self.m_armature6:setVisible(false);
		self.m_armature7:setVisible(false);
		scheduler.unscheduleGlobal(self.handle);
	end
end

function AmatureScene:showSixthArmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature8 then 
		self.m_armature8:setVisible(true);
		return;
	end

	self.m_armature8 = ccs.Armature:create("Cowboy");
    self.m_armature8:getAnimation():play("Fire");
    self.m_armature8:setScaleX(-0.24);
    self.m_armature8:setScaleY(0.24);
    self.m_armature8:setPosition(cc.p(display.left + 50, display.cy));

    local function callback1()
        self.m_armature8:runAction(cc.ScaleTo:create(0.3, 0.24, 0.24));
        self.m_armature8:getAnimation():play("FireMax", 10);
    end

    local function callback2()
        self.m_armature8:runAction(cc.ScaleTo:create(0.3, -0.24, 0.24));
        self.m_armature8:getAnimation():play("Fire", 10);
    end

    local function animationEvent(armatureBack,movementType,movementID)
        local id = movementID;
        if movementType == ccs.MovementEventType.loopComplete then
            if id == "Fire" then
                local actionToRight = cc.MoveTo:create(2, cc.p(display.right - 50, display.cy));
                armatureBack:stopAllActions();
                armatureBack:runAction(cc.Sequence:create(actionToRight,cc.CallFunc:create(callback1)));
                armatureBack:getAnimation():play("Walk");
            elseif id == "FireMax" then
                local actionToLeft = cc.MoveTo:create(2, cc.p(display.left + 50, display.cy));
                armatureBack:stopAllActions();
                armatureBack:runAction(cc.Sequence:create(actionToLeft, cc.CallFunc:create(callback2)));
                armatureBack:getAnimation():play("Walk");
            end
        end
    end

    self.m_armature8:getAnimation():setMovementEventCallFunc(animationEvent);
    self:addChild(self.m_armature8);
end

function AmatureScene:hideSixthAmature()
	if self.m_armature8 then 
		self.m_armature8:setVisible(false);
	end
end

function AmatureScene:showSeventhAmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	local gridNode = cc.NodeGrid:create();
    local function checkAction(dt)
        if gridNode:getNumberOfRunningActions() == 0 and gridNode:getGrid() ~= nil then
            gridNode:setGrid(nil);
        end
    end

	if self.m_armature9 then
		self.m_armature9:setVisible(true);
		scheduler.scheduleUpdateGlobal(checkAction);
		return;
	end

	self.m_armature9 = ccs.Armature:create("HeroAnimation");
    self.m_armature9 :getAnimation():play("attack");
    self.m_armature9 :getAnimation():setSpeedScale(0.5);
    self.m_armature9 :setPosition(cc.p(display.cx - 50, display.cy -100));
    local frameEventActionTag = 10000;

    local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
        if (not gridNode:getActionByTag(frameEventActionTag)) or (not gridNode:getActionByTag(frameEventActionTag):isDone()) then
            gridNode:stopAllActions();

            local action =  cc.ShatteredTiles3D:create(0.2, cc.size(16,12), 5, false);
            action:setTag(frameEventActionTag);
            gridNode:runAction(action);
        end
    end

    self.m_armature9:getAnimation():setFrameEventCallFunc(onFrameEvent);
    gridNode:addChild(self.m_armature9);

    self:addChild(gridNode);


    self.handle2 = scheduler.scheduleUpdateGlobal(checkAction);
end

function AmatureScene:hideSeventhAmature()
	if self.m_armature9 then
		self.m_armature9:setVisible(false);
		scheduler.unscheduleGlobal(self.handle2);
	end
end

function AmatureScene:showEighthAmature()
	self.m_subTitle:setVisible(true);
	self.m_subTitle:setString("Touch to change animation");
	self.m_title:setString(self.m_titles[self.m_index]);

	self.animationID = 0;

	if self.m_armature10 then 
		self.m_armature10:setVisible(true);
		return;
	end

    self.m_armature10 = ccs.Armature:create("robot");
    self.m_armature10:getAnimation():playWithIndex(0);
    self.m_armature10:setPosition(display.cx, display.cy);
    self.m_armature10:setScale(0.48);
    self:addChild(self.m_armature10);

    local p1 = cc.ParticleSystemQuad:create("armature/Particles/SmallSun.plist");
    local p2 = cc.ParticleSystemQuad:create("armature/Particles/SmallSun.plist");

    local bone  = ccs.Bone:create("p1");
    bone:addDisplay(p1, 0);
    bone:changeDisplayWithIndex(0, true);
    bone:setIgnoreMovementBoneData(true);
    bone:setLocalZOrder(100);
    bone:setScale(1.2);
    self.m_armature10:addBone(bone, "bady-a3");

    bone  = ccs.Bone:create("p2");
    bone:addDisplay(p2, 0);
    bone:changeDisplayWithIndex(0, true);
    bone:setIgnoreMovementBoneData(true);
    bone:setLocalZOrder(100);
    bone:setScale(1.2);
    self.m_armature10:addBone(bone, "bady-a30");

    local function onTouchEnded()     
        self.animationID = (self.animationID + 1) % self.m_armature10:getAnimation():getMovementCount();
        self.m_armature10:getAnimation():playWithIndex(self.animationID);
    end

    self.m_armature10:setTouchEnabled(true);

    self.m_armature10:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true;
    	elseif event.name=='ended' then
    		onTouchEnded();
    	end
    end)
end

function AmatureScene:hideEighthAmature()
	if self.m_armature10 then 
		self.m_armature10:setVisible(false);
	end
end

function AmatureScene:showNinthAmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature11 then 
		self.m_armature11:setVisible(true);
		return;
	end

	self.displayIndex = 1;

    self.m_armature11 = ccs.Armature:create("Knight_f/Knight");
    self.m_armature11:getAnimation():playWithIndex(0);
    self.m_armature11:setPosition(cc.p(display.left + 70, display.cy));
    self.m_armature11:setScale(1.2);
    self:addChild(self.m_armature11);

    local weapon = {
        "weapon_f-sword.png",
        "weapon_f-sword2.png",
        "weapon_f-sword3.png",
        "weapon_f-sword4.png",
        "weapon_f-sword5.png",
        "weapon_f-knife.png",
        "weapon_f-hammer.png",
    };

    for i = 1,table.getn(weapon) do
        local skin = ccs.Skin:createWithSpriteFrameName(weapon[i]);
        self.m_armature11:getBone("weapon"):addDisplay(skin, i - 1);
    end

    local function onTouchEnded(touches, event)     
        self.displayIndex = (self.displayIndex + 1) % (table.getn(weapon) - 1);
        self.m_armature11:getBone("weapon"):changeDisplayWithIndex(self.displayIndex, true);
    end

    self.m_armature11:setTouchEnabled(true);

    self.m_armature11:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true;
    	elseif event.name=='ended' then
    		onTouchEnded();
    	end
    end);
end

function AmatureScene:hideNinthAmature()
	if self.m_armature11 then 
		self.m_armature11:setVisible(false);
	end
end

function AmatureScene:showTenthAmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_armature12 then 
		for i=1,#self.m_armature12 do 
			self.m_armature12[i]:setVisible(true);
		end
		return;
	end

	self.m_armature12 = {};
	for  i = 1 , 5 do
        self.m_armature12[i] = ccs.Armature:create("Cowboy");
        self.m_armature12[i]:getAnimation():playWithIndex(0);
        self.m_armature12[i]:setPosition(display.cx, display.cy);
        self.m_armature12[i]:setScale(0.2);
        self:addChild(self.m_armature12[i], 0, 1000+i);
    end

    self:getChildByTag(1000+1):setAnchorPoint(cc.p(0,0));
    self:getChildByTag(1000+2):setAnchorPoint(cc.p(0,1));
    self:getChildByTag(1000+3):setAnchorPoint(cc.p(1,0));
    self:getChildByTag(1000+4):setAnchorPoint(cc.p(1,1));
    self:getChildByTag(1000+5):setAnchorPoint(cc.p(0.5,0.5));
end

function AmatureScene:hideTenthAmature()
	if self.m_armature12 then 
		for i=1,#self.m_armature12 do 
			self.m_armature12[i]:setVisible(false);
		end
	end
end

function AmatureScene:showEleventhAmature()
	self.m_subTitle:setVisible(false);
	self.m_title:setString(self.m_titles[self.m_index]);

	self.weaponIndex = 0;

	if self.m_armature13 then 
		self.m_armature13:setVisible(true);
		return;
	end

    self.m_armature13 = ccs.Armature:create("cyborg");
    self.m_armature13:getAnimation():playWithIndex(1);
    self.m_armature13:setPosition(display.cx, display.cy);
    self.m_armature13:setScale(1.2);
    self.m_armature13:getAnimation():setSpeedScale(0.4);
    self:addChild(self.m_armature13);

    local function onTouchEnded(touches, event)     
        self.weaponIndex = (self.weaponIndex + 1) % 4;
        self.m_armature13:getBone("armInside"):getChildArmature():getAnimation():playWithIndex(self.weaponIndex);
        self.m_armature13:getBone("armOutside"):getChildArmature():getAnimation():playWithIndex(self.weaponIndex);
    end

    self.m_armature13:setTouchEnabled(true);

    self.m_armature13:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true;
    	elseif event.name=='ended' then
    		onTouchEnded();
    	end
    end);
end

function AmatureScene:hideEleventhAmature()
	if self.m_armature13 then 
		self.m_armature13:setVisible(false);
	end
end

function AmatureScene:showTwelvthAmature()
	self.m_subTitle:setVisible(true);
	self.m_subTitle:setString("Move to a mount and press the ChangeMount Button.");
	self.m_title:setString(self.m_titles[self.m_index]);

	if self.m_hero then 
		self.m_hero:setVisible(true);
		self.m_horse:setVisible(true);
		self.m_horse2:setVisible(true);
		self.exitButton:setVisible(true);
		self.m_bear:setVisible(true);
		return;
	end

    self.m_hero = Hero.new();
    self.m_hero.m_layer = self;
    self.m_hero:playWithIndex(0);
    self.m_hero:setPosition(display.left + 20, display.cy);
    self:addChild(self.m_hero);

    self.m_horse = self:createMount("horse", cc.p(display.cx, display.cy));

    self.m_horse2 = self:createMount("horse", cc.p(120, 200));
    self.m_horse2:setOpacity(200);

    self.m_bear = self:createMount("bear", cc.p(300,70));

	local function onTouchEnded(event)
        local location = cc.p(event.x, event.y);  
        local armature = self.m_hero._mount and self.m_hero._mount or self.m_hero;
        if location.x < armature:getPositionX() then
            armature:setScaleX(-1);
        else
            armature:setScaleX(1);
        end

        local move = cc.MoveTo:create(2, location);
        armature:stopAllActions();
        armature:runAction(cc.Sequence:create(move));
    end

    self.m_hero:setTouchEnabled(true);

    self.m_hero:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true;
    	elseif event.name=='ended' then
    		onTouchEnded(event);
    	end
    end)

    local function changeMountCallback()
        self.m_hero:stopAllActions();

        if nil ~= self.m_hero._mount then
            self.m_hero:changeMount(nil);
        else
            if cc.pGetDistance(cc.p(self.m_hero:getPosition()),cc.p(self._horse:getPosition())) < 20 then
                self.m_hero:changeMount(self.m_horse);
            elseif cc.pGetDistance(cc.p(self.m_hero:getPosition()),cc.p(self._horse2:getPosition())) < 20 then
                self.m_hero:changeMount(self.m_horse2);
            elseif cc.pGetDistance(cc.p(self.m_hero:getPosition()),cc.p(self._bear:getPosition())) < 30 then
                self.m_hero:changeMount(self.m_bear);
            end
        end
    end

    self.exitButton =      
        cc.ui.UIPushButton.new({})
        :setButtonLabel("normal", cc.Label:createWithTTF("Change Mount", "armature/fonts/arial.ttf", 24))
        :setButtonLabel("pressed", cc.Label:createWithTTF("Change Mount", "armature/fonts/arial.ttf", 30))
        :onButtonClicked(function()
            changeMountCallback()
        end)
        :pos(display.right - 240, 60)
        :addTo(self);

end

function AmatureScene:hideTwelvthAmature()
	if self.m_hero then 
		self.m_hero:setVisible(false);
		self.m_horse:setVisible(false);
		self.m_horse2:setVisible(false);
		self.exitButton:setVisible(false);
		self.m_bear:setVisible(false);
	end
end

function AmatureScene:createMount(name,pt)
    local armature = ccs.Armature:create(name);
    armature:getAnimation():playWithIndex(0);
    armature:setPosition(pt);
    self:addChild(armature);
    return armature;
end

function AmatureScene:run()
	
end

function AmatureScene:onEnter()

end

function AmatureScene:onExit()

end

return AmatureScene;