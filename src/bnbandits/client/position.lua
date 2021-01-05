
local reportPosition  = false
local rIntv           = 60


--- EXPORT: ReportPosition()
-- Reports to MySQL if given a true argument
-- Stops reporting if given a nil or false argument (default)
function ReportPosition(doReport)
  reportPosition = doReport
  CreateThread(function()
    if Config.debugging and reportPosition then
      print("Reporting position to server every "..rIntv.." seconds.")
    end
    Wait(rIntv * 1000)
    while reportPosition do
      TriggerServerEvent('bb:save_pos', GetEntityCoords(PlayerPedId()))
      Wait(rIntv * 1000)
    end
  end)
end


-- Start reporting location on character load
AddEventHandler('bb:loaded', function()
  ReportPosition(true)
end)


AddEventHandler('bb:unload', function()
  ReportPosition(false)
end)