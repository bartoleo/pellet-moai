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
  if direction then
    dx = DIRECTIONS[direction].dx
    dy = DIRECTIONS[direction].dy
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
    -- character moved
    if self.lastdir ~= self.lastanim then
      -- change anim
      if self.animact then
        self.animact:stop()
      end
      self.anim = MOAIAnim:new ()
      self.anim:reserveLinks ( 1 )
      if self.lastdir then
        self.anim:setLink ( 1, self["anim"..self.lastdir], self.prop, MOAIProp2D.ATTR_INDEX )
      end
      self.anim:setMode ( MOAITimer.LOOP )
      self.animact = self.anim:start ()
      self.lastanim = self.lastdir
    end
  else
    --- stop anim
    if self.animact then
      self.animact:stop()
    end
    if self.direction then
      self.prop:setIndex(self.baseframe+DIRECTIONS[self.direction].baseframe)
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
  if direction then
    dx = DIRECTIONS[direction].dx
    dy = DIRECTIONS[direction].dy
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
  self.prop:setIndex ( self.baseframe )
  GAMEOBJECT.layer:insertProp ( self.prop )

  self.animn = self:newAnim("n")
  self.anime = self:newAnim("e")
  self.anims = self:newAnim("s")
  self.animw = self:newAnim("w")
end

function character:newAnim(dir)
  local time = 0.15
  local ani=MOAIAnimCurve.new ()
  ani:reserveKeys ( 5 )
  ani:setKey ( 1, time*0, self.baseframe+DIRECTIONS[dir].baseframe+1, MOAIEaseType.FLAT )
  ani:setKey ( 2, time*1, self.baseframe+DIRECTIONS[dir].baseframe+2, MOAIEaseType.FLAT )
  ani:setKey ( 3, time*2, self.baseframe+DIRECTIONS[dir].baseframe+3, MOAIEaseType.FLAT )
  ani:setKey ( 4, time*3, self.baseframe+DIRECTIONS[dir].baseframe+4, MOAIEaseType.FLAT )
  ani:setKey ( 5, time*4, self.baseframe+DIRECTIONS[dir].baseframe+1, MOAIEaseType.FLAT )
  return ani
end

function character:unload()
  GAMEOBJECT.layer:removeProp ( self.prop )
  self.prop = nil
  self.anime = nil
  self.animw = nil
  self.animn = nil
  self.anims = nil
  self.animact = nil
end

function character:stop()
  if self.animact then
    self.animact:stop()
  end
end

function character:start()
  if self.animact then
    self.animact:start()
  end
end

return character