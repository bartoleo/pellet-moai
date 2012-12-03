local _level={}
_level.number,_level.layer=...
_level.name="Level : ".._level.number
_level.textmap=[[
.....................|01
.....................|02
.....................|03
.....................|04
.....................|05
.....................|06
.....................|07
.....................|08
....##############...|09
....#************#...|10
....#@           #...|11
....# ########## #...|12
....# ********** #...|13
....#      a     #...|14
....##############...|15
.....................|16
.....................|17
.....................|18
.....................|19
.....................|20
.....................|21
.....................|22
]]
_level.enemies={
  ya={pos="a",char=4,actions={"patrol"}}
}
--- enterlevel custom ---------------------------------------------------------------------
_level.enterLevelWait = 3.7
_level.enterlevelLoad = function (self,layer)
    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,32"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -300, -300, 300, 300 )
    self.textbox1:setString ("use wasd keys to move player\nget all the pellets\navoid enemies\nenemies can see or hear you" )
    self.textbox1:setLoc ( 0, 0)
    self.textbox1:spool (  )
    layer:insertProp ( self.textbox1 )
end
--_level.enterLevelUpdate=function (self) end
--_level.enterLevelUnload=function (self) end
--- level custom callbacks -------------------------------------------------------------------
--_level.update=function (self) end
--_level.unload=function (self) end

return _level