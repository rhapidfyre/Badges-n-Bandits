
function BB.WantedLevel(client)
  if not BB.wanted[client] then BB.wanted[client] = 0 end
  if Config.debugging then
    print(BB.Player[client].I.." has "..BB.wanted[client].." WP.",
      BB.wanted[client], Config.levelDivision,
      BB.wanted[client]/Config.levelDivision,
      math.ceil(BB.wanted[client] / Config.levelDivision)
    )
  end
  return math.ceil(BB.wanted[client] / Config.levelDivision)
end


function BB.MostWanted()
  local mw, mp = 0, 100.0
  for idPlayer,wantedPoints in pairs (BB.wanted) do 
    if wantedPoints > mp then mw = idPlayer end
  end
  if Config.debugging then print("Player #"..mw.." is currently the Most Wanted.") end
  return mw
end


function BB.SetWanted(client, wPoints)
  if not BB.wanted[client] then BB.wanted[client] = 0 end
  if not wPoints then wPoints = 0 end
  local oldWanted = BB.WantedLevel(client)
  BB.wanted[client] = wPoints
  TriggerEvent('bb:wanted_points', client, BB.wanted[client])
  TriggerClientEvent('bb:wanted_points', (-1), client, BB.wanted[client])
  local newWanted = BB.WantedLevel(client)
  if oldWanted < newWanted then 
    TriggerEvent('bb:wanted_increased', client, newWanted)
    TriggerClientEvent('bb:wanted_increased', (-1), client, newWanted)
    if newWanted > 10 then 
      if BB.MostWanted() == client then
        TriggerEvent('bb:most_wanted', client)
        TriggerClientEvent('bb:most_wanted', (-1), client)
      end
    end
  elseif oldWanted > newWanted then 
    TriggerEvent('bb:wanted_decreased', client, newWanted)
    TriggerClientEvent('bb:wanted_decreased', (-1), client, newWanted)
  end
  return BB.WantedLevel(client)
end


function BB.IncreaseWantedPoints(client, wPoints)
  if not BB.wanted[client] then BB.wanted[client] = 0 end
  if not wPoints then wPoints = 1 end
  if wPoints < 1 then wPoints = 1 end
  if wPoints > 0 then
    local oldMW     = BB.MostWanted()
    local oldWanted = BB.WantedLevel(client)
    BB.wanted[client] = oldWanted + wPoints
    local newWanted = BB.WantedLevel(client)
    TriggerEvent('bb:wanted_points', client, BB.wanted[client])
    TriggerClientEvent('bb:wanted_points', (-1), client, BB.wanted[client])
    if oldWanted < newWanted then
      TriggerEvent('bb:wanted_increased', client, newWanted)
      TriggerClientEvent('bb:wanted_increased', (-1), client, newWanted)
      if newWanted > 10 then -- If WL above 10, check if client is the MW
        if BB.MostWanted() == client and oldMW ~= client then
          TriggerEvent('bb:most_wanted', client)
          TriggerClientEvent('bb:most_wanted', (-1), client)
          print(BB.Player[client].i.." is now the Most Wanted")
          return BB.wanted[client]
        end
      end
    end
    print(BB.Player[client].i.." is now Wanted Level "..newWanted)
    return BB.wanted[client]
  else ConsolePrint("BB.IncreaseWantedPoints() call had no effect. It was ignored.")
  end
  return nil
end


function BB.DecreaseWantedPoints(client, wPoints)
  if not BB.wanted[client] then BB.wanted[client] = 0 end
  if not wPoints then wPoints = 1 end
  if wPoints < 1 then wPoints = 1 end
  if wPoints > 0 then
    local oldWanted = BB.WantedLevel(client)
    BB.wanted[client] = BB.wanted[client] - wPoints
    if BB.wanted[client] < 1 then BB.wanted[client] = 0 end
    local newWanted = BB.WantedLevel(client)
    TriggerEvent('bb:wanted_points', client, BB.wanted[client])
    TriggerClientEvent('bb:wanted_points', (-1), client, BB.wanted[client])
    if oldWanted > newWanted then
      if newWanted < 1 then
        TriggerEvent('bb:innocent', client)
        TriggerClientEvent('bb:innocent', (-1), client)
      else
        TriggerEvent('bb:wanted_decreased', client, newWanted)
        TriggerClientEvent('bb:wanted_decreased', (-1), client, newWanted)
      end
    end
    return BB.wanted[client]
  else ConsolePrint("BB.DecreaseWantedPoints() call had no effect. It was ignored.")
  end
  return nil
end


-- Reduces all player's wanted levels every X amount time (specified in the Config)
CreateThread(function()
  while not Config do Wait(100) end -- Wait until the Config loads
  if Config.debugging then ConsolePrint("Beginning passive wanted level reduction.") end
  while true do
    for idPlayer,wPoints in pairs (BB.wanted) do
      if wPoints > 0 then
        BB.DecreaseWantedPoints(idPlayer, Config.reducePoints)
      end
    end
    Wait(Config.reduceTimer * 1000)
  end
end)