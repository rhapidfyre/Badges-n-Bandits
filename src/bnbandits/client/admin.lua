
RegisterNetEvent('bbadmin:assigned')
RegisterNetEvent('bbadmin:cl_teleport')

local function AdminLevel()
  local cl = GetPlayerServerId(PlayerId())
  if not BB.admins[cl] then BB.admins[cl] = 0 end
  return BB.admins[cl]
end

local function CommandValid(str)
  local cmd = str:match("^([%w]+)")
  if AdminLevel() >= AdminCommandLevel(cmd) then 
    if Config.debugging then print("Permission Granted for command '"..cmd.."'.") end
    return true
  end
  print("Insufficient Permissions for command '"..cmd.."'.")
  return false
end


AddEventHandler('bbadmin:assigned', function(aNumber, aRank)
  local cl = GetPlayerServerId(PlayerId())
  BB.admins[cl] = aNumber
end)


RegisterCommand('admin', function()
  TriggerServerEvent('bbadmin:check')
end)


RegisterCommand('tpmark', function(s,a,raw)
  if CommandValid(raw) then
    local coords = GetWaypointCoords() -- Retrieve GPS marker coords
    if coords then
      TriggerServerEvent('bbadmin:teleport', 'marker', coords)
    else print("DEBUG - No blip set.")
    end
  end
end)
AddEventHandler('bbadmin:cl_teleport', function(tpType, data)
  if source ~= "" then 
    if tpType == 'marker' then
      print("Teleporting to gps marker.")
      SetEntityCoords(PlayerPedId(), data)
    else print("Unknown teleport event received from server.")
    end
  else print("Event 'bbadmin:cl_teleport' received illegitimately")
  end
end)