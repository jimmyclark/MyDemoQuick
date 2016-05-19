math.randomseed(os.time());

function initGrid(m,n)
	local grid = {};
	for i=1,m do 
		if not grid[i] then 
			grid[i] = {};
		end
		for j=1,n do 
			grid[i][j] = 0;
		end
	end

	randomNum(grid);
    randomNum(grid);
    return grid;
end

function randomNum(grid)
	local i , j = getRandomZeroPos(grid);
	if i and j then 
		local r = math.random();
		if r < 0.9 then 
			grid[i][j] = 2;
		else
			grid[i][j] = 4;
		end
		return i,j;
	end
end

function getRandomZeroPos(grid)
	local m = #grid;
	local n = #grid[1];
	local zeros = {};
	for i = 1,m do 
		for j = 1,n do 
			if grid[i][j] == 0 then 
				table.insert(zeros,{i=i,j=j});
			end
		end
	end
	if #zeros > 0 then 
		local r = math.random(1,#zeros);
		return zeros[r].i,zeros[r].j;
	end
end
