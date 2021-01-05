Config = {}
Config.debugging = true

Config.reduceTimer    = 30    -- Number of seconds per wanted point reduction
Config.reducePoints   = 25    -- Number of wanted points to lose per above seconds
Config.levelDivision  = 100   -- Points per wanted level (10 = every 10 points is 1 wanted level)

-- Always true if in debugging mode
Config.verbose   = Config.debugging or ( false )


function Config.GetNumberOfPlayzones()
  return GetConvarInt("bnb_zones", 1)
end

function Config.PassiveTime()
  return GetConvarInt("bnb_zones", 1)
end

function Config.RevealMap()
  return GetConvarInt("bnb_showmap", 1)
end