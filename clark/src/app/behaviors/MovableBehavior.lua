local MapConstants = require("app.map.MapConstants");
local math2d = require("app.math2d");

local BehaviorBase = require("app.behaviors.BehaviorBase");
local MovableBehavior = class("MovableBehavior", BehaviorBase);

MovableBehavior.MOVING_STATE_STOPPED   = 0;
MovableBehavior.MOVING_STATE_SPEEDUP   = 1;
MovableBehavior.MOVING_STATE_SPEEDDOWN = 2;
MovableBehavior.MOVING_STATE_FULLSPEED = 3;

MovableBehavior.SPEED_SCALE = 1.0 / 300;

function MovableBehavior:ctor()
    MovableBehavior.super.ctor(self, "MovableBehavior", nil, 1);
end

function MovableBehavior:setNextPosition(object)
    local map = object.m_map;
    if not object.m_nextPathId then
        object.m_nextPathId = object.m_bindingPathId;
        object.m_nextPointIndex = object.m_bindingPointIndex;
        object.m_nextMovingForward = object.m_bindingMovingForward;
    end

    object.m_currentPathId = object.m_nextPathId;
    object.m_currentPointIndex = object.m_nextPointIndex;

    local nextPath,
          nextPointIndex,
          nextMovingForward = map:getNextPointIndexOnPath(object.m_currentPathId,
                                                          object.m_currentPointIndex,
                                                          object.m_nextMovingForward,
                                                          true);

    object.m_nextPathId = nextPath:getId();
    object.m_nextPointIndex = nextPointIndex;
    object.m_nextMovingForward = nextMovingForward;
    object.m_nextX, object.m_nextY = nextPath:getPoint(nextPointIndex);

    object.m_nextRadians = math2d.radians4point(object.m_x, object.m_y, object.m_nextX, object.m_nextY);
    object.m_nextDist = math2d.dist(object.m_x, object.m_y, object.m_nextX, object.m_nextY);
    object.m_currentDist = 0;
end

function MovableBehavior:bind(object)
    object.m_movingLocked = 0
    object.m_bindingPathId = object.m_state.bindingPathId;
    object.m_bindingPointIndex = object.m_state.bindingPointIndex;
    object.m_bindingMovingForward = object.m_state.bindingMovingForward;
    if type(object.m_bindingMovingForward) ~= "boolean" then
        object.m_bindingMovingForward = true;
    end

    object.m_nextPathId = nil;
    object.m_nextPointIndex = nil;
    object.m_nextMovingForward = nil;
    object.m_nextX, object.m_nextY = nil;
    object.m_nextRadians = nil;
    object.m_nextDist = 0;
    object.m_currentDist = 0;

    local function isBinding(objec)
        return object.m_bindingPathId ~= nil;
    end

    object:bindMethod(self, "isBinding", isBinding);

    local function getBindingPathId(object)
        return object.m_bindingPathId;
    end

    object:bindMethod(self, "getBindingPathId", getBindingPathId);

    local function getBindingPointIndex(object)
        return object.m_bindingPointIndex;
    end

    object:bindMethod(self, "getBindingPointIndex", getBindingPointIndex);

    local function getCurrentPathId(object)
        return object.m_currentPathId;
    end

    object:bindMethod(self, "getCurrentPathId", getCurrentPathId);

    local function getCurrentPointIndex(object)
        return object.m_currentPointIndex;
    end

    object:bindMethod(self, "getCurrentPointIndex", getCurrentPointIndex);

    local function isMovingForward(object)
        return object.m_bindingMovingForward;
    end

    object:bindMethod(self, "isMovingForward", isMovingForward);

    local function setMovingForward(object, movingForward)
        object.m_bindingMovingForward = movingForward;
    end

    object:bindMethod(self, "setMovingForward", setMovingForward);

    local function isMovingLocked(object)
        return object.m_movingLocked > 0;
    end

    object:bindMethod(self, "isMovingLocked", isMovingLocked);

    local function addMovingLock(object)
        object.m_movingLocked = object.m_movingLocked + 1;
    end

    object:bindMethod(self, "addMovingLock", addMovingLock);

    local function removeMovingLock(object)
        object.m_movingLocked = object.m_movingLocked - 1;
        assert(object.m_movingLocked >= 0, "MovableBehavior.removeMovingLock() - object.m_movingLocked must >= 0");
    end

    object:bindMethod(self, "removeMovingLock", removeMovingLock);

    local function bindPath(object, path, pathPointIndex)
        local pathId = path:getId();
        if object.m_bindingPathId ~= pathId and object.m_bindingPathId then
            object:unbindPath();
        end
        object.m_bindingPathId = pathId;
        object.m_bindingPointIndex = pathPointIndex;
        object:setPosition(path:getPoint(pathPointIndex));

        object.m_nextPathId = nil;
        self:setNextPosition(object);
    end
    object:bindMethod(self, "bindPath", bindPath);

    local function unbindPath(object)
        object.m_bindingPathId = nil;
        object.m_bindingPointIndex = nil;
    end

    object:bindMethod(self, "unbindPath", unbindPath);

    local function validate(object)
        if not object.m_bindingPathId then 
            return ;
        end
        if not object.m_map:isObjectExists(object.m_bindingPathId) then
            object:unbindPath();
            return;
        end

        local path = object.m_map:getObject(object.m_bindingPathId);
        if object.m_bindingPointIndex < 1 or object.m_bindingPointIndex > path:getPointsCount() then
            object:unbindPath();
            return;
        end

        object:setPosition(path:getPoint(object.m_bindingPointIndex));
    end

    object:bindMethod(self, "validate", validate);

    local function startMoving(object)
        if not object.m_bindingPathId then 
            return ;
        end

        if object.m_movingState == MovableBehavior.MOVING_STATE_STOPPED
                or object.m_movingState == MovableBehavior.MOVING_STATE_SPEEDDOWN then
            object.m_movingState = MovableBehavior.MOVING_STATE_SPEEDUP;

            if not object.m_currentPathId then
                self:setNextPosition(object);
            end
        end
    end

    object:bindMethod(self, "startMoving", startMoving);

    local function stopMoving(object)
        if object.m_movingState == MovableBehavior.MOVING_STATE_FULLSPEED
                or object.m_movingState == MovableBehavior.MOVING_STATE_SPEEDUP then
            object.m_movingState = MovableBehavior.MOVING_STATE_SPEEDDOWN;
        end
    end

    object:bindMethod(self, "stopMoving", stopMoving);

    local function stopMovingNow(object)
        object.m_movingState = MovableBehavior.MOVING_STATE_STOPPED;
        object.m_currentSpeed = 0;
    end

    object:bindMethod(self, "stopMovingNow", stopMovingNow);

    local function isMoving(object)
        return object.m_movingState == MovableBehavior.MOVING_STATE_FULLSPEED
                or object.m_movingState == MovableBehavior.MOVING_STATE_SPEEDUP;
    end

    object:bindMethod(self, "isMoving", isMoving);

    local function tick(object, dt)
        if not object.m_play or object.m_movingLocked > 0 or not object.m_bindingPathId then 
            return;
        end

        local state = object.m_movingState;

        if state == MovableBehavior.MOVING_STATE_STOPPED then 
            return;
        end

        if state == MovableBehavior.MOVING_STATE_SPEEDUP
                or (state == MovableBehavior.MOVING_STATE_FULLSPEED
                    and object.m_currentSpeed < object.m_maxSpeed) then
            object.m_currentSpeed = object.m_currentSpeed + object.m_speedIncr;

            if object.m_currentSpeed >= object.m_maxSpeed then
                object.m_currentSpeed = object.m_maxSpeed;
                object.m_movingState = MovableBehavior.MOVING_STATE_FULLSPEED;
            end

        elseif state == MovableBehavior.MOVING_STATE_SPEEDDOWN then
            object.m_currentSpeed = object.m_currentSpeed - object.m_speedDecr;

            if object.m_currentSpeed <= 0 then
                object.m_currentSpeed = 0;
                object.m_movingState = MovableBehavior.MOVING_STATE_STOPPED;
            end

        elseif object.m_currentSpeed > object.m_maxSpeed then
            object.m_currentSpeed = object.m_currentSpeed - object.m_speedDecr;

            if object.m_currentSpeed < object.m_maxSpeed then
                object.m_currentSpeed = object.m_maxSpeed;
            end
        end

        local x, y = object.m_x, object.m_y;
        local currentDist = object.m_currentDist + object.m_currentSpeed;

        if currentDist >= object.m_nextDist then
            object.m_x, object.m_y = object.m_nextX, object.m_nextY;
            currentDist = currentDist - object.m_nextDist;
            self:setNextPosition(object);
            x, y = math2d.pointAtCircle(object.m_x, object.m_y, object.m_nextRadians, currentDist);
        else
            local ox, oy = math2d.pointAtCircle(0, 0, object.m_nextRadians, object.m_currentSpeed);
            x = x + ox;
            y = y + oy;
        end

        object.m_currentDist = currentDist;

        if x < object.m_x then
            object.m_flipSprite = true;
        elseif x > object.m_x then
            object.m_flipSprite = false;
        end

        object.m_x, object.m_y = x, y;
    end

    object:bindMethod(self, "tick", tick);

    local function preparePlay(object)
        object.m_currentSpeed = 0;
        object.m_movingState = MovableBehavior.MOVING_STATE_STOPPED;
        object.m_nextPathId = nil;
    end

    object:bindMethod(self, "preparePlay", preparePlay);

    local function getFuturePosition(object, time)
        local x, y = object.m_x, object.m_y;

        if object.m_currentSpeed == 0 or not object.m_bindingPathId then
            return x, y;
        end

        -- 到下一个路径点的距离、弧度，以及下一个路径点的位置
        local nextDist = object.m_nextDist;
        local nextRadians = object.m_nextRadians;
        local nextX, nextY = object.m_nextX, object.m_nextY;

        -- 从当前路径出发，time 时间后的距离
        local currentDist = object.m_currentDist + object.m_currentSpeed * time * 60;

        local map = object.m_map;
        local currentPathId = object.m_currentPathId;
        local currentPointIndex = object.m_currentPointIndex;
        local movingForward = object.m_nextMovingForward;

        if currentDist < nextDist then
            currentDist = currentDist - object.m_currentDist;
        end

        while currentDist >= nextDist do
            x, y = nextX, nextY;
            currentDist = currentDist - nextDist;

            local nextPath,
                  nextPointIndex,
                  nextMovingForward = map:getNextPointIndexOnPath(currentPathId,
                                                                  currentPointIndex,
                                                                  movingForward,
                                                                  true);

            currentPathId = nextPath:getId();
            currentPointIndex = nextPointIndex;
            movingForward = nextMovingForward;
            nextX, nextY = nextPath:getPoint(nextPointIndex);
            nextRadians = math2d.radians4point(x, y, nextX, nextY);
            nextDist = math2d.dist(x, y, nextX, nextY);
        end

        x, y = math2d.pointAtCircle(x, y, nextRadians, currentDist);
        return x, y;
    end

    object:bindMethod(self, "getFuturePosition", getFuturePosition);

    local function setSpeed(object, maxSpeed)
        object.m_speed = checknumber(maxSpeed);

        if object.m_speed < 0 then 
            object.m_speed = 0;
        end

        object.m_speedIncr = object.m_speed * 0.025 * MovableBehavior.SPEED_SCALE;
        object.m_speedDecr = object.m_speed * 0.038 * MovableBehavior.SPEED_SCALE;
        object.m_maxSpeed  = object.m_speed * MovableBehavior.SPEED_SCALE;
    end

    object:bindMethod(self, "setSpeed", setSpeed);

    local function vardump(object, state)
        state.bindingPathId = object.m_bindingPathId;
        state.bindingPointIndex = object.m_bindingPointIndex;
        state.bindingMovingForward = object.m_bindingMovingForward;
        return state;
    end

    object:bindMethod(self, "vardump", vardump);

    self:reset(object);
end

function MovableBehavior:unbind(object)
    object.m_bindingPathId = nil;
    object.m_bindingPointIndex = nil;
    object.m_bindingMovingForward = nil;

    object:unbindMethod(self, "isBinding");
    object:unbindMethod(self, "getBindingPathId");
    object:unbindMethod(self, "getBindingPointIndex");
    object:unbindMethod(self, "isMovingForward");
    object:unbindMethod(self, "setMovingForward");
    object:unbindMethod(self, "isMovingLocked");
    object:unbindMethod(self, "addMovingLock");
    object:unbindMethod(self, "removeMovingLock");
    object:unbindMethod(self, "bindPath");
    object:unbindMethod(self, "unbindPath");
    object:unbindMethod(self, "validate");
    object:unbindMethod(self, "startMoving");
    object:unbindMethod(self, "stopMoving");
    object:unbindMethod(self, "stopMovingNow");
    object:unbindMethod(self, "isMoving");
    object:unbindMethod(self, "tick");
    object:unbindMethod(self, "preparePlay");
    object:unbindMethod(self, "getFuturePosition");
    object:unbindMethod(self, "setSpeed");
    object:unbindMethod(self, "vardump");
end

function MovableBehavior:reset(object)
    object:setSpeed(checknumber(object.m_state.speed));
    object.m_currentSpeed = 0;
    object.m_movingState = MovableBehavior.MOVING_STATE_STOPPED;
end

return MovableBehavior;
