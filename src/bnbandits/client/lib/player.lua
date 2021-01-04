

function BB.WantedLevel()
  local me = GetPlayerServerId(PlayerId())
  if not BB.wanted[me] then BB.wanted[me] = 0 end
  local wL = math.ceil(BB.wanted[me] / 100)
  return wL
end


function BB.Initialize(myUID)
  while not BB do
    print("^1BB Metatable didn't exist... ^7Waiting.")
    Wait(5000)
  end
  BB.Player = {}
  if not myUID then return false end
  if myUID < 1 then return false end
  BB.Player.idUnique = myUID
  BB.Player.scores   = {0,0}
  BB.WantedLevel()
  return true
end

