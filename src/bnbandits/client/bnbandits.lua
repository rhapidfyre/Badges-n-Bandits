
-- This file contains all base gamemode operations (enable pvp, rich presence, exports, etc

-- Discord Rich Presence
Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(611712266164895744) -- Discord app id
		SetDiscordRichPresenceAsset('Badges & Bandits') -- Big picture asset name
    SetDiscordRichPresenceAssetText('Badges & Bandits') -- Big picture hover text
    SetDiscordRichPresenceAssetSmall('bb_logo') -- Small picture asset name
    SetDiscordRichPresenceAssetSmallText('RedM: Badges & Bandits') -- Small picture hover text
		Citizen.Wait(300000) -- Update every 5 minutes
	end
end)


--- EXPORT GetClosestPlayer()
-- Finds the closest player
-- @return Player local ID. nil if client's alone
function GetClosestPlayer()
	local ped  = PlayerPedId()
	local plys = GetActivePlayers()
  local myPos = GetEntityCoords(ped)
	local cPly = 0
	local cDist = 120.0
	for k,v in pairs (plys) do
		local tgt = GetPlayerPed(v)
		if tgt ~= ped then
			local dist = #(myPos - GetEntityCoords(tgt))
			if dist < cDist then
				cPly = v
				cDist = dist
			end
		end
	end
	return cPly
end

-- Enable PVP
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		--SetCanAttackFriendly(PlayerPedId(), true, false)
		NetworkSetFriendlyFireOption(true)
	end
end)
