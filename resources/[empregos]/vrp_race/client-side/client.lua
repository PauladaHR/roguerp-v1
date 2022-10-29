-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
hiro = {}
Tunnel.bindInterface("vrp_race",hiro)
vSERVER = Tunnel.getInterface("vrp_race")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local currentRace = 0
local timeRace = 0
local racePos = 0
local inRace = false
local initializeTime = 0
local initializeStart = false
local races = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
		local timeDistance = 500
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsUsing(ped)
			local mHash = (GetEntityModel(vehicle))

			if not inRace then

				for k,v in pairs(races) do
					local distance = #(coords - vector3(v["initialCoord"][1],v["initialCoord"][2],v["initialCoord"][3]))
					if distance <= 10 then
						timeDistance = 4
						DrawText3D(v["initialCoord"][1],v["initialCoord"][2],v["initialCoord"][3]+1,"BUZINE PARA COMEÇAR A CORRIDA")
						DrawMarker(23,v["initialCoord"][1],v["initialCoord"][2],v["initialCoord"][3]-0.2,0,0,0,0,0,0,15.0,15.0,1.0,0,102,204,50,0,0,0,0)
						if IsControlJustPressed(0,38)  and GetPedInVehicleSeat(vehicle,-1) == ped and vSERVER.globalCooldown(k) and IsEntityAVehicle(vehicle) then
							if vSERVER.checkTicket() then
								currentRace = k
								vSERVER.addPlayerInRace(k)
								vSERVER.checkStart(k)
							end
						end
					end
				end
			else

				local distanceRace = #(coords - vector3(races[currentRace]["coordsRace"][racepoint][1],races[currentRace]["coordsRace"][racepoint][2],races[currentRace]["coordsRace"][racepoint][3]))

				if distanceRace <= 100.0 then
					timeDistance = 4

					DrawMarker(1,races[currentRace]["coordsRace"][racepoint][1],races[currentRace]["coordsRace"][racepoint][2],races[currentRace]["coordsRace"][racepoint][3]-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0) -- CIRCULO FORA
					DrawMarker(21,races[currentRace]["coordsRace"][racepoint][1],races[currentRace]["coordsRace"][racepoint][2],races[currentRace]["coordsRace"][racepoint][3]+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,0,102,204,50,1,0,0,1) -- BLIP DENTRO

					if distanceRace <= 15.1 then
						RemoveBlip(blips)
						if racepoint == #races[currentRace]["coordsRace"] then
							local timeFinal = races[currentRace]["time"] - timeRace
							inRace = false
							PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
							vSERVER.removePlayerFromRace(currentRace,true)
							SendNUIMessage({ active = false })
							vSERVER.PayRace(currentRace,timeFinal,mHash)
						else
							racepoint = racepoint + 1
							PlaySoundFrontend(-1,"CHECKPOINT_AHEAD","HUD_MINI_GAME_SOUNDSET",false)
							CreateBlip(races[currentRace]["coordsRace"][racepoint][1],races[currentRace]["coordsRace"][racepoint][2],races[currentRace]["coordsRace"][racepoint][3])
						end
					end
				end
				
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTADOR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999

		if initializeStart then
			timeDistance = 1
			drawText(""..initializeTime.."")

			if initializeTime == 0 then
				initializeStart = false
				initializeTime = 0

				PlaySoundFrontend(-1,"CHECKPOINT_AHEAD","HUD_MINI_GAME_SOUNDSET",false)
				racepoint = 1
				CreateBlip(races[currentRace]["coordsRace"][racepoint][1],races[currentRace]["coordsRace"][racepoint][2],races[currentRace]["coordsRace"][racepoint][3])
				timeRace = races[currentRace]["time"]
				inRace = true
				vSERVER.freezeRace(currentRace,false)
			end
		end

		if inRace and IsPedInAnyVehicle(PlayerPedId()) then
			timeDistance = 1
			vSERVER.updateLeaderboard(currentRace,racepoint,GetGpsBlipRouteLength(PlayerPedId()))
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if inRace then
			if timeRace > 0 then
				timeRace = timeRace - 1

				if timeRace <= 0 or not IsPedInAnyVehicle(PlayerPedId()) then

					inRace = false
					RemoveBlip(blips)
					vSERVER.removePlayerFromRace(currentRace)

					Citizen.Wait(3000)
					SendNUIMessage({ active = false })

					AddExplosion(GetEntityCoords(GetPlayersLastVehicle()),2,1.0,true,true,true)
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if initializeStart then
			if initializeTime > 0 then
				initializeTime = initializeTime - 1
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERACE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_race:sendPosition")
AddEventHandler("vrp_race:sendPosition",function(position,total)
	racePos = position
	SendNUIMessage({ active = true, pos = racePos, total = total, time = timeRace })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEFUSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_race:defuseRace")
AddEventHandler("vrp_race:defuseRace",function()
	inRace = false
	RemoveBlip(blips)
	vSERVER.removePlayerFromRace(currentRace)
	SendNUIMessage({ active = false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_race:start")
AddEventHandler("vrp_race:start",function()
	initializeStart = true
	initializeTime = 10
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_race:freeze")
AddEventHandler("vrp_race:freeze",function(boolean)
	FreezeEntityPosition(GetPlayersLastVehicle(),boolean)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.updateRaces(status)
	races = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATERACES
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.updateRaces(status)
	races = status

	for k,v in pairs(races) do
		local blip = AddBlipForRadius(v["initialCoord"][1],v["initialCoord"][2],v["initialCoord"][3],10.0)
		SetBlipAlpha(blip,200)
		SetBlipColour(blip,59)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- Blips
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateBlip(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,1)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Checkpoint")
	EndTextCommandSetBlipName(blips)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,255)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)
		local width = string.len(text) / 125 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,0,102,204,100)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function drawText(text,height)
	SetTextFont(2)
	SetTextScale(2.50,2.50)
	SetTextColour(0,102,204,180)
	SetTextOutline()
	SetTextCentre(5)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.500,0.150)
	SetTextProportional(1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Actived = false
local TyreExplodes = 0
CreateThread(function()
	while true do
		local TimeDistance = 999
		if not Actived then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				TimeDistance = 1

				DisableControlAction(0,345,true)

				local Vehicle = GetVehiclePedIsUsing(Ped)
				if GetPedInVehicleSeat(Vehicle,-1) == Ped then
					if GetVehicleDirtLevel(Vehicle) ~= 0.0 then
						SetVehicleDirtLevel(Vehicle,0.0)
					end

					local Speed = GetEntitySpeed(Vehicle) * 2.236936
					if Speed ~= TyreExplodes then
						if (TyreExplodes - Speed) >= 125 then
							local Tyre = math.random(4)
							if Tyre == 1 then
								if GetTyreHealth(Vehicle,0) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,0,true,1000.0)
								end
							elseif Tyre == 2 then
								if GetTyreHealth(Vehicle,1) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,1,true,1000.0)
								end
							elseif Tyre == 3 then
								if GetTyreHealth(Vehicle,4) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,4,true,1000.0)
								end
							elseif Tyre == 4 then
								if GetTyreHealth(Vehicle,5) == 1000.0 then
									SetVehicleTyreBurst(Vehicle,5,true,1000.0)
								end
							end
						end

						TyreExplodes = Speed
					end
				end
			else
				if TyreExplodes ~= 0 then
					TyreExplodes = 0
				end
			end
		end

		Wait(TimeDistance)
	end
end)