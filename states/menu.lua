-- menu state

local state = {}
state.layerTable = nil
state.menulayer = nil
state.commands_queue = {}
state.menu = ""

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

  statemgr.registerInputCallbacks()

end

----------------------------------------------------------------
state.onFocus = function ( self, prevstatename )

  self:setGuiMenu()
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
    for i=#self.commands_queue,1,-1 do
      local cmd = self.commands_queue[i]
      if cmd=="game" then
        statemgr.push ( "game",statemgr.fadein_fadeout_black,1)
        _return = true
      end
      if cmd=="continuestart" then
        local _levelnum = tonumber(self.simplegui:getElementByName("level").value)
        statemgr.push ( "game",statemgr.fadein_fadeout_black,_levelnum)
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
state.onKey = function (self, source, up,key)
  if up and key==27 then
    if self.menu == "menu" then
      os.exit()
    else
      self:setGuiMenu()
    end
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
    soundmgr.playSound(sounds.plin,0.5)
    if pname=="game" then
      table.insert(state.commands_queue,"game")
    elseif pname=="continue" then
      state:setGuiContinue()
    elseif pname=="continuestart" then
      table.insert(state.commands_queue,"continuestart")
    elseif pname=="options" then
      state:setGuiOptions()
    elseif pname=="back_to_menu" then
      if state.menu=="options" then
        state:applyOptions()
      end
      state:setGuiMenu()
    elseif pname=="quit" then
      os.exit()
    end
  elseif pevent=="change" then
    if pname=="volume" then
      local _volume = tonumber(state.simplegui:getElementByName("volume").value)/100
      soundmgr.setGlobalVolume(_volume)
    end
  end
end

state.setGuiMenu = function(self)
  self.menu = "menu"
  self.simplegui:clear()
  self.simplegui.divisor=12
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width,300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent(),"center")
  self.simplegui:addelement("game","button",{text="New Game",width=200})
  local _enabledcontinue=false
  self:checkLevelContinue()
  if self.levelcontinue>1 then
    _enabledcontinue=true
  end
  self.simplegui:addelement("continue","button",{text="Continue",enabled=_enabledcontinue,width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("options","button",{text="Options",width=200})
  self.simplegui:addelement("sep2","separator",{height=10,width=200})
  self.simplegui:addelement("quit","button",{text="Quit",width=200})
  self.simplegui:draw()
end

state.setGuiOptions = function(self)
  self.menu = "options"
  self.simplegui:clear()
  self.simplegui.divisor=12
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width,300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent(),"center")
  self.simplegui:addelement("options","label",{text="[Options]",font=fonts["resource,48"],fontheight=30,width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("volume","hcombo",{width=200,text="Volume:",value=soundmgr.globalvolume*100,values={0,"0%",10,"10%",20,"20%",30,"30%",40,"40%",50,"50%",60,"60%",70,"70%",80,"80%",90,"90%",100,"100%"}})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("back_to_menu","button",{text="Back",width=200})
  self.simplegui:draw()
end

state.setGuiContinue = function(self)
  self.menu = "continue"
  self.simplegui:clear()
  self.simplegui.divisor=12
  self.simplegui:setlayout("down",-utils.screen_width/2,100,utils.screen_width,300,fonts["resource,32"],20,{r=1,g=1,b=1,a=1},{r=1,g=1,b=0,a=1},self.menulayer,inputmgr.keyboardPresent(),"center")
  self.simplegui:addelement("continue","label",{text="[Continue]",font=fonts["resource,48"],fontheight=30,width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  local _values={}
  for i=1,self.levelcontinue do
    table.insert(_values,i)
    table.insert(_values,i)
  end
  self.simplegui:addelement("level","hcombo",{width=200,text="Level:",value=self.levelcontinue,values=_values})
  self.simplegui:addelement("continuestart","button",{text="Continue from Level",enabled=_enabledcontinue,width=200})
  self.simplegui:addelement("sep1","separator",{height=10,width=200})
  self.simplegui:addelement("back_to_menu","button",{text="Back",width=200})
  self.simplegui:draw()
end

state.checkLevelContinue = function(self)
  self.levelcontinue=1
  local _storage=storagemgr.get("_save",false)
  if _storage.data then
    if _storage.data.levelnumber and _storage.data.levelnumber>1 then
      self.levelcontinue=_storage.data.levelnumber
    end
  end
end

state.applyOptions = function(self)
  local _volume = tonumber(self.simplegui:getElementByName("volume").value)/100
  storagemgr.put("_settings",{globalvolume=_volume})
  soundmgr.setGlobalVolume(_volume)
end

return state