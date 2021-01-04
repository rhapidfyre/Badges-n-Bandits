
RegisterServerEvent('bb:init')

local useDiscord = false  -- Toggles discord messages created by this script


local function AssignUniqueId(client)

end


--- EXPORT: UniqueId()
-- Retrieves the user's Unique ID. If not found, will check MySQL
-- @param client The Player's Server ID
function UniqueId(client)
  if client then

    -- If no meta, build meta. If uid exists in meta, return it
    if not BB.Player[client] then BB.Player[client] = {} end

    if id then
      BB.Player[client].unique = id
      print("DEBUG - Assigned uid "..id.." to Player #"..client)
      return id

    else
      if not BB.Player[client].unique then
        print("DEBUG - Checking SQL for Unique ID.")
        BB.Player[client].unique = AssignUniqueId(client)
      end
    end

    return BB.Player[client].unique
  end
  return nil -- If player ID not given return nil
end


local function InitializePlayer(client)
  if not client then
    return false, "No ID given to InitializePlayer()"
  end
  local uid = UniqueId(client)
  if not uid then return true, 0 end
  return true, uid
end


AddEventHandler('bb:init', function()
  local client = source
  if Config.verbose then print(GetPlayerName(client).." ("..client..") has joined!") end
  local isReady, data = InitializePlayer(client)
  if isReady then
    if Config.verbose then
      print(GetPlayerName(client).." ("..client..
      ") is ready to play! (Unique ID = "..data..")")
    end
    if data < 1 then
      print(GetPlayerName(client).." ("..client..") ^1Failed to Validate^7. "..
        "They can still play but their stats will not be saved."
      )
      --[[TriggerClientEvent('chat:addMessage', client, {color = {255,0,0}, multiline = true,
        args = {"LOGIN ERROR", "No credentials found (Steam, RedM, Social Club). "..
        "You can still play, however your session won't be saved."}
      })]]
    end
    TriggerEvent('bb:initPlayer', client, data)
    TriggerClientEvent('bb:initPlayer', client, data)
  else DropPlayer(client, data)
  end
end)