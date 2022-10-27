-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("lscustoms",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission(hasPerm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local getFines = vRP.getFines(user_id)
		if getFines[1] then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000,'info')
			return false
		end
		return not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) and (not hasPerm or vRP.hasPermission(user_id,hasPerm) or vRP.hasRank(user_id,"Admin",60))
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:attemptPurchase")
AddEventHandler("lscustoms:attemptPurchase",function(type,mod)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if type == "engines" then
			if vRP.getInventoryItemAmount(user_id,"engine") >= 1 then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
					vRP.removeInventoryItem(user_id,"engine",1,false)
				end
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		elseif type == "turbo" then
			if vRP.getInventoryItemAmount(user_id,"turbo") >= 1 then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type])) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
					vRP.removeInventoryItem(user_id,"turbo",1,false)
				end
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end			
		elseif type == "brakes" then
			if vRP.getInventoryItemAmount(user_id,"brakes") >= 1 then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
					vRP.removeInventoryItem(user_id,"brakes",1,false)
				end
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end	
		elseif type == "transmission" then
			if vRP.getInventoryItemAmount(user_id,"transmission") >= 1 then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
					vRP.removeInventoryItem(user_id,"transmission",1,false)
				end
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end	
		elseif type == "suspension" then
			if vRP.getInventoryItemAmount(user_id,"suspension") >= 1 then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
					vRP.removeInventoryItem(user_id,"suspension",1,false)
				end
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end	
		elseif type == "shield" then
			if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end						
		else
			if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type])) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:updateVehicle")
AddEventHandler("lscustoms:updateVehicle",function(mods)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,2)
		if vehicle then
			local plateUser = vRP.getVehiclePlate(vehPlate)
			if plateUser then
				vRP.setSData("custom:"..parseInt(plateUser)..":"..tostring(vehName),json.encode(mods))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHEDIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vehedit",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id, "Admin",60) then
			TriggerClientEvent("lscustoms:openAdmin",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local inVehicle = {}
RegisterServerEvent("lscustoms:inVehicle")
AddEventHandler("lscustoms:inVehicle",function(vehNet,vehPlate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vehNet == nil then
			if inVehicle[user_id] then
				inVehicle[user_id] = nil
			end
		else
			inVehicle[user_id] = { vehNet,vehPlate }
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id)
	if inVehicle[user_id] then
		Citizen.Wait(1000)
		TriggerEvent("vrp_garages:deleteVehicle",inVehicle[user_id][1],inVehicle[user_id][2])
		inVehicle[user_id] = nil
	end
end)