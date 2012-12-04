-- enterlevel state

local state = {}
state.layerTable = nil
state.frames = 0

----------------------------------------------------------------
state.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )

	self.waitSeconds = 2
	if GAMEOBJECT.level.enterLevelWait then
		self.waitSeconds = GAMEOBJECT.level.enterLevelWait
	end
	self.startTime = MOAISim.getDeviceTime ()
	self.interrupted=false

end

----------------------------------------------------------------
state.onInput = function ( self )

end

----------------------------------------------------------------
state.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	self.layerTable [ 1 ] = { layer }

    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,32"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -300, -20, 300, 20 )
    self.textbox1:setString ( GAMEOBJECT.level.name )
    self.textbox1:setLoc ( 0, utils.screen_middleheight-40)
    layer:insertProp ( self.textbox1 )

    if GAMEOBJECT.level.enterlevelLoad then
        GAMEOBJECT.level:enterlevelLoad(layer)
    end

    self.frames = 0

    statemgr.registerInputCallbacks()

end

----------------------------------------------------------------
state.onLoseFocus = function ( self )
end

----------------------------------------------------------------
state.onUnload = function ( self )

    if GAMEOBJECT.level.enterlevelUnload then
        GAMEOBJECT.level:enterlevelUnload()
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
state.onUpdate = function ( self )

    if GAMEOBJECT.level.enterlevelUpdate then
        GAMEOBJECT.level:enterlevelUpdate()
    end

   	if self.interrupted or self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then

		statemgr.pop ( statemgr.fadein_fadeout_black )
	end
end

----------------------------------------------------------------
state.onKey = function (self,source, up,key)
  if up and MOAISim.getDeviceTime () - self.startTime > 0.2 then
    self.interrupted=true
  end
end

----------------------------------------------------------------
state.onTouch= function (self,source,up,idx,x,y,tapcount)
  if up and MOAISim.getDeviceTime () - self.startTime > 0.2 then
    self.interrupted=true
  end
end

return state