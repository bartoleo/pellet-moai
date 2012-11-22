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

  local textbox = {}
  textbox[1] = MOAITextBox.new ()
  textbox[1]:setFont ( fonts["resource,64"] )
  textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[1]:setYFlip ( true )
  textbox[1]:setRect ( -150, -40, 150, 40 )
  textbox[1]:setString ( "pellet-moai" )
  textbox[1]:setLoc(0,300)
  layer:insertProp ( textbox[1] )

  local textbox = {}
  textbox[1] = MOAITextBox.new ()
  textbox[1]:setFont ( fonts["resource,32"] )
  textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[1]:setYFlip ( true )
  textbox[1]:setRect ( -150, -40, 150, 40 )
  textbox[1]:setString ( "made with" )
  textbox[1]:setLoc(0,200)
  layer:insertProp ( textbox[1] )

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