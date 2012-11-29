--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x026CFE08 ]
	table [ "globalvolume" ] = 0.5

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x026CFE08 ] = {},

}

init ( objects )

--Returning Tables
return objects [ 0x026CFE08 ]
