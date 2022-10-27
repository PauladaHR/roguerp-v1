-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("dealership",src)
vSERVER = Tunnel.getInterface("dealership")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehicles = {}
local vehIds = {}
local Open = "Santos"
-----------------------------------------------------------------------------------------------------------------------------------------
-- ZONES
-----------------------------------------------------------------------------------------------------------------------------------------
local zone = PolyZone:Create({
    vector2(-28.33,-1120.86),
    vector2(-44.92,-1122.70),
    vector2(-64.26,-1123.11),
    vector2(-71.02,-1117.35),
    vector2(-68.44,-1108.67),
    vector2(-57.19,-1079.97),
    vector2(-43.52,-1083.67),
    vector2(-36.62,-1089.40),
    vector2(-30.89,-1087.63),
    vector2(-25.52,-1089.94),
    vector2(-27.49,-1094.88),
    vector2(-18.20,-1099.08)
},{ name="pdm", minZ = 22, maxZ = 40 })

local coords = {
	[1] = { cds = vector3(-47.81,-1096.01,25.74), h = 127.35 },
	[2] = { cds = vector3(-40.1,-1098.85,25.74), h = 122.33 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dealership:syncVehicles")
AddEventHandler("dealership:syncVehicles",function(vehs)
	for k,v in pairs(vehs) do
		if not vehicles[k] or v.model ~= vehicles[k].model then
			swapVehicle(v.model,k)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:enterTablet")
AddEventHandler("tablet:enterTablet",function(Select)
	local ped = PlayerPedId()
	if not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 100 and MumbleIsConnected() then
		dealerOpen = true
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "openSystem" })
		vRP._playAnim(false,{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"},true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inside = false
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if zone:isPointInside(coords) then
			if not inside then
				inside = true
				spawnVehicles()
			end
		else
			if inside then
				inside = false
				despawnVehicles()
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function spawnVehicles()
	ClearAreaOfVehicles(-42.01,-1094.51,27.28,200)
	local ped = PlayerPedId()
	for k,v in pairs(vehicles) do
		local hash = GetHashKey(v.model)

		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(10)
		end

		local id = CreateVehicle(hash,coords[k].cds.x,coords[k].cds.y,coords[k].cds.z,coords[k].h,false,false)
		SetVehicleOnGroundProperly(id)
		SetVehicleDoorsLocked(id,2)
		SetVehicleDirtLevel(id,0.0)
		SetVehicleColours(id,math.random(1,150),1)
		FreezeEntityPosition(id,true)
		SetEntityAsMissionEntity(id,true,true)
		SetVehicleNumberPlateText(id,"LUX"..k)
		vehIds[k] = id
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAPVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function swapVehicle(veh,slot)
	if slot > 0 and slot < 5 then
		if vehIds[slot] then
			if DoesEntityExist(vehIds[slot]) then
				DeleteEntity(vehIds[slot])
			end
		end

		local hash = GetHashKey(veh)

		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(10)
		end

		local id = CreateVehicle(hash,coords[slot].cds.x,coords[slot].cds.y,coords[slot].cds.z,coords[slot].h,false,false)
		SetVehicleDoorsLocked(id,2)
		SetVehicleDirtLevel(id,0.0)
		FreezeEntityPosition(id,true)
		SetEntityAsMissionEntity(id,true,true)
		SetVehicleNumberPlateText(id,"LUX"..slot)
		vehIds[slot] = id
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function despawnVehicles()
	for k,v in pairs(vehIds) do
		if DoesEntityExist(v) then
			DeleteEntity(v)
		end
	end
	vehIds = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandleSpawn",function(data,cb)
	if data.name ~= nil then
		TriggerServerEvent("dealership:setVehicles",data.name,data.spawn)
		cb("ok")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEALERCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dealerClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeSystem" })
	dealerOpen = false
	vRP._stopAnim(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCarros",function(data,cb)
	local veiculos = vSERVER.getVehicles(data["mode"])
	if veiculos then
		cb({ veiculos = veiculos, perm = vSERVER.checkPermission() })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMotos",function(data,cb)
	local veiculos = vSERVER.getVehicles(data["mode"])
	if veiculos then
		cb({ veiculos = veiculos, perm = vSERVER.checkPermission() })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEStIMPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestImport",function(data,cb)
	local veiculos = vSERVER.getVehicles(data["mode"])
	if veiculos then
		cb({ veiculos = veiculos, perm = vSERVER.checkPermission() })
	end
end)---------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAluguel",function(data,cb)
	local veiculos = vSERVER.getVehicles(data["mode"])
	if veiculos then
		cb({ veiculos = veiculos, perm = vSERVER.checkPermission() })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("buyDealer",function(data)
	if data.name ~= nil then
		vSERVER.buyDealer(data.name)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPossuidos",function(data,cb)
	local veiculos = vSERVER.getVehicles(data["mode"])
	if veiculos then
		cb({ veiculos = veiculos })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("payTax",function(data)
	if data.name ~= nil then
		vSERVER.payTax(data.name)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sellDealer",function(data)
	if data.name ~= nil then
		vSERVER.sellDealer(data.name)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTO-UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dealership:Update")
AddEventHandler("dealership:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEALER-CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dealership:Close")
AddEventHandler("dealership:Close",function()
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeSystem" })
	dealerOpen = false
	vRP._DeletarObjeto()
	vRP._stopAnim(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDrive = nil
local benDrive = false
local benCoords = { 0.0,0.0,0.0 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandleTest",function(data)
	local startDrive,vehPlate = vSERVER.startDrive()
	if startDrive then
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "closeSystem" })

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		benCoords = { coords["x"],coords["y"],coords["z"] }

		TriggerEvent("races:insertList",true)
		LocalPlayer["state"]["Commands"] = true
		TriggerEvent("Notify","azul","Teste iniciado, para finalizar saia do veículo.",5000)

		Wait(1000)

		vehCreate(data["name"],vehPlate)

		Wait(1000)

		SetPedIntoVehicle(ped,vehDrive,-1)
		benDrive = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vehCreate(vehName,vehPlate)
	local mHash = GetHashKey(vehName)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Wait(1)
	end

	if HasModelLoaded(mHash) then
		if Open == "Santos" then
			vehDrive = CreateVehicle(mHash,-53.28,-1110.93,26.47,68.04,false,false)
		elseif Open == "Sandy" then
			vehDrive = CreateVehicle(mHash,1209.74,2713.49,37.81,175.75,false,false)
		end

		SetVehicleNumberPlateText(vehDrive,vehPlate)
		SetEntityInvincible(vehDrive,true)
		SetModelAsNoLongerNeeded(mHash)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if benDrive then
			timeDistance = 1
			DisableControlAction(1,69,false)

			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				Wait(1000)

				benDrive = false
				vSERVER.removeDrive()
				TriggerEvent("races:insertList",false)
				LocalPlayer["state"]["Commands"] = false
				SetEntityCoords(ped,benCoords[1],benCoords[2],benCoords[3],false,false,false,false)
				DeleteEntity(vehDrive)
			end
		end

		Wait(timeDistance)
	end
end)

function src.checkConnection()
	return true
end