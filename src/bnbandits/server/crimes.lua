
RegisterServerEvent('bb:crime')
RegisterServerEvent('bb:murder')


AddEventHandler('bb:crime', function(cType, isAttempt)
  local client = source
  local aMsg = ''
  if BB.DoesCrimeExist(cType) then
    local crimeInfo = {
      name    = GetCrimeName(cType),
      f       = GetCrimeFine(cType),
      j       = GetCrimeTime(cType),
      felony  = GetCrimeFelony(cType),
      points  = GetCrimeWeight(cType)
    }
    BB.IncreaseWantedPoints(client, crimeInfo.points, crimeInfo.felony)
  else ConsolePrint("Unable to locate reported crime type '"..cType.."'.")
  end
end)


AddEventHandler('bb:murder', function(idKiller)
  local idVictim = source
  print((BB.Player[idVictim].I).." reports that "..(BB.Player[idKiller].I).." murdered them.")
end)