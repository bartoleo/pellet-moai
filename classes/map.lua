--- map

local map = SECS_class:new()

function map:init(layer,changeResConstant)
  --- common properties for map
  self.layer=layer
  -- this will be the source deck for the grid deck
  self.tileDeck = MOAITileDeck2D.new ()
  self.tileDeck:setTexture ( images.dungeon )
  self.tileDeck:setSize ( 16, 16 )
  self.tileDeck:setRect ( -0.5, 0.5, 0.5, -0.5 )

  self.grid_width = 21
  self.grid_height = 22
  self.grid_tilesize = 16
  self.grid_tilesize = self.grid_tilesize*changeResConstant
end

function map:update()
end

function map:parseLevelMap()
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
  GAMEOBJECT.level.pos = {}
  for line in GAMEOBJECT.level.textmap:gmatch("[^\r\n]+") do
    row = row + 1
    cols = {}
    cols[0]=" "
    cols[self.grid_width+1]=" "
    for i = 1, #line do
      if i<=self.grid_width then
        c = line:sub(i,i)
        if c == "@" then
          GAMEOBJECT.level.startx=i
          GAMEOBJECT.level.starty=row
          c=" "
        elseif c >="a" and c<="z" then
          GAMEOBJECT.level.pos[c] = {x=i,y=row}
          c=" "
        elseif c >="0" and c<="9" then
          GAMEOBJECT.level.pos[c] = {x=i,y=row}
          c=" "
        end
        cols[i]=c
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
      n,n2,n3=self:applyrule(c,cn,cnw,cw,csw,cs,cse,ce,cne)
      if n2>0 then
        self.coins = self.coins + 1
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

self.remappercoins = MOAIDeckRemapper.new ()
self.remappercoins:reserve ( self.grid_width*self.grid_height )
self.gridcoinsProp:setRemapper ( self.remappercoins )

self.curvecoins = MOAIAnimCurve.new ()

self.curvecoins:reserveKeys ( 8 )
self.curvecoins:setKey ( 1, 0.00, 129, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 2, 0.25, 130, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 3, 0.50, 131, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 4, 0.75, 132, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 5, 1.00, 131, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 6, 1.25, 132, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 7, 1.50, 130, MOAIEaseType.FLAT )
self.curvecoins:setKey ( 8, 3.55, 129, MOAIEaseType.FLAT )

self.animcoins = MOAIAnim:new ()
self.animcoins:reserveLinks ( 1 )
self.animcoins:setLink ( 1, self.curvecoins,self.remappercoins, 129 )
self.animcoins:setMode ( MOAITimer.LOOP )
self.animcoins:start ()


end

function map:los(x0,y0,x1,y1)
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
    _xm,_ym = self.gridwalls:locToCoord (x,y)
    if self.gridwalls:getTile (_xm,_ym ) == 0 then
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

function map:isDirection(direction,x0,y0,x1,y1)
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


function map:getRndTile()
  local _x,_y
  while true do
    _x = math.random(1,self.grid_width)
    _y = math.random(1,self.grid_height)
    if self.gridwalls:getTile (_x,_y ) > 0 then
      return _x,_y
    end
  end
end

function map:update()
end

function map:unload()
  if self.layer and self.gridProp then
    self.layer:removeProp ( self.gridProp )
  end
  if self.layer and self.gridcoinsProp then
    self.layer:removeProp ( self.gridcoinsProp )
  end
end

function map:applyrule(type,n,nw,w,sw,s,se,e,ne)
  local tile,walk,coin=0,0,0
  local _r=self.tilesrules[type]
  if _r==nil then
    _r=self.tilesrules[" "]
  end
  local _value
  local _expr
  local _tab = {n=n,nw=nw,w=w,sw=sw,s=s,se=se,e=e,ne=ne}
  if _r then
    tile=_r.default
    walk=_r.walk
    coin=_r.coin
    if _r.rules then
      for i,v in ipairs(_r.rules) do
        _value = true
        for kk,vv in pairs(v) do
          if kk~="tile" then
            for expr in vv:gmatch("[^&]+") do
              if string.sub(expr,1,1)=="!" then
                if _tab[kk]==string.sub(expr,2,2) then
                  _value=false
                  break
                end
              else
                if _tab[kk]~=string.sub(expr,1,1) then
                  _value=false
                  break
                end
              end
            end
          end
        end
        if _value then
          tile=v.tile
          break
        end
      end
    end
  end
  return tile,coin,walk
end

map.tilesrules=
{
  [" "]={default=2,walk=1,coin=129,rules={
          {tile=113,n="|"},
          {tile=50,w="*"},
          {tile=18,w="#",nw="!#&!*&!|"},
          {tile=50,w="#",sw="!#&!*&!|"},
          {tile=34,w="#"},
        }},
  ["*"]={default=3,walk=0,coin=0,rules={
          {tile=19,n="#",w="#"},
          {tile=35,w="#"},
          {tile=114,w="|"}
        }},
  ["|"]={default=81,walk=0,coin=0,rules={
        }},
  ["#"]={default=25,walk=0,coin=0,rules={
                { tile= 117,s="|",n="!#" } ,
                { tile= 65,s="|" } ,
                { tile= 25,nw="#", n="#", ne="#", w="#", e="#", sw="#", s="#", se="#" } ,
                --- Row 1 ---
                { tile=  7,nw="!#", n="!#", ne="!#", w="!#", e="!#", s="#"} ,
                { tile=  8,n="!#", w="!#", e="#", s="#", se="#" } ,
                { tile=  9,n="!#", w="#", e="#", sw="#", s="#", se="#" } ,
                { tile= 10,n="!#", w="#", e="!#", sw="#", s="#" } ,
                { tile= 11,n="!#", w="!#", e="#", s="#", se="!#" } ,
                { tile= 12,n="!#", w="#", e="#", sw="!#", s="#", se="!#" } ,
                { tile= 13,n="!#", w="#", e="!#", sw="!#", s="#" } ,
                { tile= 14,nw="#", n="#", ne="#", w="#", e="#", sw="#", s="#", se="!#"} ,
                { tile= 15,nw="#", n="#", ne="#", w="#", e="#", sw="!#", s="#", se="!#"} ,
                { tile= 16,nw="#", n="#", ne="#", w="#", e="#", sw="!#", s="#", se="#"} ,
                --- Row 2 ---
                { tile= 23,n="#", w="!#", e="!#", s="#" } ,
                { tile= 24,n="#", ne="#", w="!#", e="#", s="#", se="#" } ,
                --{ tile= 24,nw="#", n="#", ne="#", w="#", e="#", sw="#", s="#", se="#" } ,
                { tile= 26,nw="#", n="#", w="#", e="!#", sw="#", s="#" } ,
                { tile= 27,n="#", ne="!#", w="!#", e="#", s="#", se="!#" } ,
                { tile= 28,nw="!#", n="!#", ne="!#", w="!#", e="!#", sw="!#", s="!#", se="!#" } ,
                { tile= 29,nw="!#", n="#", w="#", e="!#", sw="!#", s="#" } ,
                { tile= 30,nw="#", n="#", ne="!#", w="#", e="#", sw="#", s="#", se="!#" } ,
                { tile= 31,nw="!#", n="#", ne="!#", w="#", e="#", sw="!#", s="#", se="!#" } ,
                { tile= 32,nw="!#", n="#", ne="#", w="#", e="#", sw="!#", s="#", se="#" } ,
                --- Row 3 ---
                { tile= 39,n="#", w="!#", e="!#", s="!#" } ,
                { tile= 40,n="#", ne="#", w="!#", e="#", s="!#" } ,
                { tile= 41,nw="#", n="#", ne="#", w="#", e="#", s="!#" } ,
                { tile= 42,nw="#", n="#", w="#", e="!#", s="!#" } ,
                { tile= 43,n="#", ne="!#", w="!#", e="#", s="!#" } ,
                { tile= 44,nw="!#", n="#", ne="!#", w="#", e="#", s="!#" } ,
                { tile= 45,nw="!#", n="#", w="#", e="!#", s="!#" } ,
                { tile= 46,nw="#", n="#", ne="!#", w="#", e="#", sw="#", s="#", se="#" } ,
                { tile= 47,nw="!#", n="#", ne="!#", w="#", e="#", sw="#", s="#", se="#" } ,
                { tile= 48,nw="!#", n="#", ne="#", w="#", e="#", sw="#", s="#", se="#" } ,
                --- Row 4 ---
                { tile= 56,n="!#", w="!#", e="#", s="!#" } ,
                { tile= 57,n="!#", w="#", e="#", s="!#" } ,
                { tile= 58,n="!#", w="#", e="!#", s="!#" } ,
                { tile= 59,n="!#", w="#", e="#", sw="#", s="#", se="!#" } ,
                { tile= 60,nw="#", n="#", w="#", e="!#", sw="!#", s="#" } ,
                { tile= 61,n="#", ne="#", w="!#", e="#", s="#", se="!#" } ,
                { tile= 62,n="!#", w="#", e="#", sw="!#", s="#", se="#" } ,
                { tile= 63,nw="#", n="#", ne="!#", w="#", e="#", sw="!#", s="#", se="!#" } ,
                { tile= 64,nw="!#", n="#", ne="#", w="#", e="#", sw="!#", s="#", se="!#" } ,
                --- Row 5 ---
                { tile= 73,nw="#", n="#", ne="!#", w="#", e="#", sw="!#", s="#", se="#" } ,
                { tile= 74,nw="!#", n="#", ne="#", w="#", e="#", sw="#", s="#", se="!#" } ,
                { tile= 75,n="#", ne="!#", w="!#", e="#", s="#", se="#" } ,
                { tile= 76,nw="!#", n="#", ne="#", w="#", e="#", s="!#" } ,
                { tile= 77,nw="#", n="#", ne="!#", w="#", e="#", s="!#" } ,
                { tile= 78,nw="!#", n="#", w="#", e="!#", sw="#", s="#" } ,
                { tile= 79,nw="!#", n="#", ne="!#", w="#", e="#", sw="#", s="#", se="!#" } ,
                { tile= 80,nw="!#", n="#", ne="!#", w="#", e="#", sw="!#", s="#", se="#" } ,
        }}
}

return map