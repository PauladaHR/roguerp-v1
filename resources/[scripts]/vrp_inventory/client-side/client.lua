-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hiro = {}
Tunnel.bindInterface("vrp_inventory",Hiro)
vSERVER = Tunnel.getInterface("vrp_inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data,cb)
	TriggerEvent("inventory:Close")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	TriggerEvent("hud:Active",true)
	SendNUIMessage({ action = "hideMenu" })
	TransitionFromBlurred(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVmoc",function(source,args)
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Buttons"] and not IsPlayerFreeAiming(PlayerId()) then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "showMenu" })
		TriggerEvent("hud:Active",false)
		TransitionToBlurred(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropItem",function(data)
	TriggerServerEvent("vrp_inventory:dropItem",data.item,data.slot,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("useItem",function(data)
	TriggerServerEvent("vrp_inventory:useItem",data.slot,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sendItem",function(data)
	TriggerServerEvent("vrp_inventory:sendItem",data.item,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
    TriggerServerEvent("vrp_inventory:populateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
    TriggerServerEvent("vrp_inventory:updateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMochila",function(data,cb)
	local inventario,peso,maxpeso,infos = vSERVER.Mochila()
	if inventario then
		cb({ inventario = inventario, peso = peso, maxpeso = maxpeso, infos = infos })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_INVENTORY:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:Update")
AddEventHandler("vrp_inventory:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Craft",function()
    Backpack = false
    SetNuiFocus(false,false)
    TriggerEvent("hud:Active",true)
    SendNUIMessage({ action = "hideMenu" })

	Wait(100)

    TriggerEvent("crafting:utils")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairVehicle")
AddEventHandler("inventory:repairVehicle",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if GetVehicleNumberPlateText(v) == vehPlate then
				local vehTyres = {}
				local fuel = GetVehicleFuelLevel(v)

				for i = 0,7 do
					local tyre_state = 2
					if IsVehicleTyreBurst(v,i,true) then
						tyre_state = 1
					elseif IsVehicleTyreBurst(v,i,false) then
						tyre_state = 0
					end

					vehTyres[i] = tyre_state
				end

				SetVehicleFixed(v)
				SetVehicleFuelLevel(v,fuel)

				for k,vs in pairs(vehTyres) do
					if vs < 2 then
						SetVehicleTyreBurst(v,k,(vs == 1),1000.0)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRBODY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairBody")
AddEventHandler("inventory:repairBody",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if GetVehicleNumberPlateText(v) == vehPlate then
				local fuel = GetVehicleFuelLevel(v)
				SetVehicleBodyHealth(v,1000.0)
				SetVehicleEngineHealth(v,1000.0)
				SetVehiclePetrolTankHealth(v,1000.0)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRTIRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairTyre")
AddEventHandler("inventory:repairTyre",function(Vehicle,Tyres,vehPlate)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Vehicle = NetToEnt(Vehicle)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == vehPlate then
				local vehTyres = {}

				for i = 0,7 do
					local Status = false

					if i ~= Tyres then
						if GetTyreHealth(Vehicle,i) ~= 1000.0 then
							Status = true
						end
					end

					SetVehicleTyreFixed(Vehicle,i)

					vehTyres[i] = Status
				end

				for Tyre,Burst in pairs(vehTyres) do
					if Burst then
						SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairAdmin")
AddEventHandler("inventory:repairAdmin",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if GetVehicleNumberPlateText(v) == vehPlate then
				local fuel = GetVehicleFuelLevel(v)

				SetVehicleFixed(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKPICKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:lockpickVehicle")
AddEventHandler("vrp_inventory:lockpickVehicle",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,true,true)
			if GetVehicleDoorsLockedForPlayer(v,PlayerId()) == 1 then
				SetVehicleDoorsLocked(v,false)
				SetVehicleDoorsLockedForAllPlayers(v,false)
			else
				SetVehicleDoorsLocked(v,true)
				SetVehicleDoorsLockedForAllPlayers(v,true)
			end
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
			Wait(200)
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCKBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if LocalPlayer["state"]["Buttons"] then
			timeDistance = 1
			DisableControlAction(1,75,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Buttons")
AddEventHandler("inventory:Buttons",function(status)
	LocalPlayer["state"]["Buttons"] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARACHUTECOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.parachuteColors()
	vRP.giveWeapons({["GADGET_PARACHUTE"] = { ammo = 1 }})
	SetPedParachuteTintIndex(PlayerPedId(),math.random(7))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKFOUNTAIN
-----------------------------------------------------------------------------------------------------------------------------------------
local hen = { 
	{ 441.3,6512.19,28.8 },
	{ 441.34,6509.94,28.75 },
	{ 441.41,6507.94,28.72 },
	{ 441.55,6505.56,28.81 },
	{ 441.59,6503.57,28.86 },
	{ 441.65,6501.3,29.0 },
	{ 436.66,6502.58,28.79 },
	{ 434.53,6502.48,28.76 },
	{ 432.11,6502.46,28.73 },
}

function Hiro.checkHen()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	for k,v in pairs(hen) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 1.5 then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- throwableWeapons
-----------------------------------------------------------------------------------------------------------------------------------------
local currentWeapon = ""
RegisterNetEvent("inventory:throwableWeapons")
AddEventHandler("inventory:throwableWeapons",function(weaponName)
	currentWeapon = weaponName

	local ped = PlayerPedId()
	if GetSelectedPedWeapon(ped) == GetHashKey(currentWeapon) then
		while GetSelectedPedWeapon(ped) == GetHashKey(currentWeapon) do
			if IsPedShooting(ped) then
				vSERVER.removeThrowable(currentWeapon)
			end
			Wait(0)
		end
		currentWeapon = ""
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
local Weapon = ""
function Hiro.returnWeapon()
	if Weapon ~= "" then
		return Weapon
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local fishCoords = PolyZone:Create({
	vector2(2308.64,3906.11),
	vector2(2180.13,3885.29),
	vector2(2058.22,3883.56),
	vector2(2024.97,3942.53),
	vector2(1748.72,3964.53),
	vector2(1655.65,3886.34),
	vector2(1547.59,3830.17),
	vector2(1540.73,3826.94),
	vector2(1535.67,3816.55),
	vector2(1456.35,3756.87),
	vector2(1263.44,3670.38),
	vector2(1172.99,3648.83),
	vector2(967.98,3653.54),
	vector2(840.55,3679.16),
	vector2(633.13,3600.70),
	vector2(361.73,3626.24),
	vector2(310.58,3571.61),
	vector2(266.92,3493.13),
	vector2(173.49,3421.45),
	vector2(128.16,3442.66),
	vector2(143.41,3743.49),
	vector2(-38.59,3754.16),
	vector2(-132.62,3716.80),
	vector2(-116.73,3805.33),
	vector2(-157.23,3838.81),
	vector2(-204.70,3846.28),
	vector2(-208.28,3873.08),
	vector2(-236.88,4076.58),
	vector2(-184.11,4231.52),
	vector2(-139.54,4253.54),
	vector2(-45.38,4344.43),
	vector2(-5.96,4408.34),
	vector2(38.36,4411.02),
	vector2(150.77,4311.74),
	vector2(216.02,4342.85),
	vector2(294.16,4245.62),
	vector2(396.21,4342.24),
	vector2(438.37,4315.38),
	vector2(505.22,4178.69),
	vector2(606.65,4202.34),
	vector2(684.48,4169.83),
	vector2(773.54,4152.33),
	vector2(877.34,4172.67),
	vector2(912.20,4269.57),
	vector2(850.92,4428.91),
	vector2(922.96,4376.48),
	vector2(941.32,4328.09),
	vector2(995.318,4288.70),
	vector2(1050.33,4215.29),
	vector2(1082.27,4285.61),
	vector2(1060.97,4365.31),
	vector2(1072.62,4372.37),
	vector2(1119.24,4317.53),
	vector2(1275.27,4354.90),
	vector2(1360.96,4285.09),
	vector2(1401.09,4283.69),
	vector2(1422.33,4339.60),
	vector2(1516.60,4393.69),
	vector2(1597.58,4455.65),
	vector2(1650.81,4499.17),
	vector2(1781.12,4525.83),
	vector2(1828.69,4560.26),
	vector2(1866.59,4554.49),
	vector2(2162.70,4664.53),
	vector2(2279.31,4660.26),
	vector2(2290.52,4630.90),
	vector2(2418.64,4613.91),
	vector2(2427.06,4597.69),
	vector2(2449.86,4438.97),
	vector2(2396.62,4353.36),
	vector2(2383.66,4160.74),
	vector2(2383.05,4046.07)
},{ name = "Pescaria" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHINGCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.fishingCoords()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	if fishCoords:isPointInside(coords) and IsEntityInWater(ped) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHINGANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.fishingAnim()
	local ped = PlayerPedId()
	if IsEntityPlayingAnim(ped,"amb@world_human_stand_fishing@idle_a","idle_c",3) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
local firecracker = nil
RegisterNetEvent("vrp_inventory:Firecracker")
AddEventHandler("vrp_inventory:Firecracker",function()
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
			RequestNamedPtfxAsset("scr_indep_fireworks")
			Wait(10)
		end
	end

	local mHash = GetHashKey("ind_prop_firework_03")

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Wait(10)
	end

	local explosives = 25
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.6,0.0)
	firecracker = CreateObjectNoOffset(mHash,coords.x,coords.y,coords.z,true,false,false)

	PlaceObjectOnGroundProperly(firecracker)
	FreezeEntityPosition(firecracker,true)
	SetModelAsNoLongerNeeded(mHash)

	Wait(10000)

	repeat
		UseParticleFxAssetNextCall("scr_indep_fireworks")
		local explode = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst",coords.x,coords.y,coords.z,0.0,0.0,0.0,2.5,false,false,false,false)
		explosives = explosives - 1

		Wait(2000)
	until explosives == 0

	TriggerServerEvent("tryDeleteEntity",ObjToNet(firecracker))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v.x << 8) | v.y
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local dropDown = 0
local dropList = {}
local dropGrids = {}
local dropDeltas = { vector2(-1,-1),vector2(-1,0),vector2(-1,1),vector2(0,-1),vector2(1,-1),vector2(1,0),vector2(1,1),vector2(0,1) }
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:dropUpdates")
AddEventHandler("vrp_inventory:dropUpdates",function(status)
	dropList = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDROPGRIDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		dropGrids = {}
		for k,v in ipairs(dropDeltas) do
			local h = coords.xy + (v * 20)
			dropGrids[toChannel(vector2(gridChunk(h.x),gridChunk(h.y)))] = true
		end

		Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDROP
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for grid,v in pairs(dropGrids) do
			if dropList[grid] then
				for k,v in pairs(dropList[grid]) do
					local distance = #(coords - vector3(v[3],v[4],v[5]))
					if distance <= 15 then
						timeDistance = 4
						DrawMarker(20,v[3],v[4],v[5]-0.85,0,0,0,180.0,0,0,0.2,0.3,0.2,255,0,0,50,0,0,0,1)
						if distance <= 0.6 and not IsPedInAnyVehicle(ped) and IsControlJustPressed(1,38) and dropDown <= 0 then
							vSERVER.itemPickup(grid,parseInt(k))
							dropDown = 3
						end
					end
				end
			end
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDROPDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if dropDown > 0 then
			dropDown = dropDown - 1
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNFREEZEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.FreezeVehicle()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			FreezeEntityPosition(vehicle,true)
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNFREEZEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.unfreezeVehicle()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			FreezeEntityPosition(vehicle,false)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATE - COLORS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.plateApply(plate)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleNumberPlateText(vehicle,plate)
		FreezeEntityPosition(vehicle,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAÇADOR
-----------------------------------------------------------------------------------------------------------------------------------------
local hashAnimal = {
	{ hash = 1457690978 }, -- Cormorão
	{ hash = 402729631 }, -- Corvo
	{ hash = -1430839454 }, -- Águia
	{ hash = -664053099 }, -- Cervo
	{ hash = -541762431 }, -- Coelho
	{ hash = 1682622302 }, -- Coyote
	{ hash = 1318032802 }, -- Lobo
	{ hash = 307287994 }, -- Puma
	{ hash = -832573324 } -- Javali
}

function Hiro.removeMeat()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	if not IsPedInAnyVehicle(ped) then
		local handle,npc = FindFirstPed()
		local finished = false
		repeat
			local coordsAnimal = GetEntityCoords(npc)
			local distance = #(coords - coordsAnimal)
			if IsPedDeadOrDying(npc) and not IsPedAPlayer(npc) and not IsPedInAnyVehicle(npc) and distance < 3 then
				for k,v in pairs(hashAnimal) do
					if GetEntityModel(npc) == v.hash then
						SetEntityHeading(ped,GetEntityHeading(npc))
						finished = true
						return true
					end
				end
			end
			finished,npc = FindNextPed(handle)
		until not finished
		EndFindPed(handle)
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STEALTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:stealTrunk")
AddEventHandler("inventory:stealTrunk",function(entity)
    local ped = PlayerPedId()

    if GetCurrentPedWeapon(ped, GetHashKey("WEAPON_CROWBAR")) then
        if GetVehicleDoorsLockedForPlayer(entity[3],PlayerId()) ~= 1 then
            local trunk = GetEntityBoneIndexByName(entity[3],"boot")
            if trunk ~= -1 then
                if GetVehicleDoorAngleRatio(entity[3],5) < 0.9 then
                    local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,0.0)
                    local coordsEnt = GetWorldPositionOfEntityBone(entity[3],trunk)
                    local distance = #(coords - coordsEnt)
                    if distance <= 2.0 then
                        vSERVER.stealTrunk(entity)
                        vRP.stopAnim(source)
                        SetVehicleAlarm(entity[3], true)
                        SetVehicleAlarmTimeLeft(entity[3], 60 * 1000)
                    end
                end
            end
        end
    else
        TriggerEvent("Notify","vermelho","Você precisa de um pé de cabra.",3000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEALARM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:vehicleAlarm")
AddEventHandler("inventory:vehicleAlarm",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local Vehicle = NetToEnt(vehIndex)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == vehPlate then
				SetVehicleAlarm(Vehicle,true)
				StartVehicleAlarm(Vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRELIST
-----------------------------------------------------------------------------------------------------------------------------------------
local tyreList = {
	["wheel_lf"] = 0,
	["wheel_rf"] = 1,
	["wheel_lm"] = 2,
	["wheel_rm"] = 3,
	["wheel_lr"] = 4,
	["wheel_rr"] = 5
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REMOVETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:removeTyres")
AddEventHandler("inventory:removeTyres",function(Entity)
	if GetVehicleDoorLockStatus(Entity[3]) == 1 then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if GetCurrentPedWeapon(ped, GetHashKey("WEAPON_WRENCH")) then

			for k,Tyre in pairs(tyreList) do
				local Selected = GetEntityBoneIndexByName(Entity[3],k)
				if Selected ~= -1 then
					local coordsWheel = GetWorldPositionOfEntityBone(Entity[3],Selected)
					local distance = #(coords - coordsWheel)
					if distance <= 1.0 then
						TriggerServerEvent("inventory:removeTyres",Entity,Tyre)
					end
				end
			end
		else
			TriggerEvent("Notify","amarelo","<b>Chave Inglesa</b> não encontrada.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EXPLODETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:explodeTyres")
AddEventHandler("inventory:explodeTyres",function(vehNet,vehPlate,Tyre)
	if NetworkDoesNetworkIdExist(vehNet) then
		local Vehicle = NetToEnt(vehNet)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == vehPlate then
				SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.tyreStatus()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
		local Vehicle = vRP.getNearVehicle(5)
		local coords = GetEntityCoords(ped)

		for k,Tyre in pairs(tyreList) do
			local Selected = GetEntityBoneIndexByName(Vehicle,k)
			if Selected ~= -1 then
				local coordsWheel = GetWorldPositionOfEntityBone(Vehicle,Selected)
				local distance = #(coords - coordsWheel)
				if distance <= 1.0 then
					return true,Tyre,VehToNet(Vehicle),GetVehicleNumberPlateText(Vehicle)
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.tyreHealth(vehNet,Tyre)
	if NetworkDoesNetworkIdExist(vehNet) then
		local Vehicle = NetToEnt(vehNet)
		if DoesEntityExist(Vehicle) then
			return GetTyreHealth(Vehicle,Tyre)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUNKBLES
-----------------------------------------------------------------------------------------------------------------------------------------
local drunkPoints = 0
local drunked = false
local drunkTime = 0

RegisterNetEvent("inventory:drunkPlayer",function(points)
    drunkPoints = drunkPoints + points
    if drunkPoints >= 3 then
        drunkPoints = 0
        drunked = true
        drunkTime = (drunkTime or 0) + 160
        startDrunk()
    end
end)

local drunkedThread
function startDrunk()
    if drunkedThread then return end

    drunkedThread = true

    CreateThread(function()
        while drunked do
            StartScreenEffect("RaceTurbo",0,true)
            StartScreenEffect("DrugsTrevorClownsFight",0,true)
            Wait(30000)
        end
    end)

    CreateThread(function()
        while drunked do
            drunkTime = drunkTime - 1
            if drunkTime <= 0 then
                drunked = false
            end
            Wait(1000)
        end
        drunkedThread = false
		StopScreenEffect("RaceTurbo")
		StopScreenEffect("DrugsTrevorClownsFight")
    end)
end


function Hiro.checkConnection()
	return true
end