--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local enterlevel = {}
enterlevel.layerTable = nil
enterlevel.frames = 0

----------------------------------------------------------------
enterlevel.onFocus = function ( self )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	enterlevel.waitSeconds = 2
	enterlevel.startTime = MOAISim.getDeviceTime ()

end

----------------------------------------------------------------
enterlevel.onInput = function ( self )

end

----------------------------------------------------------------
enterlevel.onLoad = function ( self )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	enterlevel.layerTable [ 1 ] = { layer }

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["arialbd,12"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -150, -20, 150, 20 )
    self.textbox1:setString ( "enterlevel "..GAMEOBJECT.level.name )
    self.textbox1:setLoc ( 0, utils.screen_middleheight-40)
    layer:insertProp ( self.textbox1 )

    enterlevel.frames = 0

end

----------------------------------------------------------------
enterlevel.onLoseFocus = function ( self )
end

----------------------------------------------------------------
enterlevel.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer:clear ()
			layer = nil
		end
	end

	self.layerTable = nil
end

----------------------------------------------------------------
enterlevel.onUpdate = function ( self )

   	if self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

		statemgr.pop ( "menu" )
	end
end

return enterlevel