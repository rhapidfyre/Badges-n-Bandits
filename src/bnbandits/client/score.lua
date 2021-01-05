
RegisterNetEvent('bb:initPlayer')


AddEventHandler('bb:initPlayer', function()
    local open = false
    while true do
        Wait(1)
        if IsControlPressed(0, KEYS['TAB']) then
            if not open then
                ToggleScoreboard(true)
                open = true
                while open do
                    Wait(0)
                    if IsControlPressed(0, KEYS['TAB']) then
                      open = false
                      DisplayHud(true)
                      DisplayRadar(true)
                      SendNUIMessage({hidescores = true})
                      break
                    end
                end
            end
        end
    end
end)


function ToggleScoreboard(doOpen)
  if doOpen then
    DisplayHud(false)
    DisplayRadar(false)
    local htmlTable = {}
    local plys = GetActivePlayers()
    for _,v in ipairs(plys) do
      local id = tonumber(v)
      local sv = GetPlayerServerId(id)
      local wl = '&nbsp;'
      local clss = ''
      local wLevel = BB.WantedLevel(sv)
      if wLevel > 0 then
        if wLevel > 10 then
          wl    = 'MOST WANTED'
          clss  = ' class="mw"'
        else
          wl    = 'WANTED ('..BB.WantedType(wLevel)..')'
          clss  = ' class="wflash wanted'..wLevel..'"'
        end
      end
      htmlTable[#htmlTable + 1] = (
        '<tr><td>'..sv..'</td><td>'..GetPlayerName(id)..'</td><td'..clss..'>'..wl..'</td></tr>'
      )
    end
    SendNUIMessage({ showscores = true, updatescores = table.concat(htmlTable) })
  end
end

