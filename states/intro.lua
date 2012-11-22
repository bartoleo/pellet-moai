--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local intro = {}
intro.layerTable = nil
intro.frames = 0

----------------------------------------------------------------
intro.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	intro.waitSeconds = 2
	intro.startTime = MOAISim.getDeviceTime ()

end

----------------------------------------------------------------
intro.onInput = function ( self )

end

----------------------------------------------------------------
intro.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	intro.layerTable [ 1 ] = { layer }

	local moaiLogo = MOAIProp2D.new ()
	moaiLogo:setDeck ( utils.MOAIGfxQuad2D_new (images.moai) )
	layer:insertProp ( moaiLogo )

    intro.frames = 0

end

----------------------------------------------------------------
intro.onLoseFocus = function ( self )
end

----------------------------------------------------------------
intro.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer:clear ()
			layer = nil
		end
	end

	self.layerTable = nil
end

----------------------------------------------------------------
intro.onUpdate = function ( self )

    intro.frames = intro.frames + 1
    
    if intro.frames == 2 then
        assetloader.load()
    end
   	
   	if intro.frames >=2 and self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

		statemgr.swap ( "menu" )
	end
end

return intro