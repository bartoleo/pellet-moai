local _level={}
_level.number=1
_level.name="Level : ".._level.number
_level.update=function () end
_level.textmap=[[
#####################|01
#*******************#|02
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
   guya={pos="a",char=4,actions={"goto_1","patrol","goto_2","patrol","goto_3","patrol","goto_a","patrol"}}
  ,guyb={pos="b",char=4,actions={"goto_4","patrol","goto_a","patrol","goto_5","patrol","goto_b","patrol"}}
  ,guyc={pos="c",char=6,actions={"goto_rnd","patrol"}}
}
return _level