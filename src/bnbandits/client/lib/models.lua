local models = {
  male = {
  },
  female = {
  
  }
}

function ThisModelNumber(mdl, isFemale)
  if not isFemale then
    for i = 1, #models.male do
      if mdl == models.male[i] then
        return i
      end
    end
  else
    for i = 1, #models.female do
      if mdl == models.female[i] then
        return i
      end
    end
  end
  return 0
end


function GetBBModel(n, isFemale)
  -- if n is not provided, then pick random
  if not n then
    if isFemale then n = math.random(#models.female)
    else n = math.random(#models.male)
    end
  end
  if isFemale then return models.female[n] end
  return models.male[n]
end