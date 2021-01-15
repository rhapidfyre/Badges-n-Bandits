
RegisterServerEvent('bb:init')
RegisterServerEvent('bb:loaded')


-- Called when a player loads into the game for the first time
AddEventHandler('bb:init', function()
  local client = source
  if Config.verbose then print(GetPlayerName(client).." ("..client..") has joined!") end
  local isReady = BB.InitializePlayer(client)
  if isReady then
    if Config.verbose then
      print(GetPlayerName(client).." ("..client..
      ") is ready to play! (Unique ID = "..(BB.Player[client].unique)..")")
    end
    if BB.Player[client].unique < 1 then
      print(GetPlayerName(client).." ("..client..") ^1Failed to Validate^7. "..
        "They can still play, but their stats will not be saved."
      )
    end
  else
    print(GetPlayerName(client).." ("..client..") ^1Failed to Validate^7. "..
      "There was a problem running BB.InitializePlayer("..client..")."
    )
    DropPlayer(client, "Invalid Initialization.")
  end
  
  local charInfo = BB.SQL.QUERY(
    "SELECT * FROM characters WHERE idUnique = @u ORDER BY created DESC LIMIT 1",
    {['u'] = BB.Players[client].unique}
  )
  
  local metaTable = {
    [1] = BB.Player[client].unique,
    [2] = BB.Player[client].lastPos,
    [3] = charInfo['model'],
  }
  
  TriggerEvent('bb:initPlayer', client, charInfo[1])
  TriggerClientEvent('bb:initPlayer', client, charInfo[1])
  local plyrNames = {}
  local plys = GetPlayers()
  for _,i in ipairs (plys) do 
    plyrNames[tonumber(i)] = GetPlayerName(i)
    print("Player #"..i..": "..GetPlayerName(i))
  end
  TriggerClientEvent('bb:player_names', (-1), plyrNames)
end)


-- Called when a player has fully spawned for the first time
AddEventHandler('bb:loaded', function()
  local client = source
  BB.Player[client].ready = true
  local idUnique = BB.Player[client].unique
  if idUnique > 0 then
    local existingWL = BB.SQL.RSYNC(
      "SELECT wanted FROM players WHERE id = @u", {['u'] = idUnique}
    )
    if not existingWL then existingWL = 0 end
    if existingWL > 0 then 
      ConsolePrint(BB.Player[client].I.." logged in with a Wanted Level.")
      BB.SetWanted(client, existingWL)
    end
  end
end)


