local witnesses = {}
local crimes    = {}

function CreateWitness(target, crimeType)
  local ped = PlayerPedId()
  local myPos = GetEntityCoords(ped)
  local ev  = #witnesses + 1
  crimes[ev] = crimeType
  local coords = GetEntityCoords(PlayerPedId())
  for witness in EnumeratePeds() do
    if DoesEntityExist(witness) then
      if #(myPos - GetEntityCoords(witness)) < 42.0 then
        if not witnesses[ev] then witnesses[ev] = {} end
        --TaskGoToEntity(witness, crow, -1, 1.0, 3.0)
        TaskReact(witness,ped,2111647205,0,0,0,0,0,0)
        local n = #witnesses[ev] + 1
        witnesses[ev][n] = witness
      end
    end
  end
  if Config.debugging then
    print((#witnesses[ev]).." witnesses to Crime #"..ev.." ("..crimes[ev]..")")
  end
end


AddEventHandler('bb:loaded', function()
  while true do
    Citizen.Wait(10)
    
    -- Check for shooting/aim crimes
    if IsPedShooting(PlayerPedId()) then
      local retval, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
      if GetPedType(target) == 4 or GetPedType(target) == 5 or GetPedType(target) == 2 then
        if not IsPedAPlayer(target) then CreateWitness(target, 'brandish') end
      end
    end
    
    -- Handle witnesses
    -- Must iterate backwards to compensate for removals
    for i = #witnesses, 1, -1 do
      for j = #witnesses[i], 1, -1 do
        -- If entity doesn't exist anymore, remove it
        if not DoesEntityExist(ent) then
          print("DEBUG - Witness no longer exists. Removing.")
          table.remove(witnesses, idEntry)
        else
          if IsPedDeadOrDying(ent) then 
            print("DEBUG - Witness is dead. Removing.")
            table.remove(witnesses, idEntry)
          end
        end
      end
      if #witnesses[i] < 1 then
        print("All witnesses for Crime #"..i.." have despawned. Removing entry.")
        table.remove(witnesses, i)
      end
    end
    
  end
end)