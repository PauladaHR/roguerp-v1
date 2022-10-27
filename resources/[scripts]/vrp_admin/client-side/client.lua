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
Tunnel.bindInterface("vrp_admin",cRP)
vSERVER = Tunnel.getInterface("vrp_admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.vehicleHash(vehicle)
    local teste = (GetEntityModel(vehicle))
    vRP.prompt(source,""..teste)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.teleportWay()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		Ped = GetVehiclePedIsUsing(Ped)
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(GetBlipInfoIdCoord(waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(Ped,x,y,height,false,false,false)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(Ped) do
			Wait(1)
		end

		Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(Ped,0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(Ped) do
		Wait(1)
	end

	SetEntityCoordsNoOffset(Ped,x,y,z,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.teleportLimbo()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local _,vector = GetNthClosestVehicleNode(x,y,z,math.random(5,10),0,0,0)
	local x2,y2,z2 = table.unpack(vector)

	SetEntityCoordsNoOffset(ped,x2,y2,z2+5,0,0,1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETENPCS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deleteNpcs()
	local handle,ped = FindFirstPed()
	local finished = false
	repeat
		local coords = GetEntityCoords(ped)
		local coordsPed = GetEntityCoords(PlayerPedId())
		local distance = #(coords - coordsPed)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			TriggerServerEvent("tryDeleteEntity",PedToNet(ped))
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_admin:vehicleTuning")
AddEventHandler("vrp_admin:vehicleTuning",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleModKit(vehicle,0)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11)-1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12)-1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13)-1,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15)-1,false)
		ToggleVehicleMod(vehicle,18,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS E
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,121) then
-- 			vSERVER.buttonTxt3()
-- 		end
-- 		Citizen.Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS CORRIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(1)
--		local ped = PlayerPedId()
--		local coords = GetEntityCoords(ped)
--		if IsControlJustPressed(1,121) and IsInputDisabled(0) then
--			TriggerServerEvent("cds:corridas",coords)
--		end
--	end
--end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_admin:createProp")
AddEventHandler("vrp_admin:createProp",function(props)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop = CreateObjectNoOffset(props,x,y,z,1,0,1)
	PlaceObjectOnGroundProperly(prop)
	FreezeEntityPosition(prop,true)
	SetEntityAsMissionEntity(prop,true,true)
	SetEntityAsNoLongerNeeded(prop)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_admin:clearInventory")
AddEventHandler("vrp_admin:clearInventory",function()
	TriggerServerEvent("clearInventory")
end)
------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cloud:setApagao")
AddEventHandler("cloud:setApagao", function(cond)
    local status = false
    if cond == 1 then
        status = true
    end
    SetBlackout(status)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYDAMAGED
-----------------------------------------------------------------------------------------------------------------------------------------
local unGlitch = GetGameTimer()
AddEventHandler('entityDamaged',function(entity,attacker,weapon,fatal)
    if weapon == GetHashKey("WEAPON_STUNGUN") and unGlitch <= GetGameTimer() then
        if DoesEntityExist(entity) then
            unGlitch = GetGameTimer() + 350
            Wait(350)
			vSERVER.TxtEntity(GetEntityModel(entity),GetEntityCoords(entity),GetEntityRotation(entity),GetEntityHeading(entity))
        end
    end
end)