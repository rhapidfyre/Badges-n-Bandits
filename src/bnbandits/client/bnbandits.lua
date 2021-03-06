
RegisterNetEvent('bb:setPlayer')
RegisterNetEvent('bb:delPlayer')

-- This file contains all base gamemode operations (enable pvp, rich presence, exports, etc)
RegisterCommand('menus', function()
  TriggerEvent('bb:nui_rescue')
  SetNuiFocus(false)
end)

--  Independent startup stuff (init/no dependency)
Citizen.CreateThread(function()
    
  SetNuiFocus(false) -- Rescue on gamemode reload
    
  -- Enable PVP
  Citizen.Wait(1000) 
  Citizen.InvokeNative(0xF808475FA571D823, true)
	NetworkSetFriendlyFireOption(true)
  SetRelationshipBetweenGroups(5, `PLAYER`, `PLAYER`)
  
  while not Config do
    print("Metatable not ready. Waiting 1 second and trying again.")
    Wait(1000)
  end
  
  if Config.RevealMap() > 0 then
    Citizen.InvokeNative(0x4B8F743A4A6D2FF8, true)
  end
  
  -- Discord  Rich Presence
	while true do
		SetDiscordAppId(602957874259296256) -- Discord app id
		SetDiscordRichPresenceAsset("RedM: Badges & Bandits") -- Big picture asset name
    SetDiscordRichPresenceAssetText("RedM: Badges & Bandits") -- Big picture hover text
    SetDiscordRichPresenceAssetSmall('bb_logo') -- Small picture asset name
    SetDiscordRichPresenceAssetSmallText("RedM: Badges n' Bandits") -- Small picture hover text
		Citizen.Wait(300000) -- Update every 5 minutes
	end
end)


AddEventHandler('bb:setPlayer', function(client, pName)
  BB.Players[client] = {name = pName}
  BB.Players[client].I = BB.Players[client].name .. " ("..client..") "
end)


AddEventHandler('bb:delPlayer', function(client)
  BB.Players[client] = nil
end)


-- Establish server connection
CreateThread(function()
  DoScreenFadeOut(0)
  while not IsScreenFadedOut() do Wait(1) end
  while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
  TriggerServerEvent('bb:init')
end)