--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x0396D8C0 ]
	table [ "levelnumber" ] = 2

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x0396D8C0 ] = {},

}

init ( objects )

--Returning Tables
return objects [ 0x0396D8C0 ]
