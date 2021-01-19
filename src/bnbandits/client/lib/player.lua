
function BB.Initialize(metaData)
  if not metaData then return false end
  if not metaData[1] then return false end
  while not BB do Wait(100) end
  BB.Player = {
    idServer = GetPlayerServerId(PlayerId()),
    scores   = {0,0}, idUnique = metaData[1],
    model    = metaData[3]
  }
  if metaData[3] then
    LoadModel(metaData[3])
    SetPlayerModel(PlayerPedId(), metaData[3])
    SetModelAsNoLongerNeeded(metaData[3])
    if N_0x283978a15512b2fe then
      N_0x283978a15512b2fe(PlayerPedId(), true)
      UpdatePedVariation(PlayerPedId(), 0, 1, 1, 1, false)
    end
  else CreateCharacter(); return false
  end
  if metaData[1] < 1 then return false end
  return true
end