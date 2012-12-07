--- object

local object = SECS_class:new()

function object:initGfx(pbaseframe,ptilelib,ptilesize,psymbol)

  self.baseframe = pbaseframe

  self.tilesize = ptilesize

  self.tileLib = ptilelib

  self.prop = MOAIProp2D.new ()
  self.prop:setDeck ( self.tileLib )
  self.prop:setIndex ( self.baseframe )
  GAMEOBJECT.layer:insertProp ( self.prop )

end

function object:changeAnim(panim)
  if self.animact then
    self.animact:stop()
  end
  self.anim = MOAIAnim:new ()
  self.anim:reserveLinks ( 1 )
  self.anim:setLink ( 1, self["anim"..panim], self.prop, MOAIProp2D.ATTR_INDEX )
  self.animact = self.anim:start ()
  self.lastanim = panim
end

function object:unload()
  GAMEOBJECT.layer:removeProp ( self.prop )
  self.prop = nil
  self.animact = nil
end

function object:stop()
  if self.animact then
    self.animact:stop()
  end
end

function object:start()
  if self.animact then
    self.animact:start()
  end
end

function object:position(px,py)
  self.x = px
  self.y = py
  self.prop:setLoc(-GAMEOBJECT.map.grid_width*GAMEOBJECT.map.grid_tilesize/2+self.x, GAMEOBJECT.map.grid_height*GAMEOBJECT.map.grid_tilesize/2-self.y)
end

return object