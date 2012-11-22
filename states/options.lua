--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local options = {}
options.layerTable = nil

----------------------------------------------------------------
options.onInput = function ( self )
end

----------------------------------------------------------------
options.onLoad = function ( self, prevstatename )

  self.layerTable = {}
  local layer = MOAILayer2D.new ()
  layer:setViewport ( viewport )
  options.layerTable [ 1 ] = { layer }
  
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
  textbox[2] = MOAITextBox.new ()
  textbox[2]:setFont ( fonts["resource,32"] )
  textbox[2]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[2]:setYFlip ( true )
  textbox[2]:setRect ( -150, -40, 150, 40 )
  textbox[2]:setString ( "Options" )
  textbox[2]:setLoc(0,200)
  layer:insertProp ( textbox[2] )

  if self.simplegui==nil then
    self.simplegui = _G.simplegui:new(self.simplegui_event)
  end
  self.simplegui:clear()
  self.simplegui.divisor=7
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width/2,-300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},layer,inputmgr.keyboardPresent())
  self.simplegui:addelement("notdoneyet","label",{label="Not done yet"})
  self.simplegui:addelement("sep1","separator",{height=10})
  self.simplegui:addelement("back","button",{text="Back"})
  self.simplegui:draw()


  statemgr.registerInputCallbacks()

end

----------------------------------------------------------------
options.onUnload = function ( self )

  for i, layerSet in ipairs ( self.layerTable ) do

    for j, layer in ipairs ( layerSet ) do

      layer = nil
    end
  end

  self.layerTable = nil

end

----------------------------------------------------------------
options.onUpdate = function ( self )
    self.simplegui:update()
end

----------------------------------------------------------------
options.onKey = function (self,source, up,key)
  if up and key==27 then
    statemgr.pop()
  end
  if up then
    self.simplegui:keypressed(key)
  end
end

----------------------------------------------------------------
options.simplegui_event = function(pname,pevent) 
  if pevent=="click" then
    if pname=="back" then
      statemgr.pop()
    end
  end
end

return options