
RegisterNetEvent('bb:initPlayer')
RegisterNetEvent('bnb:respawn')

function RespawnPlayer(usePos)
  local findSpawn = nil
  if usePos or #BB.spawns < 1 then
    findSpawn = GetEntityCoords(PlayerPedId())
    if Config.debugging then print("Respawning at player's current position.") end
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


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
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
      
		end
	end
end)

AddEventHandler('bb:initPlayer', function(myUID)
  BB.Initialize(myUid)
  RespawnPlayer()
end)

AddEventHandler('bb:respawn', RespawnPlayer)
