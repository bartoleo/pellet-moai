--- enemy

local enemy = classes.character:new()

function enemy:init(pname,pid,px,py,pbaseframe,ptilelib,ptilesize,pactions)
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
  self.statustimer = 0
  self.noiselimit = 0
  self.actions = pactions
  self.actionindex = 1

  self.pathFinder = MOAIPathFinder.new ()
  self.pathFinder:setGraph ( GAMEOBJECT.gridwalls )
  self.pathFinder:setFlags(MOAIGridPathGraph.NO_DIAGONALS)
  self.pathFinder:setHeuristic ( MOAIGridPathGraph.EUCLIDEAN_DISTANCE  )

end

function enemy:update()
  -- call super method
  local _ret = enemy.__baseclass.update(self)
  -- can see player
  local _see,_seex,_seey = self:canSeePlayer()
  local _noise,_noisedir = false,nil,nil
  if self.noiselimit > 0 then
    self.noiselimit = self.noiselimit -1
  end
  if _see then
    self:setStatus(2)
    self.statustimer = 120
  else
    _noise,_noisedir = self:canHearPlayer()
    if _noise then
      self.noiselimit = self.noiselimit + 2
    end
    if _noise and self.status<2 then
      self:setStatus(1)
      self.statustimer = 120
      self.lookaroundtimer=40
      self.lookaroundindex=0
    end
    if self.noiselimit > 24 then
      self:setStatus(2)
      self.statustimer = 120
      self.lastseenx,self.lastseeny = self:randomPlaceDir(_noisedir)
    end
  end
  self.statustimer = self.statustimer -1
  -- alarm
  if self.status==2 then
    if self.lastseenx and self.lastseeny then
      if not self:gotoPos(self.lastseenx, self.lastseeny) then
        self.statustimer = self.statustimer + 1
      elseif _noise then
        self.direction=_noisedir
        self:position(self.x,self.y)
      elseif not self:lookAround() then
        self.statustimer = self.statustimer + 1
      end
    elseif _noise then
      self.direction=_noisedir
      self:position(self.x,self.y)
    elseif not self:lookAround() then
      self.statustimer = self.statustimer + 1
    end
    if self.statustimer <= 0 then
      self:setStatus(1)
      self.statustimer = 120
    end
    return _ret
  end
  -- cautious
  if self.status==1 then
    if _noise then
      self.direction=_noisedir
      self:position(self.x,self.y)
    elseif not self:lookAround() then
      self.statustimer = self.statustimer + 1
    end
    if self.statustimer <= 0 then
      self:setStatus(0)
      self.statustimer = 120
    end
    return _ret
  end
  -- idle
  if self.status==0 then
    if self.actions then
      if self.actionindex>#self.actions then
        self.actionindex=1
      end
      local action = self.actions[self.actionindex]
      if action[1] == "goto" then
        local _x,_y 
        if action[2] == "rnd" then
          if self.actionindex~=self.actionindexlast then
            action.x,action.y = GAMEOBJECT.grid:getTileLoc(GAMEOBJECT:getRndTile())
            print (action.x,action.y)
          end
          _x,_y = action.x,action.y
        else
          _x,_y = GAMEOBJECT.grid:getTileLoc (GAMEOBJECT.level.pos[action[2]].x,GAMEOBJECT.level.pos[action[2]].y)
        end
        if self:gotoPos(_x,_y)  then
          self.actionindex=self.actionindex+1
        end
      elseif action[1] == "patrol" then
        if self:lookAround()  then
          self.actionindex=self.actionindex+1
        end
      else
        self.actionindex=self.actionindex+1
      end
      self.actionindexlast = self.actionindex
    end
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

function enemy:canHearPlayer()
  if GAMEOBJECT.player.moved == false then
    return false, nil, nil
  end
  local _hear = false
  local dist = math.sqrt((self.x-GAMEOBJECT.player.x)^2+(self.y-GAMEOBJECT.player.y)^2)
  if dist < self.tilesize*2 then
    _hear = true
  end
  if _hear then
    self.lastheardir=GAMEOBJECT:getDir(self.x,self.y,GAMEOBJECT.player.x,GAMEOBJECT.player.y)
    return true, self.lastheardir
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
    if i>1 or pathSize==1 then
      table.insert(self.path,{x=_x2,y=_y2})
    end
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
  if self.x==x and self.y == y or #self.path==0 then
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

function enemy:lookAround()
  if self.lookaroundx ~= self.x or self.lookaroundy ~= self.y then
    self.lookaroundindex=0
    self.lookaroundtimer=40
    self.lookaroundx = self.x 
    self.lookaroundy = self.y
  end
  local _dir = DIRECTIONS.dir(self.lookaroundindex%4+1)
  if self:checkWalkability(_dir) then
    self.direction=_dir
    self:position(self.x,self.y)
    self.lookaroundtimer=self.lookaroundtimer-1
    if self.lookaroundtimer<=0 then
      self.lookaroundindex=self.lookaroundindex+1
      self.lookaroundtimer=40
    end
  else
    self.lookaroundindex=self.lookaroundindex+1
    self.lookaroundtimer=40
  end
  if self.lookaroundindex>3 then
    return true
  end
  return false
end

function enemy:randomPlaceDir(_noisedir)
  -- TODO: real random e non coordinate esatte
  return GAMEOBJECT.player.x,GAMEOBJECT.player.y
end

return enemy