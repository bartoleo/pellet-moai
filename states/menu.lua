local state = {}
state.layerTable = nil
state.menulayer = nil
state.commands_queue = {}

----------------------------------------------------------------
state.onInput = function ( self )
end

----------------------------------------------------------------
state.onLoad = function ( self, prevstatename )

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
  textbox[1]:setString ( "Pellet Stealth" )
  textbox[1]:setLoc(0,300)
  layer:insertProp ( textbox[1] )

  if self.simplegui==nil then
    self.simplegui = _G.simplegui:new(self.simplegui_event)
  end
  self:setGuiMenu()

  statemgr.registerInputCallbacks()

  self.simplegui:update()

end

----------------------------------------------------------------
state.onUnload = function ( self )

  if self.simplegui then
    self.simplegui:clear()
  end

  for i, layerSet in ipairs ( self.layerTable ) do

    for j, layer in ipairs ( layerSet ) do

      layer = nil
    end
  end

  self.layerTable = nil

end

----------------------------------------------------------------
state.onUpdate = function ( self )

  local _return = false
  if self.commands_queue then
    for i=#state.commands_queue,1,-1 do
      local cmd = state.commands_queue[i]
      if cmd=="game" then
        statemgr.push ( "game",statemgr.fadein_fadeout_black )
        _return = true
      end
      table.remove(self.commands_queue,i)
    end
  end
  if _return then
    return
  end

  self.simplegui:update()

end

----------------------------------------------------------------
state.onKey = function (self,source, up,key)
  if up and key==27 then
    os.exit()
  end
  if up then
    self.simplegui:keypressed(key)
  end
end

----------------------------------------------------------------
state.simplegui_event = function(pname,pevent) 
  if pevent=="focus" then
    soundmgr.playSound(sounds.klick,0.5)
  elseif pevent=="hover" then
    if state.lasthover~=pname then
      soundmgr.playSound(sounds.klick,0.5)
    end
    state.lasthover=pname
  elseif pevent=="click" then
    soundmgr.playSound(sounds.blip,0.5)
    if pname=="game" then
      table.insert(state.commands_queue,"game")
    elseif pname=="continue" then
      --todo:continue
    elseif pname=="options" then
      state:setGuiOptions()
    elseif pname=="back_to_menu" then
      state:setGuiMenu()
    elseif pname=="quit" then
      os.exit()
    end
  end
end

state.setGuiMenu = function(self)
  self.simplegui:clear()
  self.simplegui.divisor=7
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width,300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent(),"center")
  self.simplegui:addelement("game","button",{text="New Game",width=200})
  self.simplegui:addelement("continue","button",{text="Continue",enabled=false,width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("options","button",{text="Options",width=200})
  self.simplegui:addelement("sep2","separator",{height=10,width=200})
  self.simplegui:addelement("quit","button",{text="Quit",width=200})
  self.simplegui:draw()
end

state.setGuiOptions = function(self)
  self.simplegui:clear()
  self.simplegui.divisor=7
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width,300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent(),"center")
  self.simplegui:addelement("options","label",{text="[Options]",font=fonts["resource,48"],fontheight=30,width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("notdoneyet","label",{text="Not done yet",width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("back_to_menu","button",{text="Back",width=200})
  self.simplegui:draw()
end


return state