--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local mainMenu = {}
mainMenu.layerTable = nil
local mainLayer = nil

local playButton

----------------------------------------------------------------
mainMenu.StartGame = function ( isNewGame )

	statemgr.push ( "game" )

end

----------------------------------------------------------------
mainMenu.onFocus = function ( self, prevstatename )

	MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )
end

----------------------------------------------------------------
mainMenu.onInput = function ( self )
	if inputmgr:up () then

		local x, y = mainLayer:wndToWorld ( inputmgr:getTouch ())

		playButton:updateClick ( false, x, y )

	elseif inputmgr:down () then

		local x, y = mainLayer:wndToWorld ( inputmgr:getTouch ())

		playButton:updateClick ( true, x, y )
	end

end

----------------------------------------------------------------
mainMenu.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	mainMenu.layerTable [ 1 ] = { layer }

	local textbox = {}
	textbox[1] = MOAITextBox.new ()
	textbox[1]:setFont ( fonts["FontVerdana18,16"] )
	textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
	textbox[1]:setYFlip ( true )
	textbox[1]:setRect ( -150, -20, 150, 20 )
	textbox[1]:setString ( "pellet-moai" )
	textbox[1]:setLoc(0,100)
	textbox[1]:setTextSize (16 )
	textbox[1]:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.DECK2D_SHADER ))
	layer:insertProp ( textbox[1] )

	playButton = elements.makeTextButton ( fonts["arialbd,16"], images.button, 206, 150, 60 )

	playButton:setCallback ( function ( self )

		mainMenu.StartGame( playButton.newGame )

	end )

	if savefiles.get ( "user" ).fileexist then
		playButton:setString ( "Continue" )
		playButton.newGame = false
	else
		playButton:setString ( "New Game" )
		playButton.newGame = true
	end

	layer:insertProp ( playButton.img )
	layer:insertProp ( playButton.txt )

	mainLayer = layer

	statemgr.registerInputCallbacks()

end

function mainMenu.onTouch(self,source,up,idx,x,y,tapcount)
	local _x, _y = mainLayer:wndToWorld ( x,y)
	if up then
		print("clicked!!!",source,up,idx,_x,_y)
		--print (prop:getWorldScl())
		--print (prop:getWorldLoc ())
		--print (prop:getWorldRot  ())
		--print (prop:getWorldDir   ())
		--soundmgr.playSound(sounds.mono16,1)
		--soundmgr.playMusic(musics.l1Music1,1)
	else
		print("2clicked!!!",_x,_y)
	end
end

----------------------------------------------------------------
mainMenu.onUnload = function ( self )

	for i, layerSet in ipairs ( self.layerTable ) do

		for j, layer in ipairs ( layerSet ) do

			layer = nil
		end
	end

	self.layerTable = nil
	mainLayer = nil
end

----------------------------------------------------------------
mainMenu.onUpdate = function ( self )

end

----------------------------------------------------------------
mainMenu.onKey = function (self,source, up,key)
  if up and key==27 then
    os.exit()
  end
end

return mainMenu