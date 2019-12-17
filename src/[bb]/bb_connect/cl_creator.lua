
-- Badges & Bandits: Character Creator Script (CLIENT)
RegisterNetEvent('bb:character_approval')
local myHash = nil

--- CharacterApproved()
-- RX'd when the server approves of the character client created
function CharacterApproved()

  -- DEBUG - This is only temporary, to get people into the game
  exports.spawnmanager:spawnPlayer({
    x = -262.85,
    y = 793.41,
    z = 118.09,
    model = 'mp_male'
  }, function()
    print("DEBUG - Player spawned as a new character!")
    exports['bb']:ReportPosition(true)
    SetPedDefaultComponentVariation(PlayerPedId())
    TriggerEvent('bb:client_loaded', true)
    TriggerServerEvent('bb:client_loaded', true)
  end)
  
end

AddEventHandler('bb:character_approval', function(passed, reason)
  if not passed then
    TriggerEvent('chat:addMessage', {multiline = true, args = {
      "REJECTED", "Character Creation was not approved.\n"..
      "Reason: "..reason
    }})
    
  else
    -- If passed, reason will be the same table of char info we sent
    CharacterApproved(reason)
    
  end
end)

--- SubmitCharacter()
-- Sends the info the client chose to the server for approval
-- @param cInfo A table with all of the creation details
function SubmitCharacter(cInfo)
  if not cInfo then cInfo = {model = 'mp_male'} end
  TriggerServerEvent('bb:request_creation', cInfo)
  
end

--- CreateCharacter()
-- Loads the character creator
function CreateCharacter(charHash)

  myHash = charHash
  
  -- DEBUG - Future Note: This will launch the character creator.
  -- For now, we're just going to jump straight to SubmitCharacter()
  SubmitCharacter({
    model = 'mp_male'
  })

end

--- ReloadCharacter()
-- Reloads the last played character with argument charInfo
-- @param charInfo Table with character information
-- @table model, clothes, weapons, gold, cash
function ReloadCharacter(charInfo)
  -- DEBUG - This is only temporary, to get people into the game
  exports.spawnmanager:spawnPlayer({
    x = -262.85,
    y = 793.41,
    z = 118.09,
    model = 'mp_male'
  }, function()
    print("DEBUG - Player spawned with their last played character!")
    exports['bb']:ReportPosition(true)
    TriggerEvent('bb:client_loaded')
    TriggerServerEvent('bb:client_loaded')
  end)
end