
--[[
  Badges n' Bandits
  A Cops and Robbers Gamemode for RedM
]]

fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"

dependency 'ghmattimysql'
resource_type 'gametype' { name = 'Badges & Bandits'}

client_scripts {
  "ent_enum.lua",
  "client/lib/init.lua",
  "client/lib/blips.lua",
  "client/lib/player.lua",
  "client/lang/*.lua",
  "client/*.lua"
}

shared_scripts {
  "config.lua",
  "shared/lib/init.lua",
  "shared/lang/*.lua",
  "shared/*.lua"
}

server_scripts {
  "server/lib/init.lua",
  "server/lib/crimes.lua",
  "server/lib/player.lua",
  "server/lang/*.lua",
  "server/*.lua"
}

ui_page "nui/ui.html"

file {
  "nui/img/bgPanel.png",
  "nui/crock.ttf",
	"nui/ui.css", "nui/hud.css", "nui/creator.css", "nui/scores.css", "nui/wanted.css",
	"nui/ui.js",	"nui/ui.html"
}

server_exports {
  'UniqueId',               -- The UniqueID of the Player
  'WantedLevel',
  'IsLawman',
  'PlayerScore',
  
  'GetPlayerByUniqueId',    -- Returns > 0 if unique ID is currently playing
}

exports {
  'UniqueId',               -- The UID of the player ID given (of the client if nil)
  'WantedLevel',
  'IsLawman',
  'PlayerScore',
}