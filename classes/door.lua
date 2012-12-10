--- door

local door = classes.object:new()

function door:init(pname, pid, px, py, pdoortype, pbaseframe, ptilelib, ptilesize, popened)
  --- common properties for door
  self.name = pname or "door"
  self.type = "door"
  self.id = pid or utils.generateId("door")

  self.tilex,self.tiley=px,py

  self.doortype = pdoortype

  self.x,self.y = GAMEOBJECT.map.grid:getTileLoc (px,py)
  self.y = self.y - 3*ptilesize/16

  self:initGfx(pbaseframe,ptilelib,ptilesize)

  self.prop2 = MOAIProp2D.new ()
  self.prop2:setDeck ( self.tileLib )
  self.prop2:setIndex ( self.baseframe+2 )
  GAMEOBJECT.layerRoof:insertProp ( self.prop2 )

  self:position(self.x,self.y)

  self.opened = popened
  if GAMEOBJECT:getStorage(self.id,"opened") then
    self.opened = true
  end

  self:setOpened(self.opened)

end

function door:initGfx(pbaseframe,ptilelib,ptilesize,psymbol)
  -- call super method
  local _ret = door.__baseclass.initGfx(self,pbaseframe,ptilelib,ptilesize,psymbol)

end

function door:update()
  return true
end

function door:unload()
  -- call super method
  local _ret = door.__baseclass.unload(self)

  GAMEOBJECT.layerRoof:removeProp ( self.prop2 )
  self.prop2 = nil

end

function door:position(px,py)
  -- call super method
  local _ret = door.__baseclass.position(self,px,py)
  self.prop2:setLoc(GAMEOBJECT.map.mapleft+self.x, GAMEOBJECT.map.maptop-self.y+self.tilesize)

end

function door:setOpened(popened)
  self.opened=popened
  if self.opened==nil then
    self.opened = false
  end
  if self.opened then
    GAMEOBJECT.map.gridwalls:setTile(self.tilex,self.tiley,1)
    GAMEOBJECT.map.gridwalls:setTile(self.tilex,self.tiley-1,1)
    self.prop:setIndex ( self.baseframe+1 )
  else
    GAMEOBJECT.map.gridwalls:setTile(self.tilex,self.tiley,0)
    GAMEOBJECT.map.gridwalls:setTile(self.tilex,self.tiley-1,0)
    self.prop:setIndex ( self.baseframe )
  end
end

return door