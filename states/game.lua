--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local game = {}
game.updates = 0
game.layerTable = nil

----------------------------------------------------------------
game.onFocus = function ( self, prevstatename )
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
game.onLoad = function ( self, prevstatename )

  self.layerTable = {}
  local layer = MOAILayer2D.new ()
  layer:setViewport ( viewport )
  game.layerTable [ 1 ] = { layer }

  game.updates = 0

  self.textbox1 = MOAITextBox.new ()
  self.textbox1:setFont ( fonts["arialbd,12"] )
  self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  self.textbox1:setYFlip ( true )
  self.textbox1:setRect ( -150, -20, 150, 20 )
  self.textbox1:setString ( "a" )
  self.textbox1:setLoc ( 0, utils.screen_middleheight-40)
  layer:insertProp ( self.textbox1 )

  self.textbox2 = MOAITextBox.new ()
  self.textbox2:setFont ( fonts["arialbd,12"] )
  self.textbox2:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
  self.textbox2:setYFlip ( true )
  self.textbox2:setRect ( -150, -20, 150, 20 )
  self.textbox2:setString ( "Time to next click - " )
  self.textbox2:setLoc ( 0, utils.screen_middleheight-80)
  layer:insertProp ( self.textbox2 )

  GAMEOBJECT = classes.gameobject:new(layer)
  GAMEOBJECT:initLevel(1)

  statemgr.registerInputCallbacks()

  statemgr.push("enterlevel")

end

----------------------------------------------------------------
game.onUnload = function ( self )

  for i, layerSet in ipairs ( self.layerTable ) do
    for j, layer in ipairs ( layerSet ) do
      layer = nil
    end
  end

  self.layerTable = nil

end

----------------------------------------------------------------
game.onUpdate = function ( self )
  self.updates = self.updates + 1
  self.textbox1:setString ( "coins "..GAMEOBJECT.coins)
  self.textbox2:setString(""..MOAISim.getPerformance() )
  local _return = GAMEOBJECT:update()
  if _return then
    if _return == "LOSE" then
      GAMEOBJECT.lifes = GAMEOBJECT.lifes  -1
      statemgr.push("lostlife")
    elseif _return == "WIN" then
      statemgr.push("winlevel")
    end
  end
end

----------------------------------------------------------------
game.onKey = function (self,source, up,key)
  if up and key==112 then
    statemgr.push("pause")
  end
  if up and key==27 then
    GAMEOBJECT:unload()
    statemgr.pop()
  end
end

return game
