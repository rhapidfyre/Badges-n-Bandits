
--[[
      CRIMES
      weight:     How many points the crime is weighted (the more points the more severe)
                  0 = No Wanted Level Increase (Fine/Time Only)
      sentence:   How many seconds in jail.
      isFelony:   If true, can be calculated to exceed Wanted Level 6
                  If false, the crime's weight is ignored past Wanted Level 6
      fine:       Returns a random amount for the fine of the crime
]]
local crimes = {
  ['horse-theft'] = {
    title = "Theft of a Horse", weight = 330, sentence = 3, isFelony = true,
    fine = function() return (math.random(50, 125)) end
  },
  ['carjack'] = {
    title = "Horse Theft", weight = 410, sentence = 5, isFelony = true,
    fine = function() return (math.random(10, 50)) end
  },
  ['murder'] = {
    title = "Murder (Kill Player)", weight = 600, sentence = 10, isFelony = true,
    fine = function() return (math.random(5000, 8000)) end
  },
  ['murder-leo'] = {
    title = "Murder of a Lawman", weight = 220, sentence = 15, isFelony = true,
    fine = function() return (math.random(6250, 12000)) end
  },
  ['trample'] = {
    title = "Trampling", weight = 220, sentence = 2,
    fine = function() return (math.random(6250, 12000)) end
  },
  ['manslaughter'] = {
    title = "Manslaughter (Kill NPC)", weight = 45, sentence = 2,
    fine = function() return (math.random(1000, 2000)) end
  },
  ['adw'] = {
    title = "Assault with a Weapon", weight = 60, sentence = 1, isFelony = true,
    fine = function() return (math.random(50, 100)) end
  },
  ['assault'] = {
    title = "Strongarm Assault", weight = 10, sentence = 5,
    fine = function() return (math.random(50, 100)) end
  },
  ['discharge'] = {
    title = "Firearm Discharge", weight = 12, sentence = 5,
    fine = function() return (math.random(20, 40)) end
  },
  ['robbery'] = {
    title = "Robbery", weight = 90, sentence = 4, isFelony = true,
    fine = function() return (math.random(50, 200)) end
  },
  ['robbery-train'] = {
    title = "Train Robbery", weight = 90, sentence = 5, isFelony = true,
    fine = function() return (math.random(50, 200)) end
  },
  ['robbery-banj'] = {
    title = "Bank Robbery", weight = 42, sentence = 8, isFelony = true,
    fine = function() return (math.random(10, 40)) end
  },
  ['unpaid'] = {
    title = "Unpaid Fine", weight = 50, sentence = 1, isFelony = true,
    fine = function() return (math.random(10, 50)) end
  },
  ['brandish'] = {
    title = "Weapon Brandished", weight = 5, sentence = 1,
    fine = function() return (math.random(20, 100)) end
  },
  ['jailbreak'] = {
    title = "Jailbreak", weight = 120, sentence = 10, isFelony = true,
    fine = function() return (math.random(500, 800)) end
  },
  ['kidnapping-npc'] = {
    title = "Kidnapping (NPC)", weight = 90, sentence = 10, isFelony = true,
    fine = function() return (math.random(100, 500)) end
  },
  ['kidnapping'] = {
    title = "Kidnapping", weight = 90, minTime = 5, maxTime = 10, isFelony = true,
    fine = function() return (math.random(100, 500)) end
  },
}


--- EXPORT: GetCrimeName()
-- Returns the proper name of the given crime.
-- @param crime The string of the title of the crime (carjack, murder, etc)
-- @return The name of the crime (always string, 'crime' if not found)
function BB.GetCrimeName(crime)
  if not crime               then  return  "crime"  end
  if not crimes[crime]       then  return  "crime"  end
  if not crimes[crime].title then  return  "crime"  end
  return crimes[crime].title
end


--- EXPORT: GetCrimeTime()
-- Returns the generated time for the given crime
-- @param crime The string of the title of the crime (carjack, murder, etc)
-- @return The time (in minutes) to serve. If not found, returns 0 minutes
function BB.GetCrimeTime(crime)
  if not crime         then return 0 end
  if not crimes[crime] then return 0 end
  local c = crimes[crime]
  if not c.minTime then c.minTime =  5 end
  if not c.maxTime then c.maxTime = 10 end
  local cTime = math.random(c.minTime, c.maxTime)
  return cTime
end


--- EXPORT: GetCrimeFine()
-- Returns the generated fine for the crime
-- @param crime The string of the title of the crime (carjack, murder, etc)
-- @return The time (in minutes) to serve. If not found, returns 50 dollars
function BB.GetCrimeFine(crime)
  if not crime              then  return 0 end
  if not crimes[crime]      then  return 0 end
  if not crimes[crime].fine then  return 0 end
  return (crimes[crime].fine())
end


--- EXPORT: IsCrimeFelony()
-- Gets whether the given crime is a felony
-- @param crime The string of the title of the crime (carjack, murder, etc)
-- @return The time (in minutes) to serve. If not found, returns 50 dollars
function BB.IsCrimeFelony(crime)
  if not crime                  then  return false  end
  if not crimes[crime]          then  return false  end
  if not crimes[crime].isFelony then  return false  end
  return (crimes[crime].isFelony)
end


--- EXPORT: GetCrimeWeight()
-- Gets the severity of a crime
-- @param crime The string of the title of the crime (carjack, murder, etc)
-- @return The severity weight, where 1 is least severe
function BB.GetCrimeWeight(crime)
  if not crime                 then  return (Config.levelDivision) end
  if not crimes[crime]         then  return (Config.levelDivision) end
  if not crimes[crime].weight  then  return (Config.levelDivision) end
  return ((crimes[crime].weight)*Config.levelDivision)
end


--- EXPORT: DoesCrimeExist()
-- Checks if the given crime index exists in the table
-- @param crime The string to check for
-- @return True if the crime exists, false if it does not
function BB.DoesCrimeExist(crime)
  if crimes[crime] then
    if crimes[crime].title then
      return true
    else
      cprint("^1Crime '"..tostring(crime).."' did not exist in sh_wanted.lua")
      return false
    end
  else
    cprint("^1Crime '"..tostring(crime).."' did not exist in sh_wanted.lua")
    return false
  end
end

