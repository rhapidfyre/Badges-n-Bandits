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
      if not query then return error("No querystring given to BB.SQL.") end
      if not tbl then tbl = {} end
      exports['ghmattimysql']:execute(query, tbl,
        function(result) if cb then cb(result) end end
      )
    end,
    
    -- As EXECUTE
    -- Script waits for a response
    QUERY = function(query,tbl)
      if not query then return error("No querystring given to BB.SQL.") end
      if not tbl then tbl = {} end
      return ( exports['ghmattimysql']:executeSync(query, tbl) )
    end,
    
    -- Fetches first column of the first row
    -- Executes 'cb' (callback) function on result with result as argument
    -- Runs without waiting on a return
    SCALAR = function(query,tbl,cb)
      if not query then return error("No querystring given to BB.SQL.") end
      if not tbl then tbl = {} end
      exports['ghmattimysql']:scalar(query, tbl,
        function(result) if cb then cb(result) end end
      )
    end,
    
    -- As SCALAR
    -- Script waits for a response
    RSYNC = function(query,tbl)
      if not query then return error("No querystring given to BB.SQL.") end
      if not tbl then tbl = {} end
      return ( exports['ghmattimysql']:scalarSync(query, tbl) )
    end
}

-- Used by main script loop(s) to ensure metatable is ready
BB.ready  = true