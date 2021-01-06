
RegisterNetEvent('bb:initPlayer')
RegisterNetEvent('bnb:respawn')

function RespawnPlayer(usePos)
  local findSpawn = nil
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
end


local justDied = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    
    if not justDied and IsPlayerDead(PlayerId()) then
      justDied = true
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
    
		while IsPlayerDead(PlayerId()) do
    
      local ePressed = false
			Citizen.Wait(0)
			local timer = GetGameTimer() + 5000
			while timer >= GetGameTimer() do
				alive = false
				Citizen.Wait(0)
				DrawRect(0.50, 0.475, 1.0, 0.22, 1, 1, 1, 100, true, true)
				DrawTxt("YOU HAVE DIED", 0.50, 0.40, 1.0, 1.0, true, 161, 3, 0, 255, true)
        if Config.debugging then print("PLAYER IS DEAD") end
				DisplayHud(false)
				DisplayRadar(false)
				--exports.spawnmanager:setAutoSpawn(false)
        
			end
      
			while not ePressed do
				Wait(0)
				DrawTxt("Dead - Press E to Respawn", 0.50, 0.40, 1.0, 1.0, true, 161, 3, 0, 255, true)
				if IsControlJustReleased(0, 0xDFF812F9) then ePressed = true end
			end
      
			ePressed = false
			RespawnPlayer()
      justDied = false
      
		end
	end
end)

AddEventHandler('bb:initPlayer', function(idUnique, lastPosition)
  if lastPosition then
    if Config.debugging then print("Restoring previous location.") end
    if type(lastPosition) == "table" then 
      if Config.debugging then
        print("Last known position was a table. Vectorizing...")
      end
      local temp = vector3(lastPosition.x, lastPosition.y, lastPosition.z)
      lastPosition = temp
    elseif type(lastPosition) ~= "vector3" then
      if Config.debugging then
        print("Last known location was invalid. Ignoring.")
      end
      lastPosition = nil
    end
  else
    if Config.debugging then print("No previous location found.") end
  end
  RespawnPlayer(lastPosition)
  BB.Initialize(idUnique)
  TriggerEvent('bb:loaded')
  TriggerServerEvent('bb:loaded')
end)

AddEventHandler('bb:respawn', RespawnPlayer)
