local _level={}
_level.number,_level.layer=...
_level.name="Level : ".._level.number
_level.textmap=[[
#####################|01
#******|******|*****#|02
#                   #|03
# ######## ######## #|04
# #******* *******# #|05
# #      @        # #|06
# # ###### ###### # #|07
# # #***** *****# # #|08
# # #2    3     # # #|09
# # # #### #### # # #|10
# * * **** **** * * #|11
#    1    A    4    #|12
# # # #### #### # # #|13
# # # **** **** # # #|14
# # #     5    B# # #|15
# # ###### ###### # #|16
# # ****** ****** # #|17
# #               # #|18
# ######## ######## #|19
# ******** ******** #|20
#         C         #|21
#####################|22
]]
_level.enemies={
   guy_A={pos="A",char=4,actions={"goto_1","lookAround","goto_2","lookAround","goto_3","lookAround","goto_A","lookAround"}}
  ,guy_B={pos="B",char=4,actions={"goto_4","lookAround","goto_A","lookAround","goto_5","lookAround","goto_B ","lookAround"}}
  ,guy_C={pos="C",char=6,actions={"goto_rnd","lookAround"}}
}
_level.objects={
}
--- enterlevel custom ---------------------------------------------------------------------
--_level.enterLevelWait = 2
--funciton _level.enterlevelLoad(self,layer) end
--function _level.enterLevelUpdate(self) end
--function _level.enterLevelUnload(self) end
--- level custom callbacks -------------------------------------------------------------------
--function _level.update(self) end
--fucntion _level.unload (self) end
return _level