local BehaviorBase = class("BehaviorBase");

function BehaviorBase:ctor(behaviorName, depends, priority, conflictions)
    self.m_name = behaviorName;
    self.m_depend = checktable(depends);
    self.m_priority = checkint(priority) ;-- 行为集合初始化时的优先级，越大越先初始化
    self.m_conflictions = checktable(conflictions);
end

function BehaviorBase:getName()
    return self.n_name;
end

function BehaviorBase:getDepends()
    return self.m_depends;
end

function BehaviorBase:getPriority()
    return self.m_priority
end

function BehaviorBase:getConflictions()
    return self.m_conflictions;
end

function BehaviorBase:bind(object)
end

function BehaviorBase:unbind(object)
end

function BehaviorBase:reset(object)
end

return BehaviorBase;
