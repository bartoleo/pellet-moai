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

  self:initGfx(pbaseframe,ptilelib,ptilesize,"")

  self:position(self.x,self.y)

  self.status = 0 -- 0:idle 1:caoutius 2:alarm

end

function enemy:update()
  if math.random()>0.95 and self:go("n") then
  elseif math.random()>0.95 and self:go("s") then
  elseif math.random()>0.95 and self:go("e") then
  elseif math.random()>0.95 and	self:go("w") then
  elseif math.random()>0.50 and self:go(self.direction) then
  else
    local dir = self.direction
    if self.x<GAMEOBJECT.player.x then
      if self:checkWalkability("e") then
        dir = "e"
      end
    elseif self.x>GAMEOBJECT.player.x then
      if self:checkWalkability("w") then
        dir = "w"
      end
    end
    if self.y<GAMEOBJECT.player.y then
      if self:checkWalkability("s") then
        dir = "s"
      end
    elseif self.y>GAMEOBJECT.player.y then
      if self:checkWalkability("n") then
        dir = "n"
      end
    end
    self:go(dir)
  end
  -- call super method
  local _ret = enemy.__baseclass.update(self)
  -- can see player
  local _see,_seex,_seey = self:canSeePlayer()
  if _see then
    self:setStatus(2)
  else
    self:setStatus(0)
  end
  return _ret
end

function enemy:canSeePlayer()
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

function enemy:setStatus(newstatus)
  if self.status~=newstatus then
    if self.symbol.anim ~= nil then
      self.symbol.anim:stop ()
      self.symbol.animact = nil
      self.symbol.anim = nil
    end
    if newstatus == 0 then
      -- idle
      self.symbol:setString("")
    elseif newstatus == 1 then
      -- cautious
      self.symbol:setString("?")
      self.symbol:setColor(1,1,0,1)
    elseif newstatus == 2 then
      -- alarm
      self.symbol:setString("!")
      self.symbol:setColor(1,0,0,1)
    end
    if newstatus > 0 then
      self.symbol.anim = MOAIAnim:new ()
      self.symbol.anim:reserveLinks ( 2 )
      self.symbol.anim:setLink ( 1, self.symbol.curve,  self.symbol, MOAIProp2D.ATTR_X_SCL )
      self.symbol.anim:setLink ( 2, self.symbol.curve,  self.symbol, MOAIProp2D.ATTR_Y_SCL )
      self.symbol.anim:setMode ( MOAITimer.LOOP )
      self.symbol.animact = self.symbol.anim:start ()
    end
     self.status=newstatus
  end
end

return enemy