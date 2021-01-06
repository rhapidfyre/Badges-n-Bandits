
RegisterServerEvent('bb:crime')
RegisterServerEvent('bb:murder')


AddEventHandler('bb:crime', function(cType, isAttempt)
  local client = source
  local aMsg = ''
  if isAttempt then aMsg = ' (Attempted)' end
  print(BB.Player[client].I .. " reports they committed a '"..cType..aMsg.."'.")
end)

AddEventHandler('bb:murder', function(idKiller)
  local idVictim = source
  print((BB.Player[idVictim].I).." reports that "..(BB.Player[idKiller].I).." murdered them.")
end)