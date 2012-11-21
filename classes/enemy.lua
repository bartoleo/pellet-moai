--- enemy

local enemy = classes.character:new()

function enemy:init(pname,pid,px,py,pbaseframe,ptilelib,ptilesize)
  --- common properties for enemy
  self.name = pname or "enemy"
  self.type = "enemy"
  self.id = pid or utils.generateId("enemy")

  self.x,self.y = GAMEOBJECT.grid:getTileLoc (px,py)
  self.lastdir = ""
  self.lastanim = ""

  self:initGfx(pbaseframe,ptilelib,ptilesize)

  self:position(self.x,self.y)

end

function enemy:update()
  -- if math.random()>0.95 and self:go("n") then
  -- elseif math.random()>0.95 and self:go("s") then
  -- elseif math.random()>0.95 and self:go("e") then
  -- elseif math.random()>0.95 and	self:go("w") then
  -- else
  -- 	self:go(self.direction)
  -- end
  enemy.__baseclass.update(self)
  local _see,_seex,_seey = self:canViewPlayer()
  if _see then
    print(self.id..":seeyou")
  end
  return true
end

function enemy:canViewPlayer()
  local _see = false
  if GAMEOBJECT:isDirection(self.direction,self.x,self.y,GAMEOBJECT.player.x, GAMEOBJECT.player.y) then
    _see = GAMEOBJECT:los(self.x,self.y,GAMEOBJECT.player.x, GAMEOBJECT.player.y)
  end
  if _see then
    self.lastseenx, self.lastseeny=GAMEOBJECT.player.x, GAMEOBJECT.player.y
    return true, self.lastseenx, self.lastseeny
  else
    return false, nil, nil
  end

end

return enemy