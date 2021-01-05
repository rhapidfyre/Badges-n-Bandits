
RegisterServerEvent('bb:save_pos')
local positions  = {}     -- Holds last known position ( [ID] => vector3() )


function BB.UninitializePlayer(client)
  if BB.wanted[client] then BB.SetWanted(client, 0) end -- Update all players
  BB.wanted[client] = nil
  BB.lawman[client] = nil
  BB.scores[client] = nil
  BB.admins[client] = nil
  if BB.Player[client] then
    if Config.debugging then print((BB.Player[client].I).." has been uninitialized.") end
  end
  BB.Player[client] = nil
end


AddEventHandler('bb:save_pos', function(pos)
  local client = source
  local idUnique = BB.Player[client].unique
  if idUnique and pos then
    if Config.debugging then ConsolePrint("Saved last known position for "..(BB.Player[client].I)) end
    positions[idUnique] = pos
  end
end)


function SavePlayerPos(idUnique, pos)
  if idUnique then

    -- If pos not given, check positions table
    if not pos then pos = positions[idUnique] end

    -- Only update if positions table has changed (is not nil)
    if pos then
      exports['ghmattimysql']:execute(
        "UPDATE players SET x = @x, y = @y, z = @z WHERE id = @idUnique",
        {
          ['x']   = (math.floor(pos.x * 1000))/1000, -- Ensures 2 decimal places
          ['y']   = (math.floor(pos.y * 1000))/1000,
          ['z']   = (math.floor(pos.z * 1000))/1000,
          ['idUnique'] = idUnique
        },
        function()
          -- Once updated, remove entry
          print("DEBUG - Position saved for idUnique #"..idUnique)
          positions[idUnique] = nil
        end
      )
    end

  end
end

AddEventHandler('playerDropped', function(reason)
  local client     = source
  if BB.Player[client] then
    local idUnique   = BB.Player[client].unique
    local clientInfo = GetPlayerName(client)
    if idUnique then SavePlayerPos(idUnique, positions[idUnique]) end
    if Config.verbose then ConsolePrint("^1"..tostring(clientInfo).." disconnected. ^7("..tostring(reason)..")") end
    --RecentDisconnect(client, reason) -- For restoring session in case of crash/desync
    BB.UninitializePlayer(client)
  end
end)
