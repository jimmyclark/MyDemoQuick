local FilterScene = class("FilterScene",function()
	return display.newScene("FilterScene");
end);


FilterScene._FILTERS = {

	-- custom
	{"CUSTOM"},

	-- {"CUSTOM", json.encode({frag = "Shaders/example_Flower.fsh",
	-- 					center = {display.cx, display.cy},
	-- 					resolution = {480, 320}})},

	{{"CUSTOM", "CUSTOM"},
		{json.encode({frag = "Shaders/example_Blur.fsh",
			shaderName = "blurShader",
			resolution = {480,320},
			blurRadius = 10,
			sampleNum = 5}),
		json.encode({frag = "Shaders/example_sepia.fsh",
			shaderName = "sepiaShader",})}},

	-- colors
	{"GRAY",{0.2, 0.3, 0.5, 0.1}},
	{"RGB",{1, 0.5, 0.3}},
	{"HUE", {90}},
	{"BRIGHTNESS", {0.3}},
	{"SATURATION", {0}},
	{"CONTRAST", {2}},
	{"EXPOSURE", {2}},
	{"GAMMA", {2}},
	{"HAZE", {0.1, 0.2}},
	--{"SEPIA", {}},
	-- blurs
	{"GAUSSIAN_VBLUR", {7}},
	{"GAUSSIAN_HBLUR", {7}},
	{"ZOOM_BLUR", {4, 0.7, 0.7}},
	{"MOTION_BLUR", {5, 135}},
	-- others
	{"SHARPEN", {1, 1}},
	{{"GRAY", "GAUSSIAN_VBLUR", "GAUSSIAN_HBLUR"}, {nil, {10}, {10}}},
	{{"BRIGHTNESS", "CONTRAST"}, {{0.1}, {4}}},
	{{"HUE", "SATURATION", "BRIGHTNESS"}, {{240}, {1.5}, {-0.4}}},
}

function FilterScene:ctor()
	self.m_backBtn = UICreator.createBtnText("close.png",true,display.left + 100,display.top - 100,display.CENTER);
	self.m_backBtn:addTo(self);

	self.m_backBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_backBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_backBtn:onButtonClicked(function(event)
		local mainScene = require("app.scenes.MainScene").new();
		display.replaceScene(mainScene,"shrinkGrow", 0.6, display.COLOR_WHITE);
	end);

	-- 定制filter传入的参数为json字符串
	-- frag固定为fragment shader文件资源中的所在位置
	-- vert固定为vert shader文件资源中的所在位置
	-- shaderName为当前shader的名字,不同的shader,不同参数对应不同名字,
	-- 其它值会认为是要传入的参数
	local customParams = {frag = "Shaders/example_Noisy.fsh",
						shaderName = "noisyShader",
						-- u_outlineColor = {1.0, 0.2, 0.3},
						-- u_radius = 0.01,
						-- u_threshold = 1.75,
						resolution = {480, 320}};
	local par = json.encode(customParams);
	self._FILTERS[1][2] = par;

	self:addUI();
	self:createFilters();
	self:showFilter();
end

function FilterScene:addUI()
	local preImage = {
		normal = "b1.png",
		pressed = "b2.png"
	};

	self.m_preBtn = UICreator.createBtnText(preImage,true,display.cx -100,display.bottom+ 50,display.BOTTOM_CENTER,79,46);
	self.m_preBtn:addTo(self, 0);
	self.m_preBtn:onButtonClicked(handler(self, self.onPrev));
	self.m_preBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_preBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	local resetImage = {
		normal = "r1.png",
		pressed = "r2.png"
	};

	self.m_resetBtn = UICreator.createBtnText(resetImage,true,display.cx,display.bottom+50,display.BOTTOM_CENTER,49,47);
	self.m_resetBtn:addTo(self, 0)
	self.m_resetBtn:onButtonClicked(handler(self, self.onReset));
	self.m_resetBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_resetBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	local nextImage = {
		normal="f1.png",
		pressed="f2.png"
	};

	self.m_nextBtn = UICreator.createBtnText(nextImage,true,display.cx +100,display.bottom+50,display.BOTTOM_CENTER,79,46);
	self.m_nextBtn:addTo(self, 0)
	self.m_nextBtn:onButtonClicked(handler(self, self.onNext));
	self.m_nextBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_nextBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	local clearLabel = UICreator.createText("clear filter",22,display.CENTER,display.cx,display.cy,96,200,96);
	self.m_clearFilterBtn = UICreator.createBtnText("BlueBlock.png",true,display.cx,150,display.CENTER,100,30,clearLabel);
	self.m_clearFilterBtn:addTo(self);

	self.m_clearFilterBtn:onButtonClicked(handler(self, self.onClearFilter));
	self.m_clearFilterBtn:onButtonPressed(function(event)
		event.target:setOpacity(128);
	end);

	self.m_clearFilterBtn:onButtonRelease(function(event)
		event.target:setOpacity(255);
	end);

	self.m_title = UICreator.createText("Filters Test",22,display.CENTER,display.cx,display.top-80,255,255,255);
	self.m_title:addTo(self,10);

end

function FilterScene:onClearFilter()
	if self.m_filterSprite then
		self.m_filterSprite:clearFilter();
	end
end

function FilterScene:onEnter()

end

function FilterScene:run()

end


function FilterScene:onPrev()
	self.m_curFilter = self.m_curFilter - 1;
	if self.m_curFilter <= 0 then
		self.m_curFilter = self._filterCount;
	end
	self:showFilter();
end

function FilterScene:onReset()
	self:showFilter();
end

function FilterScene:onNext()
	self.m_curFilter = self.m_curFilter + 1;
	if self.m_curFilter > self._filterCount then
		self.m_curFilter = 1;
	end
	self:showFilter();
end

function FilterScene:createFilters()
	self.m_curFilter = 1;
	self._filterCount = #self._FILTERS;
end


function FilterScene:showFilter()
	if self.m_filterSprite then
		self.m_filterSprite:removeSelf();
		self.m_filterSprite = nil;
	end
	local __curFilter = FilterScene._FILTERS[self.m_curFilter];
	-- self._filterSprite = display.newFilteredSprite("helloworld.png", unpack(__curFilter))
	local __filters, __params = unpack(__curFilter);
	if __params and #__params == 0 then
		__params = nil;
	end
	self.m_filterSprite = display.newFilteredSprite("helloworld.png", __filters, __params)
		:align(display.CENTER, display.cx, display.cy)
		:addTo(self, 10);
	-- self._filterSprite:setAnchorPoint(cc.p(1, 1))
	-- self._filterSprite:setPosition(display.cx, display.cy)

        local __title = "";
        if type(__filters) == "table" then
			for i in ipairs(__filters) do
				__title = __title..__filters[i];
				local __param = __params[i];
				if "table" == type(__param) then
					__title = __title.." (" .. table.concat(__param, ",")..")\n";
				else
					__title = __title.." (nil)\n";
				end
			end
        else
            __title = __filters;
			if __params and type(__params) == "table" then
				__title = __title.. " (" .. table.concat(__params, ",")..")";
			end
        end
        self.m_title:setString(__title);
end

function FilterScene:onExit()

end

return FilterScene;