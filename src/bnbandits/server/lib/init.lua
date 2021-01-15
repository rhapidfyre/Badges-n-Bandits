BB = {}
BB.Player   = {}
BB.Server   = {}
BB.wanted   = {}
BB.crimes   = {}
BB.lawman   = {}
BB.inmates  = {}
BB.scores   = {}
BB.admins   = {}
BB.reduce   = {points = 1,timer  = 60}

BB.SQL = {
    -- Execute and Forget
    -- Executes 'cb' (callback) function on result with result as argument
    -- Script doesn't wait for a response/result
    EXECUTE = function(query,tbl,cb)
      CreateThread(function()
        if not query then return error("No querystring given to BB.SQL.EXECUTE") end
        if not tbl then tbl = {} end
        exports['ghmattimysql']:execute(query, tbl,
          function(result) if cb then cb() end end
        )
      end)
    end,
    
    -- As EXECUTE
    -- Script waits for a response
    QUERY = function(query,tbl)
      if not query then return error("No querystring given to BB.SQLQUERY.") end
      if not tbl then tbl = {} end
      return ( exports['ghmattimysql']:executeSync(query, tbl) )
    end,
    
    -- Fetches first column of the first row
    -- Executes 'cb' (callback) function on result with result as argument
    -- Runs without waiting on a return
    SCALAR = function(query,tbl,cb)
      if not query then return error("No querystring given to BB.SQL.SCALAR") end
      if not tbl then tbl = {} end
      exports['ghmattimysql']:scalar(query, tbl,
        function(result) if cb then cb(result) end end
      )
    end,
    
    -- As SCALAR
    -- Script waits for a response
    RSYNC = function(query,tbl)
      if not query then return error("No querystring given to BB.SQL.RSYNC") end
      if not tbl then tbl = {} end
      return ( exports['ghmattimysql']:scalarSync(query, tbl) )
    end
}


function BB.InitializePlayer(client)
  if not client then
    return false, "No ID given to InitializePlayer()"
  end
  
  local idUnique = UniqueId(client)
  BB.Player[client].I = GetPlayerName(client).." ("..client..")"
  
  -- If UID does not exist, return a single playable session
  if not idUnique then return true, 0 end
  
  local lastPos = BB.SQL.QUERY(
    "SELECT x,y,z FROM characters WHERE id = @u",{['u'] = idUnique}
  )
  if lastPos[1] then
    if Config.verbose then
      ConsolePrint("Restored previous location for "..(BB.Player[client].I))
    end
    local prevPosition = vector3(lastPos[1]['x'],lastPos[1]['y'],lastPos[1]['z'])
    BB.Player[client].lastPos = prevPosition
  else
    if Config.verbose then ConsolePrint("No previous position found for "..(BB.Player[client].I)) end
  end
  
  return true, idUnique
end


-- Used by main script loop(s) to ensure metatable is ready
BB.ready  = true