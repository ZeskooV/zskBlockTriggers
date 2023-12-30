local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

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
function deletePed()
    for ped in EnumeratePeds() do
        if not (IsPedAPlayer(ped))then
            RemoveAllPedWeapons(ped, true)
            DeleteEntity(ped)
        end
    end  
end

if (Shared.AntiRapePlayer) then
  CreateThread(
    function()
      while (true) do
        Wait(1000)

        for k,v in ipairs(GetActivePlayers()) do
          local _player = GetPlayerPed(v)
          local checkPlayerAnim = IsEntityPlayingAnim(_player, 'rcmpaparazzo_2', 'shag_loop_poppy', 3)
          if (checkPlayerAnim) then
            ClearPedTasks(_player)
            deletePed()
          end
        end
      end
    end
  )
end

if (Shared.AntiGodMode) then
  CreateThread(
    function()
      while (true) do
        Wait(1000)
        local _ped = PlayerPedId()
        --[[ local checkInvincible = GetPlayerInvincible(_ped) and not isAdmin
        if (checkInvincible) then
          banPlayer('Use of the GodMode detected')
        else
          local isInvincible = GetPlayerInvincible(PlayerId()) and not isAdmin
          if (isInvincible) then
            FreezeEntityPosition(_ped, true)
            DisablePlayerFiring(PlayerId(), true)
            local curVehicle = IsPedInAnyVehicle(_ped, false) > 0
            if (curVehicle) then
              FreezeEntityPosition(curVehicle, true)
            end
          end
        end--]]
	-- upgrading to a better code
      end
    end
  )
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
