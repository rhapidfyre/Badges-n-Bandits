
-- This file contains all base gamemode operations (enable pvp, rich presence, exports, etc)

--  Independent startup stuff (init/no dependency)
Citizen.CreateThread(function()
  
  -- Enable PVP
  Citizen.Wait(1000) 
  Citizen.InvokeNative(0xF808475FA571D823, true)
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)
  SetRelationshipBetweenGroups(5, `PLAYER`, `PLAYER`)
  
  if Config.RevealMap() > 0 then
    Citizen.InvokeNative(0x4B8F743A4A6D2FF8, true)
  end
  
  -- Discord  Rich Presence
	while true do
		SetDiscordAppId(611712266164895744) -- Discord app id
		SetDiscordRichPresenceAsset("RedM: Badges & Bandits") -- Big picture asset name
    SetDiscordRichPresenceAssetText("RedM: Badges & Bandits") -- Big picture hover text
    SetDiscordRichPresenceAssetSmall('bb_logo') -- Small picture asset name
    SetDiscordRichPresenceAssetSmallText("RedM: Badges n' Bandits") -- Small picture hover text
		Citizen.Wait(300000) -- Update every 5 minutes
	end
end)


-- Establish server connection
CreateThread(function()
  DoScreenFadeOut(0)
  while not IsScreenFadedOut() do Wait(1) end
  while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
  NetworkSetVoiceActive(true)
  TriggerServerEvent('bb:init')
end)