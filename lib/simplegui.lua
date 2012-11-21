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

function simplegui:setlayout(ptype,px,py,pwidth,pheight,pfont,pfontheight,pcolor,phcolor)
  self.layout={type=ptype,x=px,y=py,width=pwidht,height=pheight,dx=0,dy=0}
  if pfont then
    self.layout.font = pfont
  end
  if pcolor then
    self.layout.color = pcolor
  end
  if phcolor then
    self.layout.hcolor = phcolor
  end
  if self.fontheight then
    self.fontheight=pfontheight
  end
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
      self.layout.dy=self.layout.dy+_element.height+self.divisor
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
  self.elements={}
  self.element_focus=nil
  self.layout={type="down",x=0,y=0,width=nil,height=nil,dx=0,dy=0,nil,nil,color={r=255,g=255,b=255,a=255},hcolor={r=255,g=255,b=0,a=255}}
  self.counter=0
end

function simplegui:update(dt)
  mousex, mousey = love.mouse.getPosition( )
  mouselb = love.mouse.isDown("l")
  mouselbclick = false
  if self.oldmouselb==false and mouselb==true then
    mouselbclick = true
  end
  self.oldmouselb = mouselb
  for i,v in ipairs(self.elements) do
    v.mousehover = false
    if v.enabled and v.visible and mousex>=v.x and mousex<=v.x+v.width and  mousey>=v.y and mousey<=v.y+v.height then
      v.mousehover = true
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
      if v.prev and mousex>=v.prevx and mousex<=v.prevx+v.fontheight and  mousey>=v.y and mousey<=v.y+v.height then
        v.mousehover = true
        if mouselbclick then
          self:changeHCombo(v,false)
          if self.callback then
            self.callback(self.element_focus.name, "change")
          end
        end
      end
      if v.next and mousex>=v.nextx and mousex<=v.nextx+v.fontheight and  mousey>=v.y and mousey<=v.y+v.height then
        v.mousehover = true
        if mouselbclick then
          self:changeHCombo(v,true)
          if self.callback then
            self.callback(self.element_focus.name, "change")
          end
        end
      end
    end
  end
end

function simplegui:draw()
  local _r,_g,_b,_a = love.graphics.getColor()
  local _f = love.graphics.getFont()
  local _width = love.graphics.getLineWidth( )

  local lovegraphicssetLineWidth=love.graphics.setLineWidth
  local lovegraphicssetColor=love.graphics.setColor
  local lovegraphicssetFont=love.graphics.setFont
  local lovegraphicsprint=love.graphics.print
  local lovegraphicsprintf=love.graphics.printf
  local lovegraphicsrectangle=love.graphics.rectangle
  local lovegraphicspolygon=love.graphics.polygon
  local lovegraphicstriangle=love.graphics.triangle

  lovegraphicssetLineWidth(1)
  for i,v in ipairs(self.elements) do
    if v.visible then
        if v.type=="separator" then
        elseif v.type=="label" then
          lovegraphicssetFont(v.font)
          if v.mousehover or self.element_focus and self.element_focus.name==v.name then
            lovegraphicssetColor(v.hcolor.r,v.hcolor.g,v.hcolor.b,truefalse(v.enabled,v.hcolor.a,v.hcolor.a/2))
          else
            lovegraphicssetColor(v.color.r,v.color.g,v.color.b,truefalse(v.enabled,v.color.a,v.color.a/2))
          end
          lovegraphicsprint(v.label,v.x,v.y)
        elseif v.type=="button" then
          lovegraphicssetFont(v.font)
          if v.mousehover or self.element_focus and self.element_focus.name==v.name then
            lovegraphicssetColor(v.hcolor.r,v.hcolor.g,v.hcolor.b,truefalse(v.enabled,v.hcolor.a,v.hcolor.a/2))
          else
            lovegraphicssetColor(v.color.r,v.color.g,v.color.b,truefalse(v.enabled,v.color.a,v.color.a/2))
          end
          lovegraphicsprint(v.text,v.x,v.y)
        elseif v.type=="checkbox" then
          lovegraphicssetFont(v.font)
          if v.mousehover or self.element_focus and self.element_focus.name==v.name then
            lovegraphicssetColor(v.hcolor.r,v.hcolor.g,v.hcolor.b,truefalse(v.enabled,v.hcolor.a,v.hcolor.a/2))
          else
            lovegraphicssetColor(v.color.r,v.color.g,v.color.b,truefalse(v.enabled,v.color.a,v.color.a/2))
          end
          lovegraphicsprint(v.label,v.x,v.y)
          local _x=v.x+v.font:getWidth( v.label )+self.divisor
          lovegraphicssetLineWidth(2)
          lovegraphicsrectangle("line",_x,v.y,v.fontheight,v.fontheight)
          if v.value==v.valuechecked then
            lovegraphicspolygon("line",_x,v.y+v.fontheight/2,
                                         _x+v.fontheight/3,v.y+v.fontheight,
                                         _x+v.fontheight,v.y,
                                         _x+v.fontheight/3,v.y+v.fontheight)
          end
          lovegraphicssetLineWidth(1)
        elseif v.type=="hcombo" then
          lovegraphicssetFont(v.font)
          if v.mousehover or self.element_focus and self.element_focus.name==v.name then
            lovegraphicssetColor(v.hcolor.r,v.hcolor.g,v.hcolor.b,truefalse(v.enabled,v.hcolor.a,v.hcolor.a/2))
          else
            lovegraphicssetColor(v.color.r,v.color.g,v.color.b,truefalse(v.enabled,v.color.a,v.color.a/2))
          end
          lovegraphicsprint(v.label,v.x,v.y)
          if v.prev then
                lovegraphicssetLineWidth(2)
                lovegraphicstriangle("line",v.prevx,v.y+v.fontheight/2,v.prevx+v.fontheight/2,v.y,v.prevx+v.fontheight/2,v.y+v.fontheight)
                lovegraphicssetLineWidth(1)
          end
          if v.mousehover or self.element_focus and self.element_focus.name==v.name then
            lovegraphicssetColor(v.hcolor.r,v.hcolor.g,v.hcolor.b,truefalse(v.enabled,v.hcolor.a/2,v.hcolor.a/4))
          else
            lovegraphicssetColor(v.color.r,v.color.g,v.color.b,truefalse(v.enabled,v.color.a/2,v.color.a/4))
          end
          lovegraphicsrectangle("line",v.prevx+v.fontheight,v.y,v.maxvaluewidth,v.height)
          if v.mousehover or self.element_focus and self.element_focus.name==v.name then
            lovegraphicssetColor(v.hcolor.r,v.hcolor.g,v.hcolor.b,truefalse(v.enabled,v.hcolor.a,v.hcolor.a/2))
          else
            lovegraphicssetColor(v.color.r,v.color.g,v.color.b,truefalse(v.enabled,v.color.a,v.color.a/2))
          end
          lovegraphicsprintf(v.labelvalue,v.prevx+v.fontheight,v.y,v.maxvaluewidth,"center")
          if v.next then
            lovegraphicssetLineWidth(2)
            lovegraphicstriangle("line",v.nextx+v.fontheight/2,v.y+v.fontheight/2,v.nextx,v.y,v.nextx,v.y+v.fontheight)
            lovegraphicssetLineWidth(1)
          end
        end
    end
  end
  lovegraphicssetColor(_r,_g,_b,_a)
  lovegraphicssetFont(_f)
  lovegraphicssetLineWidth(_width)
end

function simplegui:keypressed(key, unicode)
  if key=="up" or key=="w" or key=="8" then
    self:navigate(false)
  end
  if key=="down" or key=="s" or key=="2" then
    self:navigate(true)
  end
  if key=="left" or key=="a" or key=="4" then
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
  if key=="right" or key=="d" or key=="6" then
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
  if key=="return" or key==" " or key=="5" then
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