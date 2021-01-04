
RegisterNetEvent('bbadmin:assigned')

local function AdminLevel()
  local cl = GetPlayerServerId(PlayerId())
  if not BB.admins[cl] then BB.admins[cl] = 0 end
  return BB.admins[cl]
end

local function CommandValid(str)
  if AdminLevel() >= AdminCommandLevel(str:match("^([%w]+)")) then 
    return true
  end
  return false
end


AddEventHandler('bbadmin:assigned', function(aNumber, aRank)
  BB.permission = aNumber
end)


RegisterCommand('admin', function()
  TriggerServerEvent('bb_admin:check')
end)


RegisterCommand('tpmark', function(s,a,raw)
  if CommandValid(raw) then
    local blip  = GetFirstBlipInfoId(8) -- Retrieve GPS marker
    if DoesBlipExist(blip) then
      TriggerServerEvent('bbadmin:teleport', 'marker', GetBlipCoords(blip))
    else print("DEBUG - No blip set.")
    end
  end
end)