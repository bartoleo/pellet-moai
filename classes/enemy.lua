--- enemy

local enemy = classes.character:new()

function enemy:init(pname,pid,px,py,pbaseframe)
  --- common properties for enemy
  self.name = pname or "enemy"
  self.type = "enemy"
  self.id = pid or utils.generateId("enemy")

  self.x,self.y = GAMEOBJECT.grid:getTileLoc (px,py)
  self.lastdir = ""
  self.lastanim = ""

  self.tileLib = MOAITileDeck2D.new ()
  self.tileLib:setTexture ( images.pg)
  self.tileLib:setSize ( 20, 46 )
  self.tilesize = 26*1.875
  self.tileLib:setRect ( -self.tilesize/2, -self.tilesize/2, self.tilesize/2, self.tilesize/2 )

  self.baseframe = pbaseframe

  self.prop = MOAIProp2D.new ()
  self.prop:setDeck ( self.tileLib )
  self.prop:setIndex ( self.baseframe )
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

function enemy:update()
  if math.random()>0.95 and self:go("n") then
  elseif math.random()>0.95 and self:go("s") then
  elseif math.random()>0.95 and self:go("e") then
  elseif math.random()>0.95 and	self:go("w") then
  else
  	self:go(self.lastdirc)
  end
  self.lastdirc = self.lastdir
  enemy.__baseclass.update(self)
  return true
end

return enemy