local CurvedBulletBase = require("app.map.CurvedBulletBase");
local CannonBullet = class("CannonBullet", CurvedBulletBase);

function CannonBullet:ctor(source, target, delay, spriteName, params)
    if not params then
        params = {
            flyTime = math.random(70, 85) / 100,
            g = -1000,
            delay = delay or 0.2,
        };
    end

    self.m_boomSpriteScale = 1;

    if not spriteName then 
        spriteName = "#CannonBall01.png";
    end

    local sprite = display.newSprite(spriteName);
    sprite:setVisible(params.delay == 0);

    return CannonBullet.super.ctor(self, source, target, sprite, params);
end

function CannonBullet:fireBegan()
    CannonBullet.super.fireBegan(self);
    self.m_sprite:setVisible(true);
end

function CannonBullet:hit()
    local framesName = self.m_boomFramesName;
    
    if not framesName then 
        framesName = "CannonBoom%04d.png";
    end

    local framesLength = self.m_boomFramesLength;

    if not framesLength then 
        framesLength = 15 ;
    end

    local framesTime = self.m_boomFramesTime;
    
    if not framesTime then 
        framesTime = 0.8;
    end

    local frames    = display.newFrames(framesName, 1, framesLength);
    local boom      = display.newSprite(frames[1]);
    local animation = display.newAnimation(frames, framesTime / framesLength);

    local x, y = self.m_sprite:getPosition();
    boom:setPosition(x, y + 10);
    boom:setScale(math.random(100, 120) / 100 * self.m_boomSpriteScale);
    boom:playAnimationOnce(animation, "removeWhenFinished");

    local parent = self.m_sprite:getParent();
    parent:addChild(boom, self.m_sprite:getLocalZOrder());
end

return CannonBullet;
