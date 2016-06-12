local BenchMark = class("BenchMark",function()
	return display.newScene("BenchMark");
end);
local random = math.random;

function BenchMark:ctor()
	self.m_backBtn = display.newSprite("close.png",display.left + 100,display.top - 100);
	self:addChild(self.m_backBtn);
	self.backBoundBox = self.m_backBtn:getBoundingBox();

    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME);

	self.m_layer = display.newNode();
    self.m_layer:setContentSize(cc.size(display.width, display.height));
    self:addChild(self.m_layer);

    self.m_addBtn = display.newSprite("#AddCoinButton.png", display.right - 100, display.bottom + 270);
    self:addChild(self.m_addBtn);
    self.addCoinButtonBoundingBox = self.m_addBtn:getBoundingBox();

    self.m_removeBtn = display.newSprite("#RemoveCoinButton.png", display.right - 100, display.bottom + 100);
    self:addChild(self.m_removeBtn);
    self.removeCoinButtonBoundingBox = self.m_removeBtn:getBoundingBox();

    self.m_label = UICreator.createFontText("00000",20,display.CENTER,display.cx,display.top - 40,255,255,255,"UIFont.fnt");

    self:addChild(self.m_label);

    self.coins = {};
    self.state = "IDLE";

    local frames = display.newFrames("CoinSpin%02d.png", 1, 8);
    local animation = display.newAnimation(frames, 0.4 / 8);
    display.setAnimationCache("Coin", animation);

    self.left   = display.left   + display.width / 4;
    self.right  = display.right  - display.width / 4;
    self.top    = display.top    - display.height / 3;
    self.bottom = display.bottom + display.height / 3;

end

function BenchMark:run()
end

function BenchMark:onEnter()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
		self:onEnterFrame(dt);
	end);
    self:scheduleUpdate();
    self.m_layer:setTouchEnabled(true);
    self.m_layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y);
    end);
end

function BenchMark:onEnterFrame(dt)
	 if self.state == "ADD" then
        self:addCoin();
    elseif self.state == "REMOVE" and self.coinsCount > 0 then
        self:removeCoin();
    elseif self.state == "EXIT" then
    	os.exit();
		-- display.removeAnimationCache("Coin");
		-- self:removeFromParent();
  --   	local mainScene = require("app.scenes.MainScene").new();
		-- display.replaceScene(mainScene,"splitRows", 0.6, display.COLOR_WHITE);
    	return;
    end

    local coins = self.coins;
    for i = 1, #coins do
        local coin = coins[i];
        coin:onEnterFrame(dt);
    end
end

function BenchMark:addCoin()
    local coin = display.newSprite("#CoinSpin01.png");
    coin:playAnimationForever(display.getAnimationCache("Coin"));
    coin:setPosition(random(self.left, self.right), random(self.bottom, self.top));
    -- self.batch:addChild(coin)
    self:addChild(coin);

    function coin:onEnterFrame(dt)
        local x, y = self:getPosition();
        x = x + random(-2, 2);
        y = y + random(-2, 2);
        self:setPosition(x, y);
    end

    self.coins[#self.coins + 1] = coin;
    self.coinsCount = #self.coins;
    self.m_label:setString(string.format("%05d", self.coinsCount));
end

function BenchMark:removeCoin()
    local coin = self.coins[self.coinsCount];
    coin:removeFromParent();
    table.remove(self.coins, self.coinsCount);
    self.coinsCount = self.coinsCount - 1;
    self.m_label:setString(string.format("%05d", self.coinsCount));
end

function BenchMark:onTouch(event, x, y)
    if event == "began" then
        local p = cc.p(x, y);
        if cc.rectContainsPoint(self.addCoinButtonBoundingBox, p) then
            self.state = "ADD";
        elseif cc.rectContainsPoint(self.removeCoinButtonBoundingBox, p) then
            self.state = "REMOVE";
		elseif cc.rectContainsPoint(self.backBoundBox,p) then
			print("EXIT")
        	self.state= "EXIT";
        else
            self.state = "IDLE";
        end
        return true;
    elseif event ~= "moved" then
        self.state = "IDLE";
    end
    return true;
end

function BenchMark:onExit()
	display.removeAnimationCache("Coin");
end

return BenchMark;