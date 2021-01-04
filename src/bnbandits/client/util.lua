

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, x, y)
end


--- EXPORT GetClosestPlayer()
-- Finds the closest player
-- @return Player local ID. nil if client's alone
function GetClosestPlayer()
	local ped  = PlayerPedId()
	local plys = GetActivePlayers()
  local myPos = GetEntityCoords(ped)
	local cPly = 0
	local cDist = 120.0
	for k,v in pairs (plys) do
		local tgt = GetPlayerPed(v)
		if tgt ~= ped then
			local dist = #(myPos - GetEntityCoords(tgt))
			if dist < cDist then
				cPly = v
				cDist = dist
			end
		end
	end
	return cPly
end