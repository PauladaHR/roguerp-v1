-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Treatment = false
local Timer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDSIN
-----------------------------------------------------------------------------------------------------------------------------------------
local bedsIn = {
	["Santos"] = {
		{ -812.26,-1224.43,6.9,140.01 },
		{ -809.23,-1220.88,6.9,320.01 },
		{ 314.46,-584.2,44.2,340.16 },
		{ 317.68,-585.37,44.2,340.16 },
		{ 322.62,-587.16,44.2,340.16 },
		{ 324.26,-582.8,44.2,158.75 },
		{ 319.42,-581.05,44.2,158.75 },
		{ 313.93,-579.04,44.2,158.75 },
		{ 309.35,-577.38,44.2,158.75 }
	},
	["Paleto"] = {
		{ -252.15,6323.11,33.35,133.23 },
		{ -246.98,6317.95,33.35,133.23 },
		{ -245.27,6316.22,33.35,133.23 },
		{ -251.03,6310.51,33.35,317.49 },
		{ -252.63,6312.12,33.35,317.49 },
		{ -254.39,6313.88,33.35,317.49 },
		{ -256.1,6315.58,33.35,317.49 }
	},
	["Bolingbroke"] = {
		{ 1771.98,2591.79,46.66,87.88 },
		{ 1771.98,2594.88,46.66,87.88 },
		{ 1771.98,2597.95,46.66,87.88 },
		{ 1761.87,2597.73,46.66,272.13 },
		{ 1761.87,2594.64,46.66,272.13 },
		{ 1761.87,2591.56,46.66,272.13 }
	},
	["Clandestine"] = {
		{ -471.86,6287.42,14.70,235.28 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("checkin:initCheck")
AddEventHandler("checkin:initCheck",function(Hospital)
	if LocalPlayer["state"]["Route"] < 900000 then
		local ped = PlayerPedId()

		for _,v in pairs(bedsIn[Hospital]) do
			local checkPos = nearestPlayer(v[1],v[2],v[3])
			if not checkPos then
				if vSERVER.PayCheckin() then
					TriggerEvent("inventory:preventWeapon",true)
					LocalPlayer["state"]["Commands"] = true
					LocalPlayer["state"]["Cancel"] = true
					TriggerEvent("paramedic:Reset")

					if GetEntityHealth(ped) <= 101 then
						vRP.revivePlayer(102)
					end

					DoScreenFadeOut(0)
					Wait(1000)

					Treatment = true
					SetEntityHeading(ped,v[4])
					SetEntityCoords(ped,v[1],v[2],v[3],1,0,0,0)
					vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)

					Wait(1000)
					DoScreenFadeIn(1000)
				end

				break
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function nearestPlayers(x,y,z)
	local userList = {}
	local ped = PlayerPedId()
	local userPlayers = GetPlayers()

	for k,v in pairs(userPlayers) do
		local uPlayer = GetPlayerFromServerId(k)
		if uPlayer ~= PlayerId() and NetworkIsPlayerConnected(uPlayer) then
			local uPed = GetPlayerPed(uPlayer)
			local uCoords = GetEntityCoords(uPed)
			local distance = #(uCoords - vec3(x,y,z))
			if distance <= 2 then
				userList[uPlayer] = distance
			end
		end
	end

	return userList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function nearestPlayer(x,y,z)
	local userSelect = false
	local minRadius = 2.0001
	local userList = nearestPlayers(x,y,z)

	for _,_Infos in pairs(userList) do
		if _Infos <= minRadius then
			minRadius = _Infos
			userSelect = true
		end
	end

	return userSelect
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
	local pedList = {}

	for _,_player in ipairs(GetActivePlayers()) do
		pedList[GetPlayerServerId(_player)] = true
	end

	return pedList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("checkin:startTreatment")
AddEventHandler("checkin:startTreatment",function()
	if not Treatment then
		LocalPlayer["state"]["Commands"] = true
		Treatment = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment then
			if GetGameTimer() >= Timer then
				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)
				Timer = GetGameTimer() + 1000

				if health < 200 then
					SetEntityHealth(ped,health + 1)
				else
					Treatment = false
					LocalPlayer["state"]["Cancel"] = false
					LocalPlayer["state"]["Commands"] = false
					TriggerEvent("Notify","amarelo","Tratamento concluido.",5000)
				end
			end
		end

		Wait(1000)
	end
end)