--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local lostlife = {}
lostlife.layerTable = nil
lostlife.IS_POPUP = true

----------------------------------------------------------------
lostlife.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	lostlife.waitSeconds = 2
	lostlife.startTime = MOAISim.getDeviceTime ()

end

----------------------------------------------------------------
lostlife.onInput = function ( self )

end

----------------------------------------------------------------
lostlife.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	lostlife.layerTable [ 1 ] = { layer }

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,32"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -150, -20, 150, 20 )
    self.textbox1:setString ( "lostlife "..GAMEOBJECT.lifes.." lifes left" )
    self.textbox1:setLoc ( 0, utils.screen_middleheight-40)
    layer:insertProp ( self.textbox1 )

end

----------------------------------------------------------------
lostlife.onLoseFocus = function ( self )
end

----------------------------------------------------------------
lostlife.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer:clear ()
			layer = nil
		end
	end

	self.layerTable = nil
end

----------------------------------------------------------------
lostlife.onUpdate = function ( self )

   	if self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then
   		if GAMEOBJECT.lifes == 0 then
		  statemgr.swap ( "gameover" )
		else
		  GAMEOBJECT:reinitLevel()
		  statemgr.swap ( "enterlevel")
		end
	end
end

return lostlife