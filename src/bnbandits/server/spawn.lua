
RegisterServerEvent('bb:init')
RegisterServerEvent('bb:loaded')
RegisterServerEvent('bb:create_character')
RegisterServerEvent('bb:model_choice')

local mChoices = {
  [1] = {}  -- males
  [2] = {}, -- females
}

AddEventHandler('bb:model_choice', function(pGender, mNumber, dir)
  
  local client = source
  
  -- Initializes models on first load
  if #mChoices[1] < 1 then 
    local males = BB.SQL.QUERY(
      "SELECT * FROM models WHERE female = 0 AND `admin` = 0 AND lawman = 0"
    )
    local females = BB.SQL.QUERY(
      "SELECT * FROM models WHERE female = 1 AND `admin` = 0 AND lawman = 0"
    )
    for k,v in pairs (males) do
      local n = #mChoices[1]
      mChoices[1][n] = (v['hashkey'])
    end
    for k,v in pairs (females) do
      local n = #mChoices[0]
      mChoices[2][n] = (v['hashkey'])
    end
  end
  
  if not dir then dir = 0 end
  mNumber = mNumber + dir
  if      mNumber > #mChoices[pGender]  then mNumber = 1
  elseif  mNumber < 1                   then mNumber = #mChoices[pGender+1]
  end
  print(
    pGender+1, mNumber, dir,
    mChoices[pGender+1], mChoices[pGender+1][mNumber],
    #mChoices[pGender+1]
  
  )
  TriggerClientEvent('bb:creator_model', client, mChoices[pGender+1][mNumber], mNumber)
  
end)


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
    {['u'] = BB.Player[client].unique}
  )
  
  local metaTable = {
    [1] = BB.Player[client].unique,
    [2] = BB.Player[client].lastPos
  }
  if charInfo[1] then 
    metaTable[3] = charInfo[1]['model']
  end
  
  
  TriggerEvent('bb:initPlayer', client, metaTable)
  TriggerClientEvent('bb:initPlayer', client, metaTable)
  
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


AddEventHandler('bb:create_character', function(pGender, modelChoice)
  local client = source
  local idUnique = BB.Player[client].unique
  if idUnique > 0 then
    BB.SQL.QUERY(
      "INSERT INTO characters (model,x,y,z) VALUES (@m,@x,@y,@z)",
      {
        ['m'] = mChoices[pGender][modelChoice],
        ['x'] = math.floor( BB.StartPosition.x * 100 ) / 100,
        ['y'] = math.floor( BB.StartPosition.y * 100 ) / 100,
        ['z'] = math.floor( BB.StartPosition.z * 100 ) / 100
      }
    )
    local charInfo = BB.SQL.QUERY(
      "SELECT * FROM characters WHERE idUnique = @u ORDER BY created DESC LIMIT 1",
      {['u'] = BB.Player[client].unique}
    )
  
    local charInfo = BB.SQL.QUERY(
      "SELECT * FROM characters WHERE idUnique = @u ORDER BY created DESC LIMIT 1",
      {['u'] = BB.Player[client].unique}
    )
    
    local metaTable = {
      [1] = BB.Player[client].unique,
      [2] = BB.Player[client].lastPos,
      [3] = charInfo[1]['model'],
    }
    
    TriggerClientEvent('bb:initPlayer', client, metaTable)
    
  end
end)
