config =  require("config")
require "lib/SECS"
require "lib/utils"
require "lib/simplegui"
require "lib/statemgr"
require "lib/inputmgr"
require "lib/soundmgr"
require "lib/storage"
require "lib/assetloader"
require "lib/directions"

if  MOAIFileSystem.checkFileExists ("is"..MOAIEnvironment.osBrand..".lua") then
  require ("is"..MOAIEnvironment.osBrand)
end

function main()

  utils.init_screen("Pellet-MOAI",config,640,960)

  soundmgr.init(nil,16,44000,512)

  -- seed random numbers
  math.randomseed ( os.time ())
  globalData = {}

  JUMP_TO = nil
  statemgr.push ( JUMP_TO or "intro" )

  -- Start the game!
  statemgr.begin ()

end

main()