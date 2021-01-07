

local function SpawnHorse()
  if BB.Player.horse then 
    
  end
  local mdl = GetHashKey(a[1])
  print("Preparing Model...", a[1], mdl)
  LoadModel(mdl)
  
  print("Model Ready.")
  local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
  print("Positional Offset.", GetEntityCoords(PlayerPedId()), offset)
  local horse = Citizen.InvokeNative(0xD49F9B0955C367DE, mdl, offset.x, offset.y, offset.z,
    0, 0, 0, 0, Citizen.ResultAsInteger()
  )
  if DoesEntityExist(horse) then
  Citizen.InvokeNative(0x1794B4FCC84D812F, horse, 1) -- SetEntityVisible
  Citizen.InvokeNative(0x0DF7692B1D9E7BA7, horse, 255, false) -- SetEntityAlpha
  Citizen.InvokeNative(0x283978A15512B2FE, horse, true) -- Invisible without
  Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
  Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, horse)  -- BlipAddForEntity
  Citizen.InvokeNative(0x4AD96EF928BD4F9A, hash) -- SetModelAsNoLongerNeeded
    print("Horse Ready")
  else print("Failed to create horse")
  end
end


AddEventHandler('bb:player_horse', function(hModel)

end)