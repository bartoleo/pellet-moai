--- chest

local chest = classes.object:new()

function chest:init(pname, pid, px, py, pchesttype, pbaseframe, ptilelib, ptilesize)
  --- common properties for chest
  self.name = pname or "chest"
  self.type = "chest"
  self.id = pid or utils.generateId("chest")

  self.tilex,self.tiley=px,py

  self.chesttype = pchesttype

  self.x,self.y = GAMEOBJECT.map.grid:getTileLoc (px,py)

  self:initGfx(pbaseframe,ptilelib,ptilesize)

  self:position(self.x,self.y)

end

function chest:initGfx(pbaseframe,ptilelib,ptilesize,psymbol)
  -- call super method
  local _ret = chest.__baseclass.initGfx(self,pbaseframe,ptilelib,ptilesize,psymbol)

end

function chest:update()
  return true
end

function chest:unload()
  -- call super method
  local _ret = chest.__baseclass.unload(self)

end

return chest