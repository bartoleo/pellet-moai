--- character

local character = SECS_class:new()

function character:init()
end

function character:go(direction)
  self.lastdir = direction
  self.direction = direction
  --
  if not self:checkWalkability(direction) then
    return false
  end
  -- directions
  local dx,dy = 0,0
  if direction=="n" then
    dy=-1
  elseif direction=="e" then
    dx=1
  elseif direction=="s" then
    dy=1
  elseif direction=="w" then
    dx=-1
  end
  -- check if adjusting player on "cell"
  if math.abs(dy)>0 then
    if self.x%GAMEOBJECT.grid_tilesize<GAMEOBJECT.grid_tilesize/2-GAMEOBJECT.grid_tilesize/16 then
      dx = 1
      dy = 0
      self.lastdir = "e"
    elseif self.x%GAMEOBJECT.grid_tilesize>GAMEOBJECT.grid_tilesize/2+GAMEOBJECT.grid_tilesize/16 then
      dx = -1
      dy = 0
      self.lastdir = "w"
    end
  elseif math.abs(dx)>0 then
    if self.y%GAMEOBJECT.grid_tilesize<GAMEOBJECT.grid_tilesize/2-GAMEOBJECT.grid_tilesize/16 then
      dx = 0
      dy = 1
      self.lastdir = "s"
    elseif self.y%GAMEOBJECT.grid_tilesize>GAMEOBJECT.grid_tilesize/2+GAMEOBJECT.grid_tilesize/16 then
      dx = 0
      dy = -1
      self.lastdir = "n"
    end
  end
  -- move
  self:position(self.x + dx*GAMEOBJECT.grid_tilesize/16,self.y + dy*GAMEOBJECT.grid_tilesize/16)
  --
  return true
end

function character:update()
  if self.lastdir ~= "" then
    if self.lastdir ~= self.lastanim then
      if self.animact then
        self.animact:stop()
      end
      self.anim = MOAIAnim:new ()
      self.anim:reserveLinks ( 1 )
      if self.lastdir == "n" then
        self.anim:setLink ( 1, self.animn, self.prop, MOAIProp2D.ATTR_INDEX )
      elseif self.lastdir == "e" then
        self.anim:setLink ( 1, self.anime, self.prop, MOAIProp2D.ATTR_INDEX )
      elseif self.lastdir == "w" then
        self.anim:setLink ( 1, self.animw, self.prop, MOAIProp2D.ATTR_INDEX )
      elseif self.lastdir == "s" then
        self.anim:setLink ( 1, self.anims, self.prop, MOAIProp2D.ATTR_INDEX )
      end
      self.anim:setMode ( MOAITimer.LOOP )
      self.animact = self.anim:start ()
      self.lastanim = self.lastdir
    end
  else
    if self.animact then
      self.animact:stop()
    end
    if self.direction=="n" then
      self.prop:setIndex(self.baseframe+10)
    elseif self.direction=="s" then
      self.prop:setIndex(self.baseframe+5)
    elseif self.direction=="w" then
      self.prop:setIndex(self.baseframe+15)
    elseif self.direction=="e" then
      self.prop:setIndex(self.baseframe)
    else
      self.prop:setIndex(self.baseframe)
    end
    self.lastanim = ""
  end
  self.lastdir=""
  return true
end

function character:position(px,py)
  self.x = px
  self.y = py
  self.prop:setLoc(-GAMEOBJECT.grid_width*GAMEOBJECT.grid_tilesize/2+self.x, GAMEOBJECT.grid_height*GAMEOBJECT.grid_tilesize/2-self.y+self.tilesize/3)
end

function character:checkWalkability(direction)
  -- directions
  local dx,dy = 0,0
  if direction=="n" then
    dy=-1
  elseif direction=="e" then
    dx=1
  elseif direction=="s" then
    dy=1
  elseif direction=="w" then
    dx=-1
  end
  -- check walls
  local _x,_y = GAMEOBJECT.gridwalls:locToCoord (self.x + dx*GAMEOBJECT.grid_tilesize/2, self.y + dy*GAMEOBJECT.grid_tilesize/2 )
  if GAMEOBJECT.gridwalls:getTile (_x,_y ) == 0 then
    return false
  end
  return true
end

function character:initGfx(pbaseframe,ptilelib,ptilesize)
  
  self.baseframe = pbaseframe

  self.tilesize = ptilesize

  self.tileLib = ptilelib

  self.prop = MOAIProp2D.new ()
  self.prop:setDeck ( self.tileLib )
  self.prop:setIndex ( 61 )
  GAMEOBJECT.layer:insertProp ( self.prop )

  self.anime = MOAIAnimCurve.new ()
  self.anime:reserveKeys ( 5 )
  self.anime:setKey ( 1, 0.00, self.baseframe+1, MOAIEaseType.FLAT )
  self.anime:setKey ( 2, 0.15, self.baseframe+2, MOAIEaseType.FLAT )
  self.anime:setKey ( 3, 0.30, self.baseframe+3, MOAIEaseType.FLAT )
  self.anime:setKey ( 4, 0.45, self.baseframe+4, MOAIEaseType.FLAT )
  self.anime:setKey ( 5, 0.60, self.baseframe+1, MOAIEaseType.FLAT )

  self.anims = MOAIAnimCurve.new ()
  self.anims:reserveKeys ( 5 )
  self.anims:setKey ( 1, 0.00, self.baseframe+6, MOAIEaseType.FLAT )
  self.anims:setKey ( 2, 0.15, self.baseframe+7, MOAIEaseType.FLAT )
  self.anims:setKey ( 3, 0.30, self.baseframe+8, MOAIEaseType.FLAT )
  self.anims:setKey ( 4, 0.45, self.baseframe+9, MOAIEaseType.FLAT )
  self.anims:setKey ( 5, 0.60, self.baseframe+6, MOAIEaseType.FLAT )

  self.animn = MOAIAnimCurve.new ()
  self.animn:reserveKeys ( 5 )
  self.animn:setKey ( 1, 0.00, self.baseframe+11, MOAIEaseType.FLAT )
  self.animn:setKey ( 2, 0.15, self.baseframe+12, MOAIEaseType.FLAT )
  self.animn:setKey ( 3, 0.30, self.baseframe+13, MOAIEaseType.FLAT )
  self.animn:setKey ( 4, 0.45, self.baseframe+14, MOAIEaseType.FLAT )
  self.animn:setKey ( 5, 0.60, self.baseframe+11, MOAIEaseType.FLAT )

  self.animw = MOAIAnimCurve.new ()
  self.animw:reserveKeys ( 5 )
  self.animw:setKey ( 1, 0.00, self.baseframe+16, MOAIEaseType.FLAT )
  self.animw:setKey ( 2, 0.15, self.baseframe+17, MOAIEaseType.FLAT )
  self.animw:setKey ( 3, 0.30, self.baseframe+18, MOAIEaseType.FLAT )
  self.animw:setKey ( 4, 0.45, self.baseframe+19, MOAIEaseType.FLAT )
  self.animw:setKey ( 5, 0.60, self.baseframe+16, MOAIEaseType.FLAT )

end

return character