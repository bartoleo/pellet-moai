--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local menu = {}
menu.layerTable = nil
menu.menulayer = nil

----------------------------------------------------------------
menu.onInput = function ( self )
end

----------------------------------------------------------------
menu.onLoad = function ( self, prevstatename )

  self.layerTable = {}
  local layer = MOAILayer2D.new ()
  layer:setViewport ( viewport )
  self.layerTable [ 1 ] = { layer }
  self.menulayer = layer

  local textbox = {}
  textbox[1] = MOAITextBox.new ()
  textbox[1]:setFont ( fonts["resource,64"] )
  textbox[1]:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textbox[1]:setYFlip ( true )
  textbox[1]:setRect ( -150, -40, 150, 40 )
  textbox[1]:setString ( "pellet-moai" )
  textbox[1]:setLoc(0,300)
  layer:insertProp ( textbox[1] )

  if self.simplegui==nil then
    self.simplegui = _G.simplegui:new(self.simplegui_event)
  end
  self:setGuiMenu()

  statemgr.registerInputCallbacks()

end

----------------------------------------------------------------
menu.onUnload = function ( self )

  for i, layerSet in ipairs ( self.layerTable ) do

    for j, layer in ipairs ( layerSet ) do

      layer = nil
    end
  end

  self.layerTable = nil

end

----------------------------------------------------------------
menu.onUpdate = function ( self )
    self.simplegui:update()
end

----------------------------------------------------------------
menu.onKey = function (self,source, up,key)
  if up and key==27 then
    os.exit()
  end
  if up then
    self.simplegui:keypressed(key)
  end
end

----------------------------------------------------------------
menu.simplegui_event = function(pname,pevent) 
  if pevent=="click" then
    if pname=="game" then
      statemgr.push ( "game" )
    elseif pname=="continue" then
      --todo:continue
    elseif pname=="options" then
      menu:setGuiOptions()
    elseif pname=="back_to_menu" then
      menu:setGuiMenu()
    elseif pname=="quit" then
      os.exit()
    end
  end
end

menu.setGuiMenu = function(self)
  self.simplegui:clear()
  self.simplegui.divisor=7
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width/2,-300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent())
  self.simplegui:addelement("game","button",{text="New Game"})
  self.simplegui:addelement("continue","button",{text="Continue",enabled=false})
  self.simplegui:addelement("sep1","separator",{height=10})
  self.simplegui:addelement("options","button",{text="Options"})
  self.simplegui:addelement("sep2","separator",{height=10})
  self.simplegui:addelement("quit","button",{text="Quit"})
  self.simplegui:draw()
end

menu.setGuiOptions = function(self)
  self.simplegui:clear()
  self.simplegui.divisor=7
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width/2,-300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent())
  self.simplegui:addelement("options","label",{label="Options",font=fonts["resource,48"],fontheight=30})
  self.simplegui:addelement("sep1","separator",{height=10})
  self.simplegui:addelement("notdoneyet","label",{label="Not done yet"})
  self.simplegui:addelement("sep1","separator",{height=10})
  self.simplegui:addelement("back_to_menu","button",{text="Back"})
  self.simplegui:draw()
end


return menu