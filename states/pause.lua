--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local pause = {}
pause.layerTable = nil
pause.IS_POPUP = true

----------------------------------------------------------------
pause.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

end

----------------------------------------------------------------
pause.onInput = function ( self )

end

----------------------------------------------------------------
pause.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	pause.layerTable [ 1 ] = { layer }

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["arialbd,12"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -150, -20, 150, 20 )
    self.textbox1:setString ( "pause "..GAMEOBJECT.level.name )
    self.textbox1:setLoc ( 0, utils.screen_middleheight-40)
    layer:insertProp ( self.textbox1 )

    statemgr.registerInputCallbacks()

end

----------------------------------------------------------------
pause.onLoseFocus = function ( self )
end

----------------------------------------------------------------
pause.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer:clear ()
			layer = nil
		end
	end

	self.layerTable = nil
end

----------------------------------------------------------------
pause.onUpdate = function ( self )

end

----------------------------------------------------------------
pause.onKey = function (self,source, up,key)
  if up then
    statemgr.pop()
  end
end

----------------------------------------------------------------
pause.onTouch= function (self,source,up,idx,x,y,tapcount)
  if up then
    statemgr.pop()
  end
end

return pause