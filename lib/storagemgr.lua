module ( "storagemgr", package.seeall )

----------------------------------------------------------------
----------------------------------------------------------------
-- variables
----------------------------------------------------------------
local storage = {}

----------------------------------------------------------------
-- exposed functions
----------------------------------------------------------------
function get ( filename, cache )

	if cache then
		if not storage [ filename ] then
			storage [ filename ] = makeStorage ( filename )
			storage [ filename ]:load ()
		end
        return storage [ filename ]
	else
		local _storage = makeStorage ( filename )
		_storage:load ()
		return _storage
	end

end

function put ( filename, data )
	local _storage = makeStorage ( filename )
	_storage.data = data
	_storage:save ()
end

function clearCache()
	storage={}
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
	storage.load = function ( self )

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
	storage.save = function ( self )

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
