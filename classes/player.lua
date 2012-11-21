--- player

local player = classes.character:new()

function player:init(px,py,pbaseframe)
  --- common properties for player
  self.name = "player"
  self.type = "player"
  self.id = "__player__"

  self.x,self.y = GAMEOBJECT.grid:getTileLoc (px,py,pbaseframe)
  self.lastdir = ""
  self.lastanim = ""
  self.baseframe = pbaseframe

  self.tileLib = MOAITileDeck2D.new ()
  self.tileLib:setTexture ( images.pg)
  self.tileLib:setSize ( 20, 46 )
  self.tilesize = 26*1.875
  self.tileLib:setRect ( -self.tilesize/2, -self.tilesize/2, self.tilesize/2, self.tilesize/2 )

  self.prop = MOAIProp2D.new ()
  self.prop:setDeck ( self.tileLib )
  self.prop:setIndex ( 61 )
  GAMEOBJECT.layer:insertProp ( self.prop )

  self.anime = MOAIAnimCurve.new ()
  self.anime:reserveKeys ( 5 )
  self.anime:setKey ( 1, 0.00, self.baseframe+1, MOAIEaseType.FLAT )
  self.anime:setKey ( 2, 0.25, self.baseframe+2, MOAIEaseType.FLAT )
  self.anime:setKey ( 3, 0.50, self.baseframe+3, MOAIEaseType.FLAT )
  self.anime:setKey ( 4, 0.75, self.baseframe+4, MOAIEaseType.FLAT )
  self.anime:setKey ( 5, 1   , self.baseframe+1, MOAIEaseType.FLAT )

  self.anims = MOAIAnimCurve.new ()
  self.anims:reserveKeys ( 5 )
  self.anims:setKey ( 1, 0.00, self.baseframe+6, MOAIEaseType.FLAT )
  self.anims:setKey ( 2, 0.25, self.baseframe+7, MOAIEaseType.FLAT )
  self.anims:setKey ( 3, 0.50, self.baseframe+8, MOAIEaseType.FLAT )
  self.anims:setKey ( 4, 0.75, self.baseframe+9, MOAIEaseType.FLAT )
  self.anims:setKey ( 5, 1   , self.baseframe+6, MOAIEaseType.FLAT )

  self.animn = MOAIAnimCurve.new ()
  self.animn:reserveKeys ( 5 )
  self.animn:setKey ( 1, 0.00, self.baseframe+11, MOAIEaseType.FLAT )
  self.animn:setKey ( 2, 0.25, self.baseframe+12, MOAIEaseType.FLAT )
  self.animn:setKey ( 3, 0.50, self.baseframe+13, MOAIEaseType.FLAT )
  self.animn:setKey ( 4, 0.75, self.baseframe+14, MOAIEaseType.FLAT )
  self.animn:setKey ( 5, 1   , self.baseframe+11, MOAIEaseType.FLAT )

  self.animw = MOAIAnimCurve.new ()
  self.animw:reserveKeys ( 5 )
  self.animw:setKey ( 1, 0.00, self.baseframe+16, MOAIEaseType.FLAT )
  self.animw:setKey ( 2, 0.25, self.baseframe+17, MOAIEaseType.FLAT )
  self.animw:setKey ( 3, 0.50, self.baseframe+18, MOAIEaseType.FLAT )
  self.animw:setKey ( 4, 0.75, self.baseframe+19, MOAIEaseType.FLAT )
  self.animw:setKey ( 5, 1   , self.baseframe+16, MOAIEaseType.FLAT )

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