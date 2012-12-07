--- gameobject

local gameobject = SECS_class:new()

function gameobject:init(layer, layerMap, layerGui)
  --- common properties for gameobject
  self.objects={}
  self.objectsId={}
  self.layer = layer
  self.layerMap = layerMap
  layer:setSortMode(MOAILayer2D.SORT_Y_DESCENDING)
  self.layerGui = layer

  self.lifes = 3

  self.changeResConstant = 1.875

  self.charTileLib = MOAITileDeck2D.new ()
  self.charTileLib:setTexture ( images.pg)
  self.charTileLib:setSize ( 20, 46 )
  self.charTileLibSize = 26*self.changeResConstant
  self.charTileLib:setRect ( -self.charTileLibSize/2, -self.charTileLibSize/2, self.charTileLibSize/2, self.charTileLibSize/2 )

  self.dungeonDeck = MOAITileDeck2D.new ()
  self.dungeonDeck:setTexture ( images.dungeon )
  self.dungeonDeck:setSize ( 16, 16 )
  self.dungeonDeckSize = 16*self.changeResConstant
  self.dungeonDeck:setRect ( -self.dungeonDeckSize/2, -self.dungeonDeckSize/2, self.dungeonDeckSize/2, self.dungeonDeckSize/2 )

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
  self.textboxCoins:setString ( "Coins left : "..self.map.coins )
  if self.level and self.level.update then
    self.level:update()
  end
  self.map:update()
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
  if self.level and self.level.unload then
    self.level:unload()
  end
  self:clearObjects()
  if self.map then
    self.map:unload()
    self.map = nil
  end
end

function gameobject:unload()
  self:clearlevel()
end

function gameobject:initLevel(plevelnum)
  self:clearlevel()
  self.level = assert(loadfile( "levels/level"..string.format("%03u",plevelnum)..".lua" ))(plevelnum)
  self.map = classes.map:new(self.layerMap,self.changeResConstant)
  self.map:parseLevelMap()
  self.lifes = 3 or self.level.lifes
  self:reinitLevel()
  return true
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
  self.textboxCoins:setString ( "Coins left : "..self.map.coins )
  self:clearObjects()
  self:parseLevelEnemies()
  self:parseLevelObjects()
  self.player = classes.player:new(self.level.startx,self.level.starty,61,self.charTileLib,self.charTileLibSize)
  self:registerObject(self.player)
end

function gameobject:parseLevelEnemies()
  if self.level.enemies then
    for k,v in pairs(self.level.enemies) do
      local _x,_y
      if type(v.pos)=="string" then
        _x,_y = self.level.pos[v.pos].x,self.level.pos[v.pos].y
      elseif type(v.pos)=="table" then
        _x,_y = v.pos.x,v.pos.y
      end
      local _baseframe = 61
      if v.char then
        _baseframe = 20*v.char+1
      end
      _actions={}
      if v.actions then
        local _action 
        for ii,vv in ipairs(v.actions) do
           _action = {}
           for token in vv:gmatch("[^_]+") do
             table.insert(_action,token)
           end
           table.insert(_actions,_action)
        end
      end
      local _enemy = classes.enemy:new(v.name,v.id,_x,_y,_baseframe,self.charTileLib,self.charTileLibSize,_actions)
      self:registerObject(_enemy)
    end
  end
end

function gameobject:parseLevelObjects()
  if self.level.objects then
    for k,v in pairs(self.level.objects) do
      local _object
      local _x,_y
      if type(v.pos)=="string" then
        _x,_y = self.level.pos[v.pos].x,self.level.pos[v.pos].y
      elseif type(v.pos)=="table" then
        _x,_y = v.pos.x,v.pos.y
      end
      local _baseframe
      if v.type=="gate" then
        if v.gatetype=="horizontal" then
          _baseframe = 161
        end
        _object = classes.gate:new(v.name,v.id,_x,_y,v.gatetype,_baseframe,self.dungeonDeck,self.dungeonDeckSize,v.opened,v.start,v.timeopen,v.timeclose)
      elseif v.type=="key" then
        _baseframe = 135
        _object = classes.key:new(v.name,v.id,_x,_y,v.keytype,_baseframe,self.dungeonDeck,self.dungeonDeckSize)
      elseif v.type=="chest" then
        _baseframe = 136
        _object = classes.chest:new(v.name,v.id,_x,_y,v.keytype,_baseframe,self.dungeonDeck,self.dungeonDeckSize)
      elseif v.type=="door" then
        _baseframe = 151
        _object = classes.door:new(v.name,v.id,_x,_y,v.keytype,_baseframe,self.dungeonDeck,self.dungeonDeckSize)
      end
      if _object then
        self:registerObject(_object)
      end
    end
  end
end

function gameobject:checkWin()
  if self.map.coins <= 0 then
    return true
  end
  return false
end

function gameobject:checkLose()
  if self.player then
    for k,v in pairs(self.objects) do
      if v.type=="enemy" then
        if math.abs(v.x-self.player.x)<self.map.grid_tilesize/2 and math.abs(v.y-self.player.y)<self.map.grid_tilesize/2 then
          return true
        end
      end
    end
  end
  return false
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

function gameobject:getDir(x0,y0,x1,y1)
  local angle = math.atan2(y1-y0, x1-x0)
  local _pi = math.pi
  if angle>=-_pi/4 and angle <= _pi/4 then
    return "e"
  end
  if angle>=-3*_pi/4 and angle <= -_pi/4 then
    return "n"
  end
  if (angle>=-_pi and angle <= -3*_pi/4) or (angle>=3*_pi/4 and angle <= _pi) then
    return "w"
  end
  if angle>=_pi/4 and angle <= 3*_pi/4 then
    return "s"
  end
  return nil
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

return gameobject