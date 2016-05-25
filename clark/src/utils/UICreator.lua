require("utils.UIConfig")
--[[
	ClassName   :     UICreator.lua
	description :  	create ui more fast
	author 		:   	ClarkWu
]]
UICreator = {};

--[[
	@function 	:  createText
	@param 		:  text   -- 文本内容
				   size   -- 文本大小
				   align  -- 对齐方式
				   x,y 	  -- x,y 坐标
	description :  创建普通文本
	return 		:  UILabel对象
]]
function UICreator.createText(text,size,align,x,y,r,g,b,fontName)
	local text = cc.ui.UILabel.new({
			font = fontName,
            UILabelType = UIConfig.LABEL.TTF_FONT,
            text = text, 
            size = size,
            color = cc.c3b(r,g,b)
            })
        :align(align,x, y);
    return text;
end

--[[
	@function 	: createImg
	@param 		: imageName 	-- 图片名称
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  width			-- 宽度
				  height 		-- 高度
	description : 创建图片
	return 		: 图片精灵
]]
function UICreator.createImg(imageName,isScale9OrNot,x,y,width,height)
	if isScale9OrNot then 
		local image = display.newScale9Sprite(imageName);
		image:setContentSize(width,height);
		image:pos(x,y);
		return image;
	end
end

--[[
	@function 	: createUIImage
	@param 		: imageName 	-- 图片名称
				  x,y 			-- x,y坐标
				  width			-- 宽度
				  height 		-- 高度
				  align 		-- 对齐方式
				  isScale9OrNot -- 是否可以缩放
	description : 创建图片
	return 		: 图片
]]
function UICreator.createUIImage(imageName,x,y,width,height,align,isScale9OrNot)
	local image = cc.ui.UIImage.new(imageName,{scale9 = isScale9OrNot or false})
        :align(align,x,y);
    if width or height then
    	image:setLayoutSize(width,height);
    end
    return image;
end

--[[
	@function 	: createBtnText
	@param 		: imageName 	-- 图片名称
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  align 		-- 对齐方式
				  width			-- 宽度
				  height 		-- 高度
				  label 		-- 文字
	description : 创建按钮文本
	return 		: 按钮
]]
function UICreator.createBtnText(imageName,isScale9OrNot,x,y,align,width,height,label)
	local button;
	button = cc.ui.UIPushButton.new(imageName, {scale9 = isScale9OrNot or false})
	if width and height then
    	button:setButtonSize(width, height);
	end
	if label then
       button:setButtonLabel(UIConfig.BUTTON.STATE_NORMAL, label)
    end
    button:align(align,x,y);
    return button;
end

--[[
	@function 	: createLine
	@param 		: x1,y1 	-- 起始点坐标
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  align 		-- 对齐方式
				  width			-- 宽度
				  height 		-- 高度
				  label 		-- 文字
	description : 创建线条
	return  	: 线条
]]
function UICreator.createLine(x1,y1,x2,y2,r,g,b,a,borderWidth)
	local line = display.newLine(
		{{x1,y1},{x2,y2}},
		{borderColor=cc.c4f(r,g,b,a)},
		{borderWidth=borderWidth});
	return line;
end

--[[
	@function 	: createPageView
	@param		: viewRect 	    页面控件的显示区域 cc.rect(起始(x,y,宽度，高度)) 	
				  columnNum  	每一页的列数
				  rowNum 		每一页的行数
				  paddingRect 	{
				  				-   left 左边间隙
							    -   right 右边间隙
							    -   top 上边间隙
							    -   bottom 下边间隙
							    }
				  columnSpace   列之间的间隙
				  rowSpace 		行之间的间隙
				  isCircle		页面是否循环,默认为false
	description : 创建页面
	return 		: 页面
]]
function UICreator.createPageView(viewRect,columnNum,rowNum,paddingRect,columnSpace,rowSpace,isCircle)
	local pageView = cc.ui.UIPageView.new {
        viewRect = viewRect,
        column = columnNum, row = rowNum,
        padding = paddingRect,
        columnSpace = columnSpace, rowSpace = rowSpace,bCirc = isCircle};
    return pageView;
end

--[[
	@function 	: createListView
	@param		: direction 	列表控件的滚动方向，默认为垂直方向
				  itemAlign  	listViewItem中content的对齐方式，默认为垂直居中
				  viewRect 		列表控件的显示区域
				  scrollbarImgH 水平方向的滚动条
				  scrollbarImgV 垂直方向的滚动条
				  bg  			背景图
				  bgScale9   	背景图是否可缩放
				  r,g,b,a 		背景颜色
	description : 创建列表ListView
	return 		: 列表ListView
]]
function UICreator.createListView(direction,itemAlign,viewRect,scrollbarImgH,scrollbarImgV,bg,bgScale9,r,g,b,a,isAsysc)
	local listView = cc.ui.UIListView.new {
		direction = direction,
		alignment = itemAlign,
		viewRect = viewRect,
		scrollbarImgH = scrollbarImgH,
		scrollbarImgV = scrollbarImgV,
		bg = bg,
		bgScale9 = bgScale9 or false,
		bgColor = cc.c4b(r,g,b,a),
		async = isAsysc or false
	};
    return listView;
end

--[[
	@function 	: createScrollView
	@param		: direction 	滚动控件的滚动方向，默认为垂直与水平方向都可滚动
				  viewRect 		列表控件的显示区域
				  scrollbarImgH 水平方向的滚动条
				  scrollbarImgV 垂直方向的滚动条
				  bg 			背景图
				  bgScale9 		是否可缩放
				  r,g,b,a 		背景颜色
	description : 创建列表ScrollView
	return 		: 列表ScrollView
]]
function UICreator.createScrollView(direction,viewRect,scrollbarImgH,scrollbarImgV,bg,bgScale9,r,g,b,a)
	local scrollView = cc.ui.UIScrollView.new{
		direction = direction,
		viewRect = viewRect,
		scrollbarImgH = scrollbarImgH,
		scrollbarImgV = scrollbarImgV,
		bgColor = cc.c4b(r,g,b,a),
		bg = bg,
		bgScale9 = bgScale9 or false
	};
	return scrollView;
end

function UICreator.createUICheckBox(offImages,onImages)
	-- if type 
	-- local checkBoxBtn = cc.ui.UICheckBoxButton.new(TestUIButtonScene.CHECKBOX_BUTTON_IMAGES)
end