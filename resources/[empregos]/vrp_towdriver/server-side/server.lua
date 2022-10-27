-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_towdriver",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
local itensList = { "plastic","glass","rubber","aluminum","copper" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.enterService()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if userList[user_id] == nil then
			userList[user_id] = source
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_towdriver:callPlayers")
AddEventHandler("vrp_towdriver:callPlayers",function(source,vehName,vehPlate)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	for k,v in pairs(userList) do
		async(function()
			TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Registro de Veículo", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vRP.vehicleName(vehName).." - "..vehPlate, time = "Recebido às "..os.date("%H:%M"), blipColor = 33 })
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = math.random(500,725)
		vRP.giveInventoryItem(user_id,itensList[math.random(#itensList)],math.random(35,40),true)
		vRP.giveInventoryItem(user_id,"dollars",value,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.tryTow(vehid01,vehid02,mod)
	TriggerClientEvent("vrp_towdriver:syncTow",-1,vehid01,vehid02,tostring(mod))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if userList[user_id] then
		userList[user_id] = nil
	end
end)