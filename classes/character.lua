--- character

local character = SECS_class:new()

function character:init()
end

function character:go(direction)
  self.lastdir = direction
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
    self.prop:setIndex(self.baseframe)
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

return character