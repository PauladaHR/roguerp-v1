local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vGARAGE = Tunnel.getInterface("vrp_garages")


local dismantleList = {}
local dismantleTimer = os.time()
local dismantleCooldown = os.time()

function dismantleUpdate()
	dismantleList = {}
	local amountVeh = 0
	local selectVehs = 0
	dismantleTimer = os.time() + 1600

	repeat
		selectVehs = math.random(#cfg.DismantleList)
		if dismantleList[cfg.DismantleList[selectVehs]] == nil then
			dismantleList[cfg.DismantleList[selectVehs]] = true
			amountVeh = amountVeh + 1
		end
	until amountVeh >= 10
end

RegisterServerEvent("hiro_dismantle:checkVehicleList")
AddEventHandler("hiro_dismantle:checkVehicleList",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if os.time() >= dismantleTimer then
			dismantleUpdate()
		end

		local vehListNames = ""
		for k,v in pairs(dismantleList) do
			vehListNames = vehListNames.."<b>"..vRP.vehicleName(k).."</b>, "
		end

		TriggerClientEvent("Notify",source,"azul",vehListNames.." a lista vai ser atualizada em <b>"..(dismantleTimer - os.time()).."</b> segundos.",60000)
	end
end)

function src.paymentMethod(Vehicle,Plate)
	local source = source
	local user_id = vRP.getUserId(source)
	local VehPlateID = vRP.getVehiclePlate(Plate)
	if user_id then
		vGARAGE.deleteVehicle(source,Vehicle)
		cfg.paymentDismantle()

		if VehPlateID then
			cfg.paymentDismantlePlayer()
			vRP.execute("vRP/set_dismantle",{ user_id = parseInt(VehPlateID), vehicle = Vehicle, dismantle = 1 })
		end

		local reputationValue = vRP.checkReputation(user_id,"Dismantle")
		if reputationValue <= 1001 then
			vRP.insertReputation(user_id,"Dismantle",parseInt(cfg.reputationGive))
		end
	end
end

function src.checkVehicleList()
	local source = source
	local user_id = vRP.getUserId(source)
	local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,11)
	local VehPlateID = vRP.getVehiclePlate(vehPlate)
	if user_id and VehPlateID then
		if vRP.hasPermission(user_id,cfg.permList) then
			local getDismantle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(VehPlateID), vehicle = vehName })
			if getDismantle then
				if getDismantle[1]["dismantle"] == 0 then
					if os.time() < dismantleCooldown then
						TriggerClientEvent("Notify",source,"amarelo","Desmanche não autorizado.",5000)
						return false
					else
						dismantleCooldown = os.time() + 1200
						return true,vehicle,vehName,VehPlateID
					end
				end
			end
		end
	else
		if user_id and dismantleList[vehName] then
			dismantleList[vehName] = nil
			return true
		end
	end
end