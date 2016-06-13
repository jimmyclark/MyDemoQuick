local math2d = require("math2d");
local MapConstants = require("app.map.MapConstant");

local MapCamera = class("MapCamera");

function MapCamera:ctor(map)
    self.m_map = map;
    self.m_zooming = false;
    self.m_scale = 1;
    self.m_actualScale = 1;
    self.m_offsetX = 0;
    self.m_offsetY = 0;
    self.m_offsetLimit = nil;
    self.m_margin = {top = 0, right = 0, bottom = 0, left = 0};

    local width,height = map:getSize();
    local minScaleV = display.height / height;
    local minScaleH = display.width / width;
    local minScale = minScaleV;

    if minScaleH > minScale then 
        minScale = minScaleH; 
    end
    self.m_minScale = minScale;
end

--[[
    返回地图的边空
]]
function MapCamera:getMargin()
    return clone(self.m_margin);
end

--[[
    设置地图卷动的边空
]]
function MapCamera:setMargin(top, right, bottom, left)
    if self.m_zooming then 
        return; 
    end

    if type(top) == "number" then 
        self.m_margin.top = top;
    end

    if type(right) == "number" then 
        self.m_margin.right = right;
    end

    if type(bottom) == "number" then 
        self.m_margin.bottom = bottom;
    end

    if type(left) == "number" then 
        self.m_margin.left = left;
    end

    self:resetOffsetLimit();
end

--[[
    更新地图的卷动限制
]]
function MapCamera:resetOffsetLimit()
    local mapWidth, mapHeight = self.m_map:getSize();
    self.m_offsetLimit = {
        minX = display.width - self.m_margin.right - mapWidth * self.m_actualScale,
        maxX = self.m_margin.left,
        minY = display.height - self.m_margin.top - mapHeight * self.m_actualScale,
        maxY = self.m_margin.bottom,
    };
end

--[[
    返回地图当前的缩放比例
]]
function MapCamera:getScale()
    return self.m_scale;
end

--[[
    设置地图当前的缩放比例
]]
function MapCamera:setScale(scale)
    if self.m_zooming then 
        return;
    end

    self.m_scale = scale;
    if scale < self.m_minScale then 
        scale = self.m_minScale; 
    end

    -- TODO?
    self.m_scale = scale;

    self.m_actualScale = scale;
    self:resetOffsetLimit();

    self:setOffset(self.m_offsetX, self.m_offsetY);

    local backgroundLayer = self.m_map:getBackgroundLayer();
    local batchLayer      = self.m_map:getBatchLayer();
    local marksLayer      = self.m_map:getMarksLayer();
    local debugLayer      = self.m_map:getDebugLayer();

    backgroundLayer:setScale(scale);
    batchLayer:setScale(scale);
    marksLayer:setScale(scale);
    if debugLayer then 
        debugLayer:setScale(scale);
    end
end


--[[
    设置地图卷动的偏移量
]]
function MapCamera:setOffset(x, y, movingSpeed, onComplete)
    if self.m_zooming then 
        return;
    end

    if x < self.m_offsetLimit.minX then
        x = self.m_offsetLimit.minX;
    end
    if x > self.m_offsetLimit.maxX then
        x = self.m_offsetLimit.maxX;
    end
    if y < self.m_offsetLimit.minY then
        y = self.m_offsetLimit.minY;
    end
    if y > self.m_offsetLimit.maxY then
        y = self.m_offsetLimit.maxY;
    end

    self.m_offsetX, self.m_offsetY = x, y;

    if type(movingSpeed) == "number" and movingSpeed > 0 then
        transition.stopTarget(self.m_bgSprite);
        transition.stopTarget(self.m_batch);
        transition.stopTarget(self.m_marksLayer);
        if self.m_debugLayer then
            transition.stopTarget(self.m_debugLayer);
        end

        local cx, cy = self.m_bgSprite:getPosition();
        local mtx = cx / movingSpeed;
        local mty = cy / movingSpeed;
        local movingTime;
        if mtx > mty then
            movingTime = mtx;
        else
            movingTime = mty;
        end

        transition.moveTo(self.m_bgSprite, {
            x = x,
            y = y,
            time = movingTime,
            onComplete = onComplete
        });
        transition.moveTo(self.m_batch, {x = x, y = y, time = movingTime});
        transition.moveTo(self.m_marksLayer, {x = x, y = y, time = movingTime});
        if self.m_debugLayer then
            transition.moveTo(self.m_debugLayer, {x = x, y = y, time = movingTime});
        end
    else
        self.m_map:getBackgroundLayer():setPosition(x, y);
        self.m_map:getBatchLayer():setPosition(x, y);
        self.m_map:getMarksLayer():setPosition(x, y);
        local debugLayer = self.m_map:getDebugLayer();
        if debugLayer then 
            debugLayer:setPosition(x, y);
        end
    end
end

--[[
    动态调整摄像机的缩放比例
]]
function MapCamera:zoomTo(scale, x, y)
    self.m_zooming = true;
    self.m_scale = scale;
    
    if scale < self.m_minScale then 
        scale = self.m_minScale;
    end

    self.m_actualScale = scale;
    self:resetOffsetLimit();

    local backgroundLayer = self.m_map:getBackgroundLayer();
    local batchLayer = self.m_map:getBatchLayer();
    local marksLayer = self.m_map:getMarksLayer();
    local debugLayer = self.m_map:getDebugLayer();

    if self.m_backgroundLayerAction then 
        transition.removeAction(self.m_backgroundLayerAction);
    end

    if self.m_batchLayerAction then 
        transition.removeAction(self.m_batchLayerAction);
    end

    if self.m_marksLayerAction then 
        transition.removeAction(self.m_marksLayerAction);
    end

    if debugLayer then
        transition.stopTarget(debugLayer);
    end

    self.m_backgroundLayerAction = transition.scaleTo(backgroundLayer, {scale = scale, time = MapConstants.ZOOM_TIME});
    self.m_batchLayerAction = transition.scaleTo(batchLayer, {scale = scale, time = MapConstants.ZOOM_TIME});
    self.m_marksLayerAction = transition.scaleTo(marksLayer, {scale = scale, time = MapConstants.ZOOM_TIME});

    if debugLayer then
        transition.scaleTo(debugLayer, {scale = scale, time = MapConstants.ZOOM_TIME});
    end

    if type(x) ~= "number" then 
        return; 
    end

    if x < self.m_offsetLimit.minX then
        x = self.m_offsetLimit.minX;
    end
    if x > self.m_offsetLimit.maxX then
        x = self.m_offsetLimit.maxX;
    end
    if y < self.m_offsetLimit.minY then
        y = self.m_offsetLimit.minY;
    end
    if y > self.m_offsetLimit.maxY then
        y = self.m_offsetLimit.maxY;
    end

    self.m_offsetX, self.m_offsetY = x, y;

    transition.moveTo(backgroundLayer, {
        x = x,
        y = y,
        time = MapConstant.ZOOM_TIME,
        onComplete = function()
            self.m_zooming = false;
        end
    });
    transition.moveTo(batchLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME});
    transition.moveTo(marksLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME});
    if debugLayer then
        transition.moveTo(debugLayer, {x = x, y = y, time = MapConstants.ZOOM_TIME});
    end
end

--[[
    返回地图当前的卷动偏移量
]]
function MapCamera:getOffset()
    return self.m_offsetX, self.m_offsetY;
end

--[[
    移动指定的偏移量
]]
function MapCamera:moveOffset(offsetX, offsetY)
    self:setOffset(self.m_offsetX + offsetX, self.m_offsetY + offsetY);
end

--[[
    返回地图的卷动限制
]]
function MapCamera:getOffsetLimit()
    return clone(self.m_offsetLimit);
end

--[[
    将屏幕坐标转换为地图坐标
]]
function MapCamera:convertToMapPosition(x, y)
    return (x - self.m_offsetX) / self.m_actualScale, (y - self.m_offsetY) / self.m_actualScale;
end

--[[
    将地图坐标转换为屏幕坐标
]]
function MapCamera:convertToWorldPosition(x, y)
    return x * self.m_actualScale + self.m_offsetX, y * self.m_actualScale + self.m_offsetY;
end

--[[
    将指定的地图坐标转换为摄像机坐标
]]
function MapCamera:convertToCameraPosition(x, y)
    local left = -(x - (display.width - self.m_margin.left - self.m_margin.right) / 2);
    local bottom = -(y - (display.height - self.m_margin.top - self.m_margin.bottom) / 2);
    return left, bottom;
end

return MapCamera;
