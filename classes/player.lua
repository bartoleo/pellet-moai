--- player

local player = classes.character:new()

function player:init(px,py,pbaseframe,ptilelib,ptilesize)
  --- common properties for player
  self.name = "player"
  self.type = "player"
  self.id = "__player__"

  self.x,self.y = GAMEOBJECT.map.grid:getTileLoc (px,py,pbaseframe)
  self.lastdir = ""
  self.lastanim = ""
  self.walksound=0

  self:initGfx(pbaseframe,ptilelib,ptilesize,false)

  self:position(self.x,self.y)

  self.lastinput = ""
end

function player:go(direction)
  -- call super method
  player.__baseclass.go(self,direction)
  -- check coin
  _x,_y = GAMEOBJECT.map.gridcoins:locToCoord (self.x , self.y )
  if GAMEOBJECT.map.gridcoins:getTile(_x,_y) > 0 then
    soundmgr.playSound(sounds.klick,0.5)
    GAMEOBJECT.map.gridcoins:setTile(_x,_y,0)
    GAMEOBJECT.map.coins = GAMEOBJECT.map.coins-1
    self.walksound=16
  elseif self.walksound<=0 then
    soundmgr.playSound(sounds.klick,0.2)
    self.walksound=16
  end
  self.walksound=self.walksound-1
  --
  return true
end

function player:update()
  -- call super method
  local _ret = player.__baseclass.update(self)
  if self.lastinput =="n" or  self.lastinput =="s" or self.lastinput =="w" or self.lastinput =="e" then
    self:go(self.lastinput)
  end
  self.lastinput = ""
  return _ret
end

function player:input(inp)
  self.lastinput=inp
end

return player