
RegisterNetEvent('bbadmin:assigned')
RegisterNetEvent('bbadmin:cl_teleport')
RegisterNetEvent('bbadmin:cl_giveweapon')


local function FindZCoord(coord, ent)
  local zFound, zCoord
  local ht = 1000.0
  local timeOut = GetGameTimer() + 5000
  repeat
    Wait(10)
    ht = ht - 10.0
    SetEntityCoordsNoOffset(ent, coord.x, coord.y, ht)
    zFound, zCoord = GetGroundZAndNormalFor_3dCoord(coord.x, coord.y, ht)
    if ht < 1.5 then ht = 1000.0 end
  until zFound or (GetGameTimer() > timeOut)
  if not zCoord then return 0.0 end
  return zCoord
end


RegisterCommand('comps', function(s,a,r)
  local ped = PlayerPedId()
  print(Citizen.InvokeNative(0x90403E8107B60E81, ped))
end)


RegisterCommand('setmodel', function(s,a,r)
  local mdl = GetHashKey(a[1])
  if LoadModel(mdl) then
    SetPlayerModel(PlayerId(), mdl)
    --RespawnPlayer()
    SetModelAsNoLongerNeeded(mdl)
    if N_0x283978a15512b2fe then
      N_0x283978a15512b2fe(PlayerPedId(), true)
      UpdatePedVariation(PlayerPedId(), 0, 1, 1, 1, false)
    end
  else
    print("Failed to load model '"..a[1].."'")
  end
end)

local idModel = 0
RegisterCommand('loadmodel', function(s,a,r)
  TriggerServerEvent('bbdebug:getmodel')
end)
function SetModelLawmanSkin()
  if idModel > 0 then
    local temp = idModel
    idModel = 0
    TriggerServerEvent('bbdebug:lawman', temp)
  else
    TriggerEvent('chat:addMessage', {color={255,0,0},multiline=true,args={
      "INVALID USAGE", "You must first /loadmodel before using /lawman."
    }})
  end
end
RegisterCommand('lawman', SetModelLawmanSkin)
function SetModelBannedSkin()
  if idModel > 0 then
    local temp = idModel
    idModel = 0
    TriggerServerEvent('bbdebug:banskin', temp)
  else
    TriggerEvent('chat:addMessage', {color={255,0,0},multiline=true,args={
      "INVALID USAGE", "You must first /loadmodel before using /banskin."
    }})
  end
end
RegisterCommand('banskin', SetModelBannedSkin)
RegisterNetEvent('bbdebug:setmodel')
AddEventHandler('bbdebug:setmodel', function(mdlInfo)
  idModel = mdlInfo['id']
  local mdl = GetHashKey(mdlInfo['model'])
  if LoadModel(mdl) then
    SetPlayerModel(PlayerId(), mdl)
    SetModelAsNoLongerNeeded(mdl)
    if N_0x283978a15512b2fe then
      N_0x283978a15512b2fe(PlayerPedId(), true)
      --UpdatePedVariation(PlayerPedId(), 0, 1, 1, 1, false)
    end
    local mismatch = ''
    if tostring(mdlInfo['hashkey']) ~= tostring(mdl) then
      print("HASH MISTMATCH ON MODEL DB NUMBER '"..idModel.."'", tostring(mdlInfo['hashkey']), tostring(mdl))
      mismatch = "^1HASH MISMATCH^7"
    end
    TriggerEvent('chatMessage', "Model #^2"..idModel.."^7: '"..mdlInfo['model'].."' "..mismatch.." - Loaded")
    Citizen.Wait(800)
    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 180.0)
  else
    TriggerEvent('chatMessage', "Failed to load model '"..mdlInfo['model'].."'")
  end
end)
function SetModelAsVerified()
  if idModel > 0 then
    local temp = idModel
    idModel = 0
    TriggerServerEvent('bbdebug:nextskin', temp)
  else
    TriggerEvent('chat:addMessage', {color={255,0,0},multiline=true,args={
      "INVALID USAGE", "You must first /loadmodel before using /nextskin."
    }})
  end
end
RegisterCommand('nextskin', SetModelAsVerified)

Citizen.CreateThread(function()
  while true do
    if IsControlJustReleased(0, KEYS['L']) then     SetModelLawmanSkin()
    elseif IsControlJustReleased(0, KEYS['B']) then SetModelBannedSkin()
    elseif IsControlJustReleased(0, KEYS['N']) then SetModelAsVerified()
    end
    Wait(0)
  end
end)



---------- END OF DEBUG FUNCTIONS















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
RegisterCommand('tpto', function(s,a,raw)
  if CommandValid(raw) then
    local target = GetWaypointCoords() -- Retrieve GPS marker coords
    if a[1] then
      TriggerServerEvent('bbadmin:teleport', 'player', tonumber(a[1]))
    else
      TriggerEvent('chat:addMessage', {color={255,0,0},multiline=true,args={
        "INVALID USAGE", "Player ID Required (Check 'Z')"
      }})
    end
  end
end)
AddEventHandler('bbadmin:cl_teleport', function(tpType, data)
  if source ~= "" then 
    if tpType == 'marker' then
      print("Teleporting to gps marker.")
      local ped = PlayerPedId()
      local myPos = GetEntityCoords(ped)
      local z = FindZCoord(data, ped)
      if z > 0.0 then
        SetEntityCoordsNoOffset(ped, data.x, data.y, z)
      else
        print("Unable to Teleport (Unsafe)")
        SetEntityCoordsNoOffset(ped, myPos)
      end
    elseif tpType == "player" then
      print("Teleporting to player.")
      local ped = GetPlayerPed(GetPlayerFromServerId(data))
      local endPos = GetEntityCoords(ped)
      SetEntityCoordsNoOffset(PlayerPedId(), endPos.x, endPos.y, endPos.z + 1.0)
    else print("Unknown teleport event received from server.")
    end
  else print("Event 'bbadmin:cl_teleport' received illegitimately")
  end
end)


RegisterCommand('mypos', function(s,a,r)
  TriggerServerEvent('bbadmin:mypos', GetEntityCoords(PlayerPedId()))
end)


RegisterCommand('giveweapon', function(s,a,r)
  if CommandValid(r) then
    if not a[1] or not a[2] then 
      TriggerEvent('chat:addMessage', {color={255,0,0},multiline=true,args={
        "INVALID USAGE", "/giveweapon <Player ID> <Weapon Name> <Ammo(optional)>"
      }})
      return 0
    end
    TriggerServerEvent('bbadmin:giveweapon', tonumber(a[1]), a[2], a[3])
  end
end)
AddEventHandler('bbadmin:cl_giveweapon', function(weaponName, ammoCount)
  if source ~= "" then
    local weapon = GetHashKey(weaponName)
    GiveWeaponToPed_2(PlayerPedId(),weapon,ammoCount,true,true)
    --SetPedAmmo(PlayerPedId(), weapon, ammoCount)
    TriggerEvent('chat:addMessage', {color={255,255,0},multiline=true,args={
      "GIVEWEAPON", "An Admin has given you '"..weaponName.."'."
    }})
  else print("Event 'bbadmin:cl_giveweapon' received illegitimately")
  end
end)