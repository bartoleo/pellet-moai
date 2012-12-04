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
#    1    a    4    #|12
# # # #### #### # # #|13
# # # **** **** # # #|14
# # #     5    b# # #|15
# # ###### ###### # #|16
# # ****** ****** # #|17
# #               # #|18
# ######## ######## #|19
# ******** ******** #|20
#         c         #|21
#####################|22
]]
_level.enemies={
   guy_a={pos="a",char=4,actions={"goto_1","lookAround","goto_2","lookAround","goto_3","lookAround","goto_a","lookAround"}}
  ,guy_b={pos="b",char=4,actions={"goto_4","lookAround","goto_a","lookAround","goto_5","lookAround","goto_b","lookAround"}}
  ,guy_c={pos="c",char=6,actions={"goto_rnd","lookAround"}}
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