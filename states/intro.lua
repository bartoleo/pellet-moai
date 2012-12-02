-- intro state

local state = {}
state.layerTable = nil
state.frames = 0

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

  local textbox = {}
  textbox[1] = MOAITextBox.new ()
  textbox[1]:setFont ( fonts["resource,64"] )
  textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[1]:setYFlip ( true )
  textbox[1]:setRect ( -150, -40, 150, 40 )
  textbox[1]:setString ( "Pellet Stealth" )
  textbox[1]:setLoc(0,300)
  layer:insertProp ( textbox[1] )

  textbox[2] = MOAITextBox.new ()
  textbox[2]:setFont ( fonts["resource,32"] )
  textbox[2]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[2]:setYFlip ( true )
  textbox[2]:setRect ( -150, -40, 150, 40 )
  textbox[2]:setString ( "made with" )
  textbox[2]:setLoc(0,200)
  layer:insertProp ( textbox[2] )

  textbox[3] = MOAITextBox.new ()
  textbox[3]:setFont ( fonts["resource,32"] )
  textbox[3]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[3]:setYFlip ( true )
  textbox[3]:setRect ( -200, -100, 200, 100 )
  textbox[3]:setString ( "game made by Leo Bartoloni\n\npixel art by Free Pixel Project\nhttp://www.squidi.net/pixel/index.php")
  textbox[3]:setLoc(0,-300)
  layer:insertProp ( textbox[3] )

  local moaiLogo = MOAIProp2D.new ()
  moaiLogo:setDeck ( utils.MOAIGfxQuad2D_new (images.moai) )
  layer:insertProp ( moaiLogo )

  state.frames = 0

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

  state.frames = state.frames + 1

  if state.frames == 2 then
    assetloader.load()
  end

  if state.frames >=2 and self.waitSeconds < ( MOAISim.getDeviceTime () - self.startTime ) then
    statemgr.swap ( "menu",statemgr.fadein_fadeout_black )
  end
end

return state