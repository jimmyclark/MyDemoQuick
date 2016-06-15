
--[[
    Map 对象的生命周期
    Map.new() 创建 Map 对象实例
    Map:init() 初始化 Map 对象
    Map:createView() 创建 Map 对象的视图
    Map:removeView() 删除 Map 对象的视图
    Map:updateView() 更新 Map 对象的视图
    Map:destroy() 销毁 Map 对象
    Map:newObject() 创建新的地图子对象，并绑定行为
                如果此时视图已经创建，则调用子对象的 createView()

]]
local MapConstants  = require("app.map.MapConstants");
local MapCamera     = require("app.map.MapCamera");
local ObjectFactory = require("app.map.ObjectFactory");
local Path          = require("app.map.Path");

local Map = class("Map");

function Map:ctor(id, debug)
    self.m_id = id;
    self.m_debug = debug;
    self.m_debugViewEnabled = debug;
    self.m_ready = false;
    self.m_mapModuleName = string.format("maps.Map%sData", id);
    self.m_eventModuleName = string.format("maps.Map%sEvents", id);

    local ok, data = pcall(function() 
        return require(self.m_mapModuleName);
    end);

    if not ok or type(data) ~= "table" then
        data = {
            size    = {width = CONFIG_SCREEN_WIDTH, height = CONFIG_SCREEN_HEIGHT},
            objects = {},
        };
    end

    self.m_data = clone(data);
end

function Map:init()
    self.m_width = self.m_data.size.width;
    self.m_height = self.m_data.size.height;
    self.m_imageName = self.m_data.imageName;
    
    if not self.m_imageName then
        self.m_imageName = string.format("Map%sBg.png", self.m_id);
    end

    self.m_bgSprite = nil;
    self.m_batch = nil;
    self.m_marksLayer = nil;
    self.m_promptLayer = nil;
    self.m_debugLayer = nil;

    self.m_objects = {};
    self.m_objectsByClass = {};
    self.m_nextObjectIndex = 1;

    -- 添加地图数据中的对象
    for id, state in pairs(self.m_data.objects) do
        local classId = unpack(string.split(id, ":"));
        self:newObject(classId, state, id);
    end

    -- 验证所有的路径
    for i, path in pairs(self:getObjectsByClassId("path")) do
        path:validate();

        if not path:isValid() then
            echoInfo(string.format("Map:init() - invalid path %s", path:getId()));
            self:removeObject(path);
        end
    end

    -- 验证其他对象
    for id, object in pairs(self.m_objects) do
        local classId = object:getClassId();

        if classId ~= "path" then
            object:validate();

            if not object:isValid() then
                echoInfo(string.format("Map:init() - invalid object %s", object:getId()));
                self:removeObject(object);
            end
        end
    end

    -- 计算地图位移限定值
    self.m_camera = MapCamera.new(self);
    self.m_camera:resetOffsetLimit();

    -- 地图已经准备好
    self.m_ready = true;
end

--[[
    返回地图的 Id
]]
function Map:getId()
    return self.m_id;
end

--[[
    返回地图尺寸
]]
function Map:getSize()
    return self.m_width, self.m_height;
end

--[[
    返回摄像机对象
]]
function Map:getCamera()
    return self.m_camera;
end

--[[    
    确认地图是否处于 Debug 模式
]]
function Map:isDebug()
    return self.m_debug;
end

--[[
    确认是否允许使用调试视图
]]
function Map:isDebugViewEnabled()
    return self.m_debugViewEnabled;
end

--[[
    设置地图调试模式
]]
function Map:setDebugViewEnabled(isDebugViewEnabled)
    self.m_debugViewEnabled = isDebugViewEnabled;

    for id, object in pairs(self.m_objects) do
        object:setDebugViewEnabled(isDebugViewEnabled);
    end

    if self:getDebugLayer() then
        self:getDebugLayer():setVisible(isDebugViewEnabled);
    end
end

--[[
    确认地图是否已经创建了视图
]]
function Map:isViewCreated()
    return self.m_batch ~= nil;
end

--[[
    创建新的对象，并添加到地图中
]]
function Map:newObject(classId, state, id)
    if not id then
        id = string.format("%s:%d", classId, self.m_nextObjectIndex);
        self.m_nextObjectIndex = self.m_nextObjectIndex + 1;
    end

    local object = ObjectFactory.newObject(classId, id, state, self);
    object:setDebug(self.m_debug);
    object:setDebugViewEnabled(self.m_debugViewEnabled);
    object:resetAllBehaviors();

    -- validate max object index
    local index = object:getIndex();
    if index >= self.m_nextObjectIndex then
        self.m_nextObjectIndex = index + 1;
    end

    -- add object
    self.m_objects[id] = object;
    if not self.m_objectsByClass[classId] then
        self.m_objectsByClass[classId] = {};
    end
    self.m_objectsByClass[classId][id] = object;

    -- validate object
    if self.m_ready then
        object:validate();

        if not object:isValid() then
            echoInfo(string.format("Map:newObject() - invalid object %s", id));
            self:removeObject(object);
            return nil;
        end

        -- create view
        if self:isViewCreated() then
            object:createView(self.m_batch, self.m_marksLayer, self.m_debugLayer);
            object:updateView();
        end
    end

    return object;
end

--[[
    从地图中删除一个对象
]]
function Map:removeObject(object)
    local id = object:getId();
    assert(self.m_objects[id] ~= nil, string.format("Map:removeObject() - object %s not exists", tostring(id)));

    self.m_objects[id] = nil;
    self.m_objectsByClass[object:getClassId()][id] = nil;

    if object:isViewCreated() then 
        object:removeView();
    end
end

--[[
    从地图中删除指定 Id 的对象
]]
function Map:removeObjectById(objectId)
    self:removeObject(self:getObject(objectId));
end

--[[
    删除所有对象
]]
function Map:removeAllObjects()
    for id, object in pairs(self.m_objects) do
        self:removeObject(object);
    end
    self.m_objects = {};
    self.m_objectsByClass = {};
    self.m_nextObjectIndex = 1;
    self.m_crossPointsOnPath = {};
end

--[[
    检查指定的对象是否存在
]]
function Map:isObjectExists(id)
    return self.m_objects[id] ~= nil;
end

--[[
    返回指定 Id 的对象
]]
function Map:getObject(id)
    assert(self:isObjectExists(id), string.format("Map:getObject() - object %s not exists", tostring(id)));
    return self.m_objects[id];
end

--[[
    返回地图中所有的对象
]]
function Map:getAllObjects()
    return self.m_objects;
end

--[[
    返回地图中特定类型的对象
]]
function Map:getObjectsByClassId(classId)
    -- dump(self.m_objectsByClass[classId])
    return self.m_objectsByClass[classId] or {};
end

--[[
    获取指定路径开始，下一个点的坐标
]]
function Map:getNextPointIndexOnPath(pathId, pointIndex, movingForward, reverseAtEnd)
    local path = self:getObject(pathId);

    if movingForward then
        pointIndex = pointIndex + 1;
        local count = path:getPointsCount();

        if pointIndex > count then
            pointIndex = count;

            if reverseAtEnd then
                pointIndex = pointIndex - 1;
                movingForward = false;
            end
        end
    else
        pointIndex = pointIndex - 1;

        if pointIndex < 1 then
            pointIndex = 1;

            if reverseAtEnd then
                pointIndex = 2;
                movingForward = true;
            end
        end
    end

    return path, pointIndex, movingForward;
end

--[[
    建立地图的视图
]]
function Map:createView(parent)
    assert(self.m_batch == nil, "Map:createView() - view already created");

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565);
    self.m_bgSprite = display.newSprite(self.m_imageName);
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888);

    self.m_bgSprite:addNodeEventListener(cc.NODE_EVENT, function(event)
        -- 地图对象删除时，自动从缓存里卸载地图材质
        if event.name == "exit" then
            display.removeSpriteFrameByImageName(self.m_imageName);
        end
    end);

    self.m_bgSprite:align(display.LEFT_BOTTOM, 0, 0);
    parent:addChild(self.m_bgSprite);

    -- self.m_batch = display.newBatchNode("SheetMapBattle.png", 1000);
    self.m_batch = display.newNode();
    parent:addChild(self.m_batch);

    self.m_marksLayer = display.newNode();
    parent:addChild(self.m_marksLayer);

    if self.m_debug then
        self.m_debugLayer = display.newNode();
        parent:addChild(self.m_debugLayer);
    end

    for id, object in pairs(self.m_objects) do
        object:createView(self.m_batch, self.m_marksLayer, self.m_debugLayer);
        object:updateView();
    end

    self:setAllObjectsZOrder();
end

--[[
    删除视图
]]
function Map:removeView()
    assert(self.m_batch ~= nil, "Map:removeView() - view not exists");

    for id, object in pairs(self.m_objects) do
        if object:isViewCreated() then
            object:removeView();
        end
    end

    self.m_bgSprite:removeSelf();
    self.m_batch:removeSelf();
    self.m_marksLayer:removeSelf();

    if self.m_debugLayer then 
        self.m_debugLayer:removeSelf();
    end

    self.m_bgSprite   = nil;
    self.m_batch      = nil;
    self.m_marksLayer = nil;
    self.m_debugLayer = nil;
end

--[[
    调用地图中所有对象的 updateView()
]]
function Map:updateView()
    assert(self.m_batch ~= nil, "Map:removeView() - view not exists");

    for id, object in pairs(self.m_objects) do
        object:updateView();
    end
end

--[[
    按照 Y 坐标重新排序所有可视对象
]]
function Map:setAllObjectsZOrder()
    local batch = self.m_batch;
    
    for id, object in pairs(self.m_objects) do
        local view = object:getView();
        
        if view then
            if object.m_viewZOrdered then
                batch:reorderChild(view, MapConstants.MAX_OBJECT_ZORDER - object.m_y);
            elseif type(object.m_zorder) == "number" then
                batch:reorderChild(view, object.m_zorder);
            else
                batch:reorderChild(view, MapConstants.DEFAULT_OBJECT_ZORDER);
            end

            object:updateView();
        end
    end
end

--[[
    返回背景图
]]
function Map:getBackgroundLayer()
    return self.m_bgSprite;
end

--[[
    返回地图的批量渲染层
]]
function Map:getBatchLayer()
    return self.m_batch;
end

--[[
    返回用于显示地图标记的层
]]
function Map:getMarksLayer()
    return self.m_marksLayer;
end

--[[
    放回用于编辑器的批量渲染层
]]
function Map:getDebugLayer()
    return self.m_debugLayer;
end

--[[
    返回地图的数据
]]
function Map:vardump()
    local state = {
        objects = {},
        size = {width = self.m_width, height = self.m_height},
        imageName = self.m_imageName,
    };

    for id, object in pairs(self.m_objects) do
        state.objects[id] = object:vardump();
    end

    return state;
end

--[[
    导出地图数据
]]
function Map:dump()
    local lines = {};

    lines[#lines + 1] = "";
    lines[#lines + 1] = string.format("------------ MAP %s ------------", self.m_id);
    lines[#lines + 1] = "";
    lines[#lines + 1] = "local map = {}";
    lines[#lines + 1] = "";
    lines[#lines + 1] = string.format("map.size = {width = %d, height = %d}", self.m_width, self.m_height);
    lines[#lines + 1] = string.format("map.imageName = \"%s\"", self.m_imageName);
    lines[#lines + 1] = "";

    -- objects
    local allid = table.keys(self.m_objects);
    table.sort(allid);
    lines[#lines + 1] = "local objects = {}";
    
    for i, id in ipairs(allid) do
        lines[#lines + 1] = "";
        lines[#lines + 1] = self.m_objects[id]:dump("local object");
        lines[#lines + 1] = string.format("objects[\"%s\"] = object", id);
        lines[#lines + 1] = "";
        lines[#lines + 1] = "----";
    end

    lines[#lines + 1] = "";
    lines[#lines + 1] = "map.objects = objects";
    lines[#lines + 1] = "";
    lines[#lines + 1] = "return map";
    lines[#lines + 1] = "";

    return table.concat(lines, "\n");
end

--[[
    从 package.path 中查找指定模块的文件名，如果失败返回 false。
    @param string moduleName
    @return string
]]
function Map:findModulePath(moduleName)
    local filename = string.gsub(moduleName, "%.", "/") .. ".lua";
    local paths = string.split(package.path, ";");
    
    for i, path in ipairs(paths) do
        if string.sub(path, -5) == "?.lua" then
            path = string.sub(path, 1, -6);
            if not string.find(path, "?", 1, true) then
                local fullpath = path .. filename;
                if io.exists(fullpath) then
                    return fullpath;
                end
            end
        end
    end

    return false;
end

--[[
    导出地图数据到文件
]]
function Map:dumpToFile()
    local contents = self:dump();
    local path = self:findModulePath(self.m_mapModuleName);

    if path then
        printf("save data filename \"%s\" [%s]", path, os.date("%Y-%m-%d %H:%M:%S"));
        io.writefile(path, contents);
        return true;
    else
        printf("not found module file, dump [%s]", os.date("%Y-%m-%d %H:%M:%S"));
        echo("\n\n" .. contents .. "\n");
        return false;
    end
end

--[[
    重置地图状态
]]
function Map:reset(state)
    self:removeAllObjects();

    if self:isViewCreated() then 
        self:removeView(); 
    end

    self.m_data = clone(state);
    self.m_ready = false;
    self:init();
end

return Map;
