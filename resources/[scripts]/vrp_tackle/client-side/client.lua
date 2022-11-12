-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local tackleSystem = 0
local anim = "dive_run_fwd_-45_loop"
local dict = "swimming@first_person@diving"
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping('tackle:inTackle', 'Derrubar jogador', 'keyboard', "E")
RegisterCommand('tackle:inTackle', function()
	local ped = PlayerPedId()
	if (IsPedRunning(ped) or IsPedSprinting(ped)) and tackleSystem <= 0 and not IsPedSwimming(ped) then
		local userStatus = nearestPlayers()
		if userStatus then
			TriggerServerEvent("tackle:Update",GetPlayerServerId(userStatus))
			tackleSystem = 3

			startCooldownThread()

			if not IsPedRagdoll(ped) then
				RequestAnimDict(dict)
				while not HasAnimDictLoaded(dict) do
					Wait(1)
				end

				if IsEntityPlayingAnim(ped,dict,anim,3) then
					ClearPedSecondaryTask(ped)
				else
					TaskPlayAnim(ped,dict,anim,8.0,-8,-1,49,0,0,0,0)

					local tackleSeconds = 3
					while tackleSeconds > 0 do
						Wait(100)
						tackleSeconds = tackleSeconds - 1

						-- for k, v in ipairs(GetTouchedPlayers()) do
						-- 	TriggerServerEvent("tackle:Update", GetPlayerServerId(v))
						-- end
					end

					ClearPedSecondaryTask(ped)
					SetPedToRagdoll(ped,1000,1000,0,0,0,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLE:PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tackle:Player")
AddEventHandler("tackle:Player",function()
	SetPedToRagdoll(PlayerPedId(),5000,5000,0,0,0,0)
	TriggerServerEvent("inventory:Cancel")
	tackleSystem = 3

	startCooldownThread()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function startCooldownThread()
	CreateThread(function()
		while tackleSystem > 0 do
			tackleSystem = tackleSystem - 1
			Wait(1000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function nearestPlayers()
	local ped = PlayerPedId()
	local nearestPlayer = false
	local listPlayers = GetPlayers()
	local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,1.25,0.0)
	for _,v in ipairs(listPlayers) do
		local uPlayer = GetPlayerPed(v)
		if uPlayer ~= ped and not IsPedInAnyVehicle(uPlayer) then
			local uCoords = GetEntityCoords(uPlayer)
			local distance = #(coords - uCoords)
			if distance <= 1.25 then
				nearestPlayer = v
			end
		end
	end
	return nearestPlayer
end

function GetTouchedPlayers()
    local TouchedPlayer = {}
    for Key,Value in ipairs(GetPlayers()) do
		if IsEntityTouchingEntity(PlayerPedId(),GetPlayerPed(Value)) then
			table.insert(TouchedPlayer,Value)
		end
    end
    return TouchedPlayer
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
	return GetActivePlayers()
end
