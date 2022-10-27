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
Tunnel.bindInterface("vrp_inspect",cRP)
vCLIENT = Tunnel.getInterface("vrp_inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userInspect = {}
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
-- REVISTAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inspect:runInspect")
AddEventHandler("vrp_inspect:runInspect",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local nplayer = vRPC.nearestPlayer(source,5)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			if vRP.hasPermission(user_id,{"Police","Paramedic","ActionPolice"}) then
				vCLIENT.toggleCarry(nplayer,source)

				local weapons = vRPC.replaceWeapons(nplayer)
				for k,v in pairs(weapons) do
					vRP.giveInventoryItem(nuser_id,k,1)
					if v.ammo > 0 then
						vRP.giveInventoryItem(nuser_id,vRP.weaponAmmo(k),v.ammo)
					end
				end

				vRPC.updateWeapons(nplayer)
				userInspect[user_id] = parseInt(nuser_id)
				vCLIENT.openInspect(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if userInspect[user_id] ~= nil then

			local ninventory = {}
			local myInv = vRP.getInventory(user_id)
			for k,v in pairs(myInv) do

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

				ninventory[k] = v
			end

			local uinventory = {}
			local othInv = vRP.getInventory(userInspect[user_id])
			for k,v in pairs(othInv) do

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

				uinventory[k] = v
			end

			local identity = vRP.getUserIdentity(user_id)
			return ninventory,uinventory,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.computeInvWeight(userInspect[user_id]),vRP.getBackpack(userInspect[user_id]),{ identity.name.." "..identity.name2,user_id,parseInt(identity.bank),parseInt(vRP.getUserGems(user_id)),identity.phone,identity.registration }
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NO STORE
-----------------------------------------------------------------------------------------------------------------------------------------
local noStore = {
	["identity"] = true,
	["premiumEmerald80"] = true,
	["premiumGold60"] = true, 
	["premiumSilver50"] = true,
	["carpass"] = true,
	["rgchange"] = true,
	["numberchange"] = true,
	["housekey"] = true,
	["namechange"] = true,
	["keygarage"] = true,
	["renewcar"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeItem(itemName,slot,amount,target)
	local source = source
	if itemName then
		if parseInt(amount) > 0 or amount == nil then
			local user_id = vRP.getUserId(source)
			local nsource = vRP.getUserSource(parseInt(userInspect[user_id]))
			local nuser_id = vRP.getUserId(nsource)
			if user_id then

				if string.find(itemName,"rental") or noFull[itemName] then
					TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
					TriggerClientEvent("Notify",source,"amarelo", "Você não pode armazenar este item.", 5000, 'info')
					return
				end

				if noStore[itemName] then
					TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
					TriggerClientEvent("Notify",source,"amarelo", "Você não pode armazenar este item.", 5000, 'info')
					return
				end

				if vRP.getInventoryItemMax(userInspect[user_id],itemName,parseInt(amount)) then
					if vRP.computeInvWeight(userInspect[user_id]) + vRP.itemWeightList(itemName) * parseInt(amount) <= vRP.getBackpack(userInspect[user_id]) then
						if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
							vRP.giveInventoryItem(userInspect[user_id],itemName,amount,true,target)
							TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
							if amount ~= nil then
								TriggerEvent("webhooks","inspectcolocar","```ini\n[ID]: "..user_id.." \n[ID DO COLOCADO]: "..nuser_id.." \n[ITEM] "..vRP.itemNameList(itemName).." [QUANTIDADE]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho", "Mochila cheia.", 5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho", "Você não pode carregar essa quantidade de itens.", 5000)
				end
			end
			TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
		end
	end
	return false
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
		-- if cRP.DupCheckChest(chestOpen,user_id) then
			if not vRP.updateChest(user_id,"chest:"..chestOpen,itemName,slot,target,amount) then
				TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
			-- end
		end
		TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(itemName,slot,amount,target)
	local source = source
	if itemName then
		if parseInt(amount) > 0 or amount == nil then
			local user_id = vRP.getUserId(source)
			local nsource = vRP.getUserSource(parseInt(userInspect[user_id]))
			local nuser_id = vRP.getUserId(nsource)
			if user_id then

				if string.find(itemName,"rental") or noFull[itemName] then
					TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
					TriggerClientEvent("Notify",source,"amarelo", "Você não pode retirar este item.", 5000, 'info')
					return
				end

				if noStore[itemName] then
					TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
					TriggerClientEvent("Notify",source,"amarelo", "Você não pode retirar este item.", 5000, 'info')
					return
				end

				if vRP.getInventoryItemMax(user_id,itemName,parseInt(amount)) then
					if vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemName) * parseInt(amount) <= vRP.getBackpack(user_id) then
						if vRP.tryGetInventoryItem(userInspect[user_id],itemName,amount,true,slot) then
							vRP.giveInventoryItem(user_id,itemName,amount,false,target)
							TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
							if amount ~= nil then
								TriggerEvent("webhooks","inspectretirar","```ini\n[ID]: "..user_id.." \n[ID DO RETIRADO]: "..nuser_id.." \n[ITEM] "..vRP.itemNameList(itemName).." [QUANTIDADE]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho", "Mochila cheia.", 5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho", "Você não pode carregar essa quantidade de itens.", 5000)
				end
			end
			TriggerClientEvent("vrp_inspect:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.resetInspect()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local nplayer = vRPC.nearestPlayer(source,5)
		if nplayer then
			vRPC._stopAnim(nplayer,false)
			vCLIENT.toggleCarry(nplayer,source)
		end

		if userInspect[user_id] ~= nil then
			userInspect[user_id] = nil
		end
		vRPC._stopAnim(source,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inspect:runRobbbery")
AddEventHandler("vrp_inspect:runRobbbery",function()
	local source = source
	local ped = GetPlayerPed(source)
	if GetEntityHealth(ped) > 101 then
		local user_id = vRP.getUserId(source)
		if user_id then
			local nplayer = vRPC.nearestPlayer(source,5)
			if nplayer then
				local nuser_id = vRP.getUserId(nplayer)
				local weapons = vRPC.replaceWeapons(nplayer)
				for k,v in pairs(weapons) do
					vRP.giveInventoryItem(nuser_id,k,1)
					if v.ammo > 0 then
						vRP.giveInventoryItem(nuser_id,vRP.weaponAmmo(k),v.ammo)
					end
				end

				if vRPC.getHealth(nplayer) <= 101 then
					vRPC.updateWeapons(nplayer)
					userInspect[user_id] = parseInt(nuser_id)
					vCLIENT.openInspect(source)
					vCLIENT.toggleCarry(nplayer,source)
				elseif vRPC.getHealth(nplayer) >= 101 then
					local request = vRP.request(nplayer,"Revistar","Você está sendo revistado, você permite?",60)
					if request then
						vCLIENT.toggleCarry(nplayer,source)
						vRPC.updateWeapons(nplayer)
						userInspect[user_id] = parseInt(nuser_id)
						vCLIENT.openInspect(source)
					end
				end
			end
		end

	else
		TriggerClientEvent("Notify",source,"vermelho","Você não pode lootear morto!",2000)
	end
end)