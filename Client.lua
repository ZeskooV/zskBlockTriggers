local function banPlayer(reason)
  TriggerServerEvent(GetCurrentResourceName() .. ':bNa_PlA-EyR', reason or "Unspecified BAN reason")
end

local function triggerExecuted(source, args, rawCommand)
  banPlayer('Client-Side LUA Trigger Execution')
end

local function NUIDevToolsOpened()
  -- Code From : QamarQ
  if (Shared.BlockNUIDevTools) then
    print("Bye bye, you're going to get banned!")
    banPlayer('Opening of the NUI Dev Tools')
  end
end

RegisterNUICallback(GetCurrentResourceName(), NUIDevToolsOpened)

local function checkSilentAim()
  local checkSecs = 10
  local _ped = PlayerPedId()
  while (true) do
    Wait((checkSecs) * 1000)
    local _model = GetEntityModel(_ped)
    local min, max 	= GetModelDimensions(_model)
    if (min.y < -0.29 or max.z > 0.98) then
      banPlayer('Silent Aim Detected')
    end
  end
end

if (Shared.AntiSilentAIM) then
  CreateThread(checkSilentAim)
end

if (Shared.Enabled) then
  for i=1, #Shared.ClientTriggers, 1 do
    local triggerName = Shared.ClientTriggers[i]
    if (triggerName) then
      RegisterNetEvent(triggerName)
      AddEventHandler(triggerName, triggerExecuted)
    end
  end
end
