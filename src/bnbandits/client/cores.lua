
RegisterNetEvent('bb:initPlayer')

AddEventHandler('bb:initPlayer', function()
  CreateThread(function()
    while true do
      Wait(100)
      local ped = PlayerPedId()
      if not IsPedSprinting(ped) then
        for i = 0, 2 do
          local cv = GetAttributeCoreValue(ped, i)
          if cv < 100 then
            if cv + 1 > 100 then Citizen.InvokeNative(0xC6258F41D86676E0, ped, i, 100)
            else Citizen.InvokeNative(0xC6258F41D86676E0, ped, i, cv + 1)
            end
          end
        end
      end
    end
  end)
end)