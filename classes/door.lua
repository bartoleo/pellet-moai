--- door

local door = classes.object:new()

function door:init(pname, pid, px, py, pdoortype, pbaseframe, ptilelib, ptilesize)
  --- common properties for door
  self.name = pname or "door"
  self.type = "door"
  self.id = pid or utils.generateId("door")

  self.tilex,self.tiley=px,py

  self.doortype = pdoortype

  self.x,self.y = GAMEOBJECT.map.grid:getTileLoc (px,py)

  self:initGfx(pbaseframe,ptilelib,ptilesize)
  
  self.prop2 = MOAIProp2D.new ()
  self.prop2:setDeck ( self.tileLib )
  self.prop2:setIndex ( self.baseframe+1 )
  GAMEOBJECT.layer:insertProp ( self.prop2 )

  self:position(self.x,self.y)

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

  GAMEOBJECT.layer:removeProp ( self.prop2 )
  self.prop2 = nil

end

function door:position(px,py)
  -- call super method
  local _ret = door.__baseclass.position(self,px,py)
  self.prop2:setLoc(-GAMEOBJECT.map.grid_width*GAMEOBJECT.map.grid_tilesize/2+self.x, GAMEOBJECT.map.grid_height*GAMEOBJECT.map.grid_tilesize/2-self.y+self.tilesize)

end

return door