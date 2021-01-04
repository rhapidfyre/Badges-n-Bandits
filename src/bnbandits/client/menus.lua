
-- NUI: MainMenu
-- Handles NUI functionality from JQuery/JS to Lua
RegisterNUICallback("MainMenu", function(data, callback)

  if data.action == "exit" then
    SendNUIMessage({hidemenu = true})
    SetNuiFocus(false, false)

  end

end)