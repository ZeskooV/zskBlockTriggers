local function getIdentifiers(player)
  local src = source
  if (player) then
    src = player
  end
  
  local identifiers = GetPlayerIdentifiers(src)

  local identifiersArray = {
    steam = nil,
    discord = nil,
    license = nil,
    xbox = nil,
    ip = nil
  }
  
  for _, identifier in pairs(identifiers) do
    if (identifier and string.sub(identifier, 1, string.len("steam:")) == "steam:") then
      identifiersArray['steam'] = identifier
    elseif (identifier and string.sub(identifier, 1, string.len("discord:")) == "discord:") then
      identifiersArray['discord'] = identifier
    elseif (identifier and string.sub(identifier, 1, string.len("license:")) == "license:") then
      identifiersArray['license'] = identifier
    elseif (identifier and string.sub(identifier, 1, string.len("xbox:")) == "xbox:") then
      identifiersArray['xbox'] = identifier
    elseif (identifier and string.sub(identifier, 1, string.len("ip:")) == "ip:") then
      identifiersArray['ip'] = identifier
    end
  end


  return identifiersArray
end

local function triggerBlock(...)
  local 
end

for i=1, #Shared.ServerTriggers, 1 do
  local triggerName = Shared.ServerTriggers[i]
  if (triggerName) then
    RegisterNetEvent(triggerName)
    AddEventHandler(triggerName, triggerBlock)
  end
end
