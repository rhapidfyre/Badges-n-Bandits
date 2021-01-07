
RegisterServerEvent('bbadmin:check')
RegisterServerEvent('bb:loaded')
RegisterServerEvent('bbadmin:teleport')
RegisterServerEvent('bbadmin:mypos')
RegisterServerEvent('bbadmin:giveweapon')



function DebugLoadModel(client)
  local modelInfo = BB.SQL.QUERY(
    "SELECT id,model,hashkey FROM models WHERE handled = 0 AND processing = 0"
  )
  if modelInfo[1] then
    BB.SQL.QUERY("UPDATE models SET processing = 1 WHERE id = @i",
      {['i'] = modelInfo[1]['id']}
    )
    ConsolePrint("^2Processing Model '"..modelInfo[1]['model'].."' ("..modelInfo[1]['hashkey']..")")
    TriggerClientEvent('bbdebug:setmodel', client, modelInfo[1])
  else
    ConsolePrint("^1There are no models left to handle.")
    TriggerClientEvent('chat:addMessage', client, {color={255,180,0},multiline=true,args={
      "FINISHED", "There are no models left to verify."
    }})
  end
end
RegisterServerEvent('bbdebug:getmodel')
AddEventHandler('bbdebug:getmodel', function()
  DebugLoadModel(source)
end)
RegisterServerEvent('bbdebug:lawman')
AddEventHandler('bbdebug:lawman', function(idModel)
  local client = source
  BB.SQL.QUERY(
    "UPDATE models SET lawman = 1, handled = 1 WHERE id = @i",
    {['i'] = idModel}
  )
  DebugLoadModel(client)
end)
RegisterServerEvent('bbdebug:banskin')
AddEventHandler('bbdebug:banskin', function(idModel)
  local client = source
  BB.SQL.QUERY(
    "UPDATE models SET admin = 1, handled = 1 WHERE id = @i",
    {['i'] = idModel}
  )
  DebugLoadModel(client)
end)
RegisterServerEvent('bbdebug:nextskin')
AddEventHandler('bbdebug:nextskin', function(idModel)
  local client = source
  BB.SQL.QUERY(
    "UPDATE models SET handled = 1 WHERE id = @i",
    {['i'] = idModel}
  )
  DebugLoadModel(client)
end)










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
  if client == 0 then return true end
  if not cmd then return false end
  local command = cmd:match("^([%w]+)")
  if AdminLevel(client) >= AdminCommandLevel(command) then
    print("DEBUG - Command Authorized ("..GetPlayerName(client)..": "..command..")")
    return true
  end
  print("DEBUG - Command Denied ("..GetPlayerName(client)..": "..command..")")
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
  print("DEBUG - Checking if Player #"..tostring(client).." is Server Staff...")
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
    if tpType == 'marker' then
      ConsolePrint(GetPlayerName(client).." ("..client..
        ") teleported to X:"..(string.format("%.2f", data.x))..
        ", Y:"..(string.format("%.2f", data.y)), 2
      )
    elseif tpType == 'player' then
      if GetPlayerName(data) then 
        TriggerClientEvent('bbadmin:cl_teleport', client, tpType, data)
      else
        TriggerEvent('chat:addMessage', {color={255,0,0},multiline=true,args={
          "INVALID PLAYER", "Player ID "..tostring(data).." does not exist or has disconnected."
        }})
      end
    end
    TriggerClientEvent('bbadmin:cl_teleport', client, tpType, data)
  else print("DEBUG - Command denied for player #"..client)
  end
end)


RegisterCommand('setwanted', function(s,a,r)
  if CanUseCommand(s, r) then

    local target, wLevel

    if not a[1] and not a[2] then
      ConsolePrint("Improper Usage of Command 'setwanted': /setwanted <ID> <Points>", 3)
      return 0
    end
    target = tonumber(a[1])
    wLevel = tonumber(a[2])
      
    if not GetPlayerName(target) then
      print("No such player exists.")
      return false
    end
    
    if Config.verbose then
      ConsolePrint("Setting WP to ^3"..wLevel.."^7 for player "..(BB.Player[target].I))
    end
    BB.SetWanted(target, wLevel)

  end
end)


AddEventHandler('bbadmin:mypos', function(pos)
  local client = source
  TriggerClientEvent('chat:addMessage', client, {color={255,180,0}, multiline = true, args = {
    "POSITION", "X("..(string.format("%.2f", pos.x))..") Y("..(string.format("%.2f", pos.y))..") Z("..(string.format("%.2f", pos.z))..")"
  }})
end)


AddEventHandler('bbadmin:giveweapon', function(target, weapon, ammoCount)
  local client = source
  if CanUseCommand(client, 'giveweapon') then

    if not target or not weapon then return 0 end
      
    if not GetPlayerName(target) then
      TriggerClientEvent('chat:addMessage', client, {color={255,0,0},multiline=true,args={
        "INVALID PLAYER", "Player #"..target.." does not exist or has disconnected."
      }})
      return false
    end
    
    if not ammoCount then ammoCount = 48 end
    print("Args:", target, weapon, ammoCount)
    TriggerClientEvent('bbadmin:cl_giveweapon', target, weapon, ammoCount)
    
  end
end)

