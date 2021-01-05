
RegisterNetEvent('bb:initPlayer')
local viewDistance = 24.0
local ignorePlayerNameDistance = false

function NameColoring(sv)

  local wL = BB.WantedLevel(sv)
  if wL > 0 then
    if wL > 10 then wL = 11 end
    if COLOR_CRI[wL] then return COLOR_CRI[wL] end
    return {255,180,0}
  end

--[[
  local cplayer = IsLawman(sv)
  if cplayer then
    local ccolor = COLOR_COP[cplayer]
    if ccolor then return ccolor end
  end
]]

  return {255,255,255}

end

-- Draws the text above the head
local function HeadBoard(pos,text,col)
  local onScreen,_x,_y=GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z + 1.0)
  local camPos = GetGameplayCamCoord()
  local dist = #(camPos - pos)
  local scale = (4.00001 / dist) * 0.3
  if     scale >  0.2 then scale = 0.20
  elseif scale < 0.15 then scale = 0.15
  end

  SetTextScale(scale, scale)
  SetTextFontForCurrentCommand(1)
  SetTextColor(col[1], col[2], col[3], 215)
  local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
  SetTextCentre(1)
  DisplayText(str,_x,_y)
  
end

function ShowPlayerHeaders()
  if Config.debugging then print("Showing player headboards.") end
  while true do
    local clientTable = GetActivePlayers()
    for _,i in ipairs (clientTable) do
      local ped = GetPlayerPed(i)
      --if ped ~= PlayerPedId() then
        local myPos = GetEntityCoords(PlayerPedId())
        local theyPos = GetEntityCoords(ped)
        local sv = GetPlayerServerId(i)
        distance = #(myPos - theyPos)
        HeadBoard(theyPos, GetPlayerName(i).." ["..sv.."]", NameColoring(sv))
        --[[
        if HasEntityClearLosToEntity(PlayerPedId(), ped, 17) then
          if (ignorePlayerNameDistance) then
            HeadBoard(x2, y2, z2+1, sv, nameColor)
          else
            if ((distance < viewDistance)) then
              HeadBoard(x2, y2, z2+1, GetPlayerName(i).." ["..sv.."]", nameColor)
            end
          end
        end]]
      --end
    end
    Citizen.Wait(0)
  end
end

function CheckForScoreboard()
  if Config.debugging then print("Waiting for Scoreboard.") end
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
end


AddEventHandler('bb:initPlayer', function()
    local open = false
    CreateThread(ShowPlayerHeaders)
    CreateThread(CheckForScoreboard)
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

