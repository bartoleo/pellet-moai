--- player

local player = classes.character:new()

function player:init(px,py,pbaseframe,ptilelib,ptilesize)
  --- common properties for player
  self.name = "player"
  self.type = "player"
  self.id = "__player__"

  self.x,self.y = GAMEOBJECT.grid:getTileLoc (px,py,pbaseframe)
  self.lastdir = ""
  self.lastanim = ""

  self:initGfx(pbaseframe,ptilelib,ptilesize)

  self:position(self.x,self.y)
end

function player:go(direction)
  player.__baseclass.go(self,direction)
  -- check coin
  _x,_y = GAMEOBJECT.gridcoins:locToCoord (self.x , self.y )
  if GAMEOBJECT.gridcoins:getTile(_x,_y) > 0 then
    GAMEOBJECT.gridcoins:setTile(_x,_y,0)
    GAMEOBJECT.coins = GAMEOBJECT.coins-1
  end
  --
  return true
end

function player:update()
  player.__baseclass.update(self)
  return true
end

return player