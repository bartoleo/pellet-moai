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
....#*****$******#...|10
....#@           #...|11
....# ########## #...|12
....# ****$***** #...|13
....#      A     #...|14
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
  gui_A={pos="A",char=4,actions={"lookAround"}}
}
_level.objects={
}
--- enterlevel custom ---------------------------------------------------------------------
_level.enterLevelWait = 3.7
function _level.enterlevelLoad(self,layer)
    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,32"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -250, -250, 250, 250 )
    self.textbox1:setString ("use wasd keys to move player\nget all the pellets\navoid enemies\nenemies can see or hear you" )
    self.textbox1:setLoc ( 0, 0)
    self.textbox1:spool (  )
    layer:insertProp ( self.textbox1 )
end
--function _level.enterLevelUpdate(self) end
--function _level.enterLevelUnload(self) end
--- level custom callbacks -------------------------------------------------------------------
--function _level.update(self) end
--fucntion _level.unload (self) end

return _level