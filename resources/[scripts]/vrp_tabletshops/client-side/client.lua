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
Tunnel.bindInterface("tabletshops",cRP)
vSERVER = Tunnel.getInterface("tabletshops")
vSHOPS = Tunnel.getInterface("shopsfoods")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local computerCoords = {
	{ -1200.67,-1137.63,7.84,"coolBeans"},
	{ -584.78,-1061.56,22.35,"catCoffe"},
	{ -1818.13,-1199.24,14.48,"Pearls"},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(computerCoords) do
		exports["vrp_target"]:AddCircleZone("tabletshops:"..k,vector3(v[1],v[2],v[3]),1.0,{
			name = "tabletshops:"..k,
			heading = 0.0
		},{
			shop = k,
			distance = 1.0,
			options = {
				{
					event = "tabletshops:openSystem",
					label = "Tablet",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("tabletshops:openSystem",function(shopId)
	if vSERVER.requestPerm(computerCoords[shopId][4]) then
		if GetEntityHealth(PlayerPedId()) > 101 then
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "openSystem", name = computerCoords[shopId][4] })

			if not IsPedInAnyVehicle(PlayerPedId()) then
				vRP.removeObjects()
				vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getRestaurant",function(data,cb)
	local restaurantSell,restaurantBuy,masterPermiss,restaurantBalance = vSERVER.openRestaurant(data["restaurant"])
	if restaurantSell then
		cb({ restaurantSell = restaurantSell, restaurantBuy = restaurantBuy, masterPermiss = masterPermiss, restaurantBalance = restaurantBalance})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	vRP.removeObjects()
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeSystem" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("foodsFunctions",function(data,cb)
	if data["option"] == "Buy" then
		if data["type"] == "buyStore" then
			vSHOPS.addFood(data["openRestaurant"],data["type"],data["item"],parseInt(data["amount"]),parseInt(data["quantity"]),true)
		elseif data["type"] == "salesStore" then
			vSHOPS.addFood(data["openRestaurant"],data["type"],data["item"],parseInt(data["amount"]),parseInt(data["quantity"]),false)
		end
	end

	if data.option == "Sell" then
		vSHOPS.remFood(data["openRestaurant"],data["type"],data["item"],data["quantity"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("businessFunctions",function(data,cb)
	if data["type"] == "Add" then
        vSERVER.addBusiness(parseInt(data["passaporte"]),data["openRestaurant"])
    end

    if data["type"] == "Rem" then
        vSERVER.remBusiness(parseInt(data["passaporte"]),data["openRestaurant"])
    end

    if data["type"] == "Deposit" then
        vSERVER.depositBusiness(data["amount"],data["openRestaurant"])
    end

    if data["type"] == "Withdraw" then
        vSERVER.withdrawBusiness(data["amount"],data["openRestaurant"])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLETSHOPS:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tabletshops:Update")
AddEventHandler("tabletshops:Update",function(action)
	SendNUIMessage({ action = action })
end)