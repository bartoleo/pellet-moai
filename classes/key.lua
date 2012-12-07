--- key

local key = classes.object:new()

function key:init(pname, pid, px, py, pkeytype, pbaseframe, ptilelib, ptilesize)
  --- common properties for key
  self.name = pname or "key"
  self.type = "key"
  self.id = pid or utils.generateId("key")

  self.tilex,self.tiley=px,py

  self.keytype = pkeytype

  self.x,self.y = GAMEOBJECT.map.grid:getTileLoc (px,py)

  self:initGfx(pbaseframe,ptilelib,ptilesize)

  self:position(self.x,self.y)

end

function key:initGfx(pbaseframe,ptilelib,ptilesize,psymbol)
  -- call super method
  local _ret = key.__baseclass.initGfx(self,pbaseframe,ptilelib,ptilesize,psymbol)

end

function key:update()
  return true
end

function key:unload()
  -- call super method
  local _ret = key.__baseclass.unload(self)

end

return key