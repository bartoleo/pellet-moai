--- gameobject

local gameobject = SECS_class:new()

function gameobject:init(layer,layerGui)
  --- common properties for gameobject
  self.objects={}
  self.objectsId={}
  self.layer=layer
  self.layerGui = layer

  self.lifes = 3

  self.changeResConstant = 1.875

  self.charTileLib = MOAITileDeck2D.new ()
  self.charTileLib:setTexture ( images.pg)
  self.charTileLib:setSize ( 20, 46 )
  self.charTileLibSize = 26*self.changeResConstant
  self.charTileLib:setRect ( -self.charTileLibSize/2, -self.charTileLibSize/2, self.charTileLibSize/2, self.charTileLibSize/2 )

  self.textboxLevel = MOAITextBox.new ()
  self.textboxLevel:setFont ( fonts["resource,32"] )
  self.textboxLevel:setAlignment ( MOAITextBox.LEFT_JUSTIFY )
  self.textboxLevel:setYFlip ( true )
  self.textboxLevel:setRect ( -utils.screen_middlewidth, -20, utils.screen_middlewidth, 20 )
  self.textboxLevel:setString ( "" )
  self.textboxLevel:setLoc ( 0, utils.screen_middleheight-40)
  self.layerGui:insertProp ( self.textboxLevel )

  self.textboxCoins = MOAITextBox.new ()
  self.textboxCoins:setFont ( fonts["resource,32"] )
  self.textboxCoins:setAlignment ( MOAITextBox.LEFT_JUSTIFY )
  self.textboxCoins:setYFlip ( true )
  self.textboxCoins:setRect ( -utils.screen_middlewidth, -20, utils.screen_middlewidth, 20 )
  self.textboxCoins:setString ( "" )
  self.textboxCoins:setLoc ( 0, utils.screen_middleheight-80)
  self.layerGui:insertProp ( self.textboxCoins )

  self.textboxLifes = MOAITextBox.new ()
  self.textboxLifes:setFont ( fonts["resource,32"] )
  self.textboxLifes:setAlignment ( MOAITextBox.LEFT_JUSTIFY )
  self.textboxLifes:setYFlip ( true )
  self.textboxLifes:setRect ( -utils.screen_middlewidth, -20, utils.screen_middlewidth, 20 )
  self.textboxLifes:setString ( "Lifes:" )
  self.textboxLifes:setLoc ( 0, utils.screen_middleheight-120)
  self.layerGui:insertProp ( self.textboxLifes )


end

function gameobject:update()
  self.textboxCoins:setString ( "Coins left : "..self.coins )
  self:objectsDo("update",nil)
  if self:checkWin() then
    self:objectsDo("stop",nil)
    return "WIN"
  end
  if self:checkLose()==true then
    self:objectsDo("stop",nil)
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
  self:reinitLevel()
end

function gameobject:parseLevelMap()
  -- this will be the source deck for the grid deck
  self.tileDeck = MOAITileDeck2D.new ()
  self.tileDeck:setTexture ( images.dungeon )
  self.tileDeck:setSize ( 16, 16 )
  self.tileDeck:setRect ( -0.5, 0.5, 0.5, -0.5 )

  self.grid_width = 21
  self.grid_height = 22
  self.grid_tilesize = 16
  self.grid_tilesize = self.grid_tilesize*self.changeResConstant
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
        local _x,_y
        if type(v.pos)=="string" then
          _x,_y = self.level.pos[v.pos].x,self.level.pos[v.pos].y
        end
        local _baseframe = 61
        if v.char then
          _baseframe = 20*v.char+1
        end
        local _enemy = classes.enemy:new(v.name,v.id,_x,_y,_baseframe,self.charTileLib,self.charTileLibSize)
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
    if (angle>=-_pi and angle <= -3*_pi/4) or (angle>=3*_pi/4 and angle <= _pi) then
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
  self.textboxLevel:setString ( self.level.name )
  if self.propsLifes then
    for i,v in ipairs(self.propsLifes) do
      self.layerGui:removeProp(v)
    end
  end
  self.propsLifes={}
  for i=1,self.lifes do
    local prop = MOAIProp2D.new ()
    prop:setDeck ( self.charTileLib )
    prop:setIndex ( 61 )
    prop:setLoc(-285+i*(self.charTileLibSize-12*self.changeResConstant),utils.screen_middleheight-110)
    prop:setScl(0.7,0.7)
    self.layerGui:insertProp ( prop )
    table.insert(self.propsLifes,prop)
  end
  self:clearObjects()
  self:parseLevelEnemies()
  self.player = classes.player:new(self.level.startx,self.level.starty,61,self.charTileLib,self.charTileLibSize)
  self:registerObject(self.player)
end

function gameobject:clearObjects()
  for i=#self.objects,1,-1 do
    local v = self.objects[i]
    if v.unload then
      v:unload()
    end
    self.objectsId[v.id]=nil
    table.remove(self.objects,i)
  end
end

function gameobject:objectsDo(action,filtertype,...)
  for i,v in ipairs(self.objects) do
    if filtertype==nil or v.type==filtertype then
      if v[action] then
        v[action](v,...)
      end
    end
  end
end

function gameobject:unload()
  self:clearObjects()
end

return gameobject