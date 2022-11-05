-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_player",cRP)
vSERVER = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Meth = 0
local Drunk = 0
local Cocaine = 0
local Energetic = 0
LocalPlayer["state"]["Handcuff"] = false
LocalPlayer["state"]["Commands"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Commands")
AddEventHandler("player:Commands",function(status)
	LocalPlayer["state"]["Commands"] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AWAYSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
local awayTimers = GetGameTimer()
local awaySystem = { 0.0,0.0,1800 }

CreateThread(function()
	while true do
		if GetGameTimer() >= awayTimers then
			awayTimers = GetGameTimer() + 10000

			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			if coords["x"] == awaySystem[1] and coords["y"] == awaySystem[2] then
				if awaySystem[3] > 0 then
					awaySystem[3] = awaySystem[3] - 10

					if awaySystem[3] == 60 or awaySystem[3] == 30 then
						TriggerEvent("Notify","amarelo","Mova-se e evite ser desconectado.",3000)
					end
				else
					TriggerServerEvent("player:kickSystem","Desconectado, muito tempo ausente.")
				end
			else
				awaySystem[1] = coords["x"]
				awaySystem[2] = coords["y"]
				awaySystem[3] = 1800
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local salaryTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= salaryTimers then
			salaryTimers = GetGameTimer() + (30 * 60000)
			vSERVER.receiveSalary()
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FPS
-----------------------------------------------------------------------------------------------------------------------------------------
local FpsCommands = false
RegisterCommand("fps",function(source,args,rawCommand)
	if FpsCommands then
		FpsCommands = false
		ClearTimecycleModifier()
	else
		FpsCommands = true
		SetTimecycleModifier("cinema")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:inBennys")
AddEventHandler("player:inBennys",function(status)
	inBennys = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeVehicle()
	if not inBennys then
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			TaskLeaveVehicle(ped,GetVehiclePedIsUsing(ped),16)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deleteVehicle")
AddEventHandler("player:deleteVehicle",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) and GetVehicleNumberPlateText(v) == vehPlate then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLASTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.setPlaster(type)
	local ped = PlayerPedId()
	if type == "1" then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,11,186,9,2) -- jaqueta
			SetPedComponentVariation(ped,8,15,0,2) -- camisa
			SetPedComponentVariation(ped,3,166,0,2) -- maos
			SetPedComponentVariation(ped,4,84,9,2) -- calça
			SetPedComponentVariation(ped,6,1,2,2) -- sapatos
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,11,188,9,2) -- jaqueta
			SetPedComponentVariation(ped,8,6,0,2) -- camisa
			SetPedComponentVariation(ped,3,207,0,2) -- maos
			SetPedComponentVariation(ped,4,86,9,2) -- calça
			SetPedComponentVariation(ped,6,27,0,2) -- sapatos
		end
	end

	if type == "2" then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,11,186,9,2) -- jaqueta
			SetPedComponentVariation(ped,8,15,0,2) -- camisa
			SetPedComponentVariation(ped,3,166,0,2) -- maos
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,11,188,9,2) -- jaqueta
			SetPedComponentVariation(ped,8,6,0,2) -- camisa
			SetPedComponentVariation(ped,3,207,0,2) -- maos
		end
	end

	if type == "3" then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,4,94,1,2) -- calça
			SetPedComponentVariation(ped,6,47,3,2) -- sapatos
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,4,97,1,2) -- calça
			SetPedComponentVariation(ped,6,48,3,2) -- sapatos
		end
	end

	if type == "4" then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,6,47,3,2) -- sapatos
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,6,48,3,2) -- sapatos
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATSHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
			timeDistance = 100
			local vehicle = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(vehicle,0) == ped then
				if not GetIsTaskActive(ped,164) and GetIsTaskActive(ped,165) then
					SetPedIntoVehicle(ped,vehicle,0)
					SetPedConfigFlag(ped,184,true)
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setEnergetic")
AddEventHandler("setEnergetic",function(Timer,Number)
	Energetic = Energetic + Timer
	SetRunSprintMultiplierForPlayer(PlayerId(),Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetEnergetic")
AddEventHandler("resetEnergetic",function()
	if Energetic > 0 then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		Energetic = 0
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Energetic > 0 then
			Energetic = Energetic - 1
			RestorePlayerStamina(PlayerId(),1.0)

			if Energetic <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
				Energetic = 0
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMETH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setMeth")
AddEventHandler("setMeth",function()
	Meth = Meth + 30

	if not GetScreenEffectIsActive("DMT_flight") then
		StartScreenEffect("DMT_flight",0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMETH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Meth > 0 then
			Meth = Meth - 1

			if Meth <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				Meth = 0

				if GetScreenEffectIsActive("DMT_flight") then
					StopScreenEffect("DMT_flight")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setCocaine")
AddEventHandler("setCocaine",function()
	Cocaine = Cocaine + 30

	if not GetScreenEffectIsActive("MinigameTransitionIn") then
		StartScreenEffect("MinigameTransitionIn",0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCOCAINE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Cocaine > 0 then
			Cocaine = Cocaine - 1

			if Cocaine <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				Cocaine = 0

				if GetScreenEffectIsActive("MinigameTransitionIn") then
					StopScreenEffect("MinigameTransitionIn")
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setDrunkTime")
AddEventHandler("setDrunkTime",function(Timer)
	Drunk = Drunk + Timer

	LocalPlayer["state"]["Drunk"] = true
	RequestAnimSet("move_m@drunk@verydrunk")
	while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
		Wait(1)
	end

	SetPedMovementClipset(PlayerPedId(),"move_m@drunk@verydrunk",0.25)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Drunk > 0 then
			Drunk = Drunk - 1

			if Drunk <= 0 or GetEntityHealth(PlayerPedId()) <= 100 then
				ResetPedMovementClipset(PlayerPedId(),0.25)
				LocalPlayer["state"]["Drunk"] = false
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCHOODOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncHoodOptions")
AddEventHandler("player:syncHoodOptions",function(vehNet,Active)
	if NetworkDoesNetworkIdExist(vehNet) then
		local Vehicle = NetToEnt(vehNet)
		if DoesEntityExist(Vehicle) then
			if Active == "open" then
				SetVehicleDoorOpen(Vehicle,4,0,0)
			elseif Active == "close" then
				SetVehicleDoorShut(Vehicle,4,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORSOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:syncDoorsOptions")
AddEventHandler("player:syncDoorsOptions",function(vehNet,Active)
	if NetworkDoesNetworkIdExist(vehNet) then
		local Vehicle = NetToEnt(vehNet)
		if DoesEntityExist(Vehicle) then
			if Active == "open" then
				SetVehicleDoorOpen(Vehicle,5,0,0)
			elseif Active == "close" then
				SetVehicleDoorShut(Vehicle,5,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCWINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:syncWins")
AddEventHandler("vrp_player:syncWins",function(index,status)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			if status then
				RollUpWindow(v,0)
				RollUpWindow(v,1)
				RollUpWindow(v,2)
				RollUpWindow(v,3)
			else
				RollDownWindow(v,0)
				RollDownWindow(v,1)
				RollDownWindow(v,2)
				RollDownWindow(v,3)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:syncDoors")
AddEventHandler("vrp_player:syncDoors",function(vehIndex,door)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) and GetVehicleDoorsLockedForPlayer(v,PlayerId()) ~= 1 then
			if door == "1" then
				if GetVehicleDoorAngleRatio(v,0) == 0 then
					SetVehicleDoorOpen(v,0,0,0)
				else
					SetVehicleDoorShut(v,0,0)
				end
			elseif door == "2" then
				if GetVehicleDoorAngleRatio(v,1) == 0 then
					SetVehicleDoorOpen(v,1,0,0)
				else
					SetVehicleDoorShut(v,1,0)
				end
			elseif door == "3" then
				if GetVehicleDoorAngleRatio(v,2) == 0 then
					SetVehicleDoorOpen(v,2,0,0)
				else
					SetVehicleDoorShut(v,2,0)
				end
			elseif door == "4" then
				if GetVehicleDoorAngleRatio(v,3) == 0 then
					SetVehicleDoorOpen(v,3,0,0)
				else
					SetVehicleDoorShut(v,3,0)
				end
			elseif door == "5" then
				if GetVehicleDoorAngleRatio(v,5) == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			elseif door == "6" then
				if GetVehicleDoorAngleRatio(v,4) == 0 then
					SetVehicleDoorOpen(v,4,0,0)
				else
					SetVehicleDoorShut(v,4,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:SeatPlayer")
AddEventHandler("vrp_player:SeatPlayer",function(index)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) and IsPedInAnyVehicle(ped) then
		if parseInt(index) <= 1 or index == nil then
			seat = -1
		elseif parseInt(index) == 2 then
			seat = 0
		elseif parseInt(index) == 3 then
			seat = 1
		elseif parseInt(index) == 4 then
			seat = 2
		elseif parseInt(index) == 5 then
			seat = 3
		elseif parseInt(index) == 6 then
			seat = 4
		elseif parseInt(index) == 7 then
			seat = 5
		elseif parseInt(index) >= 8 then
			seat = 6
		end

		if IsVehicleSeatFree(vehicle,seat) then
			SetPedIntoVehicle(ped,vehicle,seat)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.toggleHandcuff()
	if not LocalPlayer["state"]["Handcuff"] then
		TriggerEvent("vrp_radio:outServers")
		LocalPlayer["state"]["Handcuff"] = true
		LocalPlayer["state"]["Commands"] = true
		LocalPlayer["state"]["Buttons"] = true
		exports["smartphone"]:closeSmartphone()
	else
		LocalPlayer["state"]["Handcuff"] = false
		LocalPlayer["state"]["Commands"] = false
		LocalPlayer["state"]["Buttons"] = false
		vRP.stopAnim(false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getHandcuff()
	return LocalPlayer["state"]["Handcuff"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetHandcuff")
AddEventHandler("resetHandcuff",function()
	if LocalPlayer["state"]["Handcuff"] then
		LocalPlayer["state"]["Handcuff"] = false
		vRP.stopAnim(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVEMENTCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.movementClip(dict)
	RequestAnimSet(dict)
	while not HasAnimSetLoaded(dict) do
		Wait(10)
	end
	SetPedMovementClipset(PlayerPedId(),dict,0.25)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if LocalPlayer["state"]["Handcuff"] then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,21,true)
			DisableControlAction(1,55,true)
			DisableControlAction(1,102,true)
			DisableControlAction(1,179,true)
			DisableControlAction(1,203,true)
			DisableControlAction(1,76,true)
			DisableControlAction(1,23,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,243,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,263,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADWHILEHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 101 then
			if not IsEntityPlayingAnim(ped,"mp_arresting","idle",3) then
				RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded("mp_arresting") do
					Wait(10)
				end

				TaskPlayAnim(ped,"mp_arresting","idle",3.0,3.0,-1,49,0,0,0,0)
				timeDistance = 1
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
local losSantos = PolyZone:Create({
	vector2(-2153.08,-3131.33),
	vector2(-1581.58,-2092.38),
	vector2(-3271.05,275.85),
	vector2(-3460.83,967.42),
	vector2(-3202.39,1555.39),
	vector2(-1642.50,993.32),
	vector2(312.95,1054.66),
	vector2(1313.70,341.94),
	vector2(1739.01,-1280.58),
	vector2(1427.42,-3440.38),
	vector2(-737.90,-3773.97)
},{ name="santos" })

local sandyShores = PolyZone:Create({
	vector2(-375.38,2910.14),
	vector2(307.66,3664.47),
	vector2(2329.64,4128.52),
	vector2(2349.93,4578.50),
	vector2(1680.57,4462.48),
	vector2(1570.01,4961.27),
	vector2(1967.55,5203.67),
	vector2(2387.14,5273.98),
	vector2(2735.26,4392.21),
	vector2(2512.33,3711.16),
	vector2(1681.79,3387.82),
	vector2(258.85,2920.16)
},{ name="sandy" })

local paletoBay = PolyZone:Create({
	vector2(-529.40,5755.14),
	vector2(-234.39,5978.46),
	vector2(278.16,6381.84),
	vector2(672.67,6434.39),
	vector2(699.56,6877.77),
	vector2(256.59,7058.49),
	vector2(17.64,7054.53),
	vector2(-489.45,6449.50),
	vector2(-717.59,6030.94)
},{ name="paleto" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local residual = false
local sprayTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local blackWeapons = {
	"WEAPON_UNARMED",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_STUNGUN",
	"GADGET_PARACHUTE",
	"WEAPON_PETROLCAN",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_BAT",
	"WEAPON_BATTLEAXE",
	"WEAPON_BOTTLE",
	"WEAPON_CROWBAR",
	"WEAPON_DAGGER",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_MACHETE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",
	"WEAPON_SWITCHBLADE",
	"WEAPON_WRENCH",
	"WEAPON_KNUCKLE"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
local BlackWeapons = false
CreateThread(function()
	while true do
		local TimeDistance = 999
		local ped = PlayerPedId()
		if IsPedArmed(ped,6) and GetGameTimer() >= sprayTimers then
			TimeDistance = 1

			if IsPedShooting(ped) then
				sprayTimers = GetGameTimer() + 60000
				residual = true

				for k,v in ipairs(blackWeapons) do
					if GetSelectedPedWeapon(ped) == GetHashKey(v) then
						BlackWeapons = true
					end
				end

				if not IsPedCurrentWeaponSilenced(ped) then
					local coords = GetEntityCoords(ped)
					if (losSantos:isPointInside(coords) or sandyShores:isPointInside(coords) or paletoBay:isPointInside(coords)) and not LocalPlayer["state"]["Police"] and not LocalPlayer["state"]["Paramedic"] then
						TriggerServerEvent("evidence:dropEvidence","blue")
						if not BlackWeapons then
							vSERVER.shotsFired()
						end

						BlackWeapons = false
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYGSR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:applyGsr")
AddEventHandler("player:applyGsr",function()
	residual = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GSRCHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.gsrCheck()
	return residual
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false
function cRP.toggleCarry(source)
	uCarry = source
	iCarry = not iCarry

	local ped = PlayerPedId()
	if iCarry and uCarry then
		AttachEntityToEntity(ped,GetPlayerPed(GetPlayerFromServerId(uCarry)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped,false,false)
			sCarry = false
		end
	end	
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarryBaby = nil
local iCarryBaby = false
local sCarryBaby = false
function cRP.toggleBaby(source)
	uCarryBaby = source
	iCarryBaby = not iCarryBaby
	local ped = PlayerPedId()
	if iCarryBaby and uCarryBaby then
		AttachEntityToEntity(ped,GetPlayerPed(GetPlayerFromServerId(uCarryBaby)),31086,0,0.2,0.9,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarryBaby = true
	else
		if sCarryBaby then
			DetachEntity(ped,false,false)
			sCarryBaby = false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeVehicle()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if iCarry then
			iCarry = false
			DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
		end

		TaskLeaveVehicle(ped,GetVehiclePedIsUsing(ped),4160)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.putVehicle(vehIndex)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			local vehSeats = 5
			local ped = PlayerPedId()

			repeat
				vehSeats = vehSeats - 1

				if IsVehicleSeatFree(v,vehSeats) then
					ClearPedTasks(ped)
					ClearPedSecondaryTask(ped)
					SetPedIntoVehicle(ped,v,vehSeats)

					if iCarry then
						iCarry = false
						DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
					end

					vehSeats = true
				end
			until vehSeats == true or vehSeats == 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WECOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.weColors(number)
	local ped = PlayerPedId()
	local weapon = GetSelectedPedWeapon(ped)
	SetPedWeaponTintIndex(ped,weapon,parseInt(number))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WELUX
-----------------------------------------------------------------------------------------------------------------------------------------
local wLux = {
	["WEAPON_PISTOL"] = {
		"COMPONENT_PISTOL_VARMOD_LUXE"
	},
	["WEAPON_APPISTOL"] = {
		"COMPONENT_APPISTOL_VARMOD_LUXE"
	},
	["WEAPON_HEAVYPISTOL"] = {
		"COMPONENT_HEAVYPISTOL_VARMOD_LUXE"
	},
	["WEAPON_MICROSMG"] = {
		"COMPONENT_MICROSMG_VARMOD_LUXE"
	},
	["WEAPON_SNSPISTOL"] = {
		"COMPONENT_SNSPISTOL_VARMOD_LOWRIDER"
	},
	["WEAPON_PISTOL50"] = {
		"COMPONENT_PISTOL50_VARMOD_LUXE"
	},
	["WEAPON_COMBATPISTOL"] = {
		"COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER"
	},
	["WEAPON_CARBINERIFLE"] = {
		"COMPONENT_CARBINERIFLE_VARMOD_LUXE"
	},
	["WEAPON_CARBINERIFLE_MK2"] = {
		"COMPONENT_CARBINERIFLE_MK2_VARMOD_LUXE"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		"COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER"
	},
	["WEAPON_SAWNOFFSHOTGUN"] = {
		"COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE"
	},
	["WEAPON_SMG"] = {
		"COMPONENT_SMG_VARMOD_LUXE"
	},
	["WEAPON_ASSAULTRIFLE"] = {
		"COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		"COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01"
	},
	["WEAPON_ASSAULTSMG"] = {
		"COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WELUX
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.weLux()
	local ped = PlayerPedId()
	for k,v in pairs(wLux) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			for k2,v2 in pairs(v) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrunk = false
local trunkPlate = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:EnterTrunk")
AddEventHandler("vrp_player:EnterTrunk",function()
	local ped = PlayerPedId()

	if not IsPedInAnyVehicle(ped) then
		if not inTrunk then
			local vehicle,vehNet,vehPlate = vRP.vehList(10)
			if DoesEntityExist(vehicle) and GetVehicleDoorsLockedForPlayer(vehicle,PlayerId()) ~= 1 then
				local trunk = GetEntityBoneIndexByName(vehicle,"boot")
				local speed = GetEntitySpeed(vehicle) * 3.6
				if trunk ~= -1 and speed <= 3 then
					local coords = GetEntityCoords(ped)
					local coordsEnt = GetWorldPositionOfEntityBone(vehicle,trunk)
					local distance = #(coords - coordsEnt)
					if distance <= 3.0 then
						if GetVehicleDoorAngleRatio(vehicle,5) < 0.9 and GetVehicleDoorsLockedForPlayer(vehicle,PlayerId()) ~= 1 then
							trunkPlate = vehPlate
							SetCarBootOpen(vehicle)
							SetEntityVisible(ped,false,false)
							Wait(750)
							AttachEntityToEntity(ped,vehicle,-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
							Wait(500)
							SetVehicleDoorShut(vehicle,5)
							LocalPlayer["state"]["Commands"] = true
							inTrunk = true
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:CheckTrunk")
AddEventHandler("vrp_player:CheckTrunk",function()
	if inTrunk then
		local ped = PlayerPedId()
		local vehicle = GetEntityAttachedTo(ped)
		if DoesEntityExist(vehicle) then
			SetCarBootOpen(vehicle)
			Wait(750)
			inTrunk = false
			LocalPlayer["state"]["Commands"] = false
			DetachEntity(ped,false,false)
			SetEntityVisible(ped,true,false)
			SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.5,-0.25),1,0,0,0)
			Wait(500)
			SetVehicleDoorShut(vehicle,5)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999

		if inTrunk then
			local ped = PlayerPedId()
			local Vehicle = GetEntityAttachedTo(ped)
			if DoesEntityExist(Vehicle) then
				timeDistance = 1

				DisablePlayerFiring(ped,true)

				if IsEntityVisible(ped) then
					SetEntityVisible(ped,false,false)
				end

				if IsControlJustPressed(1,38) then
					inTrunk = false
					DetachEntity(ped,false,false)
					SetEntityVisible(ped,true,false)
					LocalPlayer["state"]["Commands"] = false
					SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.25,-0.25),1,0,0,0)
				end
			else
				inTrunk = false
				DetachEntity(ped,false,false)
				SetEntityVisible(ped,true,false)
				LocalPlayer["state"]["Commands"] = false
				SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.25,-0.25),1,0,0,0)
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYDAMAGE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local is_dead = false 
    local has_been_dead = false 
    local diedAt 
    
    while true do
        Wait(1000)

        local player = PlayerId()
        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()
            if IsPedFatallyInjured(ped) and not is_dead then
                is_dead = true 
                if not diedAt then
                    diedAt = GetGameTimer()
                end

                local killer,killer_weapon = NetworkGetEntityKillerOfPlayer(player)

                local killerId = GetPlayerByEntityID(killer)
                if killer ~= ped and killerId ~= nil and NetworkIsPlayerActive(killerId) then
                    killerId = GetPlayerServerId(killerId)
                else
                    killerId = -1 
                end
                if killer == ped or killer == -1 then
                    has_been_dead = true
                    TriggerServerEvent('deathLogs',killerId);
                end
            elseif not IsPedFatallyInjured(ped) then 
                is_dead = false 
                diedAt = false
            end
        end
    end
end)

function GetPlayerByEntityID(id)
	for i=0,300 do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
	end
	return nil
end

AddEventHandler('gameEventTriggered',function(event,args)
    if event == 'CEventNetworkEntityDamage' then
        if GetEntityHealth(args[1]) <= 101 and PlayerPedId() == args[1] then
            local index = NetworkGetPlayerIndexFromPed(args[2]);
            local src = GetPlayerServerId(index);
            TriggerServerEvent('deathLogs',src);
        end 
    end
end)

-- RegisterCommand("bug",function(source,args,rawCommand)
-- 	FreezeEntityPosition(PlayerPedId(),false)
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local objEnt = {}
local objList = {
	["soccer"] = { prop = "p_ld_soc_ball_01", z = 0.2, freeze = false },
	["campfire"] = { prop = "prop_beach_fire", z = 0.1, freeze = true },
	["tent"] = { prop = "prop_skid_tent_01", z = 0.6, freeze = true },
	["tent2"] = { prop = "prop_gazebo_02", z = 0.0, freeze = true },
	["tent3"] = { prop = "prop_parasol_02", z = 0.0, freeze = true },
	["chair"] = { prop = "prop_chair_02", z = 0.0, freeze = true },
	["chair2"] = { prop = "prop_skid_chair_02", z = 0.0, freeze = true },
	["chair3"] = { prop = "prop_old_deck_chair", z = 0.0, freeze = true },
	["chair4"] = { prop = "prop_table_03_chr", z = 0.0, freeze = true },
	["table"] = { prop = "prop_table_03", z = 0.4, freeze = true },
	["cooler"] = { prop = "prop_coolbox_01", z = 0.0, freeze = true },
	["bbq"] = { prop = "prop_bbq_5", z = 0.0, freeze = true },
	["bbq2"] = { prop = "prop_bbq_1", z = 0.0, freeze = true },
	["mic"] = { prop = "v_club_roc_micstd", z = 0.4, freeze = true },
	["guitar"] = { prop = "prop_el_guitar_03", z = 0.55, freeze = true },
	["cab"] = { prop = "v_club_roc_cab1", z = 0.0, freeze = true },
	["cab2"] = { prop = "v_club_roc_cab2", z = 0.0, freeze = true },
	["cab3"] = { prop = "v_club_roc_cab3", z = 0.0, freeze = true },
	["cab4"] = { prop = "v_club_roc_cabamp", z = 0.0, freeze = true },
	["cab5"] = { prop = "v_club_roc_monitor", z = 0.0, freeze = true },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.insertObjects(name)
    if objList[name] then
        if not objEnt[name] then
            local v = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,0.0)
            local _,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
            local k = CreateObjectNoOffset(GetHashKey(objList[name].prop),v.x,v.y,cdz+objList[name].z,true,false,false)

			SetEntityHeading(k,GetEntityHeading(PlayerPedId()))
            FreezeEntityPosition(k,objList[name].freeze)
            SetEntityAsMissionEntity(k,true,true)
			SetEntityAsNoLongerNeeded(k)
            objEnt[name] = k
		else
            TriggerServerEvent("trydeleteobj",ObjToNet(objEnt[name]))
            objEnt[name] = nil
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOATANCHOR
-----------------------------------------------------------------------------------------------------------------------------------------
local barcoancorado = false

function cRP.boatAnchor(vehicle)
	if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) == 14 then
		if barcoancorado then
			TriggerEvent("Notify","IMPORTANTE", "Barco desancorado.", 5000, 'info')
			FreezeEntityPosition(vehicle,false)
			barcoancorado = false
		else
			TriggerEvent("Notify","IMPORTANTE", "Barco ancorado.", 5000, 'info')
			FreezeEntityPosition(vehicle,true)
			barcoancorado = true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrash = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ENTERTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:enterTrash")
AddEventHandler("player:enterTrash",function(entity)
	if not inTrash then
		LocalPlayer["state"]["Commands"] = true

		local ped = PlayerPedId()
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)
		SetEntityCoords(ped,entity[4],1,0,0,0)

		inTrash = GetOffsetFromEntityInWorldCoords(entity[1],0.0,-1.5,0.0)

		while inTrash do
			Wait(1)

			if IsControlJustPressed(1,38) then
				FreezeEntityPosition(ped,false)
				SetEntityVisible(ped,true,false)
				SetEntityCoords(ped,inTrash,1,0,0,0)
				LocalPlayer["state"]["Commands"] = false

				inTrash = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	if inTrash then
		local ped = PlayerPedId()
		FreezeEntityPosition(ped,false)
		SetEntityVisible(ped,true,false)
		SetEntityCoords(ped,inTrash,1,0,0,0)
		LocalPlayer["state"]["Commands"] = false

		inTrash = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:FLIPVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local flippingVehicle = false
AddEventHandler("player:flipVehicle",function(innerEntity)
	if not innerEntity or not innerEntity[3] or flippingVehicle then return end

	local vehicle = innerEntity[3]
	if IsEntityAVehicle(vehicle) then
		flippingVehicle = true
		
		local animationDict = "missheistfbi3b_ig7"
		local animationName = "lift_fibagent_loop"

		vRP._playAnim(false, {animationDict, animationName}, true)

		local lastTest
		local seconds = 90
		while seconds > 0 do
			Wait(1000)
			if not IsEntityPlayingAnim(PlayerPedId(), animationDict, animationName, 3) then
				TriggerEvent("Notify","amarelo","Você parou de tentar descapotar o veículo!",5000,"info")
				flippingVehicle = false
				return
			end

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(vehicle)) > 8 then
				TriggerEvent("Notify","NEGADO","Longe demais do veículo",5000,"negado")
				flippingVehicle = false
				return
			end

			local rand = math.random(100)
			if rand < 25 and (not lastTest or lastTest < GetGameTimer()) then
				if exports["vrp_taskbar"]:skillTest(3000, 4, 7) then
					seconds = seconds - 10
				else
					TriggerEvent("Notify","amarelo","Você tentou empurrar o veículo e não conseguiu, mas continuou tentando!",5000)
					seconds = seconds + 15
				end
				lastTest = GetGameTimer() + 8000
			end

			seconds = seconds - 1
		end

		flippingVehicle = false

		vRP._stopAnim()
		TriggerServerEvent("upgradeStress",20)

		NetworkFadeOutEntity(vehicle, false, true)
		while NetworkIsEntityFading(vehicle) do
			Wait(100)
		end

		SetVehicleOnGroundProperly(vehicle)

		NetworkFadeInEntity(vehicle, 0)
	end
end)
-- local parts = {
--     [1] = "Máscara",
--     [3] = "Mãos",
--     [4] = "Calça",
--     [5] = "Mochila",
--     [6] = "Sapatos",
--     [7] = "Acessorios",
--     [8] = "Blusa",
--     [9] = "Colete",
--     [10] = "Adesivos",
--     [11] = "Jaqueta",
--     ["p0"] = "Chapéu",
--     ["p1"] = "Óculos",
--     ["p2"] = "Brincos",
--     ["p4"] = "Relógio",
--     ["p5"] = "Bracelete"
-- }
-- local alerts = {
--     { ['hour'] = 22, ['minute'] = 0, ['color'] = 'amarelo', ['text'] = '<b>Alerta:</b> Assaltos estão liberados a partir das <b>22h</b> às <b>6h</b> da manhã!' },
--     { ['hour'] = 6, ['minute'] = 0, ['color'] = 'amarelo', ['text'] = '<b>Alerta:</b> Assaltos estão proibidos a partir das <b>6h</b> às <b>22h</b> da noite!' }
-- }

-- CreateThread(function()
--     local data = {}
--     while true do
--         for i=1,#alerts do
--             local hour1, min1 = alerts[i]['hour'], alerts[i]['minute']
--             local hour2, min2 = GetClockHours(), GetClockMinutes()
--             local check = hour1 == hour2 and min1 == min2
            
--             if check and not data['check'] then
--                 TriggerEvent('Notify',alerts[i]['color'],alerts[i]['text'],10000)
--                 data['check'] = hour2+min2
--             elseif not check and data['check'] then
--                 if hour2+min2 > data['check'] then
--                     data['check'] = nil
--                 end
--             end
--         end
--         Wait(1000)
--     end
-- end)