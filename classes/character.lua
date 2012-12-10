--- character

local character = SECS_class:new()

function character:init()
  self.moved=false
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
    if self.x%GAMEOBJECT.map.grid_tilesize<GAMEOBJECT.map.grid_tilesize/2-GAMEOBJECT.map.grid_tilesize/16 then
      dx = 1
      dy = 0
      self.lastdir = "e"
    elseif self.x%GAMEOBJECT.map.grid_tilesize>GAMEOBJECT.map.grid_tilesize/2+GAMEOBJECT.map.grid_tilesize/16 then
      dx = -1
      dy = 0
      self.lastdir = "w"
    end
  elseif math.abs(dx)>0 then
    if self.y%GAMEOBJECT.map.grid_tilesize<GAMEOBJECT.map.grid_tilesize/2-GAMEOBJECT.map.grid_tilesize/16 then
      dx = 0
      dy = 1
      self.lastdir = "s"
    elseif self.y%GAMEOBJECT.map.grid_tilesize>GAMEOBJECT.map.grid_tilesize/2+GAMEOBJECT.map.grid_tilesize/16 then
      dx = 0
      dy = -1
      self.lastdir = "n"
    end
  end
  -- move
  self:position(self.x + dx*GAMEOBJECT.map.grid_tilesize/16,self.y + dy*GAMEOBJECT.map.grid_tilesize/16)
  --
  return true
end

function character:update()
  self.moved=false
  if self.lastdir ~= "" then
    self.moved=true
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
        self.anim:setMode ( MOAITimer.LOOP )
        self.animact = self.anim:start ()
      end
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
  self.prop:setLoc(GAMEOBJECT.map.mapleft+self.x, GAMEOBJECT.map.maptop-self.y+self.tilesize/3)
  if self.symbol then
    self.symbol:setLoc (GAMEOBJECT.map.mapleft+self.x, GAMEOBJECT.map.maptop-self.y+self.tilesize/3+20)
  end
end

function character:checkWalkability(direction)
  -- directions
  local dx,dy = 0,0
  if direction then
    dx = DIRECTIONS[direction].dx
    dy = DIRECTIONS[direction].dy
  end
  -- check walls
  local _x,_y = GAMEOBJECT.map.gridwalls:locToCoord (self.x + dx*(GAMEOBJECT.map.grid_tilesize/2+1), self.y + dy*(GAMEOBJECT.map.grid_tilesize/2+1) )
  if GAMEOBJECT.map.gridwalls:getTile (_x,_y ) == 0 then
    return false
  end
  return true
end

function character:checkTileWalkability(direction)
  -- directions
  local dx,dy = 0,0
  if direction then
    dx = DIRECTIONS[direction].dx
    dy = DIRECTIONS[direction].dy
  end
  -- check walls
  local _x,_y = GAMEOBJECT.map.gridwalls:locToCoord (self.x , self.y )
  if GAMEOBJECT.map.gridwalls:getTile (_x+dx,_y+dy ) == 0 then
    return false
  end
  return true
end


function character:initGfx(pbaseframe,ptilelib,ptilesize,psymbol)

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
  if psymbol then
    self.symbol = MOAITextBox.new ()
    self.symbol:setFont ( fonts["resource,32"] )
    self.symbol:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.symbol:setYFlip ( true )
    self.symbol:setRect ( -20, -20, 20, 20 )
    self.symbol:setString ( psymbol )
    GAMEOBJECT.layer:insertProp ( self.symbol )

    self.symbol.curve = MOAIAnimCurve.new ()
    self.symbol.curve:reserveKeys ( 3 )
    self.symbol.curve:setKey ( 1, 0, 1 )
    self.symbol.curve:setKey ( 2, 0.5, 2 )
    self.symbol.curve:setKey ( 3, 1, 1 )
  end

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
  if self.symbol then
    GAMEOBJECT.layer:removeProp ( self.symbol )
  end
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