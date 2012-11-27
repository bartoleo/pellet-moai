module ( "storage", package.seeall )

----------------------------------------------------------------
----------------------------------------------------------------
-- variables
----------------------------------------------------------------
local storage = {}

----------------------------------------------------------------
-- exposed functions
----------------------------------------------------------------
function get ( filename )

	if not storage [ filename ] then
		storage [ filename ] = makeStorage ( filename )
		storage [ filename ]:loadGame ()
	end

	return storage [ filename ]
end

----------------------------------------------------------------
-- local functions
----------------------------------------------------------------
function makeStorage ( filename )

	local storage = {}

	storage.filename = filename
	storage.fileexist = false
	storage.data = nil

	----------------------------------------------------------------
	storage.loadGame = function ( self )

		local fullFileName = self.filename .. ".lua"
		local workingDir

		if DEVICE then
			workingDir = MOAIFileSystem.getWorkingDirectory ()
			MOAIFileSystem.setWorkingDirectory ( MOAIEnvironment.documentDirectory )
		end

		if MOAIFileSystem.checkFileExists ( fullFileName ) then
			local file = io.open ( fullFileName, 'rb' )
			storage.data = dofile ( fullFileName )
			self.fileexist = true
		else
			storage.data = {}
			self.fileexist = false
		end

		if DEVICE then
			MOAIFileSystem.setWorkingDirectory ( workingDir )
		end

		return self.fileexist
	end

	----------------------------------------------------------------
	storage.saveGame = function ( self )

		local fullFileName = self.filename .. ".lua"
		local workingDir
		local serializer = MOAISerializer.new ()

		self.fileexist = true
		serializer:serialize ( self.data )
		local gamestateStr = serializer:exportToString ()

		if not DEVICE then
			local file = io.open ( fullFileName, 'wb' )
			file:write ( gamestateStr )
			file:close ()

		else
			workingDir = MOAIFileSystem.getWorkingDirectory ()
			MOAIFileSystem.setWorkingDirectory ( MOAIEnvironment.documentDirectory )

			local file = io.open ( fullFileName, 'wb' )
			file:write ( gamestateStr )
			file:close ()
			MOAIFileSystem.setWorkingDirectory ( workingDir )
		end
	end

	return storage
end
