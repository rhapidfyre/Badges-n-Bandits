
local creator = {
  posn = vector3(-5428.24, -2262.03, 27.77),
  head = 10.0,
  horse = vector3(-5431.71, -2263.18, 27.84),
  hhead = 305.0,
}


function CreateCharacter()

  local ped = PlayerPedId()
  SetEntityCoordsNoOffset(ped, creator.posn)
  Citizen.Wait(800)
  SetEntityHeading(ped, creator.head)
  
  SendNUIMessage({showmenu = 'creator-main'})
  SetNuiFocus(true, true)
  
end


function BB.Initialize(metaData)
  if not metaData then return false end
  if not metaData.u then return false end
  while not BB do Wait(100) end
  BB.Player = {
    idServer = GetPlayerServerId(PlayerId()),
    scores   = {0,0}, idUnique = metaData.u,
    model    = metaData.m
  }
  if metaData.m then
    LoadModel(metaData.m)
    SetPlayerModel(PlayerPedId(), metaData.m)
    SetModelAsNoLongerNeeded(metaData.m)
    if N_0x283978a15512b2fe then
      N_0x283978a15512b2fe(PlayerPedId(), true)
      UpdatePedVariation(PlayerPedId(), 0, 1, 1, 1, false)
    end
  else CreateCharacter()
  end
  if metaData.u < 1 then return false end
  return true
end

