--- gate

local gate = SECS_class:new()

function gate:init(pname, pid, px, py, pgatetype, pbaseframe, ptilelib, ptilesize, popened, pstart, pframesopen, pframesclose)
  --- common properties for gate
  self.name = pname or "gate"
  self.type = "gate"
  self.id = pid or utils.generateId("gate")

  self.tilex,self.tiley=px,py

  self.gatetype = pgatetype

  self.x,self.y = GAMEOBJECT.map.grid:getTileLoc (px,py)

  self:initGfx(pbaseframe,ptilelib,ptilesize)

  self:position(self.x,self.y)

  self.framesopen=pframesopen or 180
  self.framesclose=pframesclose or 180
  self.opened=popened
  if self.opened==nil then
    self.opened = true
  end
  if self.opened then
    self.frames = self.framesopen
  else
    self.frames = self.framesclose
  end
  if pstart then
    self.frames = self.frames - pstart
  end
end

function gate:initGfx(pbaseframe,ptilelib,ptilesize,psymbol)

  self.baseframe = pbaseframe

  self.tilesize = ptilesize

  self.tileLib = ptilelib

  self.prop = MOAIProp2D.new ()
  self.prop:setDeck ( self.tileLib )
  self.prop:setIndex ( self.baseframe )
  GAMEOBJECT.layer:insertProp ( self.prop )

  self.animopen = self:newAnim(true)
  self.animclose = self:newAnim(false)

end

function gate:newAnim(popen)
  local time = 0.15
  local ani=MOAIAnimCurve.new ()
  local _frame, _incframe
  if popen then
    _frame = self.baseframe+5
    _incframe = -1
  else
    _frame = self.baseframe
    _incframe = 1
  end
  ani:reserveKeys ( 7 )
  ani:setKey ( 1, time*0, _frame+_incframe*0, MOAIEaseType.FLAT )
  ani:setKey ( 2, time*1, _frame+_incframe*1, MOAIEaseType.FLAT )
  ani:setKey ( 3, time*2, _frame+_incframe*2, MOAIEaseType.FLAT )
  ani:setKey ( 4, time*3, _frame+_incframe*3, MOAIEaseType.FLAT )
  ani:setKey ( 5, time*4, _frame+_incframe*4, MOAIEaseType.FLAT )
  ani:setKey ( 6, time*5, _frame+_incframe*5, MOAIEaseType.FLAT )
  ani:setKey ( 7, time*6, _frame+_incframe*5, MOAIEaseType.FLAT )
  return ani
end

function gate:update()
  self.frames = self.frames - 1
  if self.frames <= 0 then
    if self.opened then
      self.opened = false
      self:changeAnim("close")
      GAMEOBJECT.map.gridwalls:setTile(self.tilex,self.tiley,0)
      self.frames = self.framesopen
    else
      self.opened = true
      self:changeAnim("open")
      GAMEOBJECT.map.gridwalls:setTile(self.tilex,self.tiley,1)
      self.frames = self.framesclose
    end
  end
  if not self.opened then
    _x,_y = GAMEOBJECT.map.grid:locToCoord (GAMEOBJECT.player.x , GAMEOBJECT.player.y )
    if _x==self.tilex and _y==self.tiley then
      local _newx,_newy
      _newx = GAMEOBJECT.player.x
      if GAMEOBJECT.player.y<self.y then
        _newy = GAMEOBJECT.player.y-2*GAMEOBJECT.map.grid_tilesize/16
      else
        _newy = GAMEOBJECT.player.y+2*GAMEOBJECT.map.grid_tilesize/16
      end
      GAMEOBJECT.player:position(_newx,_newy)
    end
  end
  return true
end

function gate:changeAnim(panim)
  if self.animact then
    self.animact:stop()
  end
  self.anim = MOAIAnim:new ()
  self.anim:reserveLinks ( 1 )
  self.anim:setLink ( 1, self["anim"..panim], self.prop, MOAIProp2D.ATTR_INDEX )
  self.animact = self.anim:start ()
  self.lastanim = self.lastdir
end

function gate:unload()
  GAMEOBJECT.layer:removeProp ( self.prop )
  self.prop = nil
  self.animopen = nil
  self.animclose = nil
  self.animact = nil
end

function gate:stop()
  if self.animact then
    self.animact:stop()
  end
end

function gate:start()
  if self.animact then
    self.animact:start()
  end
end

function gate:position(px,py)
  self.x = px
  self.y = py
  self.prop:setLoc(-GAMEOBJECT.map.grid_width*GAMEOBJECT.map.grid_tilesize/2+self.x, GAMEOBJECT.map.grid_height*GAMEOBJECT.map.grid_tilesize/2-self.y)
end

return gate