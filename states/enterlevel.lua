--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local enterlevel = {}
enterlevel.layerTable = nil
enterlevel.frames = 0

----------------------------------------------------------------
enterlevel.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	enterlevel.waitSeconds = 2
	if GAMEOBJECT.level.enterLevelWait then
		enterlevel.waitSeconds = GAMEOBJECT.level.enterLevelWait
	end
	enterlevel.startTime = MOAISim.getDeviceTime ()

end

----------------------------------------------------------------
enterlevel.onInput = function ( self )

end

----------------------------------------------------------------
enterlevel.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	enterlevel.layerTable [ 1 ] = { layer }

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,32"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -300, -20, 300, 20 )
    self.textbox1:setString ( GAMEOBJECT.level.name )
    self.textbox1:setLoc ( 0, utils.screen_middleheight-40)
    layer:insertProp ( self.textbox1 )

    if GAMEOBJECT.level.enterLevelLoad then
        GAMEOBJECT.level:enterLevelLoad(layer)
    end

    enterlevel.frames = 0

end

----------------------------------------------------------------
enterlevel.onLoseFocus = function ( self )
end

----------------------------------------------------------------
enterlevel.onUnload = function ( self )

    if GAMEOBJECT.level.enterLevelUnload then
        GAMEOBJECT.level:enterLevelUnload()
    end

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

    if GAMEOBJECT.level.enterLevelUpdate then
        GAMEOBJECT.level:enterLevelUpdate()
    end

   	if self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

		statemgr.pop ( "menu" )
	end
end

return enterlevel