-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("vrp_tencode")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
local policeRadar = false
local policeFreeze = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ tencode = false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sendCode",function(data)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	vSERVER.sendCode(data["code"])
	SendNUIMessage({ tencode = false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRADAR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if (IsPedInAnyPoliceVehicle(ped) or isRadarAllowed(ped)) and LocalPlayer["state"]["Police"] then
			if policeRadar then
				if not policeFreeze then
					timeDistance = 100

					local vehicle = GetVehiclePedIsUsing(ped)
					local vehicleDimension = GetOffsetFromEntityInWorldCoords(vehicle,0.0,1.0,1.0)

					local vehicleFront = GetOffsetFromEntityInWorldCoords(vehicle,0.0,105.0,0.0)
					local vehicleFrontShape = StartShapeTestCapsule(vehicleDimension,vehicleFront,3.0,10,vehicle,7)
					local _,_,_,_,vehFront = GetShapeTestResult(vehicleFrontShape)

					if IsEntityAVehicle(vehFront) then
						local vehModel = GetEntityModel(vehFront)
						local vehName = GetDisplayNameFromVehicleModel(vehModel)
						local vehPlate = GetVehicleNumberPlateText(vehFront)
						local vehSpeed = GetEntitySpeed(vehFront) * 2.236936

						SendNUIMessage({ radar = "top", plate = vehPlate, model = vehName, speed = vehSpeed })
					end

					local vehicleBack = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-105.0,0.0)
					local vehicleBackShape = StartShapeTestCapsule(vehicleDimension,vehicleBack,3.0,10,vehicle,7)
					local _,_,_,_,vehBack = GetShapeTestResult(vehicleBackShape)

					if IsEntityAVehicle(vehBack) then
						local vehModel = GetEntityModel(vehBack)
						local vehName = GetDisplayNameFromVehicleModel(vehModel)
						local vehPlate = GetVehicleNumberPlateText(vehBack)
						local vehSpeed = GetEntitySpeed(vehBack) * 2.236936

						SendNUIMessage({ radar = "bot", plate = vehPlate, model = vehName, speed = vehSpeed })
					end
				end
			end
		end

		if not IsPedInAnyVehicle(ped) and policeRadar then
			policeRadar = false
			SendNUIMessage({ radar = false })
		end

		Wait(timeDistance)
	end
end)


local forcedVehicles = {
	"wtchallenger",
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLERADAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("toggleRadar",function(source,args,rawCommand)
	if MumbleIsConnected() then
		local ped = PlayerPedId()
		if (IsPedInAnyPoliceVehicle(ped) or isRadarAllowed(ped)) and LocalPlayer["state"]["Police"] then
			if policeRadar then
				policeRadar = false
				SendNUIMessage({ radar = false })
			else
				policeRadar = true
				SendNUIMessage({ radar = true })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEFREEZE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("toggleFreeze",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if (IsPedInAnyPoliceVehicle(ped) or isRadarAllowed(ped)) and LocalPlayer["state"]["Police"] then
		policeFreeze = not policeFreeze
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TENCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("enterTencodes",function(source,args,rawCommand)
	if LocalPlayer["state"]["Police"] and MumbleIsConnected() then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.1)
		SendNUIMessage({ tencode = true })
	end
end)


function isRadarAllowed(ped)
	local vehicle = GetVehiclePedIsIn(ped)
	local model = GetEntityModel(vehicle)
	for k, v in ipairs(forcedVehicles) do
		if GetHashKey(v) == model then
			return true
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("enterTencodes","Manusear o código policial.","keyboard","F3")
RegisterKeyMapping("toggleRadar","Ativar/Desativar radar das viaturas.","keyboard","N")
RegisterKeyMapping("toggleFreeze","Travar/Destravar radar das viaturas.","keyboard","M")