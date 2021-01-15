
local useDiscord = false  -- Toggles discord messages created by this script


function ConsolePrint(message, warnLevel)
  local dt = os.date("%X", os.time())
  if warnLevel then
    if warnLevel < 2 then     print("^4["..dt.." - GAME] ^7"..message.."^7")
    elseif warnLevel < 3 then print("^3["..dt.." - WARN] ^7"..message.."^7")
    else                      print("^1["..dt.." - ERR]  ^7"..message.."^7")
    end
  else print("^7["..dt.." - GAME] "..message.."^7")
  end
end

local function AssignUniqueId(client)
  
  local ids = GetPlayerInformation(client)
  
  local uid = BB.SQL.RSYNC(
    "SELECT GetAccount (@steam, @license, @discord, @ip, @user)", ids
  )
  
  if uid then return uid end
  return nil
  
end


--- EXPORT: UniqueId()
-- Retrieves the user's Unique ID. If not found, will check MySQL
-- @param client The Player's Server ID
function UniqueId(client)
  if client then
    
    -- If no meta, build meta. If uid exists in meta, return it
    if not BB.Player[client] then BB.Player[client] = {} end

    if id then
      BB.Player[client].unique = id
      print("DEBUG - Assigned uid "..id.." to Player #"..client)
      return id

    else
      if not BB.Player[client].unique then
        print("DEBUG - Checking SQL for Unique ID.")
        BB.Player[client].unique = AssignUniqueId(client)
      end
    end

    return BB.Player[client].unique
  end
  return nil -- If player ID not given return nil
end