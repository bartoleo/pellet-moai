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

  self.pathFinder = MOAIPathFinder.new ()
  self.pathFinder:setGraph ( GAMEOBJECT.gridwalls )
  self.pathFinder:setFlags(MOAIGridPathGraph.NO_DIAGONALS)
  self.pathFinder:setHeuristic ( MOAIGridPathGraph.EUCLIDEAN_DISTANCE  )

end

function enemy:update()
  -- if math.random()>0.95 and self:go("n") then
  -- elseif math.random()>0.95 and self:go("s") then
  -- elseif math.random()>0.95 and self:go("e") then
  -- elseif math.random()>0.95 and	self:go("w") then
  -- elseif math.random()>0.50 and self:go(self.direction) then
  -- else
  --   local dir = self.direction
  --   if self.x<GAMEOBJECT.player.x then
  --     if self:checkWalkability("e") then
  --       dir = "e"
  --     end
  --   elseif self.x>GAMEOBJECT.player.x then
  --     if self:checkWalkability("w") then
  --       dir = "w"
  --     end
  --   end
  --   if self.y<GAMEOBJECT.player.y then
  --     if self:checkWalkability("s") then
  --       dir = "s"
  --     end
  --   elseif self.y>GAMEOBJECT.player.y then
  --     if self:checkWalkability("n") then
  --       dir = "n"
  --     end
  --   end
  --   self:go(dir)
  -- end
  if self.lastseenx and self.lastseeny then
    self:gotoPos(self.lastseenx, self.lastseeny)
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

function enemy:findPath(x,y)

  self.path={dx=x,dy=y}

  local startNode = GAMEOBJECT.gridwalls:getCellAddr (GAMEOBJECT.gridwalls:locToCoord(self.x,self.y ))
  local endNode = GAMEOBJECT.gridwalls:getCellAddr ( GAMEOBJECT.gridwalls:locToCoord(x,y ) )

  self.pathFinder:init ( startNode, endNode )
  while self.pathFinder:findPath (  ) do
  end

  local pathSize = self.pathFinder:getPathSize ()
  for i = 1, pathSize do
    local entry = self.pathFinder:getPathEntry ( i )
    local _x, _y = GAMEOBJECT.gridwalls:cellAddrToCoord ( entry )
    local _x2, _y2 = GAMEOBJECT.gridwalls:getTileLoc ( _x,_y )
    table.insert(self.path,{x=_x2,y=_y2})
  end

end

function enemy:gotoPos(x,y)
  if self.x==x and self.y==y then
    return true
  end
  if self.path == nil or self.path.dx~=x or self.path.dy ~= y or #self.path==0 then
    self:findPath(x,y)
  end
  if #self.path>0 then
    self:movetoPos(self.path[1].x,self.path[1].y)
    if self.x == self.path[1].x and self.y == self.path[1].y then
      table.remove(self.path,1)
    end
  end
  if self.x==x and self.y == y then
    return true
  end
  return false
end

function enemy:movetoPos(x,y)
  if self.x<x and self:checkWalkability("e") then
    self:go("e")
  elseif self.x>x and self:checkWalkability("w") then
    self:go("w")
  elseif self.y>y and self:checkWalkability("n") then
    self:go("n")
  elseif self.y<y and self:checkWalkability("s") then
    self:go("s")
  end
end

return enemy