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
Hiro = {}
Tunnel.bindInterface("vrp_trunkchest",Hiro)
vCLIENT = Tunnel.getInterface("vrp_trunkchest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehChest = {}
local vehNames = {}
local vehWeight = {}
local chestOpen = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHS
-----------------------------------------------------------------------------------------------------------------------------------------
local storeVehs = {
	["mule3"] = true,
	["taco"] = true,
	["taco2"] = true,
	["taco3"] = true,
	["taco4"] = true,
	["rumpo"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOFULL
-----------------------------------------------------------------------------------------------------------------------------------------
local noFull = {
	["premiumBooster00"] = true,
	["premiumSilver50"] = true,
	["premiumGold60"] = true,
	["premiumPlatinum70"] = true,
	["premiumDiamond90"] = true,
	["newgarage"] = true,
	["newchars"] = true,
	["newprops"] = true,
	["newspaper"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.storeItem(itemName,slot,amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	local consult = vRP.getSData(vehChest[parseInt(user_id)])
	local result = json.decode(consult) or {}
	if user_id then
        if storeVehs[vehNames[parseInt(user_id)]] then
            if not vRP.itemHungerList(itemName) or not vRP.itemWaterList(itemName) or itemName == "identity" then
                TriggerClientEvent("vrp_trunkchest:Update",source,"requestChest")
				TriggerClientEvent("Notify",source,"amarelo","Você não pode armazenar este item em veículos.",5000)
                return
            end
        elseif not storeVehs[vehNames[parseInt(user_id)]] and vRP.itemHungerList(itemName) or vRP.itemWaterList(itemName) or itemName == "identity" or itemName == "dollars2" or noFull[itemName] then
            TriggerClientEvent("vrp_trunkchest:Update",source,"requestChest")
			TriggerClientEvent("Notify",source,"amarelo","Você não pode armazenar este item em veículos.",5000)
            return
        end
        
        if not vRP.storeChest(user_id,vehChest[parseInt(user_id)],itemName,amount,parseInt(vehWeight[user_id]),slot,target) then
			TriggerClientEvent("vrp_trunkchest:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id]))
        end
	end
	TriggerClientEvent("vrp_trunkchest:Update",source,"requestChest")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.takeItem(itemName,slot,amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	local consult = vRP.getSData(vehChest[parseInt(user_id)])
	local result = json.decode(consult) or {}
	if user_id then
        if vRP.tryChest(user_id,vehChest[parseInt(user_id)],itemName,amount,slot,target) then
			TriggerClientEvent("vrp_trunkchest:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id]))
			end
		end
	TriggerClientEvent("vrp_trunkchest:Update",source,"requestChest")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.updateChest(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local consult = vRP.getSData(vehChest[parseInt(user_id)])
	local result = json.decode(consult) or {}
	if user_id then
        if not vRP.updateChest(user_id,vehChest[parseInt(user_id)],itemName,slot,target,amount) then
			TriggerClientEvent("vrp_trunkchest:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id]))
        end
		TriggerClientEvent("vrp_trunkchest:Update",source,"requestChest")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:openTrunk")
AddEventHandler("trunkchest:openTrunk",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth = vRPC.vehList(source,7)
		if vehicle then
			for k,v in pairs(chestOpen) do
				if v == vehPlate then
					return
				end
			end

			if not vehLock then
				if vehBlock then
					return
				end

				if vehHealth < 100 then
					return
				end

				local plateUserId = vRP.getVehiclePlate(vehPlate)
				if plateUserId then
					chestOpen[user_id] = vehPlate
					vCLIENT.trunkOpen(source)

					if not vRPC.inVehicle(source) then
						TriggerClientEvent("vrp_player:syncDoors",-1,vehNet,"5")
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
		if vehicle then
			if not vRPC.inVehicle(source) then
				TriggerClientEvent("vrp_player:syncDoors",-1,vehNet,"5")
			end

			if chestOpen[user_id] then
				chestOpen[user_id] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
		if vehicle then
			local plateUserId = vRP.getVehiclePlate(vehPlate)
			if plateUserId then
				local myInventory = {}
				local myChest = {}
				if vRPC.inVehicle(source) then
					vehWeight[user_id] = 7
					vehChest[parseInt(user_id)] = "gloves:"..parseInt(plateUserId)..":"..vehName
				else
					vehWeight[user_id] = parseInt(vRP.vehicleChest(vehName))
					vehChest[parseInt(user_id)] = "chest:"..parseInt(plateUserId)..":"..vehName
				end

				vehNames[parseInt(user_id)] = vehName

				local inv = vRP.getInventory(parseInt(user_id))
				local data = vRP.getSData(vehChest[parseInt(user_id)])
				local result = json.decode(data) or {}

                if result ~= nil then
                    for k,v in pairs(result) do
                        v.amount = parseInt(v.amount)
                        v.name = vRP.itemNameList(v.item)
                        v.peso = vRP.itemWeightList(v.item)
                        v.index = vRP.itemIndexList(v.item)
                        v.max = vRP.itemMaxAmount(v.item)
                        v.type = vRP.itemTypeList(v.item)
                        v.hunger = vRP.itemHungerList(v.item)
                        v.thirst = vRP.itemWaterList(v.item)
                        v.economy = vRP.itemEconomyList(v.item)
                        v.desc = vRP.itemDescList(v.item)
                        v.key = v.item
                        v.slot = k
                        
                        myChest[k] = v
                    end
                end

				for k,v in pairs(inv) do
                    v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.peso = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.max = vRP.itemMaxAmount(v.item)
					v.type = vRP.itemTypeList(v.item)
					v.hunger = vRP.itemHungerList(v.item)
					v.thirst = vRP.itemWaterList(v.item)
					v.economy = vRP.itemEconomyList(v.item)
					v.desc = vRP.itemDescList(v.item)
					v.key = v.item
					v.slot = k

					myInventory[k] = v
				end
                return myInventory,myChest,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(vehWeight[user_id])
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if chestOpen[user_id] then
		chestOpen[user_id] = nil
	end
end)