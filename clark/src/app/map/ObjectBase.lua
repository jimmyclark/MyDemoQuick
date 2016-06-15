local BehaviorFactory = require("app.behaviors.BehaviorFactory");

local ObjectBase = class("ObjectBase");

ObjectBase.CLASS_INDEX_PATH        = 1;
ObjectBase.CLASS_INDEX_RANGE       = 2;
ObjectBase.CLASS_INDEX_STATIC      = 3;
ObjectBase.CLASS_INDEX = {
    path       = ObjectBase.CLASS_INDEX_PATH,
    range      = ObjectBase.CLASS_INDEX_RANGE,
    static     = ObjectBase.CLASS_INDEX_STATIC,
};

function ObjectBase:ctor(id, state, map)
    assert(type(state) == "table", "ObejctBase:ctor() - invalid state");

    for k, v in pairs(state) do
        local kn = "m_" .. k;
        self[kn] = v;
    end

    local classId, index = unpack(string.split(id, ":"));
    self.m_map = map;
    self.m_id = id;
    self.m_classId = classId;
    self.m_classIndex = ObjectBase.CLASS_INDEX[classId];
    self.m_index = checkint(index);
    self.m_x = checkint(self.m_x);
    self.m_y = checkint(self.m_y);
    self.m_offsetX = checkint(self.m_offsetX);
    self.m_offsetY = checkint(self.m_offsetY);
    self.m_state = state;
    self.m_valid = false;
    self.m_play = false;
    self.m_tag = 0;
    self.m_sprite = nil;
    self.m_debug = false;
    self.m_debugViewEnabled = false;

    if type(self.m_viewZOrdered) ~= "boolean" then
        self.m_viewZOrdered = true;
    end
end

function ObjectBase:init()
    if not self.m_behaviors then 
        return;
    end

    local behaviors;

    if type(self.m_behaviors) == "string" then
        behaviors = string.split(self.m_behaviors, ",");
    else
        behaviors = self.m_behaviors;
    end

    for i, behaviorName in ipairs(behaviors) do
        behaviorName = string.trim(behaviorName);
        if behaviorName ~= "" then 
            self:bindBehavior(behaviorName);
        end
    end
end

function ObjectBase:isDebug()
    return self.m_debug;
end

function ObjectBase:setDebug(isDebugEnabled)
    self.m_debug = isDebugEnabled;
end

function ObjectBase:isDebugViewEnabled()
    return self.m_debugViewEnabled;
end

function ObjectBase:setDebugViewEnabled(isDebugViewEnabled)
    self.m_debugViewEnabled = isDebugViewEnabled;
end

function ObjectBase:getId()
    return self.m_id;
end

function ObjectBase:getClassId()
    return self.m_classId;
end

function ObjectBase:getIndex()
    return self.m_index;
end

function ObjectBase:validate()
end

function ObjectBase:isValid()
    return self.m_valid;
end

function ObjectBase:getTag()
    return self.m_tag;
end

function ObjectBase:setTag(tag)
    self.m_tag = tag;
end

function ObjectBase:getPosition()
    return self.m_x, self.m_y;
end

function ObjectBase:setPosition(x, y)
    self.m_x, self.m_y = x, y;
end

function ObjectBase:isViewCreated()
    return self.m_sprite ~= nil;
end

function ObjectBase:isViewZOrdered()
    return self.m_viewZOrdered;
end

function ObjectBase:getView()
    return nil;
end

function ObjectBase:createView(batch, marksLayer, debugLayer)
    assert(self.m_batch == nil, "ObjectBase:createView() - view already created");
    self.m_batch      = batch;
    self.m_marksLayer = marksLayer;
    self.m_debugLayer = debugLayer;
end

function ObjectBase:removeView()
    assert(self.m_batch ~= nil, "ObjectBase:removeView() - view not exists");
    self.m_batch      = nil;
    self.m_marksLayer = nil;
    self.m_debugLayer = nil;
end

function ObjectBase:updateView()
end

function ObjectBase:preparePlay()
end

function ObjectBase:startPlay()
    self.m_play = true;
end

function ObjectBase:stopPlay()
    self.m_play = false;
end

function ObjectBase:isPlay()
    return self.m_play;
end

function ObjectBase:hasBehavior(behaviorName)
    return self.m_behaviorObjects and self.m_behaviorObjects[behaviorName] ~= nil;
end

function ObjectBase:bindBehavior(behaviorName)
    if not self.m_behaviorObjects then 
        self.m_behaviorObjects = {};
    end

    if self.m_behaviorObjects[behaviorName] then 
        return;
    end

    local behavior = BehaviorFactory.createBehavior(behaviorName);
    for i, dependBehaviorName in pairs(behavior:getDepends()) do
        self:bindBehavior(dependBehaviorName);

        if not self.m_behaviorDepends then
            self.m_behaviorDepends = {};
        end

        if not self.m_behaviorDepends[dependBehaviorName] then
            self.m_behaviorDepends[dependBehaviorName] = {};
        end

        table.insert(self.m_behaviorDepends[dependBehaviorName], behaviorName);
    end

    behavior:bind(self);
    self.m_behaviorObjects[behaviorName] = behavior;
    self:resetAllBehaviors();
end

function ObjectBase:unbindBehavior(behaviorName)
    assert(self.m_behaviorObjects and self.m_behaviorObjects[behaviorName] ~= nil,
           string.format("ObjectBase:unbindBehavior() - behavior %s not binding", behaviorName));
    assert(not self.m_behaviorDepends or not self.m_behaviorDepends[behaviorName],
           string.format("ObjectBase:unbindBehavior() - behavior %s depends by other binding", behaviorName));

    local behavior = self.m_behaviorObjects[behaviorName];

    for i, dependBehaviorName in pairs(behavior:getDepends()) do
        for j, name in ipairs(self.m_behaviorDepends[dependBehaviorName]) do
            if name == behaviorName then
                table.remove(self.m_behaviorDepends[dependBehaviorName], j);

                if #self.m_behaviorDepends[dependBehaviorName] < 1 then
                    self.m_behaviorDepends[dependBehaviorName] = nil;
                end

                break;
            end
        end
    end

    behavior:unbind(self);
    self.m_behaviorObjects[behaviorName] = nil;
end

function ObjectBase:resetAllBehaviors()
    if not self.m_behaviorObjects then 
        return;
    end

    local behaviors = {};

    for i, behavior in pairs(self.m_behaviorObjects) do
        behaviors[#behaviors + 1] = behavior;
    end

    table.sort(behaviors, function(a, b)
        return a:getPriority() > b:getPriority();
    end)

    for i, behavior in ipairs(behaviors) do
        behavior:reset(self);
    end
end

function ObjectBase:bindMethod(behavior, methodName, method, callOriginMethodLast)
    local originMethod = self[methodName];
    if not originMethod then
        self[methodName] = method;
        return;
    end

    if not self.m_bindingMethods then 
        self.m_bindingMethods = {};
    end

    if not self.m_bindingMethods[methodName] then 
        self.m_bindingMethods[methodName] = {};
    end

    local chain = {behavior, originMethod};
    local newMethod;

    if callOriginMethodLast then
        newMethod = function(...)
            method(...);
            chain[2](...);
        end
    else
        newMethod = function(...)
            local ret = chain[2](...);
            if ret then
                local args = {...};
                args[#args + 1] = ret;
                return method(unpack(args));
            else
                return method(...);
            end
        end
    end

    self[methodName] = newMethod;
    chain[3] = newMethod;
    table.insert(self.m_bindingMethods[methodName], chain);

    -- print(string.format("[%s]:bindMethod(%s, %s)", tostring(self), behavior:getName(), methodName))
    -- for i, chain in ipairs(self.m_bindingMethods[methodName]) do
    --     print(string.format("  index: %d, origin: %s, new: %s", i, tostring(chain[2]), tostring(chain[3])))
    -- end
    -- print(string.format("  current: %s", tostring(self[methodName])))
end

function ObjectBase:unbindMethod(behavior, methodName)
    if not self.m_bindingMethods or not self.m_bindingMethods[methodName] then
        self[methodName] = nil;
        return;
    end

    local methods = self.m_bindingMethods[methodName];
    local count = #methods;
    for i = count, 1, -1 do
        local chain = methods[i];
        if chain[1] == behavior then
            -- print(string.format("[%s]:unbindMethod(%s, %s)", tostring(self), behavior:getName(), methodName))
            if i < count then
                -- 如果移除了中间的节点，则将后一个节点的 origin 指向前一个节点的 origin
                -- 并且对象的方法引用的函数不变
                -- print(string.format("  remove method from index %d", i))
                methods[i + 1][2] = chain[2];
            elseif count > 1 then
                -- 如果移除尾部的节点，则对象的方法引用的函数指向前一个节点的 new
                self[methodName] = methods[i - 1][3];
            elseif count == 1 then
                -- 如果移除了最后一个节点，则将对象的方法指向节点的 origin
                self[methodName] = chain[2];
                self.m_bindingMethods[methodName] = nil;
            end

            -- 移除节点
            table.remove(methods, i);

            -- if self.m_bindingMethods[methodName] then;
            --     for i, chain in ipairs(self.m_bindingMethods[methodName]) do;
            --         print(string.format("  index: %d, origin: %s, new: %s", i, tostring(chain[2]), tostring(chain[3])))
            --     end
            -- end
            -- print(string.format("  current: %s", tostring(self[methodName])))
            break;
        end
    end
end

function ObjectBase:vardump()
    local state = {
        x   = self.m_x,
        y   = self.m_y,
        tag = self.m_tag,
    }

    if self.m_behaviorObjects then
        local behaviors = table.keys(self.m_behaviorObjects);
        for i = #behaviors, 1, -1 do
            if not BehaviorFactory.isStaticObjectBehavior(behaviors[i]) then
                table.remove(behaviors, i);
            end
        end
        if #behaviors > 0 then
            table.sort(behaviors);
            state.behaviors = behaviors;
        end
    end

    return state;
end

function ObjectBase:dump(label)
    return dump(self:vardump(), label);
end

return ObjectBase;
