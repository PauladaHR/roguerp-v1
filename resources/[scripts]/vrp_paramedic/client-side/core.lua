local Tunnel = module("vrp","lib/Tunnel")
vSERVER = Tunnel.getInterface("paramedic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local damaged = {}

local pistol = {
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_APPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_REVOLVER",
	"WEAPON_COMBATPISTOL"
}

local fuzil = {
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_COMBATPDW",
	"WEAPON_SMG_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_SMG",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_GUSENBERG",
	"WEAPON_MICROSMG",
	"WEAPON_MINISMG",
	"WEAPON_COMPACTRIFLE"
}

local branca = {
	"WEAPON_KNIFE",
	"WEAPON_HATCHET",
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
	"WEAPON_KNUCKLE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_UNARMED"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSEDDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if GetEntityHealth(ped) > 110 and not IsPedInAnyVehicle(ped) then
			if not damaged.vehicle and HasEntityBeenDamagedByAnyVehicle(ped) then
				ClearEntityLastDamageEntity(ped)
				damaged.vehicle = true
			end

			for k,v in pairs(pistol) do
				if HasPedBeenDamagedByWeapon(ped,GetHashKey(v),0) then
					ClearEntityLastDamageEntity(ped)
					damaged.pistol = true
				end
			end

			for k,v in pairs(fuzil) do
				if HasPedBeenDamagedByWeapon(ped,GetHashKey(v),0) then
					ClearEntityLastDamageEntity(ped)
					damaged.fuzil = true
				end
			end

			for k,v in pairs(branca) do
				if HasPedBeenDamagedByWeapon(ped,GetHashKey(v),0) then
					ClearEntityLastDamageEntity(ped)
					damaged.branca = true
				end
			end

			if not damaged.taser and IsPedBeingStunned(ped) then
				ClearEntityLastDamageEntity(ped)
				damaged.taser = true
			end
		end

		local hit,bone = GetPedLastDamageBone(ped)
		if hit and not damaged[bone] and bone ~= 0 then
			damaged[bone] = true
		end

		Wait(1000)
	end
end)

CreateThread(function()
	while true do
		local timeDistance = 999
		local playerPed = PlayerPedId()
			
		for k,v in pairs(fuzil) do
			if HasPedBeenDamagedByWeapon(playerPed, GetHashKey(v), 0) then
				timeDistance = 4
				damaged.fuzil = true
				ClearEntityLastWeaponDamage(playerPed)
			
			end
		end
		for k,v in pairs(pistol) do
			if HasPedBeenDamagedByWeapon(playerPed, GetHashKey(v), 0) then
				timeDistance = 4
				damaged.pistol = true
				ClearEntityLastWeaponDamage(playerPed)

			end
		end
		for k,v in pairs(branca) do
			if HasPedBeenDamagedByWeapon(playerPed, GetHashKey(v), 0) then
				timeDistance = 4
				damaged.branca = true
				ClearEntityLastWeaponDamage(playerPed)
			end
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetDiagnostic")
AddEventHandler("resetDiagnostic",function()
	local ped = PlayerPedId()
	ClearPedBloodDamage(ped)

	damaged = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWINJURIES
-----------------------------------------------------------------------------------------------------------------------------------------
local exit = true
RegisterNetEvent("drawInjuries")
AddEventHandler("drawInjuries",function(ped,injuries)
	local function draw3dtext(x,y,z,text)
		local onScreen,_x,_y = World3dToScreen2d(x,y,z)
		SetTextFont(4)
		SetTextScale(0.35,0.35)
		SetTextColour(255,255,255,100)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text))/300
		DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
	end

	CreateThread(function()
		local counter = 0
		exit = not exit

		while true do
			if counter > 1000 or exit then
				exit = true
				break
			end

			for k,v in pairs(injuries) do
				local x,y,z = table.unpack(GetPedBoneCoords(GetPlayerPed(GetPlayerFromServerId(ped)),k))
				draw3dtext(x,y,z,"~w~"..string.upper(v))
			end

			counter = counter + 1
			Wait(0)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)

		if health > 101 and health <= 120 then
			TimeDistance = 1
			knockPlayer = true
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
			RequestAnimSet("move_m@injured")
			SetPedMovementClipset(ped,"move_m@injured",true)
		elseif knockPlayer and health >= 120 then
			TimeDistance = 999
			knockPlayer = false
			DisableControlAction(0,21,false)
			DisableControlAction(0,22,false)
			ResetPedMovementClipset(ped)
		end
		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.Diagnostic()
	return damaged
end