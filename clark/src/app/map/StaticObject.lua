local StaticObjectsProperties = require("app.properties.StaticObjectProperties");

local ObjectBase = require("app.map.ObjectBase");
local StaticObject = class("StaticObject", ObjectBase);

function StaticObject:ctor(id, state, map)
    assert(state.defineId ~= nil, "StaticObject:ctor() - invalid state.defineId");
    local define = StaticObjectsProperties.get(state.defineId);
    for k, v in pairs(define) do
        if state[k] == nil then
            state[k] = v;
        end
    end
    StaticObject.super.ctor(self, id, state, map);

    self.m_radiusOffsetX = checkint(self.m_radiusOffsetX);
    self.m_radiusOffsetY = checkint(self.m_radiusOffsetY);
    self.m_radius = checkint(self.m_radius);
    self.m_flipSprite = checkbool(self.m_flipSprite);
    self.m_visible = true;
    self.m_valid = true;
    self.m_sprite = nil;
    self.m_spriteSize = nil;
end

function StaticObject:getDefineId()
    return self.m_defineId;
end

function StaticObject:getRadius()
    return self.m_radius;
end

function StaticObject:isFlipSprite()
    return self.m_flipSprite;
end

function StaticObject:setFlipSprite(flipSprite)
    self.m_flipSprite = flipSprite;
end

function StaticObject:getView()
    return self.m_sprite;
end

function StaticObject:createView(batch, marksLayer, debugLayer)
    StaticObject.super.createView(self, batch, marksLayer, debugLayer)

    if self.m_framesName then
        local frames = display.newFrames(self.m_framesName, self.m_framesBegin, self.m_framesLength);
        self.m_sprite = display.newSprite(frames[1]);
        self.m_sprite:playAnimationForever(display.newAnimation(frames, self.m_framesTime));
    else
        local imageName = self.m_imageName;
        if type(imageName) == "table" then
            imageName = imageName[1];
        end
        self.m_sprite = display.newSprite(imageName);
    end

    local size = self.m_sprite:getContentSize();
    self.m_spriteSize = {size.width, size.height};

    if self.m_scale then
        self.m_sprite:setScale(self.m_scale);
    end

    batch:addChild(self.m_sprite);
end

function StaticObject:removeView()
    if not self.m_sprite then
        return;
    end

    self.m_sprite:removeSelf();
    self.m_sprite = nil;
    StaticObject.super.removeView(self);
end

function StaticObject:updateView()
    if not self.m_sprite then
        return;
    end

    local sprite = self.m_sprite;
    sprite:setPosition(math.floor(self.m_x + self.m_offsetX), math.floor(self.m_y + self.m_offsetY));
    sprite:setFlippedX(self.m_flipSprite);
end

function StaticObject:fastUpdateView()
    if not self.updated__ then 
        return;
    end
    local sprite = self.m_sprite;
    sprite:setPosition(self.m_x + self.m_offsetX, self.m_y + self.m_offsetY);
    sprite:setFlippedX(self.m_flipSprite);
end

function StaticObject:isVisible()
    return self.m_visible;
end

function StaticObject:setVisible(visible)
    self.m_sprite:setVisible(visible);
    self.m_visible = visible;
end

function StaticObject:preparePlay()
end

function StaticObject:vardump()
    local state = StaticObject.super.vardump(self);
    state.defineId = self.m_defineId;
    state.flipSprite = self.m_flipSprite;
    return state;
end

return StaticObject;