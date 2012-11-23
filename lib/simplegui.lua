--- simplegui

simplegui = {}

function simplegui:new(...)
   local _o = {}
   _o.elements={}
   _o.element_focus=nil
   _o.counter=0
   _o.layout=nil
   _o.callback=nil
   _o.oldmouselb=false
   _o.divisor=5
   setmetatable(_o, self)
   self.__index = self
   _o:init(...)
   return _o
end

function simplegui:init(pcallback)
  self:clear()
  self.callback=pcallback
end

function simplegui:setlayout(ptype,px,py,pwidth,pheight,pfont,pfontheight,pcolor,phcolor,player,pkeyboard)
  self.layout={type=ptype,x=px,y=py,width=pwidth,height=pheight,dx=0,dy=0}
  if pfont then
    self.layout.font = pfont
  end
  if pcolor then
    self.layout.color = pcolor
  end
  if phcolor then
    self.layout.hcolor = phcolor
  end
  if pfontheight then
    self.fontheight=pfontheight
  end
  self.layer=player
  self.keyboard=pkeyboard
end

function simplegui:addelement(pname,ptype,pargs)

  local function nvl(object,return_ifnil)
    if (object==nil) then
      return return_ifnil
    end
    return object
  end
  local function truefalse(object,return_true,return_false)
    if (object==true) then
      return return_true
    end
    return return_false
  end

  local _name = pname
  if _name==nil then
    self.counter=self.counter+1
    _name="tmp"..self.counter
  end
  local _element = {name=_name,type=ptype}
  if pargs then
    for i,v in pairs(pargs) do
      _element[i]=v
    end
  end

  _element.color=nvl(_element.color,self.layout.color)
  _element.hcolor=nvl(_element.hcolor,self.layout.hcolor)
  _element.font=nvl(_element.font,self.layout.font)
  _element.enabled=nvl(_element.enabled,true)
  _element.visible=nvl(_element.visible,true)
  if _element.fontheight == nil then
    _element.fontheight=self.fontheight
  end
  _element.mousehover=false

  if _element.type=="separator" then
    _element.width=nvl(_element.width,12)
    _element.height=nvl(_element.height,_element.fontheight)
  elseif _element.type=="label" then
    _element.label=nvl(_element.label,"")
    _element.width=nvl(_element.width,12)
    _element.height=nvl(_element.height,_element.fontheight)
  elseif _element.type=="button" then
    _element.text=nvl(_element.text,"")
    --_element.width=nvl(_element.width,_element.font:getWidth( _element.text ))
    _element.height=nvl(_element.height,_element.fontheight)
  elseif _element.type=="checkbox" then
    _element.label=nvl(_element.label,"")
    _element.valuechecked=nvl(_element.valuechecked,true)
    _element.valueunchecked=nvl(_element.valueunchecked,false)
    _element.value=nvl(_element.value,false)
    --_element.width=nvl(_element.width,_element.font:getWidth( _element.label )+self.divisor+_element.fontheight)
    _element.height=nvl(_element.height,_element.fontheight)
  elseif _element.type=="hcombo" then
    _element.label=nvl(_element.label,"")
    _element.prev=false
    _element.next=false
    _element.labelvalue=""
    --_element.labelwidth=nvl(_element.labelwidth,_element.font:getWidth( _element.label ))
    if _element.value==nil and _element.values then
      _element.value=_element.values[1]
    end
    _element.maxvaluewidth = 0
    for i = 1,#_element.values,  2 do
      --if _element.font:getWidth( _element.values[i+1] )>_element.maxvaluewidth then
      --  _element.maxvaluewidth = _element.font:getWidth( _element.values[i+1] )
      --end
    end
    _element.maxvaluewidth = _element.maxvaluewidth + _element.fontheight
    --_element.width=nvl(_element.width,_element.font:getWidth( _element.label )+_element.maxvaluewidth+_element.fontheight*2+self.divisor*2)
    _element.height=nvl(_element.height,_element.fontheight)
  end

  if _element.x==nil then
    _element.x=self.layout.x+self.layout.dx
    if self.layout.type=="right" then
      self.layout.dx=self.layout.dx+_element.width+self.divisor
    end
  end

  if _element.y==nil then
    _element.y=self.layout.y+self.layout.dy
    if self.layout.type=="down" then
      self.layout.dy=self.layout.dy-_element.height-self.divisor
    end
  end

  if _element.type=="hcombo" then
    --_element.prevx = _element.x+_element.font:getWidth( _element.label )+self.divisor
    --_element.nextx = _element.x+_element.font:getWidth( _element.label )+self.divisor+_element.fontheight+self.divisor+_element.maxvaluewidth+self.divisor
  end

  table.insert(self.elements,_element)

  if self.element_focus==nil and self:checkiffocus(_element) then
    self.element_focus=_element
  end

end

function simplegui:clear()
  self.divisor=5
  if self.elements and self.layer then
    for i,v in ipairs(self.elements) do
      if v.props then
        for ii,vv in pairs(v.props) do
          self.layer:removeProp(vv)
        end
      end
    end
  end
  self.elements={}
  self.element_focus=nil
  self.layout={type="down",x=0,y=0,width=nil,height=nil,dx=0,dy=0,nil,nil,color={r=1,g=1,b=1,a=1},hcolor={r=1,g=1,b=0,a=1}}
  self.counter=0
end

function simplegui:update()
  local mousex, mousey = self.layer:wndToWorld ( inputmgr:getTouch ())
  local mouselb = inputmgr:up ()
  local mouselbclick = false
  if self.oldmouselb==false and mouselb==true then
    mouselbclick = true
  end
  self.oldmouselb = mouselb
  for i,v in ipairs(self.elements) do
    v.mousehover = false
    if self:checkiffocus(v) then
      local _inside=false
      if v.props then
        for ii,vv in pairs(v.props) do
          if self.keyboard and v==self.element_focus then
            if vv.setColor then
              vv:setColor(self.layout.hcolor.r,self.layout.hcolor.g,self.layout.hcolor.b,self.layout.hcolor.a)
            end
          else
            if vv.setColor then
              vv:setColor(self.layout.color.r,self.layout.color.g,self.layout.color.b,self.layout.color.a)
            end
          end
          _inside = vv:inside(mousex,mousey)
          if _inside then
            break
          end
        end
        if _inside then
          v.mousehover = true
          for ii,vv in pairs(v.props) do
            if vv.setColor then
              vv:setColor(self.layout.hcolor.r,self.layout.hcolor.g,self.layout.hcolor.b,self.layout.hcolor.a)
            end
          end
          if mouselbclick and v.type=="button" and self.callback then
            self.callback(v.name, "click")
          end
          if mouselbclick and v.type=="checkbox" and self.callback then
            self.callback(v.name, "click")
            self:changeCheckbox(v)
          end
          if mouselbclick and v.type=="hcombo" and self.callback then
            self.callback(v.name, "click")
          end
        end
      end
    elseif v.enabled==false then
      for ii,vv in pairs(v.props) do
        if vv.setColor then
          vv:setColor(self.layout.color.r,self.layout.color.g,self.layout.color.b,self.layout.color.a/2)
        end
      end
    end
    if v.type=="hcombo" then
      v.next = false
      v.prev = false
      v.labelvalue=""
      for i = 1,#v.values,  2 do
        if v.values[i]==v.value then
          _found = true
          if i > 1 then
            v.prev=true
          end
          v.labelvalue = v.values[i+1]
          if i+1<#v.values then
            v.next=true
          end
        end
      end
    end
    if v.enabled and v.visible and v.type=="hcombo" then
      -- if v.prev and mousex>=v.prevx and mousex<=v.prevx+v.fontheight and  mousey>=v.y and mousey<=v.y+v.height then
      --   v.mousehover = true
      --   if mouselbclick then
      --     self:changeHCombo(v,false)
      --     if self.callback then
      --       self.callback(self.element_focus.name, "change")
      --     end
      --   end
      -- end
      -- if v.next and mousex>=v.nextx and mousex<=v.nextx+v.fontheight and  mousey>=v.y and mousey<=v.y+v.height then
      --   v.mousehover = true
      --   if mouselbclick then
      --     self:changeHCombo(v,true)
      --     if self.callback then
      --       self.callback(self.element_focus.name, "change")
      --     end
      --   end
      -- end
    end
  end
end

function simplegui:cleardraw()
  for i,v in ipairs(self.elements) do
    if v.props then
      for ii,vv in pairs(v.props) do
        self.layer:removeProp(vv)
      end
      v.props = nil
    end
  end
end

function simplegui:draw()
  self:cleardraw()
  for i,v in ipairs(self.elements) do
    if v.visible then
        if v.type=="separator" then
        elseif v.type=="label" then
          v.props = {}
          v.props.textbox = MOAITextBox.new ()
          v.props.textbox:setFont (v.font)
          v.props.textbox:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
          v.props.textbox:setYFlip ( true )
          v.props.textbox:setRect ( self.layout.x, -v.fontheight, self.layout.width, v.fontheight )
          v.props.textbox:setString ( v.label )
          v.props.textbox:setLoc ( v.x+self.layout.width,v.y+v.height)
          v.props.textbox:setColor(self.layout.color.r,self.layout.color.g,self.layout.color.b,self.layout.color.a)
          self.layer:insertProp ( v.props.textbox )
        elseif v.type=="button" then
          v.props = {}
          v.props.textbox = MOAITextBox.new ()
          v.props.textbox:setFont (v.font)
          v.props.textbox:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
          v.props.textbox:setYFlip ( true )
          v.props.textbox:setRect ( self.layout.x, -v.fontheight, self.layout.width, v.fontheight )
          v.props.textbox:setString ( v.text )
          v.props.textbox:setLoc ( v.x+self.layout.width,v.y+v.height)
          v.props.textbox:setColor(self.layout.color.r,self.layout.color.g,self.layout.color.b,self.layout.color.a)
          self.layer:insertProp ( v.props.textbox )
        elseif v.type=="checkbox" then
        elseif v.type=="hcombo" then
        end
    end
  end
end

function simplegui:keypressed(key, unicode)
  if self.keyboard then
    if key==119 or key==87 then
      self:navigate(false)
    end
    if key==115 or key==83 then
      self:navigate(true)
    end
    if key==97 or key==65 then
      if self.element_focus then
        if self.element_focus.type=="checkbox" then
          self:changeCheckbox(self.element_focus)
          if self.callback then
            self.callback(self.element_focus.name, "change")
          end
        end
      end
      if self.element_focus then
        if self.element_focus.type=="hcombo" then
          self:changeHCombo(self.element_focus,false)
          if self.callback then
            self.callback(self.element_focus.name, "change")
          end
        end
      end
    end
    if key==100 or key==68 then
      if self.element_focus then
        if self.element_focus.type=="checkbox" then
          self:changeCheckbox(self.element_focus)
          if self.callback then
            self.callback(self.element_focus.name, "change")
          end
        end
      end
      if self.element_focus then
        if self.element_focus.type=="hcombo" then
          self:changeHCombo(self.element_focus,true)
          self:changeHCombo(self.element_focus,true)
          if self.callback then
            self.callback(self.element_focus.name, "change")
          end
        end
      end
    end
    if key==13 or key==10 or key==32 then
      if self.element_focus then
        if self.element_focus.type=="button" and self.callback then
          self.callback(self.element_focus.name, "click")
        end
        if self.element_focus.type=="hcombo" and self.callback then
          self.callback(self.element_focus.name, "click")
        end
        if self.element_focus.type=="checkbox" and self.callback then
          self:changeCheckbox(self.element_focus)
          self.callback(self.element_focus.name, "click")
        end
      end
    end
  end
end

function simplegui:checkiffocus(pelement)
 if pelement.enabled and pelement.visible and pelement.type~="label" and pelement.type~="separator" then
   return true
 else
   return false
 end
end

function simplegui:getElementByName(pname)
  for i,v in ipairs(self.elements) do
    if v.name==pname then
      return v
    end
  end
end

function simplegui:changeHCombo(pelement,pright)
  if pright then
    local _firstvalue = false
    if pelement and pelement.type=="hcombo" then
      for i = 1,#pelement.values,  2 do
        if _firstvalue then
          pelement.value = pelement.values[i]
          break
        end
        if pelement.value==pelement.values[i] then
          _firstvalue = true
        end
      end
    end
  else
    local _lastvalue = nil
    if pelement and pelement.type=="hcombo" then
      for i = 1,#pelement.values,  2 do
        if pelement.values[i]==pelement.value then
          if _lastvalue then
            pelement.value = _lastvalue
            break
          end
        end
        _lastvalue=pelement.values[i]
      end
    end
  end
end

function simplegui:navigate(pdown)
  if pdown then
    local _firstelement = false
    for i,v in ipairs(self.elements) do
      if _firstelement and self:checkiffocus(v) then
        self.element_focus = v
        break
      end
      if self.element_focus==nil or self.element_focus.name == v.name then
        _firstelement = true
      end
    end
  else
    local _lastelement = nil
    for i,v in ipairs(self.elements) do
      if self.element_focus==nil or self.element_focus.name == v.name then
        if _lastelement then
          self.element_focus = _lastelement
          break
        end
      end
      if self:checkiffocus(v) then
        _lastelement=v
      end
    end
  end
end

function simplegui:changeCheckbox(pelement)
  if pelement.value==pelement.valuechecked then
    pelement.value=pelement.valueunchecked
  else
    pelement.value=pelement.valuechecked
  end
end