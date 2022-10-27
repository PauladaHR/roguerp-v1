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
Tunnel.bindInterface("vrp_trucker",cRP)
vSERVER = Tunnel.getInterface("vrp_trucker")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local sPackage = 1
local sPosition = 1
local serviceBlip = nil
local initPackage = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PACKSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
local packService = {
	[1] = {
		["trailer"] = "tr4",
		["coords"] = {
			{ 1256.59,-3239.63,5.17 },
			{ 1725.68,4701.59,41.91,true },
			{ 2793.5,4346.1,49.23 },
			{ 583.97,-267.48,43.32 },
			{ 712.87,-3198.19,18.89 },
			{ 1256.59,-3239.63,5.17 }
		}
	},
	[2] = {
		["trailer"] = "armytanker",
		["coords"] = {
			{ 1256.59,-3239.63,5.17 },
			{ 1682.1,4923.7,41.45,true },
			{ 2793.5,4346.1,49.23 },
			{ 583.97,-267.48,43.32 },
			{ 712.87,-3198.19,18.89 },
			{ 1256.59,-3239.63,5.17 }
		}
	},
	[3] = {
		["trailer"] = "tvtrailer",
		["coords"] = {
			{ 1256.59,-3239.63,5.17 },
			{ -688.78,5778.91,16.7,true },
			{ 2793.5,4346.1,49.23 },
			{ 583.97,-267.48,43.32 },
			{ 712.87,-3198.19,18.89 },
			{ 1256.59,-3239.63,5.17 }
		}
	},
	[4] = {
		["trailer"] = "tanker",
		["coords"] = {
			{ 1256.59,-3239.63,5.17 },
			{ 154.75,6612.86,31.27,true },
			{ 2793.5,4346.1,49.23 },
			{ 583.97,-267.48,43.32 },
			{ 712.87,-3198.19,18.89 },
			{ 1256.59,-3239.63,5.17 }
		}
	},
	[5] = {
		["trailer"] = "trailerlogs",
		["coords"] = {
			{ 1256.59,-3239.63,5.17 },
			{ -576.72,5329.59,69.61,true },
			{ 2793.5,4346.1,49.23 },
			{ 583.97,-267.48,43.32 },
			{ 712.87,-3198.19,18.89 },
			{ 1256.59,-3239.63,5.17 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- vrp_TRUCKER:INITSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_trucker:initService")
AddEventHandler("vrp_trucker:initService",function()
	if not initPackage and not vSERVER.checkExist() then
		sPosition = 1
		initPackage = true
		sPackage = math.random(#packService)
		TriggerEvent("Notify","amarelo","Dirija-se até seu caminhão <b>Packer</b> e buzine o mesmo<br>para receber a carga responsável pelo transporte.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if initPackage then
			local vehicle = GetPlayersLastVehicle()
			if GetEntityModel(vehicle) == 569305213 then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local distance = #(coords - vector3(packService[sPackage]["coords"][sPosition][1],packService[sPackage]["coords"][sPosition][2],packService[sPackage]["coords"][sPosition][3]))

				if distance <= 200 then
					timeDistance = 1
					DrawMarker(1,packService[sPackage]["coords"][sPosition][1],packService[sPackage]["coords"][sPosition][2],packService[sPackage]["coords"][sPosition][3] - 3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,packService[sPackage]["coords"][sPosition][1],packService[sPackage]["coords"][sPosition][2],packService[sPackage]["coords"][sPosition][3] + 1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,42,137,255,100,0,0,0,1)

					if distance <= 10 then
						if sPosition >= #packService[sPackage]["coords"] then
							initPackage = false
							vSERVER.paymentMethod()

							if DoesBlipExist(serviceBlip) then
								RemoveBlip(serviceBlip)
								serviceBlip = nil
							end
						else
							if sPosition == 1 then
								if IsControlJustPressed(1,38) then
									local heading = GetEntityHeading(vehicle)
									local mHash = GetHashKey(packService[sPackage]["trailer"])
									local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle,0.0,-12.0,0.0)

									RequestModel(mHash)
									while not HasModelLoaded(mHash) do
										Citizen.Wait(1)
									end

									if HasModelLoaded(mHash) then
										local _,groundZ = GetGroundZAndNormalFor_3dCoord(vehCoords["x"],vehCoords["y"],vehCoords["z"])
										local nveh = CreateVehicle(mHash,vehCoords["x"],vehCoords["y"],groundZ,heading,true,false)
										local netVeh = VehToNet(nveh)

										SetNetworkIdCanMigrate(netVeh,true)

										SetEntityAsMissionEntity(nveh,true,false)
										SetVehicleHasBeenOwnedByPlayer(nveh,true)
										SetVehicleNeedsToBeHotwired(nveh,false)
										SetEntityInvincible(nveh,true)
									end

									sPosition = sPosition + 1
									makeBlipMarked()
								end
							else
								if packService[sPackage]["coords"][sPosition][4] ~= nil then
									if not IsPedInAnyVehicle(ped) and IsControlJustPressed(1,38) then
										local _,vehNet,vehPlate,modelVehicle = vRP.vehList(10)
										if modelVehicle == packService[sPackage]["trailer"] then
											TriggerEvent("Notify","amarelo","Volte para receber o pagamento.",5000)
											TriggerServerEvent("vrp_garages:deleteVehicles",vehNet,vehPlate)
											sPosition = sPosition + 1
											makeBlipMarked()
										end
									end
								else
									sPosition = sPosition + 1
									makeBlipMarked()
								end
							end
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipMarked()
	if DoesBlipExist(serviceBlip) then
		RemoveBlip(serviceBlip)
		serviceBlip = nil
	end

	serviceBlip = AddBlipForCoord(packService[sPackage]["coords"][sPosition][1],packService[sPackage]["coords"][sPosition][2],packService[sPackage]["coords"][sPosition][3])
	SetBlipSprite(serviceBlip,12)
	SetBlipColour(serviceBlip,84)
	SetBlipScale(serviceBlip,0.9)
	SetBlipRoute(serviceBlip,true)
	SetBlipAsShortRange(serviceBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Caminhoneiro")
	EndTextCommandSetBlipName(serviceBlip)
end