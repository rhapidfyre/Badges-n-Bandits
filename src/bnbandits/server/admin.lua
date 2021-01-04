
RegisterServerEvent('bbadmin:check')
RegisterServerEvent('bb:loaded')
RegisterServerEvent('bbadmin:teleport')


--- BlockAction()
-- Blocks the action attempt if affected admin is equal or greater rank
-- @return True if the action should be blocked/stopped
local function BlockAction(offense, defense)
  if not BB.admins[offense]                             then return false end
  if     BB.admins[offense] and not BB.admins[defense]  then return true  end
  if     BB.admins[offense]    >    BB.admins[defense]  then return true  end
  return false
end


local function AdminLevel(client)
  if not BB.admins[client] then BB.admins[client] = 0 end
  return BB.admins[client]
end


local function CanUseCommand(client, cmd)
  if client < 1 then return true end
  if not cmd then return false end
  if AdminLevel(client) >= AdminCommandLevel(cmd) then
    return true
  end
  return false
end

local function AssignAdministrator(client, aLevel)
  if not client then return false end
  if not type(aLevel) == "number" then aLevel = tonumber(aLevel) end
  if aLevel > 1 then
    BB.admins[client] = aLevel
    local aRank = "a ^2Moderator"
    if aLevel == 3 then aRank = "an ^1Administrator"
    elseif aLevel == 4 then aRank = "a ^3Superadmin"
    elseif aLevel == 5 then aRank = "the ^4Server Owner"
    end
    ConsolePrint(GetPlayerName(client).." ("..client..") has signed in as "..aRank.."^7.")
    TriggerClientEvent('bbadmin:assigned', client, aLevel, aRank)
  end
  return ( BB.admins[client] )
end


local function CheckAdmin(client)
  if not client then return false end
  local uid    = UniqueId(client)
  local aLevel = BB.SQL.RSYNC(
    "SELECT perms FROM players WHERE id = @uid",
    {['uid'] = uid}
  )
  print(GetPlayerName(client).." (ID #"..client..") [UID "..uid.."] has permission level "..aLevel)
  if not BB.admins then BB.admins = {} end
  BB.admins[client] = 1
  if aLevel then
    AssignAdministrator(client, aLevel)
    return true
  end
  return false
end
AddEventHandler('bb:loaded', function() CheckAdmin(source) end)
AddEventHandler('bbadmin:check', function() CheckAdmin(source) end)


AddEventHandler('bbadmin:teleport', function(tpType, data)
  local client = source
  if CanUseCommand(client, 'teleport') then
    print(tpType, data)
  end
end)