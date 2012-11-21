--- gameobject

local gameobject = SECS_class:new()

function gameobject:init(layer)
  --- common properties for gameobject
  self.objects={}
  self.objectsId={}
  self.layer=layer

  self.lifes=3

  self.charTileLib = MOAITileDeck2D.new ()
  self.charTileLib:setTexture ( images.pg)
  self.charTileLib:setSize ( 20, 46 )
  self.charTileLibSize = 26*1.875
  self.charTileLib:setRect ( -self.charTileLibSize/2, -self.charTileLibSize/2, self.charTileLibSize/2, self.charTileLibSize/2 )

end

function gameobject:update()
  for i,v in ipairs(self.objects) do
    if v.update then
      v:update()
    end
  end
  if self:checkWin() then
    return "WIN"
  end
  if self:checkLose()==true then
    return "LOSE"
  end
end

function gameobject:registerObject(object)
  if object.id == nil then
    object.id = utils.generateId(object.type)
  end
  table.insert(self.objects,object)
  self.objectsId[object.id]=object
end

function gameobject:clearlevel()
  self.objects={}
  self.objectsId={}
end

function gameobject:initLevel(plevelnum)
  self:clearlevel()
  self.level = dofile ( "levels/level"..string.format("%03u",plevelnum)..".lua" )
  self:parseLevelMap()
  self:parseLevelEnemies()
  self.player = classes.player:new(self.level.startx,self.level.starty,41,self.charTileLib,self.charTileLibSize)
  self:registerObject(self.player)
end

function gameobject:parseLevelMap()
  -- this will be the source deck for the grid deck
  self.tileDeck = MOAITileDeck2D.new ()
  self.tileDeck:setTexture ( images.dungeon )
  self.tileDeck:setSize ( 16, 16 )
  self.tileDeck:setRect ( -0.5, 0.5, 0.5, -0.5 )

  self.grid_width = 20
  self.grid_height = 22
  self.grid_tilesize = 16
  self.grid_tilesize = self.grid_tilesize*1.875
  self.coins = 0

  self.grid = MOAIGrid.new ()
  self.grid:setSize ( self.grid_width, self.grid_height, self.grid_tilesize, self.grid_tilesize )

  self.gridcoins = MOAIGrid.new ()
  self.gridcoins:setSize ( self.grid_width, self.grid_height, self.grid_tilesize, self.grid_tilesize )

  self.gridwalls = MOAIGrid.new ()
  self.gridwalls:setSize ( self.grid_width, self.grid_height, self.grid_tilesize, self.grid_tilesize )

  self.map = {}
  local emptyrow = {}
  for i=0,self.grid_width+1 do
    emptyrow[i]=" "
  end
  self.map[0]=emptyrow
  self.map[self.grid_height+1]=emptyrow

  local row = 0
  local cols = {}
  local c = " "
  local n = 0
  self.level.pos = {}
  for line in self.level.textmap:gmatch("[^\r\n]+") do
    row = row + 1
    cols = {}
    cols[0]=" "
    cols[self.grid_width+1]=" "
    for i = 1, #line do
      if i<=self.grid_width then
        c = line:sub(i,i)
        if c == "@" then
          self.level.startx=i
          self.level.starty=row
          c=" "
        elseif c >="a" and c<="z" then
          self.level.pos[c] = {x=i,y=row}
          c=" "
        end
        cols[i]=line:sub(i,i)
      end
    end
    self.map[row]=cols
  end

  for i=1,self.grid_height do
    cols = {}
    colscoins = {}
    colswalls = {}
    for j = 1, self.grid_width do
      n = 0
      n2 = 0
      n3 = 0
      c = self.map[i][j]
      cn = self.map[i-1][j]
      cnw = self.map[i-1][j-1]
      cw = self.map[i][j-1]
      csw = self.map[i+1][j-1]
      cs = self.map[i+1][j]
      cse = self.map[i+1][j+1]
      ce = self.map[i][j+1]
      cne = self.map[i-1][j+1]
      if c=="#" then
        n = 25
      elseif c=="*" then
        n = 3
        if cw=="#" then
          n = 35
          if cn=="#" then
            n = 19
          end
        end
      else
        n = 2
        n2 = 102
        n3 = 1
        self.coins = self.coins + 1
        if cw=="#" then
          n = 34
          if csw~="#" and csw~="*" then
            n = 50
          end
          if cnw~="#" and csw~="*"  then
            n = 18
          end
        end
        if cw=="*" then
          n = 50
        end
      end
      table.insert(cols,n)
      table.insert(colscoins,n2)
      table.insert(colswalls,n3)
    end
    self.grid:setRow ( i,unpack(cols))
    self.gridcoins:setRow ( i,unpack(colscoins))
    self.gridwalls:setRow ( i,unpack(colswalls))
  end

  self.gridProp = MOAIProp2D.new ()
  self.gridProp:setDeck ( self.tileDeck )
  self.gridProp:setGrid ( self.grid )
  self.gridProp:setScl ( 1, -1 )
  self.gridProp:setLoc ( -self.grid_width*self.grid_tilesize/2, self.grid_height*self.grid_tilesize/2 )
  self.layer:insertProp ( self.gridProp )

  self.gridcoinsProp = MOAIProp2D.new ()
  self.gridcoinsProp:setDeck ( self.tileDeck )
  self.gridcoinsProp:setGrid ( self.gridcoins )
  self.gridcoinsProp:setScl ( 1, -1 )
  self.gridcoinsProp:setLoc ( -self.grid_width*self.grid_tilesize/2, self.grid_height*self.grid_tilesize/2 )
  self.layer:insertProp ( self.gridcoinsProp )

end

function gameobject:parseLevelEnemies()
  if self.level.enemies then
    for k,v in pairs(self.level.enemies) do
      for times=1,1 do
        local _enemy = classes.enemy:new(v.name,v.id,self.level.pos[k].x,self.level.pos[k].y,101,self.charTileLib,self.charTileLibSize)
        self:registerObject(_enemy)
      end
    end
  end
end

function gameobject:checkWin()
  if self.coins <= 0 then
    return true
  end
  return false
end

function gameobject:checkLose()
  if self.player then
    for k,v in pairs(self.objects) do
      if v.type=="enemy" then
        if math.abs(v.x-self.player.x)<self.grid_tilesize and math.abs(v.y-self.player.y)<self.grid_tilesize then
          return true
        end
      end
    end
  end
  return false
end

function gameobject:los(x0,y0,x1,y1)
  local dx = math.abs(x1 - x0)
  local dy = math.abs(y1 - y0)
  local x = x0
  local y = y0
  local n = 1 + dx + dy
  local x_inc = 1
  if x1 < x0 then
    x_inc = -1
  end
  local y_inc = 1
  if y1 < y0 then
    y_inc = -1
  end
  local error = dx - dy
  dx = dx*2
  dy = dy*2
  local _xm,_ym
  while n>0 do
    _xm,_ym = GAMEOBJECT.gridwalls:locToCoord (x,y)
    if GAMEOBJECT.gridwalls:getTile (_xm,_ym ) == 0 then
      return false
    end

    if error > 0 then
         x = x + x_inc
         error = error-dy
    else
       y = y + y_inc;
       error = error + dx
    end
    n = n - 1
  end
  return true
end

function gameobject:isDirection(direction,x0,y0,x1,y1)
  local angle = math.atan2(y1-y0, x1-x0)
  local _pi = math.pi
  if direction=="e" or direction==nil then
    if angle>=-_pi/4 and angle <= _pi/4 then
      return true
    end
  elseif direction=="n" then
    if angle>=-3*_pi/4 and angle <= -_pi/4 then
      return true
    end
  elseif direction=="w" then
    if angle>=-_pi and angle <= -3*_pi/4 and angle>=3*_pi/4 and angle <= _pi then
      return true
    end
  elseif direction=="s" then
    if angle>=_pi/4 and angle <= 3*_pi/4 then
      return true
    end
  end
  return false
end

function gameobject:reinitLevel()
end

return gameobject