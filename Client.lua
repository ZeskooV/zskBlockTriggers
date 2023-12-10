local function triggerExecuted(source, args, rawCommand)
  TriggerServerEvent(GetCurrentResourceName() .. ':bNa_PlA-EyR')
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
