-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local voice = 2
local stress = 0
local hunger = 100
local thirst = 100
local showHud = false
local showMovie = false
local radioDisplay = ""
local FreezeTime = false
local showTime = false
local anesthesia = false
local knockPlayer = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local beltLock = 0
local beltSpeed = 0
local beltVelocity = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Mumble = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected",function()
	if not Mumble then
		SendNUIMessage({ mumble = false })
		Mumble = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected",function()
	if Mumble then
		SendNUIMessage({ mumble = true })
		Mumble = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active",function(status)
	showHud = status
	SendNUIMessage({ hud = showHud })
	updateDisplayHud(PlayerPedId())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function(source,args)
	if exports["chat"]:statusChat() then
		showHud = not showHud
		SendNUIMessage({ hud = showHud })
		updateDisplayHud(PlayerPedId())
		TriggerEvent("hud:switchHud",showHud)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("movie",function(source,args)
	if exports["chat"]:statusChat() then
		showMovie = not showMovie
		SendNUIMessage({ movie = showMovie })
		updateDisplayHud(PlayerPedId())
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
	showHood = not showHood
	SendNUIMessage({ hood = showHood })

	if showHood then
		SetPedComponentVariation(PlayerPedId(),1,69,0,2)
	else
		SetPedComponentVariation(PlayerPedId(),1,0,0,2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANESTESIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_hud:toggleAnestesia")
AddEventHandler("vrp_hud:toggleAnestesia",function()
	if anesthesia then 
		anesthesia = false
		showHud = not showHud
		SendNUIMessage({ hud = showHud })
		updateDisplayHud(PlayerPedId())
		TriggerEvent("hud:switchHud",showHud)
		ClearTimecycleModifier()
	else
		anesthesia = true
		showHud = not showHud
		SendNUIMessage({ hud = showHud })
		updateDisplayHud(PlayerPedId())
		TriggerEvent("hud:switchHud",showHud)
		DoScreenFadeOut(1100)
		Wait(2500)
		DoScreenFadeIn(1100)
		SetTimecycleModifier("BlackOut")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANESTESIA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if FreezeTime then
			SetWeatherTypeNow("CLEAR")
			SetWeatherTypePersist("CLEAR")
			SetWeatherTypeNowPersist("CLEAR")
			NetworkOverrideClockTime(00,00,00)
		else
			SetWeatherTypeNow(GlobalState["Weather"])
			SetWeatherTypePersist(GlobalState["Weather"])
			SetWeatherTypeNowPersist(GlobalState["Weather"])
			NetworkOverrideClockTime(GlobalState["Hours"],GlobalState["Minutes"],00)
		end

		if beltLock >= 1 then
			DisableControlAction(1,75,true)
		end

		Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:HOURS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:Hours")
AddEventHandler("homes:Hours",function(status)
	FreezeTime = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHUD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if showHud then
			if IsPedInAnyVehicle(PlayerPedId()) then
				timeDistance = 50
			else
				timeDistance = 500
			end
			updateDisplayHud(PlayerPedId())
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDISPLAYHUD
-----------------------------------------------------------------------------------------------------------------------------------------
local flexDirection = "Norte"
function updateDisplayHud()
	local pid = PlayerId()
	local ped = PlayerPedId()
	local armour = GetPedArmour(ped)
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	local health = GetEntityHealth(ped) - 100
	local oxigen = GetPlayerUnderwaterTimeRemaining(PlayerId())
	local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords["x"],coords["y"],coords["z"]))
	local hours = GetClockHours()
	local minutes = GetClockMinutes()

	if heading >= 315 or heading < 45 then
		flexDirection = "Norte"
	elseif heading >= 45 and heading < 135 then
		flexDirection = "Oeste"
	elseif heading >= 135 and heading < 225 then
		flexDirection = "Sul"
	elseif heading >= 225 and heading < 315 then
		flexDirection = "Leste"
	end

	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		local fuel = GetVehicleFuelLevel(vehicle)
		local speed = GetEntitySpeed(vehicle) * 3.6

		local showBelt = true
		if GetVehicleClass(vehicle) == 8 and (GetVehicleClass(vehicle) >= 13 and GetVehicleClass(vehicle) <= 16) and GetVehicleClass(vehicle) == 21 or IsPedOnAnyBike(ped) then
			showBelt = false
		end

		SendNUIMessage({ vehicle = true, talking = MumbleIsPlayerTalking(pid), health = health, armour = armour, thirst = thirst, hunger = hunger, stress = stress, street = streetName, direction = flexDirection, radio = radioDisplay, voice = voice, oxigen = oxigen, fuel = fuel, speed = speed, showbelt = showBelt, seatbelt = beltLock, hours = hours, minutes = minutes, showTime = showTime })
	else
		SendNUIMessage({ vehicle = false, talking = MumbleIsPlayerTalking(pid), health = health, armour = armour, thirst = thirst, hunger = hunger, stress = stress, street = streetName, direction = flexDirection, radio = radioDisplay, voice = voice, oxigen = oxigen, hours = hours, minutes = minutes, showTime = showTime })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOKOVOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio",function(number)
	if parseInt(number) <= 0 then
		radioDisplay = ""
	else
		if parseInt(number) == 911 then
			radioDisplay = "Policia"
		elseif parseInt(number) == 912 then
			radioDisplay = "Policia"
		elseif parseInt(number) == 112 then
			radioDisplay = "Paramédico"
		elseif parseInt(number) == 704 then
			radioDisplay = "Reboque"
		else
			radioDisplay = parseInt(number)..".0Mhz"
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_HUD:VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode",function(status)
	voice = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusHunger")
AddEventHandler("statusHunger",function(number)
	hunger = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSTHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusThirst")
AddEventHandler("statusThirst",function(number)
	thirst = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSSTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusStress")
AddEventHandler("statusStress",function(number)
	stress = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(progressTimer)
	SendNUIMessage({ progress = true, progressTimer = progressTimer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOWARDPED
-----------------------------------------------------------------------------------------------------------------------------------------
function fowardPed(ped)
	local heading = GetEntityHeading(ped) + 90.0
	if heading < 0.0 then
		heading = 360.0 + heading
	end

	heading = heading * 0.0174533

	return { x = math.cos(heading) * 2.0, y = math.sin(heading) * 2.0 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBELT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			if not IsPedOnAnyBike(ped) and not IsPedInAnyHeli(ped) and not IsPedInAnyPlane(ped) then
				timeDistance = 4

				local vehicle = GetVehiclePedIsUsing(ped)
				local speed = GetEntitySpeed(vehicle) * 3.6
				if speed ~= beltSpeed then

					if (beltSpeed - speed) >= 60 and beltLock == 0 then
						local fowardVeh = fowardPed(ped)
						local coords = GetEntityCoords(ped)
						SetEntityCoords(ped,coords["x"] + fowardVeh["x"],coords["y"] + fowardVeh["y"],coords["z"] + 1,1,0,0,0)
						SetEntityVelocity(ped,beltVelocity["x"],beltVelocity["y"],beltVelocity["z"])
						ApplyDamageToPed(ped,50,false)

						Wait(1)

						SetPedToRagdoll(ped,5000,5000,0,0,0,0)
					end

					beltVelocity = GetEntityVelocity(vehicle)
					beltSpeed = speed
				end
			end
		else
			if beltSpeed ~= 0 then
				beltSpeed = 0
			end

			if beltLock == 1 then
				beltLock = 0
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seatbelt",function(source,args)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if not IsPedOnAnyBike(ped) then
			if beltLock == 1 then
				TriggerEvent("sounds:Private","unbelt",0.5)
				beltLock = 0
			else
				TriggerEvent("sounds:Private","belt",0.5)
				beltLock = 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("seatbelt","Colocar/Retirar o cinto.","keyboard","g")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHREDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)

		if health > 101 then
			if stress >= 80 then
				ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)
				if parseInt(math.random(3)) >= 3 and not IsPedInAnyVehicle(ped) then
					SetPedToRagdoll(ped,5000,5000,0,0,0,0)
					TriggerServerEvent("vrp_inventory:Cancel")
				end
			elseif stress >= 45 and stress <= 79 then
				ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.025)
				if parseInt(math.random(3)) >= 3 and not IsPedInAnyVehicle(ped) then
					SetPedToRagdoll(ped,3000,3000,0,0,0,0)
					TriggerServerEvent("vrp_inventory:Cancel")
				end
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHREDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)

		if health > 101 then
			if hunger >= 10 and hunger <= 15 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-1)
			elseif hunger <= 9 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-2)
			end

			if thirst >= 10 and thirst <= 15 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-1)
			elseif thirst <= 9 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-2)
			end
		end

		Wait(7000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)

		if health > 101 and health <= 120 then
			knockPlayer = true
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
			RequestAnimSet("move_m@injured")
			SetPedMovementClipset(ped,"move_m@injured",true)
		elseif knockPlayer and health >= 120 then
			knockPlayer = false
			DisableControlAction(0,21,false)
			DisableControlAction(0,22,false)
			ResetPedMovementClipset(ped)
		end
		Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGPS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if ((IsPedInAnyVehicle(ped) and showHud)) then
			if not IsMinimapRendering() then
				DisplayRadar(true)
			end
		else
			if IsMinimapRendering() then
				DisplayRadar(false)
			end
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- hud:SWITCHHUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:switchHud")
AddEventHandler("hud:switchHud",function(status)
	showHud = status
end)
