
RegisterNetEvent('bb:wanted_points')
RegisterNetEvent('bb:wanted_increased')
RegisterNetEvent('bb:wanted_decreased')
RegisterNetEvent('bb:innocent')
RegisterNetEvent('bb:most_wanted')

function BB.WantedLevel(client)
  local me = GetPlayerServerId(PlayerId())
  if client then me = client end
  if not BB.wanted[me] then BB.wanted[me] = 0 end
  return math.ceil(BB.wanted[me] / Config.levelDivision)
end


function BB.WantedType(wL)
  if not wL then wL = BB.WantedLevel() end
  if wL > 5 then return "FELON"
  elseif wL > 3 then return "OUTLAW"
  elseif wL > 0 then return "PENALTY"
  end
  return "INNOCENT"
end


function MyWantedLevel()
  local wL = BB.WantedLevel()
  TriggerEvent('chat:addMessage', {color={255,180,0}, args = {
    "WANTED LEVEL" , "You are currently Wanted Level "..wL.. " ("..BB.WantedType(wL)..")"
  }})
end
RegisterCommand('mywanted', MyWantedLevel)
RegisterCommand('mywantedlevel', MyWantedLevel)
RegisterCommand('wantedlevel', MyWantedLevel)


AddEventHandler('bb:wanted_points', function(client, wp)
  if Config.verbose then print("Player #"..client.." now has "..wp.." Wanted Points.") end
  if Config.debugging then print("Event 'bb:wanted_points':", client, BB.Player.idServer, wp) end
  BB.wanted[client] = wp
end)


AddEventHandler('bb:wanted_increased', function(client, wL)
  if Config.verbose then print("Player #"..client.." has increased to Wanted Level "..wL..".") end
  if Config.debugging then print("Event 'bb:wanted_increased':", client, BB.Player.idServer, wL) end
  if client == BB.Player.idServer then
    SendNUIMessage({wanted = "inc"})
    TriggerEvent('chat:addMessage', {color={255,180,0}, args = {
      "WANTED LEVEL INCREASED", "You are now Wanted Level "..wL
    }})
  end
end)


AddEventHandler('bb:wanted_decreased', function(client, wL)
  if Config.verbose then print("Player #"..client.." has decreased to Wanted Level "..wL..".") end
  if Config.debugging then print("Event 'bb:wanted_decreased':", client, BB.Player.idServer, wL) end
  if client == BB.Player.idServer and wL > 0 then
    SendNUIMessage({wanted = "dec"})
    TriggerEvent('chat:addMessage', {color={0,180,255}, args = {
      "WANTED LEVEL DECREASED", "You are now Wanted Level "..wL
    }})
  end
end)


AddEventHandler('bb:innocent', function(client)
  if Config.verbose then print("Player #"..client.." is now innocent.") end
  if Config.debugging then print("Event 'bb:innocent':", client, BB.Player.idServer) end
  BB.wanted[client] = 0
  if client == BB.Player.idServer then
    SendNUIMessage({wanted = "inn"})
    TriggerEvent('chat:addMessage', {color={255,180,0}, args = {
      "WANTED LEVEL CLEARED", "You are no longer Wanted."
    }})
  end
end)


AddEventHandler('bb:most_wanted', function(client)
  if Config.verbose then print("Player #"..client.." is now the Most Wanted.") end
  if client == BB.Player.idServer then
    SendNUIMessage({wanted = "mw"})
    TriggerEvent('chat:addMessage', {color={255,180,0}, args = {
      "DEAD OR ALIVE", "You are now the Most Wanted!"
    }})
  end
end)