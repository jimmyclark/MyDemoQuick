local StaticObjectsDecorationProperties = require("app.properties.StaticDecorationObjectProperties");

local Decoration = class("Decoration");

function Decoration:ctor(decorationName, staticIndex)
    local define = StaticObjectsDecorationProperties.get(decorationName);
    assert(define,
           string.format("Decoration.ctor() - invalid decoration %s", decorationName));

    for k,v in pairs(define) do
        self[ "m_" .. k] = v;
    end
    if staticIndex then
        if type(self.m_imageName) == "table" then
            self.m_imageName = self.m_imageName[staticIndex];
        end
        if type(self.m_offesetX) == "table" then
            self.m_offesetX = self.m_offesetX[staticIndex];
        end
        if type(self.m_offsetY) == "table" then
            self.m_offsetY = self.m_offsetY[staticIndex];
        end
    end

    self.m_name = decorationName;
    self.m_zorder = checkint(self.m_zorder);
    self.m_offesetX = checkint(self.m_offesetX);
    self.m_offsetY = checkint(self.m_offsetY);
    self.m_delay = checknumber(self.m_delay);
    self.m_actions = {};

    self.m_scale = checknumber(self.m_scale);
    if self.m_scale == 0 then
        self.m_scale = 1;
    end

    if type(self.m_visible) ~= "boolean" then
        self.m_visible = true;
    end
end

function Decoration:release()
    if self.m_animation then
        self.m_animation:release();
        self.m_animation = nil;
    end
end

function Decoration:setDelay(delay)
    self.m_delay = delay;
end

function Decoration:createView(batch)
    if self.m_framesName then
        self.m_frames = display.newFrames(self.m_framesName, self.m_framesBegin, self.m_framesLength, self.m_framesReversed);
        self.m_animation = display.newAnimation(self.m_frames, self.m_framesTime);
        self.m_animation:retain();
        self.m_sprite = display.newSprite(self.m_frames[1])
    else
        local imageName = self.m_imageName;
        if type(imageName) == "table" then
            imageName = imageName[1];
        end
        self.m_sprite = display.newSprite(imageName);
    end
    self.m_sprite:setScale(self.m_scale);

    if not self.m_visible then
        self.m_sprite:setVisible(false);
    end

    batch:addChild(self.m_sprite);

    if not self.m_autoplay then 
        return;
    end

    if self.m_playForever then
        self:playAnimationForever();
    else
        self:playAnimationOnce();
    end

    self.m_sprite:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "exit" then
            self:release();
        end
    end)
end

function Decoration:removeView()
    self:stopAnimation();
    self:release();
    if self.m_sprite then
        self.m_sprite:removeSelf();
        self.m_sprite = nil;
    end
end

function Decoration:getView()
    return self.m_sprite;
end

function Decoration:isVisible()
    return self.m_visible;
end

function Decoration:setVisible(visible)
    self.m_sprite:setVisible(visible);
    self.m_visible = visible;
end

function Decoration:playAnimationOnce(onComplete)
    self:stopAnimation();
    if self.m_removeAfterPlay then
        local userOnComplete = onComplete;
        onComplete = function()
            if userOnComplete then 
                userOnComplete();
            end
            self:removeView();
        end
    end
    local action = self.m_sprite:playAnimationOnce(self.m_animation, self.m_removeAfterPlay, onComplete, self.m_delay);
    self.m_actions[#self.m_actions + 1] = action;
end

function Decoration:playAnimationOnceAndRemove(onComplete)
    self:stopAnimation()
    local userOnComplete = onComplete
    onComplete = function()
        if userOnComplete then userOnComplete() end
        self:removeView()
    end
    local action = self.m_sprite:playAnimationOnce(self.m_animation, self.m_removeAfterPlay, onComplete, self.m_delay)
    self.m_actions[#self.m_actions + 1] = action;
end

function Decoration:playAnimationForever()
    self:stopAnimation();
    local action = self.m_sprite:playAnimationForever(self.m_animation, true, self.m_delay);
    self.m_actions[#self.m_actions + 1] = action;
end

function Decoration:stopAnimation()
    for i, action in ipairs(self.m_actions) do
        if not tolua.isnull(action) then 
            transition.removeAction(action);
        end
    end
    self.m_actions = {};
end

function Decoration:fadeOutAndStopAnimation(time, onComplete)
    local action = transition.fadeOut(self.m_sprite, {
        time = time,
        onComplete = function()
            if onComplete then 
                onComplete(); 
            end
            self:stopAnimation();
        end
    });
    self.m_actions[#self.m_actions + 1] = action;
end

function Decoration:setDisplayFrameIndex(index)
    if self.m_frames then
        self.m_sprite:setDisplayFrame(self.m_frames[index]);
    end
end

return Decoration;
