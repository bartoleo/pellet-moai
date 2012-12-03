-- winlevel state

local state = {}
state.layerTable = nil
state.IS_POPUP = true

----------------------------------------------------------------
state.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	state.waitSeconds = 2
	state.startTime = MOAISim.getDeviceTime ()

end

----------------------------------------------------------------
state.onInput = function ( self )

end

----------------------------------------------------------------
state.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	state.layerTable [ 1 ] = { layer }

	self.box = MOAIProp2D.new ()
	self.box:setDeck ( utils.MOAIGfxQuad2D_new (images.box,400,80) )
	self.box:setColor ( 0,0,0,0.5)
	layer:insertProp ( self.box )

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,64"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -200, -32, 200, 32 )
    self.textbox1:setString ( "LEVEL FINISHED" )
    self.textbox1:setLoc ( 0, 0)
    layer:insertProp ( self.textbox1 )

end

----------------------------------------------------------------
state.onLoseFocus = function ( self )
end

----------------------------------------------------------------
state.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer:clear ()
			layer = nil
		end
	end

	self.layerTable = nil
end

----------------------------------------------------------------
state.onUpdate = function ( self )

   	if self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

        if GAMEOBJECT:initLevel(GAMEOBJECT.level.number+1) then
		    local _storage=storagemgr.get("save",false)
		    if _storage.data==nil or _storage.data.levelnumber==nil or _storage.data.levelnumber<GAMEOBJECT.level.number then
		    	storagemgr.put("save",{levelnumber=GAMEOBJECT.level.number})
		    end
		  	statemgr.swap ( "enterlevel")
		else
	        GAMEOBJECT:unload()
			statemgr.pop ( ) -- to game
			statemgr.pop ( ) -- to menu
		end
	end
end

return state