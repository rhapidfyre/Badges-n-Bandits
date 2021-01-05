

function BB.Initialize(myUID)
  while not BB do
    print("^1BB Metatable didn't exist... ^7Waiting.")
    Wait(5000)
  end
  BB.Player = {
    idServer = GetPlayerServerId(PlayerId()),
    scores   = {0,0},
    idUnique = myUID
  }
  if not myUID then return false end
  if myUID < 1 then return false end
  return true
end

