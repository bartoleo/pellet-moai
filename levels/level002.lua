local _level={}
_level.number,_level.layer=...
_level.name="Level : ".._level.number
_level.textmap=[[
.....................|01
.....................|02
.....................|03
........#####........|04
........#b3B#........|05
........# # #........|06
........# # #........|07
........# # #........|08
..####### # #######..|09
..#**$*** * ***$**#..|10
..#       @   4   #..|11
..#1########'####2#..|12
..# ********5**** #..|13
..#      A        #..|14
..#################..|15
.....................|16
.....................|17
.....................|18
.....................|19
.....................|20
.....................|21
.....................|22
]]
_level.enemies={
   guy_A={pos="A",char=4,actions={"goto_A","lookAround"}}
  ,guy_B={pos="B",char=4,actions={"goto_b","lookAround","goto_B","lookAround"}}
}
_level.objects={
   gate1={pos="1",type="gate",gatetype="horizontal",opened=true,start=0,timeopen=180,timeclose=180}
  ,gate2={pos="2",type="gate",gatetype="horizontal",opened=true,start=90,timeopen=180,timeclose=180}
  ,chest3={pos="3",type="chest"}
  ,key4={pos="4",type="key"}
  ,door5={pos="5",type="door"}
}
--- enterlevel custom ---------------------------------------------------------------------
--_level.enterLevelWait = 2
function _level.enterlevelLoad(self,layer)
    self.textbox1 = MOAITextBox.new ()
    self.textbox1:setFont ( fonts["resource,32"] )
    self.textbox1:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
    self.textbox1:setYFlip ( true )
    self.textbox1:setRect ( -250, -250, 250, 250 )
    self.textbox1:setString ("tests!!!!" )
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