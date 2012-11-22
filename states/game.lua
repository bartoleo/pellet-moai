--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

local game = {}
game.updates = 0
game.layerTable = nil
game.layerGui = nil

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
  if self.joystick then
    local mousex, mousey = self.layerGui:wndToWorld ( inputmgr:getTouch ())
    if inputmgr:isDown() then
      if self.joystick:inside(mousex,mousey) then
        local cx, cy = self.joystick:getLoc()
        local radian = math.atan2(math.abs(mousex - cx), math.abs(mousey - cy))
        local dir
        if mousex == cx and mousey == cy then
          dir = M.STICK_CENTER
        elseif math.cos(radian) < math.sin(radian) then
          dir = mousex < cx and "w" or "e"
        else
          dir = mousey < cy and "s" or "n"
        end
        GAMEOBJECT.player:go(dir)
      elseif self.pause:inside(mousex,mousey) then
        statemgr.push("pause")
      elseif self.exit:inside(mousex,mousey) then
        GAMEOBJECT:unload()
        statemgr.pop()
      end
    end
  end

end

----------------------------------------------------------------
game.onLoad = function ( self, prevstatename )

  self.layerTable = {}
  local layer = MOAILayer2D.new ()
  layer:setViewport ( viewport )
  local layerGui = MOAILayer2D.new ()
  layerGui:setViewport ( viewport )
  self.layerTable [ 1 ] = { layer, layerGui }

  self.layerGui = layerGui

  self.updates = 0

  GAMEOBJECT = classes.gameobject:new(layer,layerGui)
  GAMEOBJECT:initLevel(1)

  if MOAIInputMgr.device.keyboard and MOAIInputMgr.device.keyboard.keyIsDown and false then
    -- keyboard events
  else
    -- touch/mouse joypad
    self.joystick = MOAIProp2D.new ()
    self.joystick:setDeck ( utils.MOAIGfxQuad2D_new (images.joystick) )
    self.joystick:setLoc (-utils.screen_middlewidth+80,-utils.screen_middleheight+80)
    layerGui:insertProp ( self.joystick )
    -- touch/mouse pause
    self.pause = MOAITextBox.new ()
    self.pause:setFont ( fonts["resource,32"] )
    self.pause:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.pause:setYFlip ( true )
    self.pause:setRect ( -150, -40, 150, 40 )
    self.pause:setString ( "II\npause" )
    self.pause:setLoc(utils.screen_middlewidth-80,-utils.screen_middleheight+80)
    layerGui:insertProp ( self.pause )
    -- touch/mouse exit
    self.exit = MOAITextBox.new ()
    self.exit:setFont ( fonts["resource,32"] )
    self.exit:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.exit:setYFlip ( true )
    self.exit:setRect ( -150, -40, 150, 40 )
    self.exit:setString ( "X\nexit" )
    self.exit:setLoc(utils.screen_middlewidth-80,utils.screen_middleheight-80)
    layerGui:insertProp ( self.exit )
  end

  statemgr.registerInputCallbacks()

  statemgr.push("enterlevel")

  soundmgr.playMusic(musics.TheHaunting)

end

----------------------------------------------------------------
game.onUnload = function ( self )

  for i, layerSet in ipairs ( self.layerTable ) do
    for j, layer in ipairs ( layerSet ) do
      layer = nil
    end
  end

  self.layerTable = nil

  soundmgr.stop(musics.TheHaunting)

end

----------------------------------------------------------------
game.onUpdate = function ( self )
  self.updates = self.updates + 1
  local _return = GAMEOBJECT:update()
  if _return then
    if _return == "LOSE" then
      GAMEOBJECT.lifes = GAMEOBJECT.lifes  -1
      soundmgr.playSound(sounds.lostlife)
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