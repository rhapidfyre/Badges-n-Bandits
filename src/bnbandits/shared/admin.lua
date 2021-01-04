

local ranks = {
  ['Player']    = 0,  -- REQUIRED RANK
  ['Moderator'] = 1,  -- REQUIRED RANK
  ['Admin']     = 2,  -- REQUIRED RANK
  ['Manager']   = 3,
  ['Server']    = 4,  -- REQUIRED RANK
},
local commands = {
  ['aclear']            = 'Admin',   -- Clear all player's chatbox completely
  ['setname']           = 'Admin',   -- Forces the players name to Firstname Lastname
  ['nutrition']         = 'Moderator',      -- All nutrition commands (set hunger/thirst/alcohol)
  ['togooc']            = 'Moderator',      -- Disables/Enables Global OOC
  ['asay']              = 'Moderator',      -- Admin Chat
  ['lr']                = 'Moderator',      -- List active reports
  ['reports']           = 'Moderator',      -- List active reports
  ['report']            = 'Player',         -- Create a Report
  ['ar']                = 'Admin',   -- Accepts a Player Report
  ['acceptreport']      = 'Admin',   -- Accepts a Player Report
  ['rr']                = 'Admin',   -- Rejects a Player Report
  ['rejectreport']      = 'Admin',   -- Rejects a Player Report
  ['yacht']             = 'Admin',   -- Teleport to Admin Yacht
  ['goto']              = 'Admin',   -- Teleport to given Player ID
  ['coords']            = 'Admin',   -- Teleport to Exact Coordinates
  ['gotomark']          = 'Admin',   -- Teleport to GPS Waypoint
  ['bring']             = 'Admin',   -- Teleport Server ID to This Player
  ['tpsend']            = 'Admin',   -- Send Player 1 to Player 2
  ['tpback']            = 'Admin',   -- Go back to pre-teleport location
  ['freeze']            = 'Admin',   -- Freeze the Player from Moving
  ['unfreeze']          = 'Moderator',      -- Unfreeze the Player
  ['spawncar']          = 'Admin',   -- Spawns a Vehicle on Player
  ['spawnobj']          = 'Admin',
  ['spawnped']          = 'Admin',
  ['spectate']          = 'Admin',
  ['setcash']           = 'Admin',
  ['setbank']           = 'Admin',
  ['alock']             = 'Admin',
  ['giveweapon']        = 'Admin',
  ['takeweapon']        = 'Admin',
  ['takeweapons']       = 'Admin',
  ['takecurrentweapon'] = 'Admin',
  ['clearped']          = 'Admin',
  ['clearveh']          = 'Admin',
  ['delveh']            = 'Admin',
  ['fix']               = 'Admin',
  ['whois']             = 'Admin',
  ['admin']             = 'Admin',
  ['god']               = 'Admin',
  ['ajail']             = 'Moderator',
  ['warn']              = 'Moderator',
  ['kick']              = 'Moderator',
  ['ban']               = 'Admin',
  ['tempban']           = 'Admin',
  ['noclip']            = 'Admin',
  ['restrict']          = 'Admin',
  ['heal']              = 'Admin',
}


function AdminCommandLevel(cmd)
  local aLevel = 4
  if commands[cmd] then
    local temp = commands[cmd]
    if ranks[temp] then
      aLevel = ranks[temp]
    end
  end
  return aLevel
end


function AdminTitle(aRank)
  if not aRank then aRank = 0 end
  if type(aRank) ~= "number" then aRank = tonumber(aRank) end
  for k,v in pairs (ranks) do
    if v == aRank then return k end
  end
  return 'Player'
end