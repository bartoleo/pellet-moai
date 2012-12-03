config =  require("config")
require "lib/SECS"
require "lib/utils"
require "lib/simplegui"
require "lib/statemgr"
require "lib/inputmgr"
require "lib/soundmgr"
require "lib/storagemgr"
require "lib/assetloader"
require "lib/directions"

if  MOAIFileSystem.checkFileExists ("is"..MOAIEnvironment.osBrand..".lua") then
  require ("is"..MOAIEnvironment.osBrand)
end

function main()

  utils.init_screen("Pellet Stealth",config,640,960)

  soundmgr.init(nil,16,44100,512,1)

  local _storage=storagemgr.get("_settings")
  if _storage.data then
    if _storage.data.globalvolume then
      soundmgr.setGlobalVolume(_storage.data.globalvolume)
    end
  end

  -- seed random numbers
  math.randomseed ( os.time ())
  globalData = {}

  JUMP_TO = nil
  statemgr.push ( JUMP_TO or "intro" )

  -- Start the game!
  statemgr.begin ()

end

main()