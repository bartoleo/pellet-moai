local _level={}
_level.number,_level.layer=...
_level.name="Level : ".._level.number
_level.textmap=[[
.....................|01
.....................|02
.....................|03
..........#####......|04
..........#  b#......|05
..........# # #......|06
..........# # #......|07
..........# # #......|08
....####### # #######|09
....#****** * ******#|10
....#      @        #|11
....# ############# #|12
....# ************* #|13
....#      a        #|14
....#################|15
.....................|16
.....................|17
.....................|18
.....................|19
.....................|20
.....................|21
.....................|22
]]
_level.enemies={
   guy_a={pos="a",char=4,actions={"goto_a","lookAround"}}
  ,guy_b={pos="b",char=4,actions={"goto_b","lookAround"}}
}
--- enterlevel custom ---------------------------------------------------------------------
--_level.enterLevelWait = 2
--_level.enterlevelLoad = function (self,layer) end
--_level.enterLevelUpdate=function (self) end
--_level.enterLevelUnload=function (self) end
--- level custom callbacks -------------------------------------------------------------------
--_level.update=function (self) end
--_level.unload=function (self) end
return _level