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


local function banPlayer(player, banData)
  local banList = LoadResourceFile(GetCurrentResourceName(), "bans.json") or "{}"
  if (banList and banData) then
    banList = json.decode(banList)
    for k,v in pairs(banData.identifiers) do
      banList[v] = {
        reason = banData.reason,
        expiry = banData.expiry
      }
    end
    Wait(1000)
    SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(banList), -1)
    if (player ~= nil and player ~= -1) then
      DropPlayer(player, banData.reason)
    end
  end
end

local function formatDate(date)
  if (date) then
    local formattedDate = os.date("%Y-%m-%d %H:%M:%S", date)
    
    if (formattedDate) then
      return formattedDate
    else
      return "NEVER"
    end
  else
    return "NEVER"
  end
end

local function triggerBlock(source, ...)
  local src = source
  if (src ~= nil and src ~= -1) then
    local identifiers = getIdentifiers(src)
    local player = source
    
    if (identifiers) then
      local banData = {
        identifiers = identifiers,
        reason = "Blocked Trigger Execution"
        expiry = os.time() + ((24 * 3600) * 99999999)
      }
      
      if (banData and Shared.CustomBANSystem) then
        Shared.BANPlayer(banData)
      elseif (banData) then
        banPlayer(player, banData)
      end
    end
  else
    return
  end
end

local function playerConnecting(name, kickReason, deferrals)
  local identifiers = getIdentifiers(source)
  local banList = LoadResourceFile(GetCurrentResourceName(), "bans.json") or "{}"
  
  if (banList) then
    banList = json.decode(banList)
    
    for k,v in pairs(identifiers) do
      if (banList[v] ~= nil) then
        if (os.time() > banList[v].expiry) then
          banList[v] = nil
          SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(banList), -1)
        else
          kickReason("You've been banned from this server, for: " .. banList[v].reason .. "\nYour Ban Expires: " .. formatDate(banList[v].expiry))
          CancelEvent()
        end
      end
    end
  end
end

AddEventHandler(
  'playerConnecting',
  playerConnecting
)

for i=1, #Shared.ServerTriggers, 1 do
  local triggerName = Shared.ServerTriggers[i]
  
  if (triggerName) then
    RegisterNetEvent(triggerName)
    AddEventHandler(triggerName, triggerBlock)
  end
end

local function clientTriggerReceived(source, ...)
  if (source ~= nil and source ~= -1) then
    local identifiers = getIdentifiers(source)

    if (identifiers) then
      local banData = {
        identifiers = identifiers,
        reason = "Client-Side Blocked Trigger Execution"
        expiry = os.time() + ((24 * 3600) * 99999999)
      }

      if (banData and Shared.CustomBANSystem) then
          Shared.BANPlayer(banData)
      elseif (banData and not Shared.CustomBANSystem) then
          banPlayer(source, banData)
      end
    end
  end
end

RegisterNetEvent(GetCurrentResourceName() .. ':bNa_PlA-EyR')
AddEventHandler(GetCurrentResourceName() .. ':bNa_PlA-EyR', clientTriggerReceived)
