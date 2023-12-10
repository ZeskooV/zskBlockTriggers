local function banPlayer(reason)
  TriggerServerEvent(GetCurrentResourceName() .. ':bNa_PlA-EyR', reason)
end

local function triggerExecuted(source, args, rawCommand)
  banPlayer('Client-Side LUA Trigger Execution')
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
