local _level={}
_level.number,_level.layer=...
_level.name="Level : ".._level.number
--_level:enterlevelLoad=function (layer) end
--_level:enterLevelUpdate=function () end
--_level:enterLevelUnload=function () end
--_level:update=function () end
--_level:unload=function () end
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
return _level