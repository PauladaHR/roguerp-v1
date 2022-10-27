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
vSERVER = Tunnel.getInterface("shopsfoods")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideNUI" })
	TransitionFromBlurred(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestShop",function(data,cb)
	local inventoryShop,inventoryUser,weight,maxweight,slotShops = vSERVER.requestShop(data["shop"],data["type"])
	if inventoryShop then
		cb({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, weight = weight, maxweight = maxweight, slotShops = slotShops})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(data,cb)
	vSERVER.functionShops(data["shop"],data["type"],data["item"],data["amount"],data["slot"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("shopsfoods:populateSlot",data["item"],data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("shopsfoods:updateSlot",data["item"],data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- trunkchest:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateShops(action)
	SendNUIMessage({ action = action })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.insertShops(shopName,shopLocate,shopType,shopPermiss)
	local shopStyle = (shopType ~= "buyStore") and "Vender" or "Comprar"

	exports["vrp_target"]:AddCircleZone("shopsfoods:"..shopName..":"..shopType,vector3(shopLocate[1],shopLocate[2],shopLocate[3]),1.0,{
		name = "shopsfoods:"..shopName..":"..shopType,
		heading = 0.0
	},{
		shop = {shopName,shopType,shopPermiss},
		distance = 1.0,
		options = {
			{
				event = "shopsfoods:openSystem",
				label = shopStyle or "Abrir",
				tunnel = "shop"
			}
		}
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shopsfoods:openSystem",function(shopInfo)
	if vSERVER.checkService(shopInfo[2],shopInfo[3]) then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showNUI", name = tostring(shopInfo[1]), type = shopInfo[2] })
		TriggerEvent("vrp_sounds:source","shop",0.5)
		TransitionToBlurred(1000)
	end
end)