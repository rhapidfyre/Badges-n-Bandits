
RegisterNetEvent('bb:initPlayer')
RegisterNetEvent('bnb:respawn')     -- Rx'd by server to force respawn event

local respawnKey = 'E'


function RespawnPlayer(usePos)
  local findSpawn = nil
  if type(usePos) == "table" then usePos = usePos.v end
  if usePos or #BB.spawns < 1 then
    findSpawn = GetEntityCoords(PlayerPedId())
    if usePos then findSpawn = usePos end
    if Config.debugging and not usePos then print("Respawning at player's current position.") end
    if Config.debugging and usePos then print("Respawning at provided location.") end
  else
    repeat
      local n = math.random( #BB.spawns )
      local temp = BB.spawns[n]
      if temp then findSpawn = temp end
      Citizen.Wait(0)
      if Config.debugging then print("Attempting to locate a spawnpoint for respawn.") end
    until findSpawn
    if Config.debugging or Config.verbose then print("Located a valid respawn position.") end
  end
  ShutdownLoadingScreen()
  NetworkResurrectLocalPlayer(findSpawn.x, findSpawn.y, findSpawn.z, math.random(359))
  local ped = PlayerPedId()
  SetEntityCoordsNoOffset(ped, findSpawn.x, findSpawn.y, findSpawn.z, false, false, false, true)
  BB.Player.dead = false
  FreezeEntityPosition(ped, false)
  SetPlayerInvincible(ped, false)
  SetEntityVisible(ped, true)
  SetEntityCollision(ped, true)
  if Config.debugging or Config.verbose then print("Player has respawned.") end
  TriggerEvent('playerSpawned')
  if IsScreenFadedOut() then
    DoScreenFadeIn(600)
    while IsScreenFadedOut() do Wait(100) end
  end
  DisplayHud(true)
  DisplayRadar(true)
end


-- Received from server when the player has validated on first spawn
-- Also starts death/respawn checking loop functions
AddEventHandler('bb:initPlayer', function(metaData)

  BB.Initialize(metaData)
  RespawnPlayer(metaData)

  TriggerEvent('bb:loaded')
  TriggerServerEvent('bb:loaded')

  -- Check for Death
	while true do
		Citizen.Wait(0)

		while IsPlayerDead(PlayerId()) do

      local ePressed = false
			Citizen.Wait(0)
			local timer = GetGameTimer() + 5000

      -- Check if killed by a player
      if not BB.Player.dead then
        local killer = GetPedSourceOfDeath(PlayerPedId())
        if DoesEntityExist(killer) then
          if IsEntityAPed(killer) then
            if IsPedAPlayer(killer) then
              local plyr = 0
              local plyrs = GetActivePlayers()
              for _,i in ipairs(plyrs) do
                if GetPlayerPed(i) == killer then
                  plyr = i
                  break
                end
              end
              if plyr > 0 then
                print("DEBUG - Murdered by Player #"..GetPlayerServerId(plyr))
                TriggerServerEvent('bb:murder', GetPlayerServerId(plyr))
              else print("DEBUG - Unable to identify murderer.")
              end
            end
          end
        end
      end

			while timer >= GetGameTimer() do
				Citizen.Wait(0)
				DrawRect(0.50, 0.475, 1.0, 0.22, 1, 1, 1, 100, true, true)
				DrawTxt("YOU HAVE DIED", 0.50, 0.40, 1.0, 1.0, true, 161, 3, 0, 255, true)
				DisplayHud(false)
				DisplayRadar(false)
			end

			while not ePressed do
				Wait(0)
				DrawTxt("Dead - Press "..respawnKey.." to Respawn", 0.50, 0.40, 1.0, 1.0, true, 161, 3, 0, 255, true)
				if IsControlJustReleased(0, KEYS[respawnKey]) then ePressed = true end
			end

			ePressed = false
			RespawnPlayer()

		end
	end

end)


AddEventHandler('bb:respawn', RespawnPlayer)
