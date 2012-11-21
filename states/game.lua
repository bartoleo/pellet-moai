--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local game = {}
game.updates = 0
game.layerTable = nil
local mainLayer = nil


----------------------------------------------------------------
game.onFocus = function ( self )
  print("game.onFocus")
  MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )
end

----------------------------------------------------------------
game.onInput = function ( self )

  if MOAIInputMgr.device.keyboard and MOAIInputMgr.device.keyboard.keyIsDown then
    if MOAIInputMgr.device.keyboard:keyIsDown(119) then
      GAMEOBJECT.player:go("n")
    elseif MOAIInputMgr.device.keyboard:keyIsDown(115) then
      GAMEOBJECT.player:go("s")
    elseif MOAIInputMgr.device.keyboard:keyIsDown(97) then
      GAMEOBJECT.player:go("w")
    elseif MOAIInputMgr.device.keyboard:keyIsDown(100) then
      GAMEOBJECT.player:go("e")
    end
  end
end

----------------------------------------------------------------
game.onLoad = function ( self )

  self.layerTable = {}
  local layer = MOAILayer2D.new ()
  layer:setViewport ( viewport )
  game.layerTable [ 1 ] = { layer }
  mainLayer = layer

  game.updates = 0

  local font =  MOAIFont.new ()
  font:loadFromTTF ( "fonts/arialbd.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?! ", 12, 163 )

  textboxClicks = MOAITextBox.new ()
  textboxClicks:setFont ( font )
  textboxClicks:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textboxClicks:setYFlip ( true )
  textboxClicks:setRect ( -150, -20, 150, 20 )
  textboxClicks:setString ( "a" )
  textboxClicks:setLoc ( 0, utils.screen_middleheight-40)
  layer:insertProp ( textboxClicks )

  textboxClock = MOAITextBox.new ()
  textboxClock:setFont ( font )
  textboxClock:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  textboxClock:setYFlip ( true )
  textboxClock:setRect ( -150, -20, 150, 20 )
  textboxClock:setString ( "Time to next click - " )
  textboxClock:setLoc ( 0, utils.screen_middleheight-80)
  layer:insertProp ( textboxClock )

  GAMEOBJECT = classes.gameobject:new(layer)
  GAMEOBJECT:initLevel(1)

  statemgr.registerInputCallbacks()

end

----------------------------------------------------------------
game.onUnload = function ( self )

  for i, layerSet in ipairs ( self.layerTable ) do
    for j, layer in ipairs ( layerSet ) do
      layer = nil
    end
  end

  self.layerTable = nil
  mainLayer = nil
end

----------------------------------------------------------------
game.onUpdate = function ( self )
  self.updates = self.updates + 1
  textboxClicks:setString ( "updates:"..self.updates)
  textboxClock:setString(""..MOAISim.getPerformance() )
  local _return = GAMEOBJECT:update()
  if _return then
    if _return == "LOSE" then
      print("LOST LIFE!!!!")
    end
  end
end

----------------------------------------------------------------
game.onKey = function (self,source, up,key)
  if up and key==27 then
    statemgr.pop()
  end
end

return game
