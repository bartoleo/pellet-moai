--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local mainMenu = {}
mainMenu.layerTable = nil
local mainLayer = nil

----------------------------------------------------------------
mainMenu.onInput = function ( self )
end

----------------------------------------------------------------
mainMenu.onLoad = function ( self, prevstatename )

	self.layerTable = {}
	local layer = MOAILayer2D.new ()
	layer:setViewport ( viewport )
	mainMenu.layerTable [ 1 ] = { layer }

	local textbox = {}
	textbox[1] = MOAITextBox.new ()
	textbox[1]:setFont ( fonts["resource,64"] )
	textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
	textbox[1]:setYFlip ( true )
	textbox[1]:setRect ( -150, -40, 150, 40 )
	textbox[1]:setString ( "pellet-moai" )
	textbox[1]:setLoc(0,300)
	layer:insertProp ( textbox[1] )

	mainLayer = layer

	if self.simplegui==nil then
	  self.simplegui = _G.simplegui:new(self.simplegui_event)
	end
	self.simplegui:clear()
	self.simplegui.divisor=7
	self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width/2,-300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},layer)
	self.simplegui:addelement("game","button",{text="New Game"})
	self.simplegui:addelement("continue","button",{text="Continue",enabled=false})
	self.simplegui:addelement("sep1","separator",{height=10})
	self.simplegui:addelement("options","button",{text="Options"})
	self.simplegui:addelement("guide","button",{text="How to play"})
	self.simplegui:addelement("sep2","separator",{height=10})
	self.simplegui:addelement("quit","button",{text="Quit"})
	self.simplegui:draw()


	statemgr.registerInputCallbacks()

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
    self.simplegui:update()
end

----------------------------------------------------------------
mainMenu.onKey = function (self,source, up,key)
  if up and key==27 then
    os.exit()
  end
  if up then
  	self.simplegui:keypressed(key)
  end
end

----------------------------------------------------------------
mainMenu.simplegui_event = function(pname,pevent) 
  if pevent=="click" then
    if pname=="game" then
      statemgr.push ( "game" )
    elseif pname=="continue" then
      --todo:continue
    elseif pname=="options" then
      --todo:options
    elseif pname=="guide" then
      --todo:guide
    elseif pname=="quit" then
	    os.exit()
	end
  end
end

return mainMenu