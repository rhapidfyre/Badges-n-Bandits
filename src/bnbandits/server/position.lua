
RegisterServerEvent('bb:save_pos')
local positions  = {}     -- Holds last known position ( [ID] => vector3() )


AddEventHandler('bb:save_pos', function(pos)
  local client = source
  local cid    = clInfo[client]
  if cid and pos then
    positions[cid] = pos
  end
end)

function SavePlayerPos(cid, pos)
  if cid then

    -- If pos not given, check positions table
    if not pos then pos = positions[cid] end

    -- Only update if positions table has changed (is not nil)
    if pos then
      exports['ghmattimysql']:execute(
        "UPDATE characters SET x = @x, y = @y, z = @z WHERE id = @cid",
        {
          ['x']   = (math.floor(pos.x * 100))/100, -- Ensures 2 decimal places
          ['y']   = (math.floor(pos.y * 100))/100,
          ['z']   = (math.floor(pos.z * 100))/100,
          ['cid'] = cid
        },
        function()
          -- Once updated, remove entry
          print("DEBUG - Position saved for cid #"..cid)
          positions[cid] = nil
        end
      )
    end

  end
end

AddEventHandler('playerDropped', function(reason)
  local client     = source
  local cid        = clInfo[client].charid
  local clientInfo = GetPlayerName(client)
  if cid then SavePlayerPos(cid, positions[cid]) end
    PrettyPrint(
      "^1"..tostring(clientInfo).." disconnected. ^7("..tostring(reason)..")"
    )
  if useDiscord then
    exports['bb_chat']:DiscordMessage(
      16711680, tostring(clientInfo).." Disconnected", tostring(reason), ""
    )
  end
  RecentDisconnect(client, reason)
end)
