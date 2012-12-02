local state = {}
state.updates = 0
state.layerTable = nil
state.layerGui = nil
state.commands_queue = {}

----------------------------------------------------------------
state.onFocus = function ( self, prevstatename )
  MOAIGfxDevice.setClearColor ( 0, 0, 0, 1 )
end

----------------------------------------------------------------
state.onInput = function ( self )

  if MOAIInputMgr.device.keyboard and MOAIInputMgr.device.keyboard.keyIsDown then
    if MOAIInputMgr.device.keyboard:keyIsDown(119) or MOAIInputMgr.device.keyboard:keyIsDown(87) then
      GAMEOBJECT.player:input("n")
    elseif MOAIInputMgr.device.keyboard:keyIsDown(115) or MOAIInputMgr.device.keyboard:keyIsDown(83) then
      GAMEOBJECT.player:input("s")
    elseif MOAIInputMgr.device.keyboard:keyIsDown(97) or MOAIInputMgr.device.keyboard:keyIsDown(65) then
      GAMEOBJECT.player:input("w")
    elseif MOAIInputMgr.device.keyboard:keyIsDown(100) or MOAIInputMgr.device.keyboard:keyIsDown(68) then
      GAMEOBJECT.player:input("e")
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
        GAMEOBJECT.player:input(dir)
      elseif self.pause:inside(mousex,mousey) then
        statemgr.push("pause")
      elseif self.exit:inside(mousex,mousey) then
        GAMEOBJECT:unload()
        table.insert(state.commands_queue,"pop")
      end
    end
   end

end

----------------------------------------------------------------
state.onLoad = function ( self, prevstatename )

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
    self.joystick:setDeck ( utils.MOAIGfxQuad2D_new (images.joypad) )
    self.joystick:setLoc (-utils.screen_middlewidth+80,-utils.screen_middleheight+80)
    layerGui:insertProp ( self.joystick )
    -- touch/mouse pause
    self.pausebutton = MOAIProp2D.new ()
    self.pausebutton:setDeck ( utils.MOAIGfxQuad2D_new (images.button) )
    self.pausebutton:setLoc(utils.screen_middlewidth-80,-utils.screen_middleheight+85)
    layerGui:insertProp ( self.pausebutton )
    self.pause = MOAITextBox.new ()
    self.pause:setFont ( fonts["resource,16"] )
    self.pause:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.pause:setYFlip ( true )
    self.pause:setRect ( -150, -40, 150, 40 )
    self.pause:setString ( "| |\npause" )
    self.pause:setLoc(utils.screen_middlewidth-80,-utils.screen_middleheight+60)
    layerGui:insertProp ( self.pause )
    -- touch/mouse exit
    self.exitbutton = MOAIProp2D.new ()
    self.exitbutton:setDeck ( utils.MOAIGfxQuad2D_new (images.button) )
    self.exitbutton:setLoc(utils.screen_middlewidth-80,utils.screen_middleheight-80)
    layerGui:insertProp ( self.exitbutton )    self.exit = MOAITextBox.new ()
    self.exit:setFont ( fonts["resource,16"] )
    self.exit:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.exit:setYFlip ( true )
    self.exit:setRect ( -150, -40, 150, 40 )
    self.exit:setString ( "X\nexit" )
    self.exit:setLoc(utils.screen_middlewidth-80,utils.screen_middleheight-105)
    layerGui:insertProp ( self.exit )
  end

  statemgr.registerInputCallbacks()

  statemgr.push("enterlevel")

  soundmgr.playMusic(musics.TheHaunting)

end

----------------------------------------------------------------
state.onUnload = function ( self )

  GAMEOBJECT:unload()

  soundmgr.stop(musics.TheHaunting)

  for i, layerSet in ipairs ( self.layerTable ) do
    for j, layer in ipairs ( layerSet ) do
      layer = nil
    end
  end

  self.layerTable = nil

end

----------------------------------------------------------------
state.onUpdate = function ( self )
  self.updates = self.updates + 1
  local _return = false
  if self.commands_queue then
    for i=#state.commands_queue,1,-1 do
      local cmd = state.commands_queue[i]
      if cmd=="pop" then
        statemgr.pop(statemgr.fadein_fadeout_black)
        _return = true
      end
      table.remove(self.commands_queue,i)
    end
  end
  if _return then
    return
  end

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
state.onKey = function (self,source, up,key)
  if up and key==112 then
    statemgr.push("pause")
  end
  if up and key==27 then
    GAMEOBJECT:unload()
    table.insert(state.commands_queue,"pop")
  end
end

return state