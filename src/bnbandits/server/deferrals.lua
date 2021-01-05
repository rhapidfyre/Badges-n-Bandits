
function GetPlayerInformation(client)
  local plyInfo = GetPlayerIdentifiers(client)
  local infoTable = {
    ['ip']    = GetPlayerEndpoint(client),
    -- Removes all non alphanumeric characters
    ['user']  = string.gsub(GetPlayerName(client), "[%W]", "")
  }
  for k,id in pairs (plyInfo) do
    local length = string.len(id)
    local colon  = string.find(id, ':')
    if colon then
      local idType  = string.sub(id, 0, colon - 1)
      local idValue = string.sub(id, colon + 1, length)
      if idType and idValue then 
        infoTable[idType] = idValue
      end
    end
  end
  
  local idValid = {['steam'] = "", ['license'] = "", ['discord'] = "", ['ip'] = "", ['user'] = ""}
  for k,v in pairs (infoTable) do 
    if idValid[k] then idValid[k] = v end
  end
  
  return idValid
end

-- Connection Verification
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)

	deferrals.defer()
  local client = source
	deferrals.update("Connecting to: Badges n' Bandits")
  
  local ids = GetPlayerInformation(client)
  
  local uid = BB.SQL.RSYNC(
    "SELECT GetAccount (@steam, @license, @discord, @ip, @user)", ids
  )
  
  if uid > 0 then
    deferrals.update("Evaluating your credentials...")
    ConsolePrint("^3DEFERRALS: ^7Validating "..playerName.."'s access rights.")
    Wait(500)
    
    local banInfo = BB.SQL.QUERY(
      "SELECT perms,ban_time,ban_reason FROM players WHERE id = @uid",
      {['uid'] = uid}
    )

    -- if bantime is set, it's a temp ban
    if banInfo[1]['ban_time'] > 0 then

      local nowDate     = os.time()
      local banRelease  = banInfo[1]["ban_time"]/1000

      -- If tempban time has expired, release the ban
      if nowDate > banRelease then
        BB.SQL.QUERY(
          "UPDATE players SET ban_time = NULL, ban_reason = NULL "..
          "WHERE id = @uid", {['uid'] = uid}
        )
        deferrals.update("Tempban expired. Unbanning your account. Welcome back!")
        ConsolePrint(playerName.." was automatically unbanned (tempban expired).")
        Citizen.Wait(2000)
      else
        deferrals.done("Banned Until "..(os.date("%X %x", banRelease)).." (GMT -8). Reason: "..banInfo[1]['ban_reason'])
        ConsolePrint(playerName.." disconnected - Permabanned.")
        return false
      end

    end

    deferrals.update("Authorized. Welcome back, "..playerName)
    Citizen.Wait(100)
    ConsolePrint(playerName.." is connecting!")
    
  elseif uid < 0 then 
    deferrals.update("Preparing account for first time player...")
    ConsolePrint(playerName.." is connecting for the first time!", 2)
    Wait(2000)
    
  else
    deferrals.update("No Steam/SC/Discord ID found. Your session will not save.")
    Wait(3000)
    
  end
  
  deferrals.done()
end)
