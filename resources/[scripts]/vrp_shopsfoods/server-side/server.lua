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
Tunnel.bindInterface("shopsfoods",cRP)
vCLIENT = Tunnel.getInterface("shopsfoods")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.insertItemChest(itemName,itemQuantity,restaurantChest)
	local data = vRP.getSData(restaurantChest)
	local items = json.decode(data) or {}
	if data and items ~= nil then
	local initial = 0
		repeat
			initial = initial + 1
		until items[tostring(initial)] == nil or (items[tostring(initial)] and items[tostring(initial)].item == itemName)
		initial = tostring(initial)
	
		if items[initial] == nil then
			items[initial] = { item = itemName, amount = itemQuantity }
		elseif items[initial] and items[initial].item == itemName then
			items[initial].amount = parseInt(items[initial].amount) + itemQuantity
		end
		vRP.setSData(restaurantChest,json.encode(items))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD FOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.addFood(shopName,shopType,itemName,itemPrice,itemQuantity,getItem)
    local source = source
    local user_id = vRP.getUserId(source)
    if itemName and parseInt(itemPrice) > 0 then

	local dataShop = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_shops` WHERE `type` = ? AND `name` = ?",{ shopType,shopName })
		if dataShop[1] then
			
			if getItem then
				if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(itemQuantity),true) then
					TriggerClientEvent("Notify",source,"success","Você adicionou <b>"..vRP.itemNameList(itemName).."</b> a sua loja.",5000)
				else
					TriggerClientEvent("Notify",source,"negado","Você não possuí a quantidade de <b>"..vRP.itemNameList(itemName).."</b> suficientes.",5000)
					return
				end
			else
				TriggerClientEvent("Notify",source,"success","Você solicitou a compra de <b>"..parseFormat(itemQuantity).."</b>x de <b>"..vRP.itemNameList(itemName).."</b> a sua loja.",5000)
			end

			local shopItems = json.decode(dataShop[1]["data"]) or {}
			if shopItems then
				if shopItems[itemName] ~= nil then
					shopItems[itemName] = { price = parseInt(itemPrice), stock = parseInt(shopItems[itemName]["stock"] + itemQuantity)}
				else
					shopItems[itemName] = { price = parseInt(itemPrice), stock = parseInt(itemQuantity) }
				end

				exports["oxmysql"]:executeSync("UPDATE `vrp_shops` SET `data` = ? WHERE `type` = ? AND `name` = ?",{ json.encode(shopItems),shopType,shopName})
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM FOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.remFood(shopName,shopType,itemName,itemAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		
		local dataShop = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_shops` WHERE `type` = ? AND `name` = ?",{ shopType,shopName })
		if dataShop[1] then
			local shopItems = json.decode(dataShop[1]["data"]) or {}

			if shopItems[itemName] ~= nil then
				checkStock = parseInt(shopItems[itemName]["stock"] - itemAmount)

				if checkStock <= 0 then
					if shopType ~= "salesStore" then
						vRP.insertItemChest(itemName,shopItems[itemName]["stock"],"chest:"..tostring(dataShop[1]["chestName"]))
						TriggerClientEvent("Notify",source,"success","Você retirou <b>"..parseFormat(shopItems[itemName]["stock"]).."</b>x de <b>"..vRP.itemNameList(itemName).."</b> da sua loja.",5000)
					end
					
					shopItems[itemName] = nil
				else
					if shopType ~= "salesStore" then
						vRP.insertItemChest(itemName,itemAmount,"chest:"..tostring(dataShop[1]["chestName"]))
						TriggerClientEvent("Notify",source,"success","Você retirou <b>"..parseFormat(itemAmount).."</b>x de <b>"..vRP.itemNameList(itemName).."</b> da sua loja.",5000)
					end

					shopItems[itemName] = { price = parseInt(shopItems[itemName]["price"]), stock = checkStock}
				end
			end

			exports["oxmysql"]:executeSync("UPDATE `vrp_shops` SET `data` = ? WHERE `type` = ? AND `name` = ?",{ json.encode(shopItems),shopType,shopName})
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE FOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function updateFood(shopName,shopType,itemName,itemAmount)
	local dataShop = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_shops` WHERE `type` = ? AND `name` = ?",{ shopType,shopName })
	if dataShop[1] then
		local shopItems = json.decode(dataShop[1]["data"]) or {}

		if shopItems[itemName] ~= nil then
			checkStock = parseInt(shopItems[itemName]["stock"] - itemAmount)

			if checkStock <= 0 then
				shopItems[itemName] = nil
			else
				shopItems[itemName] = { price = parseInt(shopItems[itemName]["price"]), stock = checkStock}
			end
		end

		exports["oxmysql"]:executeSync("UPDATE `vrp_shops` SET `data` = ? WHERE `type` = ? AND `name` = ?",{ json.encode(shopItems),shopType,shopName})
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestShop(shopName,shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_shops` WHERE `type` = ? AND `name` = ?",{ shopType,shopName })
		local shopData = json.decode(data[1]["data"]) or {}
		local count = 0

		local inventoryShop = {}
		for k,v in pairs(shopData) do
			table.insert(inventoryShop,{
				price = parseInt(v.price),
				stock = parseInt(v.stock),
				name = vRP.itemNameList(k),
				index = vRP.itemIndexList(k),
				key = k,
				weight = vRP.itemWeightList(k),
				amount = parseInt(k),
				max = vRP.itemMaxAmount(k), 
				type = vRP.itemTypeList(k), 
				hunger = vRP.itemHungerList(k), 
				thirst = vRP.itemWaterList(k), 
				economy = vRP.itemEconomyList(k)
			})
			count = count + 1
		end

		if count < 30 then count = 30 end

		local inventoryUser = {}
		local inv = vRP.getInventory(user_id)
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
				v.key = v.item
				v.slot = k

				inventoryUser[k] = v
			end
		end

		return inventoryShop,inventoryUser,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),count
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkService(shopType,shopPermiss)
	if shopType == "salesStore" then
		return true
	end
	
	local amountService = vRP.numPermission(shopPermiss)
	return parseInt(#amountService) <= 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionShops(shopName,shopType,itemName,itemAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if itemAmount == nil then itemAmount = 1 end
		if itemAmount <= 0 then itemAmount = 1 end

		local dataShop = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_shops` WHERE `type` = ? AND `name` = ?",{ shopType,shopName })
		if dataShop[1] then
			local shopData = json.decode(dataShop[1]["data"]) or {}
			if vRP.getInventoryItemMax(user_id,itemName,itemAmount) then
				if shopType == "buyStore" then
					if vRP.computeInvWeight(parseInt(user_id)) + vRP.itemWeightList(itemName) * parseInt(itemAmount) <= vRP.getBackpack(parseInt(user_id)) then
						if shopData[itemName] and shopData[itemName]["stock"] > 0 then
							if shopData[itemName]["stock"] >= itemAmount then
								if vRP.paymentBank(user_id,parseInt(shopData[itemName]["price"] * itemAmount)) then
									vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(itemAmount),true,slot)
									setCashBusiness(user_id,shopName,parseInt(shopData[itemName]["price"] * itemAmount))
									updateFood(shopName,shopType,itemName,itemAmount)
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",5000)
								end
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
					end
				elseif shopType == "salesStore" then
					if shopData[itemName] then
						if vRP.getInventoryItemAmount(user_id, itemName) >= itemAmount then
							if paymentBusiness(user_id,shopName,parseInt(shopData[itemName]["price"] * itemAmount )) then
								if vRP.tryGetInventoryItem(user_id,itemName,itemAmount,true) then
									vRP.giveInventoryItem(user_id,"dollars",shopData[itemName]["price"] * itemAmount,true)
									vRP.insertItemChest(itemName,itemAmount,"chest:"..tostring(shopName))
									updateFood(shopName,shopType,itemName,itemAmount)
								end
							else
								TriggerClientEvent("Notify",source,"negado","<b>"..shopName.."</b> não possuí valor em caixa, volte mais tarde.",5000)
							end
						end
					end
				end
			else
				TriggerClientEvent("Notify",source,"vermelho","Limite Atingido!",5000)
			end
			vCLIENT.updateShops(source,"requestShop")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function paymentBusiness(user_id,shopid,amount)
    if amount > 0 then
        local consult = vRP.query("vRP/getname_business",{ business = tostring(shopid) })
        if consult[1] and consult[1]["cash"] >= amount then
			vRP.execute("vRP/withdraw_business",{ business = tostring(shopid), cash = parseInt(amount)  })
			return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET CASH BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function setCashBusiness(user_id,shopid,amount)
    if amount > 0 then
        local consult = vRP.query("vRP/getname_business",{ business = tostring(shopid) })
        if consult[1] then
            vRP.execute("vRP/deposit_business",{ business = tostring(shopid), cash = parseInt(amount)  })
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shopsfoods:populateSlot")
AddEventHandler("shopsfoods:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil or amount <= 0 then 
			amount = 1 
		end

		if vRP.tryGetInventoryItem(parseInt(user_id),itemName,amount,false,slot) then
			vRP.giveInventoryItem(parseInt(user_id),itemName,amount,false,target)
			vCLIENT.updateShops(source,"requestShop")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shopsfoods:updateSlot")
AddEventHandler("shopsfoods:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil or amount <= 0 then 
			amount = 1 
		end

		local inv = vRP.getInventory(parseInt(user_id))
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(parseInt(user_id),itemName,amount,false,slot) then
					vRP.giveInventoryItem(parseInt(user_id),itemName,amount,false,target)
				end
			else
				vRP.swapSlot(parseInt(user_id),slot,target)
			end
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	createShops(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	Wait(10000)

	createShops(-1)
end)

function createShops(target)
	local rows = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_shops`",{})
	if #rows > 0 then
		 for k,v in pairs(rows) do
			 vCLIENT.insertShops(target,v["name"],json.decode(v["coords"]),v["type"],v["permiss"])
		 end
	 end
end