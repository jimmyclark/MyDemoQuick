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
	@function 	: createBtnText
	@param 		: imageName 	-- 图片名称
				  isScale9OrNot -- 是否是9宫图
				  x,y 			-- x,y坐标
				  align 		-- 对齐方式
				  width			-- 宽度
				  height 		-- 高度
				  label 		-- 文字
]]
function UICreator.createBtnText(imageName,isScale9OrNot,x,y,align,width,height,label)
	local button;
	if type(imageName) == "table" then 
		button = cc.ui.UIPushButton.new(imageName, {scale9 = isScale9OrNot})
	else

	end
    button:setButtonSize(width, height)
       :setButtonLabel(UIConfig.BUTTON.STATE_NORMAL, label)
       :align(align,x,y);
    return button;
end

