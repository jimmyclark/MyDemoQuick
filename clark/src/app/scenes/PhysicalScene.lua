local PhysicalScene = class("PhysicalScene",function()
	return display.newPhysicsScene("PhysicalScene");
end)

local GRAVITY         = -200
local COIN_MASS       = 100;
local COIN_RADIUS     = 46;
local COIN_FRICTION   = 0.8;
local COIN_ELASTICITY = 0.8;
local WALL_THICKNESS  = 64;
local WALL_FRICTION   = 1.0;
local WALL_ELASTICITY = 0.5;

function PhysicalScene:ctor()
	local images = {
		pressed = "b2.png",
		normal = "b1.png"
	};

	self.m_backBtn = UICreator.createBtnText(images,true,display.left + 100,display.top - 50,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"pageTurn",0.7,true);
	end);

	display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME2, GAME_TEXTURE_IMAGE_FILENAME2);

	self.m_layer = display.newLayer();
    self.m_layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y);
    end)
    self.m_layer:addTo(self);

    -- create label
    self.m_title = UICreator.createText("TAP SCREEN",32,display.CENTER,display.cx,display.cy,255,255,255);	
    self.m_title:addTo(self);

    -- create physics world
    self.world = self:getPhysicsWorld();
    self.world:setGravity(cc.p(0, GRAVITY));

    local leftWallSprite = display.newSprite("#Wall.png");
    leftWallSprite:setScaleY(display.height / WALL_THICKNESS);
    leftWallSprite:setPosition(display.left + WALL_THICKNESS / 2, display.cy + WALL_THICKNESS);
    self:addChild(leftWallSprite);

    local rightWallSprite = display.newSprite("#Wall.png");
    rightWallSprite:setScaleY(display.height / WALL_THICKNESS);
    rightWallSprite:setPosition(display.right - WALL_THICKNESS / 2, display.cy + WALL_THICKNESS);
    self:addChild(rightWallSprite);

    local bottomWallSprite = display.newSprite("#Wall.png");
    bottomWallSprite:setScaleX(display.width / WALL_THICKNESS);
    bottomWallSprite:setPosition(display.cx, display.bottom + WALL_THICKNESS / 2);
    self:addChild(bottomWallSprite);

    local wallBox = display.newNode();
    wallBox:setAnchorPoint(cc.p(0.5, 0.5));
    wallBox:setPhysicsBody(
        cc.PhysicsBody:createEdgeBox(cc.size(display.width - WALL_THICKNESS*2, display.height - WALL_THICKNESS)));
    wallBox:setPosition(display.cx, display.height/2 + WALL_THICKNESS/2);
    self:addChild(wallBox);

end

function PhysicalScene:onTouch(event, x, y)
    if event == "began" then
        self:createCoin(x, y);
    end
end

function PhysicalScene:createCoin(x, y)
    -- add sprite to scene
    local coinSprite = display.newSprite("#Coin.png");
    self:addChild(coinSprite);
    local coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS,
        cc.PhysicsMaterial(COIN_RADIUS, COIN_FRICTION, COIN_ELASTICITY));
    coinBody:setMass(COIN_MASS);
    coinSprite:setPhysicsBody(coinBody);
    coinSprite:setPosition(x, y);
end

function PhysicalScene:onEnter()
 	self.m_layer:setTouchEnabled(true);
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame));
    self:scheduleUpdate();
end

function PhysicalScene:onEnterFrame(dt)
    -- body
    print("onEnterFrame");
end

function PhysicalScene:onExit()

end

return PhysicalScene;