--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local winlevel = {}
winlevel.layerTable = nil
winlevel.IS_POPUP = true

----------------------------------------------------------------
winlevel.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	winlevel.waitSeconds = 2
	winlevel.startTime = MOAISim.getDeviceTime ()

end

----------------------------------------------------------------
winlevel.onInput = function ( self )

end

----------------------------------------------------------------
winlevel.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	winlevel.layerTable [ 1 ] = { layer }

	self.box = MOAIProp2D.new ()
	self.box:setDeck ( utils.MOAIGfxQuad2D_new (images.box,300,80) )
	self.box:setColor ( 0,0,0,0.5)
	layer:insertProp ( self.box )

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,64"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -150, -32, 150, 32 )
    self.textbox1:setString ( "LEVEL FINISHED" )
    self.textbox1:setLoc ( 0, 0)
    layer:insertProp ( self.textbox1 )

end

----------------------------------------------------------------
winlevel.onLoseFocus = function ( self )
end

----------------------------------------------------------------
winlevel.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer:clear ()
			layer = nil
		end
	end

	self.layerTable = nil
end

----------------------------------------------------------------
winlevel.onUpdate = function ( self )

   	if self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

        GAMEOBJECT:initLevel(GAMEOBJECT.level.number+1)
		statemgr.swap ( "enterlevel")

	end
end

return winlevel