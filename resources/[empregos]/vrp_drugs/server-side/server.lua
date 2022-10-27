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
Tunnel.bindInterface("vrp_drugs",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local amount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local groupDrugs = {
	[1] = {
		["group"] = "Ballas",
		["drug"] = "joint",
		["drugpack"] = "joint",
		["priceMin"] = 350,
		["priceMax"] = 450
	},
	[2] = {
		["group"] = "Vagos",
		["drug"] = "meth",
		["drugpack"] = "meth",
		["priceMin"] = 350,
		["priceMax"] = 450
	},
	[3] = {
		["group"] = "Families",
		["drug"] = "cocaine",
		["drugpack"] = "cocaine",
		["priceMin"] = 350,
		["priceMax"] = 450
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dropChestMoney")
AddEventHandler("dropChestMoney",function(chest)
	local data = vRP.getSData(chest)
	local items = json.decode(data) or {}
	if data and items ~= nil then
		local initial = 0
		repeat
			initial = initial + 1
		until items[tostring(initial)] == nil or (items[tostring(initial)] and items[tostring(initial)].item == "dollars2")
		initial = tostring(initial)
		
		if items[initial] == nil then
			items[initial] = { item = "dollars2", amount = parseInt(200) }
		elseif items[initial] and items[initial].item == "dollars2" then
			items[initial].amount = parseInt(items[initial].amount) + parseInt(200)
		end
		vRP.setSData(chest,json.encode(items))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkAmount()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(groupDrugs) do
			if vRP.getInventoryItemAmount(user_id,groupDrugs[k].drug) >= 2 or vRP.getInventoryItemAmount(user_id,groupDrugs[k].drugpack) >= 2 then
				return true
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD 
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local copAmount = vRP.numPermission("Police")
		if parseInt(#copAmount) == 0 then
			copAmount = 2
		elseif parseInt(#copAmount) == 1 then
			copAmount = 2
		elseif parseInt(#copAmount) == 2 then
			copAmount = 2
		elseif parseInt(#copAmount) == 3 then
			copAmount = 3
		elseif parseInt(#copAmount) == 4 then	
			copAmount = 4
		elseif parseInt(#copAmount) >= 4 then	
			copAmount = parseInt(#copAmount)
		elseif parseInt(#copAmount) >= 12 then
			copAmount = 8
		end
		if vRP.hasPermission(user_id,{"Ballas","Families","Vagos","Bloods","Crips"}) then
			for k,v in pairs(groupDrugs) do
				local price = math.random(groupDrugs[k].priceMin,groupDrugs[k].priceMax)
				if vRP.tryGetInventoryItem(user_id,groupDrugs[k].drug,2,true) then
					local value = copAmount * (price*2)
					vRP.giveInventoryItem(user_id,"dollars2",parseInt(value),true)
					TriggerClientEvent("sounds:Private",source,"coin",0.5)
				end
			end
		else
			for k,v in pairs(groupDrugs) do
				local price = math.random(groupDrugs[k].priceMin,groupDrugs[k].priceMax)
				if vRP.tryGetInventoryItem(user_id,groupDrugs[k].drug,2,true) then
					local value = copAmount * (price*2)
					vRP.giveInventoryItem(user_id,"dollars2",parseInt(value),true)
					TriggerClientEvent("sounds:Private",source,"coin",0.5)
					TriggerEvent("dropChestMoney","chest:"..tostring(groupDrugs[k].group))
				end
			end
		end
		vRP.upgradeStress(user_id,3)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drugs:markOccurrence", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local x,y,z = vRPC.getPositions(source)
		local copAmount = vRP.numPermission("Police")
		for k,v in pairs(copAmount) do
			async(function()
				TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Denúncia de Venda de Drogas", x = x, y = y, z = z, rgba = {41,76,119} })
			end)
		end
		TriggerClientEvent("Notify",source,"amarelo", "A policia foi acionada.", 5000)
	end
end)