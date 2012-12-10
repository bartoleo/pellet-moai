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

function key:playerContact()
  self:unload()
  self.type="_remove"
  GAMEOBJECT:addStorage(self.id,{do_not_load=true})
  for i,v in pairs(GAMEOBJECT.entities) do
    if v.type=="door" then
      v:setOpened(true)
      GAMEOBJECT:addStorage(v.id,{opened=true})
    end
  end
end

return key