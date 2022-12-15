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
Tunnel.bindInterface("vrp_chest",cRP)
vCLIENT = Tunnel.getInterface("vrp_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chestOpen = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREFOOD
-----------------------------------------------------------------------------------------------------------------------------------------
local storeFood = {
	["coolBeans"] = true,
	["catCoffe"] = true,
	["Pearls"] = true,
	["catCoffeMesa"] = true,
	["coolBeansMesa"] = true,
	["CasaLagoGeladeira"] = true,
	["CasaBombeirosGeladeira"] = true,
	["CasaSistaGeladeira"] = true,
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
	["newprops"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkIntPermissions(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		if chestName == "catCoffeMesa" or chestName == "coolBeansMesa" then
			vRP.DupOpenChest(user_id,chestName)
			return true
		end

		local consultChest = vRP.query("chests/getChests",{ name = chestName })
		if consultChest[1] then
			if (vRP.hasPermission(user_id,consultChest[1]["perm"]) and not vRP.wantedReturn(user_id)) or vRP.hasPermission(user_id,"Police") then
				vRP.DupOpenChest(user_id,chestName)
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.upgradeSystem(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultChest = vRP.query("chests/getChests",{ name = chestName })
		if consultChest[1] then
			local upgradePrice = 2500

			if vRP.hasPermission(user_id,consultChest[1]["perm"]) then
				if vRP.request(source,"Comprar <b>25Kg</b> pagando <b>$"..parseFormat(upgradePrice).."</b>?",30) then
					if vRP.paymentBank(user_id,upgradePrice) then
						exports["oxmysql"]:executeSync("UPDATE vrp_chests SET weight = weight + 25 WHERE name = ?",{ chestName })
						TriggerClientEvent("Notify",source,"verde","Compra concluída.",3000)
					else
						TriggerClientEvent("Notify",source,"amarelo","Dólares insuficientes.",5000)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.chestClose(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.DupCloseChest(user_id,chestName)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkIntAdmin(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		if vRP.hasRank(parseInt(user_id),"Admin",60) then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeItem(itemName,slot,amount,target,chestOpen)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getSData("chest:"..chestOpen)
	local result = json.decode(data) or {}
	if user_id then
		local consultChest = vRP.query("chests/getChests",{ name = chestOpen })
		if consultChest[1] then

			if vRP.DupCheckChest(user_id,chestOpen) then

				if storeFood[chestOpen] then
					if not storeFood[tostring(chestOpen)] then
						TriggerClientEvent("vrp_chest2:Update",source,"requestChest")
						TriggerClientEvent("Notify",source,"amarelo", "Você não pode armazenar este item em baús.", 5000)
						return
					end

				elseif vRP.itemHungerList(itemName) or vRP.itemWaterList(itemName) or noFull[itemName] then
					TriggerClientEvent("vrp_chest2:Update",source,"requestChest")
					TriggerClientEvent("Notify",source,"amarelo", "Você não pode armazenar este item em baús.", 5000)
					return
				end

				if not vRP.storeChest(user_id,"chest:"..chestOpen,itemName,amount,consultChest[1]["weight"],slot,target) then
					TriggerClientEvent("vrp_chest2:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),consultChest[1]["weight"])
				end

				if parseInt(consultChest[1]["logs"]) >= 1 then
					TriggerEvent("discordLogs",chestOpen,"**Passaporte:** "..parseFormat(user_id).."\n**Guardou:** "..parseFormat(amount).."x "..vRP.itemNameList(itemName).."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
				end
			end
			TriggerClientEvent("vrp_chest2:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(itemName,slot,amount,target,chestOpen)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getSData("chest:"..chestOpen)
	local result = json.decode(data) or {}
	if user_id then
		local consultChest = vRP.query("chests/getChests",{ name = chestOpen })
		if consultChest[1] then
			if vRP.DupCheckChest(user_id,chestOpen) then
				if vRP.tryChest(user_id,"chest:"..chestOpen,itemName,amount,slot,target) then
					TriggerClientEvent("vrp_chest2:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),consultChest[1]["weight"])
				end
			end
			if parseInt(consultChest[1]["logs"]) >= 1 then
				TriggerEvent("discordLogs",chestOpen,"**Passaporte:** "..parseFormat(user_id).."\n**Retirou:** "..parseFormat(amount).."x "..vRP.itemNameList(itemName).."\n**Horário:** "..os.date("%H:%M:%S"),9317187)
			end
			TriggerClientEvent("vrp_chest2:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateChest(itemName,slot,target,amount,chestOpen)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getSData("chest:"..chestOpen)
	local result = json.decode(data) or {}
	if user_id then
		local consultChest = vRP.query("chests/getChests",{ name = chestOpen })
		if consultChest[1] then
			if vRP.DupCheckChest(user_id,chestOpen) then
				if not vRP.updateChest(user_id,"chest:"..chestOpen,itemName,slot,target,amount) then
					TriggerClientEvent("vrp_chest2:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),consultChest[1]["weight"])
				end
			end
			TriggerClientEvent("vrp_chest2:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openChest(chestOpen)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local myInventory = {}
		local myChest = {}

			local inv = vRP.getInventory(parseInt(user_id))
			if inv then
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
			end

            local data = vRP.getSData("chest:"..chestOpen)
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

		local consultChest = vRP.query("chests/getChests",{ name = chestOpen })
		if consultChest[1] then
			return myInventory,myChest,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),consultChest[1]["weight"]
		end
	end
	return false
end