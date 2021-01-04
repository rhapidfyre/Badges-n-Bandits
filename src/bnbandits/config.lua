Config = {}
Config.debugging = true

Config.reduceTimer  = 60        -- Number of seconds per wanted point reduction
Config.reducePoints = 1.25      -- Number of wanted points to lose per above seconds

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