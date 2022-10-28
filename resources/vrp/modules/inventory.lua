vRP.prepare("items/update_item","UPDATE vrp_items SET item = @item, name = @name, type = @type, description = @description, weight = @weight, max = @max, economy = @economy, hunger = @hunger, thirst = @thirst, stress = @stress, anim = @anim, noStore = 0, available = 1 WHERE indexName = @indexName")

local OpenedChest = {}
local srvData = {}
local itemlist = {}

-- CreateThread(function()
-- 	for k,v in pairs(itemlist) do
-- 		local checkExist = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_items` WHERE `indexName` = ? ",{ k })
-- 		if not checkExist[1] then
-- 			exports["oxmysql"]:executeSync("INSERT INTO vrp_items(indexName,item,name,type,description,weight,max,economy,hunger,thirst,stress,anim,noStore,available) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",{ k,vRP.itemIndexList(k),vRP.itemNameList(k),vRP.itemTypeList(k),vRP.itemDescList(k),vRP.itemWeightList(k),vRP.itemMaxAmount(k),vRP.itemEconomyList(k),vRP.itemHungerList(k),vRP.itemWaterList(k),vRP.itemStressList(k),vRP.itemAnim(k),1,1 })
-- 		else
-- 			vRP.execute("items/update_item",{ indexName = k, item = vRP.itemIndexList(k), name = vRP.itemNameList(k), type = vRP.itemTypeList(k), description = vRP.itemDescList(k), weight = vRP.itemWeightList(k), max = 0, economy = vRP.itemEconomyList(k), 
-- 			hunger = vRP.itemHungerList(k), thirst = vRP.itemWaterList(k), stress = vRP.itemStressList(k), anim = vRP.itemAnim(k) })
-- 		end
-- 		print(k,json.encode(v))
-- 		Wait(100)
-- 	 end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD INSERT INIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)

	print('^3[!] ^0Criação de itens ^3iniciada^0')
	SetupItemList()
	print('^2[!] ^0Criação de itens ^2finalizada^0!')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("updateitem",function(source)
	if source ~= 0 then
		return
	end

	print('^3[!] ^0Atualização de itens ^3iniciada^0')
	SetupItemList()
	print('^2[!] ^0Atualização de itens ^2finalizada^0')
end)

function SetupItemList()
	itemlist = {}
	local selectAll = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_items`",{})
	for k,v in pairs(selectAll) do
		if v["available"] then
			itemlist[v["indexName"]] = {
				index = v["item"],
				name = v["name"],
				type = v["type"],
				weight = v["weight"],
				desc = v["description"] or nil,
				max = (v["max"] ~= 0) and v["max"] or nil,
				economy = v["economy"],
				hunger = v["hunger"] or nil,
				thirst = v["thirst"] or nil,
				stress = v["stress"] or nil,
				energetic = v["energetic"] or nil,
				alcohol = v["alcohol"] or nil,
				store = v["noStore"],
				anim = json.decode(v["anim"]) or nil
			}
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getSrvdata(key)
	if srvData[key] == nil then
		local rows = vRP.query("vRP/get_srvdata",{ key = key })
		if parseInt(#rows) > 0 then
			srvData[key] = { data = json.decode(rows[1]["dvalue"]), timer = 10 }
		else
			srvData[key] = { data = {}, timer = 10 }
		end
	end

	return srvData[key]["data"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setSrvdata(key,data)
	srvData[key] = { data = data, timer = 10 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.remSrvdata(key)
	srvData[key] = { data = {}, timer = 10 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SRVSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for k,v in pairs(srvData) do
			if v["timer"] > 0 then
				v["timer"] = v["timer"] - 1

				if v["timer"] <= 0 then
					vRP.execute("entitydata/setData",{ dkey = k, value = json.encode(v["data"]) })
					srvData[k] = nil
				end
			end
		end

		Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:KickAll")
AddEventHandler("admin:KickAll",function()
	for k,v in pairs(srvData) do
		if json.encode(v["data"]) == "[]" or json.encode(v["data"]) == "{}" then
			vRP.execute("entitydata/removeData",{ dkey = k })
		else
			vRP.execute("entitydata/setData",{ dkey = k, value = json.encode(v["data"]) })
		end
	end

	print("Save no banco de dados terminou, ja pode reiniciar o servidor.")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getBackpack(user_id)
	local DataTable = vRP.getUserDataTable(user_id)
	if DataTable["backpack"] == nil then
		DataTable["backpack"] = 50
	end

	return DataTable["backpack"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBackpack(user_id,amount)
	local DataTable = vRP.getUserDataTable(user_id)
	if DataTable then
		DataTable["backpack"] = amount
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBODYLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemBodyList(item)
	if itemlist[item] then
		return itemlist[item]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMINDEXLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemIndexList(item)
	if itemlist[item] then
		return itemlist[item]["index"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMNAMELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemNameList(item)
	if itemlist[item] then
		return itemlist[item]["name"]
	end
	return "Deleted"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMTYPELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemTypeList(item)
	if itemlist[item] then
		return itemlist[item]["type"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMOLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemAmmoList(item)
	if itemlist[item] then
		return itemlist[item]["ammo"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMWEIGHTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemWeightList(item)
	if itemlist[item] then
		return itemlist[item]["weight"]
	end
	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMECONOMY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemEconomyList(item)
	if itemlist[item] then
		return itemlist[item]["economy"] or "S/V"
	end

	return "S/V"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMMAXAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemMaxAmount(item)
	if itemlist[item] then
		return itemlist[item]["max"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM 
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemDescList(item)
	if itemlist[item] then
		return itemlist[item]["desc"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM WATER 
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemWaterList(item)
	if itemlist[item] then
		return itemlist[item]["thirst"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM 
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemHungerList(item)
	if itemlist[item] then
		return itemlist[item]["hunger"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM STRESS 
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemStressList(item)
	if itemlist[item] then
		return itemlist[item]["stress"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM ANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemAnim(itemName)
    local splitName = splitString(itemName,"-")

    if itemlist[splitName[1]] then
        if itemlist[splitName[1]]["anim"] then
            return json.encode(itemlist[splitName[1]]["anim"])
        end
    end
    return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET INVENTORY ITEM MAX
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInventoryItemMax(user_id,idname,amount)
	local getItemAmount = vRP.getInventoryItemAmount(user_id,idname)
	local getItemMax = vRP.itemMaxAmount(idname)

	if getItemMax ~= nil then
		local canBuy = getItemMax - getItemAmount
		if amount <= canBuy then
			return true
		end
	else
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPUTEINVWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.computeInvWeight(user_id)
	local weight = 0
	local inventory = vRP.getInventory(user_id)
	if inventory then
		for k,v in pairs(inventory) do
			if vRP.itemBodyList(v.item) then
				weight = weight + vRP.itemWeightList(v.item) * parseInt(v.amount)
			end
		end
		return weight
	end
	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPUTECHESTWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.computeChestWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		if vRP.itemBodyList(k) then
			weight = weight + vRP.itemWeightList(k) * parseInt(v.amount)
		end
	end
	return weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVENTORYITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInventoryItemAmount(user_id,idname)
	local data = vRP.getInventory(user_id)
	local amount = 0
	if data then
		for k,v in pairs(data) do
			if v.item == idname then
				amount = amount + v.amount
			end
		end
	end
	return parseInt(amount)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.itemAmount(user_id,itemName)
    local totalAmount = 0
    local data = vRP.getInventory(user_id)
    if data then
        for k,v in pairs(data) do
            if v["item"] == itemName then
                totalAmount = totalAmount + v["amount"]
            end
        end
    end
    return totalAmount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SWAPSLOT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.swapSlot(user_id,slot,target)
	local data = vRP.getInventory(user_id)
	if data then
		local temp = data[tostring(slot)]
		data[tostring(slot)] = data[tostring(target)]
		data[tostring(target)] = temp
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.giveInventoryItem(user_id,idname,amount,notify,slot)
	local data = vRP.getInventory(user_id)
	if data and parseInt(amount) > 0 then
		if not slot then
			local initial = 0
			repeat
				initial = initial + 1
			until data[tostring(initial)] == nil or (data[tostring(initial)] and data[tostring(initial)].item == idname)
			initial = tostring(initial)
			
			if data[initial] == nil then
				data[initial] = { item = idname, amount = parseInt(amount) }
			elseif data[initial] and data[initial].item == idname then
				data[initial].amount = parseInt(data[initial].amount) + parseInt(amount)
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "+",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
			end
		else
			slot = tostring(slot)

			if data[slot] then
				if data[slot].item == idname then
					local oldAmount = parseInt(data[slot].amount)
					data[slot] = { item = idname, amount = parseInt(oldAmount) + parseInt(amount) }
				end
			else
				data[slot] = { item = idname, amount = parseInt(amount) }
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "+",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.generateItem(user_id,idname,amount,notify,slot)
	local data = vRP.getInventory(user_id)
	if data and parseInt(amount) > 0 then
		if not slot then
			local initial = 0
			repeat
				initial = initial + 1
			until data[tostring(initial)] == nil or (data[tostring(initial)] and data[tostring(initial)]["item"] == idname) or initial > vRP.getBackpack(user_id)

			if initial > vRP.getBackpack(user_id) then
				TriggerClientEvent("Notify",vRP.getUserSource(user_id),"amarelo","Limite de itens na mochila atingido.",5000)
				return
			end

			initial = tostring(initial)

			if data[initial] == nil then
				data[initial] = { item = idname, amount = amount }
			elseif data[initial] and data[initial]["item"] == idname then
				data[initial]["amount"] = parseInt(data[initial]["amount"]) + amount
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "+",vRP.itemIndexList(idname),vRP.format(amount),vRP.itemNameList(idname) })
			end
		else
			local selectSlot = tostring(slot)

			if data[selectSlot] then
				if data[selectSlot]["item"] == idname then
					data[selectSlot]["amount"] = parseInt(data[selectSlot]["amount"]) + amount
				end
			else
				data[selectSlot] = { item = idname, amount = amount }
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "+",vRP.itemIndexList(idname),vRP.format(amount),vRP.itemNameList(idname) })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYGETINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.tryGetInventoryItem(user_id,idname,amount,notify,slot)
	local data = vRP.getInventory(user_id)
	if data then
		if not slot then
			for k,v in pairs(data) do
				if v.item == idname and parseInt(v.amount) >= parseInt(amount) then
					v.amount = parseInt(v.amount) - parseInt(amount)

					if parseInt(v.amount) <= 0 then
						data[k] = nil
					end

					if notify and vRP.itemBodyList(idname) then
						TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "-",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
					end
					return true
				end
			end
		else
			local slot  = tostring(slot)

			if data[slot] and data[slot].item == idname and parseInt(data[slot].amount) >= parseInt(amount) then
				data[slot].amount = parseInt(data[slot].amount) - parseInt(amount)

				if parseInt(data[slot].amount) <= 0 then
					data[slot] = nil
				end

				if notify and vRP.itemBodyList(idname) then
					TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "-",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
				end
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEINVENTORYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removeInventoryItem(user_id,idname,amount,notify)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname and parseInt(v.amount) >= parseInt(amount) then
				v.amount = parseInt(v.amount) - parseInt(amount)

				if parseInt(v.amount) <= 0 then
					data[k] = nil
				end

				if notify and vRP.itemBodyList(idname) then
					TriggerClientEvent("itensNotify",vRP.getUserSource(user_id),{ "-",vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
				end

				break
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local activedAmount = {}
CreateThread(function()
	while true do
		for k,v in pairs(actived) do
			if actived[k] > 0 then
				actived[k] = v - 1
				if actived[k] <= 0 then
					actived[k] = nil
				end
			end
		end
		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.tryChest(user_id,chestData,itemName,amount,slot,target)
	if actived[slot] == nil and actived[target] == nil and actived[user_id] == nil then
		actived[slot] = 1
		actived[target] = 2
		actived[user_id] = 3

		local consult = vRP.getSData(chestData)
		local result = json.decode(consult) or {}
		if result ~= nil then

			if vRP.getInventoryItemMax(user_id,itemName,parseInt(amount)) then
				if vRP.computeInvWeight(user_id) + (vRP.itemWeightList(itemName) * parseInt(amount)) <= vRP.getBackpack(user_id) then
					local inventory = vRP.user_tables[parseInt(user_id)]["inventory"]
					local targetSlot = tostring(target)
					local selectSlot = tostring(slot)
					local identity = vRP.getUserIdentity(user_id)

					if inventory[targetSlot] and result[selectSlot] then
						if inventory[targetSlot]["item"] == result[selectSlot]["item"] then
							if result[selectSlot]["amount"] >= parseInt(amount) then
								inventory[targetSlot]["amount"] = inventory[targetSlot]["amount"] + parseInt(amount)
								result[selectSlot]["amount"] = result[selectSlot]["amount"] - parseInt(amount)

								if result[selectSlot]["amount"] <= 0 then
									result[selectSlot] = nil
								end

								vRP.execute("vRP/set_srvdata",{ key = chestData, value = json.encode(result) })

							else
								return false
							end
						else
							return false
						end
					else
						if result[selectSlot] then
							if result[selectSlot]["amount"] >= parseInt(amount) then
								inventory[targetSlot] = { item = itemName, amount = parseInt(amount) }
								result[selectSlot]["amount"] = result[selectSlot]["amount"] - parseInt(amount)

								if result[selectSlot]["amount"] <= 0 then
									result[selectSlot] = nil
								end

								vRP.execute("vRP/set_srvdata",{ key = chestData, value = json.encode(result) })

							else
								return false
							end
						else
							return false
						end
					end
				else
					return false
				end
			else
				TriggerClientEvent("Notify",vRP.getUserSource(user_id),"vermelho", "Você não pode carregar essa quantidade de itens.", 5000)
				return false
			end
		end
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.storeChest(user_id,chestData,itemName,amount,dataWeight,slot,target)
	if actived[slot] == nil and actived[target] == nil and actived[user_id] == nil then
		actived[slot] = 1
		actived[target] = 2
		actived[user_id] = 3

		local consult = vRP.getSData(chestData)
		local result = json.decode(consult) or {}
		if result ~= nil then
			if vRP.chestWeight(result) + vRP.itemWeightList(itemName) * parseInt(amount) <= dataWeight then
				local inventory = vRP.user_tables[parseInt(user_id)]["inventory"]
				local targetSlot = tostring(target)
				local selectSlot = tostring(slot)
				local identity = vRP.getUserIdentity(user_id)

				if result[targetSlot] and inventory[selectSlot] then
					if inventory[selectSlot]["item"] == result[targetSlot]["item"] then
						if inventory[selectSlot]["amount"] >= parseInt(amount) then
							result[targetSlot]["amount"] = result[targetSlot]["amount"] + parseInt(amount)
							inventory[selectSlot]["amount"] = inventory[selectSlot]["amount"] - parseInt(amount)

							if inventory[selectSlot]["amount"] <= 0 then
								inventory[selectSlot] = nil
							end
						else
							return true
						end
					else
						return true
					end
				else
					if inventory[selectSlot] then
						if inventory[selectSlot]["amount"] >= parseInt(amount) then
							result[targetSlot] = { item = itemName, amount = parseInt(amount) }
							inventory[selectSlot]["amount"] = inventory[selectSlot]["amount"] - parseInt(amount)

							if inventory[selectSlot]["amount"] <= 0 then
								inventory[selectSlot] = nil
							end
						else
							return true
						end
					else
						return true
					end
				end

				vRP.execute("vRP/set_srvdata",{ key = chestData, value = json.encode(result) })

			else
				return true
			end
		end
		return false
	else
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateChest(user_id,chestData,itemName,slot,target,amount)
	if actived[slot] == nil and actived[target] == nil and actived[user_id] == nil then
		actived[slot] = 1
		actived[target] = 2
		actived[user_id] = 3

		local consult = vRP.getSData(chestData)
		local result = json.decode(consult) or {}
		if result ~= nil then
			local targetSlot = tostring(target)
			local selectSlot = tostring(slot)

			if result[targetSlot] and result[selectSlot] then
				if result[selectSlot]["item"] == result[targetSlot]["item"] then
					if result[selectSlot]["amount"] >= parseInt(amount) then
						result[selectSlot]["amount"] = result[selectSlot]["amount"] - parseInt(amount)

						if result[selectSlot]["amount"] <= 0 then
							result[selectSlot] = nil
						end

						result[targetSlot]["amount"] = result[targetSlot]["amount"] + parseInt(amount)
					else
						return true
					end
				else
					local temporary = result[selectSlot]
					result[selectSlot] = result[targetSlot]
					result[targetSlot] = temporary
				end
			else
				if result[selectSlot] then
					if result[selectSlot]["amount"] >= parseInt(amount) then
						result[selectSlot]["amount"] = result[selectSlot]["amount"] - parseInt(amount)

						if result[selectSlot]["amount"] <= 0 then
							result[selectSlot] = nil
						end

						result[targetSlot] = { item = itemName, amount = parseInt(amount) }
					else
						return true
					end
				else
					return true
				end
			end

			vRP.execute("vRP/set_srvdata",{ key = chestData, value = json.encode(result) })
		end
		return false
	else
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.chestWeight(chestData)
    local totalWeight = 0
    for k,v in pairs(chestData) do
        if vRP.itemBodyList(v["item"]) then
            totalWeight = totalWeight + vRP.itemWeightList(v["item"]) * v["amount"]
        end
    end
    return totalWeight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.inventoryWeight(user_id)
    local totalWeight = 0
    local inventory = vRP.user_tables[parseInt(user_id)]["inventory"]
    if inventory then
        for k,v in pairs(inventory) do
            if vRP.itemBodyList(v["item"]) then
                totalWeight = totalWeight + vRP.itemWeightList(v["item"]) * parseInt(v["amount"])
            end
        end
        return totalWeight
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUP OPEN CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DupOpenChest(user_id,chestName)
	OpenedChest[chestName] = user_id
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DupCheckChest(user_id,chestName)
	if chestName ~= '' then
		if OpenedChest[chestName] then
			if OpenedChest[chestName] == user_id then
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DupCloseChest(user_id,chestName)
	if OpenedChest[chestName] then
		if OpenedChest[chestName] == user_id then
			OpenedChest[chestName] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	for k,v in pairs(OpenedChest) do
		if v == user_id then
			OpenedChest[k] = nil
			return
		end 
	end
end)