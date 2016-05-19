require("app.logic.TOFELogic")
local SceneTOFE = class("SceneTOFE", function()
    return display.newScene("SceneTOFE")
end)

function SceneTOFE:ctor()
    display.newColorLayer(cc.c4b(0xfa,0xf8,0xef, 255)):addTo(self);
    self.m_winStr = "";
    self.m_grid = initGrid(4,4);

    self.m_colors = {
    	[-1]   = cc.c4b(0xee,0xe4,0xda,100),
    	[0]    = cc.c3b(0xee,0xe4,0xda),
    	[2]    = cc.c3b(0xee,0xe4,0xda),
    	[4]    = cc.c3b(0xed, 0xe0, 0xc8),
	    [8]    = cc.c3b(0xf2, 0xb1, 0x79),
	    [16]   = cc.c3b(0xf5, 0x95, 0x63),
	    [32]   = cc.c3b(0xf6, 0x7c, 0x5f),
	    [64]   = cc.c3b(0xf6, 0x5e, 0x3b),
	    [128]  = cc.c3b(0xed, 0xcf, 0x72),
	    [256]  = cc.c3b(0xed, 0xcc, 0x61),
	    [512]  = cc.c3b(0xed, 0xc8, 0x50),
	    [1024] = cc.c3b(0xed, 0xc5, 0x3f),
	    [2048] = cc.c3b(0xed, 0xc2, 0x2e),
	    [4096] = cc.c3b(0x3c, 0x3a, 0x32),
	};

	self.m_configFile = device.writablePath .. "hxgame.config";

	self.m_numColors = {
	    [0] = cc.c3b(0x77,0x6e,0x65),
	    [2] = cc.c3b(0x77,0x6e,0x65),
	    [4] = cc.c3b(0x77,0x6e,0x65),
	    [8] = cc.c3b(0x77,0x6e,0x65),
	    [16] = cc.c3b(0x77,0x6e,0x65),
	    [32] = cc.c3b(0x77,0x6e,0x65),
	    [64] = cc.c3b(0x77,0x6e,0x65),
	    [128] = cc.c3b(0x77,0x6e,0x65),
	};

	self.m_touchStart = {0,0};

    self:initScene();


end

function SceneTOFE:onEnter()
end

function SceneTOFE:onExit()
end

function SceneTOFE:initScene()
	self.m_title = UICreator.createText("   2048   ",40,display.CENTER,display.cx,display.top - 20,0,0,0);
	self.m_title:addTo(self);

	self.m_score = UICreator.createText("Score : 0",30,display.CENTER,display.cx,display.top - 100,0,0,255);
	self.m_score:addTo(self);

	self:createGridView();
	self:createButtons();

	self:loadStatus();

end

function SceneTOFE:loadStatus()
	if io.exists(self.m_configFile) then 
		local str = io.readfile(self.m_configFile);
		if str then 
			local f = loadstring(str);
			local _grid,_bestScore,_totalScore,_WinStr,_isOver = f();
			if _grid and _bestScore and _totalScore and _WinStr then 
				self.m_grid,self.m_bestScore,self.m_totalScore,self.m_winStr,self.m_isOver = _grid,_bestScore,_totalScore,_WinStr,_isOver;
			end

		end
	end
	self:reloadGame();

end

function SceneTOFE:reloadGame()
	local m = #self.m_grid;
	local n = #self.m_grid[1];
	for i=1,m do
		for j=1,n do 
			self:setNum(self.m_gridShows[i][j],self.m_grid[i][j],i,j);
		end
	end
	self.m_score:setString(string.format("BEST:%d     \nSCORE:%d    \n%s",self.m_bestScore,self.m_totalScore,self.m_winStr or ""))
end

function SceneTOFE:setNum(mGridView,num,i,j)
	local s = tostring(num);
	if s == "0" then 
		s = "";
		mGridView.background:setOpacity(100);
	else
		mGridView.background:setOpacity(255);
	end
	local c = self.m_colors[num];
	if not c then 
		c = self.m_colors[4096];
	end
	mGridView.numText:setString(s);
	mGridView.background:setColor(c);

	local nc = self.m_numColors[num];
	if not nc then
		 nc = self.m_numColors[128];
	end

	mGridView.numText:setColor(nc);
end

function SceneTOFE:createButtons()
	local images = {
        normal = "GreenButton.png",
        pressed = "GreenScale9Block.png",
        disabled = "GreenButton.png",
    };
    local label = UICreator.createText("New Game",32,display.CENTER);
    self.m_newGame = UICreator.createBtnText(images,true,
    					display.left+display.width/2, display.top - 130,display.CENTER_TOP,200,60,label);
    self.m_newGame:addTo(self);

    self.m_newGame:onButtonClicked(function(event)
    	self:restartGame();
    end)

end

function SceneTOFE:createGridView()
	self.m_gridShows = {};
	for tmp=0,15 do 
		local i,j = math.floor(tmp/4)+1,math.floor(tmp%4)+1;
		local num = self.m_grid[i][j];
		local s = tostring(num);
		if tostring(num) == "0" then 
			s = "";
		end

		if not self.m_gridShows[i] then 
			self.m_gridShows[i] = {};
		end

		local x,y = self:getPosFormId(i,j);

		local cell = {
			backgroundsize = 65,
			background = cc.LayerColor:create(self.m_colors[-1],65,65),
			numText = UICreator.createText(s,35,display.CENTER,x,y,0x77,0x6e,0x65),
		};
		self.m_gridShows[i][j] = cell;

		self:show(self.m_gridShows[i][j],x,y);
	end
end

function SceneTOFE:show(cell,x,y)
	local bsz = cell.backgroundsize / 2;
	cell.background:setPosition(cc.p(x - bsz,y - bsz));
	cell.background:addTo(self);

	cell.numText:addTo(self);
end

function SceneTOFE:getPosFormId(currentX,currentY)
	local cellSize = 110;
	local cdis = 2 * cellSize - cellSize / 2;
	local origin = {x = display.cx - cdis, y = display.cy + cdis};
	local x = (currentY - 1) * cellSize + origin.x;
	local y = -(currentX - 1) * cellSize + origin.y - 80;
	return x,y;
end

function SceneTOFE:restartGame()
	self.m_grid = initGrid(4,4);
	self.m_totalScore = 0;
	self.m_winStr = "";
	self.m_isOver = false;
	self:reloadGame();
	self:saveStatus();
end

function SceneTOFE:saveStatus()
	local gridStr = serialize(self.m_grid);
	local isOverStr = "false";
	if self.m_isOver then 
		isOverStr = "true";
	end
 	local str = string.format("do local grid,bestScore,totalScore,WINSTR,isOver \
                              =%s,%d,%d,\'%s\',%s return grid,bestScore,totalScore,WINSTR,isOver end",
                              gridStr,self.m_bestScore,self.m_totalScore,self.m_winStr,isOverStr);
    io.writefile(self.m_configFile,str);
end

function SceneTOFE:onEnter()
    local layer = display.newNode();
    layer:setContentSize(display.width, display.height)

    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    layer:setTouchEnabled(true);
    layer:setTouchSwallowEnabled(false);
    layer:addTo(self);
end

function SceneTOFE:onTouch(event, x, y)
    if self.m_isOver then
        return true;
    end

    if event == "began" then
        self.m_touchStart = {x,y};
    elseif event == "ended" then
        local tx,ty = x-self.m_touchStart[1],y-self.m_touchStart[2];
        if tx==0 then
            tx = tx + 1 ;
            ty = ty + 1 ;
        end
        local dis = tx*tx + ty*ty;
        if dis<3 then   -- touch move too short will ignore
            return true;
        end
        local dt = ty/tx;
        local op_list,score,win;
        if dt>=-1 and dt<=1 then
            if tx>0 then
                op_list,score,win = touch_op(self.m_grid,"right");
            else
                op_list,score,win = touch_op(self.m_grid,"left");
            end
        else
            if ty>0 then
                op_list,score,win = touch_op(self.m_grid,"up");
            else
                op_list,score,win = touch_op(self.m_grid,"down");
            end
        end
        self:doOpList(op_list);
        if win then
            self.m_winStr = "YOUR ARE WINER";
        end
        self.m_totalScore = self.m_totalScore + score;
        if self.m_totalScore> self.m_bestScore then
            self.m_bestScore = self.m_totalScore;
        end
        self.m_score:setString(string.format("BEST:%d     \nSCORE:%d    \n%s",self.m_bestScore,self.m_totalScore,self.m_winStr or ""))
        self.m_isOver = not canMove(self.m_grid)
        self:saveStatus();
    end
    return true
end

function SceneTOFE:doOpList(op_list)
    for _,op in ipairs(op_list or {}) do
        local o = op[1]
        if o== "setnum" then
            local i,j,num = op[2],op[3],op[4];
            self:setNum(self.m_gridShows[i][j],num,i,j);
        end
    end
end

return SceneTOFE;
