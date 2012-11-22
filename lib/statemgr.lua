--==============================================================
-- Copyright (c) 2010-2012 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
--==============================================================

module ( "statemgr", package.seeall )

----------------------------------------------------------------
----------------------------------------------------------------
-- variables
----------------------------------------------------------------
local curState = nil
local loadedStates = {}
local stateStack = {}
local renderLayers = {}

----------------------------------------------------------------
-- run loop
----------------------------------------------------------------
local updateThread = MOAIThread.new ()

local function updateFunction ()

  while true do

    coroutine.yield ()

    if curState then

      if type ( curState.onInput ) == "function" then
        curState:onInput ()
      end

      if type ( curState.onUpdate ) == "function" then
        curState:onUpdate ()
      end

    else
      print ( "WARNING - There is no current state. Please call state.push/state.swap to add a state." )
    end

  end
end


----------------------------------------------------------------
-- local functions
----------------------------------------------------------------
local function rebuildRenderStack ( )

  MOAISim.forceGarbageCollection ()

  renderLayers = {}
  local firststate = 0
  local laststate = 0
  local state
  for i=1,#stateStack do
    state = stateStack[i]
    if state.IS_POPUP then
      laststate = i
    else
      firststate = i
      laststate = i
    end
  end
  if laststate>0 then
    for i=firststate,laststate do
      state = stateStack[i]
      if state.layerTable then
        for j, stacklayer in ipairs ( state.layerTable) do
          for jj, layer in  ipairs ( stacklayer ) do
            table.insert(renderLayers,layer)
          end
        end
      end
    end
  end

  MOAIRenderMgr.setRenderTable(renderLayers)

  MOAISim.forceGarbageCollection ()

end

----------------------------------------------------------------
local function loadState ( stateFile )

  if not loadedStates [ stateFile ] then

    local newState = dofile ( "states/"..stateFile..".lua" )
    loadedStates [ stateFile ] = newState
    loadedStates [ stateFile ].__statename = stateFile
  end

  return loadedStates [ stateFile ]
end

----------------------------------------------------------------
-- functions
----------------------------------------------------------------
function begin ()

  updateThread:run ( updateFunction )
end

----------------------------------------------------------------
function getCurState ( )

  return curState
end

----------------------------------------------------------------
function makePopup ( state )

  state.IS_POPUP = true
end

----------------------------------------------------------------
function pop ( )

  -- do the state's onLoseFocus
  if type ( curState.onLoseFocus ) == "function" then
    curState:onLoseFocus ()
  end

  if curState.callbacks then
    for k,v in pairs(curState.callbacks) do
      MOAIInputMgr.device[k]:setCallback(nil)
    end
  end

  -- do the state's onUnload
  if type ( curState.onUnload ) == "function" then
    curState:onUnload ()
  end

  local prevstatename=nil
  if curState then
    prevstatename = curState.__statename
  end

  curState = nil
  table.remove ( stateStack, #stateStack )
  curState = stateStack [ #stateStack ]

  rebuildRenderStack ()
  MOAISim.forceGarbageCollection ()

  if curState then

    -- do the new current state's onFocus
    if type ( curState.onFocus ) == "function" then
      curState:onFocus (prevstatename )
    end

    if curState.callbacks then
      for k,v in pairs(curState.callbacks) do
        MOAIInputMgr.device[k]:setCallback(v)
      end
    end

  end

end

----------------------------------------------------------------
function push ( stateFile, ... )

  -- do the old current state's onLoseFocus
  if curState then

    if type ( curState.onLoseFocus ) == "function" then
      curState:onLoseFocus ( )
    end
    if curState.callbacks then
      for k,v in pairs(curState.callbacks) do
        MOAIInputMgr.device[k]:setCallback(nil)
      end
    end

  end

  local prevstatename=nil
  if curState then
    prevstatename = curState.__statename
  end

  -- update the current state to the new one
  local newState = loadState ( stateFile )
  table.insert ( stateStack, newState )
  curState = stateStack [ #stateStack ]

  -- do the state's onLoad
  if type ( curState.onLoad ) == "function" then
    curState:onLoad (prevstatename, ... )
  end

  -- do the state's onFocus
  if type ( curState.onFocus ) == "function" then
    curState:onFocus (prevstatename)
  end

  rebuildRenderStack ()
end

----------------------------------------------------------------
function stop ( )

  updateThread:stop ()
end

----------------------------------------------------------------
function swap ( stateFile, ... )

  pop ()
  push ( stateFile, ... )
end

----------------------------------------------------------------
function setCallback (event,func )
  if curState.newcallbacks==nil then
    curState.callbacks={}
  end
  if MOAIInputMgr.device[event] then
    curState.callbacks[event] = func
    MOAIInputMgr.device[event]:setCallback(func)
  end
end

-----------------------------------------------------------------
function registerInputCallbacks()
  if MOAIInputMgr.device.pointer then
    setCallback("pointer", function(x,y) dispatchevent("move","pointer",false,1,x,y,0) end )
  end
  if MOAIInputMgr.device.mouseLeft then
    setCallback("mouseLeft", function(up) local x,y = MOAIInputMgr.device.pointer:getLoc () dispatchevent("touch","pointer",up,1,x,y,1) end )
  end
  if MOAIInputMgr.device.touch then
    setCallback("touch", function(eventType, idx, x, y, tapCount) dispatchevent("touch","touch",eventType,idx,x,y,tapCount) end )
  end
  if MOAIInputMgr.device.keyboard then
    setCallback("keyboard", function ( key, down ) dispatchevent("key","keyboard",not down,key,nil,nil,nil) end )
  end
end

-----------------------------------------------------------------
function dispatchevent(pevent,psource,pup,pidx,px,py,ptapcount)
  if pevent =="move" then
    if curState.onMove then
      curState:onMove(psource,pup,pidx,px,py)
    end
  elseif pevent =="touch" then
    if curState.onTouch then
      curState:onTouch(psource,pup,pidx,px,py,ptapcount)
    end
  elseif pevent =="key" then
    if curState.onKey then
      curState:onKey(psource,pup,pidx)
    end
  end
end