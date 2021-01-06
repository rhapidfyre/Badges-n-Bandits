

AddEventHandler('bb:loaded', function()
  while true do
    Citizen.Wait(1)
    
    -- Check for shooting/aim crimes
    if IsPedShooting(PlayerPedId()) then
    
      local myPos   = GetEntityCoords(PlayerPedId())
      local mapZone = Citizen.InvokeNative(0x43AD8FC02B429D33, myPos.x,myPos.y,myPos.z, 1)
      print("ZONE: "..mapZone)
      local retval, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
      if GetPedType(target) == 4 or GetPedType(target) == 5 or GetPedType(target) == 2 then
        if not IsPedAPlayer(target) then
          print("Discharged a Firearm")
          TriggerServerEvent('bb:crime', 'discharge')
        else
          print("Attempted Murder")
          TriggerServerEvent('bb:crime', 'murder', true)
        end
      end
    end
    
  end
end)