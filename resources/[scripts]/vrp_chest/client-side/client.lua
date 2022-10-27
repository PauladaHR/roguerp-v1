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
Tunnel.bindInterface("vrp_chest",cRP)
vSERVER = Tunnel.getInterface("vrp_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chestOpen = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v.x << 8) | v.y
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
local chestCoords = {

	{ "Police",475.16,-993.94,26.28,"Abrir",true },

	{ "Paramedic",-820.07,-1243.07,7.34 },
	{ "Paramedic",-252.91,6337.35,32.43 },	

	{ "Mechanic", 916.38,-2100.62,30.46 },
	{ "MechanicMaster", 886.43,-2097.43,34.89 },
	
	{ "Barragem", 1425.27,-32.18,136.55 },
	{ "Helipa", 1428.57,-765.98,73.25 },
	{ "Cupim", 1980.81,-954.32,82.44 },
	{ "HelipaMaster", 1427.11,-765.47,73.25 },
	{ "CupimMaster", 1982.28,-947.39,82.74 },
	{ "BarragemMaster", 1519.4,-41.23,151.42 },

	{ "Municao01", -1556.74,-374.84,48.05 },
	{ "Municao01Master", -1567.76,-373.28,38.1 },
	
	{ "Municao02", 1248.46,-1573.81,58.36 },
	{ "Municao02Master", 1250.76,-1581.04,58.36 },
	 

	{ "Arma01", 16.38,2246.67,28.22 },
	{ "Arma01Master", 80.77,2292.24,29.73 },
	{ "Arma02", 2525.32,4601.05,-39.67 },
	{ "Arma02Master", 2589.21,4646.29,-38.16 },

	{ "Lavagem01", 1399.99,1139.6,114.34 },
	{ "Lavagem01Master",1391.57,1158.82,114.34 },
	{ "Lavagem02", -1554.2,-573.71,108.53 },
	{ "Lavagem02Master", -1564.49,-572.93,108.53 },

	
	{ "Municao03", 985.92,-133.93,78.89 },
	{ "Municao03Master", 993.17,-135.56,74.07 },

	{ "Desmanche01", 146.7,-3007.86,7.05 },

	{ "catCoffe", -590.28,-1059.47,22.35 },
	{ "catCoffeMesa", -584.79,-1059.25,22.35,"Bandeja",true },
	{ "catCoffeMesa", -583.32,-1059.28,22.35,"Bandeja",true },

	{ "Pearls", -1838.81,-1183.59,14.33 },

	{ "CasaLago", -96.49,828.98,231.34 },
	{ "CasaLagoGeladeira", -83.56,835.48,227.75 },
	{ "CasaBombeiros", -806.63,171.22,72.84 },
	{ "CasaBombeirosGeladeira", -803.17,185.83,72.61 },
	{ "CasaSista", -74.24,1006.3,234.4 },
	{ "CasaSistaGeladeira", -395.88,4713.97,264.88 },

	{ "Arma03", -1808.21,3091.36,32.85 },

	{ "coolBeans", -1197.17,-1141.89,7.84 },
	{ "coolBeansMesa", -1202.55,-1138.32,7.84,"Bandeja",true },
	{ "coolBeansMesa", -1202.78,-1136.7,7.84,"Bandeja",true },


}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(chestCoords) do
		if v[6] then
			exports["vrp_target"]:AddCircleZone("chest:"..k,vector3(v[2],v[3],v[4]),1.0,{
				name = "chest:"..k,
				heading = 0.0
			},{
				shop = k,
				distance = 1.0,
				options = {
					{
						event = "chest:openSystem",
						label =  v[5] or "Abrir",
						tunnel = "shop"
					}
				}
			})
		else
			exports["vrp_target"]:AddCircleZone("chest:"..k,vector3(v[2],v[3],v[4]),1.0,{
				name = "chest:"..k,
				heading = 0.0
			},{
				shop = k,
				distance = 1.0,
				options = {
					{
						event = "chest:openSystem",
						label = "Abrir",
						tunnel = "shop"
					},{
						event = "chest:upgradeSystem",
						label = "Aumentar",
						tunnel = "shop"
					}
				}
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:openSystem",function(shopId)
	if vSERVER.checkIntPermissions(chestCoords[shopId][1]) then
		SetNuiFocus(true,true)
		chestOpen = chestCoords[shopId][1]
		SendNUIMessage({ action = "showMenu" })
		TransitionToBlurred(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPGRADESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:upgradeSystem",function(shopId)
	vSERVER.upgradeSystem(chestCoords[shopId][1])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("checkchest",function(source,args,rawCommand)
	if args[1] then
		if vSERVER.checkIntAdmin(args[1]) then
			SetNuiFocus(true,true)
			chestOpen = args[1]
			SendNUIMessage({ action = "showMenu" })
			TransitionToBlurred(1000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	vSERVER.chestClose(chestOpen)
	SendNUIMessage({ action = "hideMenu" })
	SetNuiFocus(false,false)
	chestOpen = ""
	TransitionFromBlurred(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(data["item"],data["slot"],data["amount"],data["target"],chestOpen)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(data["item"],data["slot"],data["amount"],data["target"],chestOpen)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateChest",function(data,cb)
	vSERVER.updateChest(data["item"],data["slot"],data["target"],data["amount"],chestOpen)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.openChest(chestOpen)
	if myInventory then
		cb({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_chest2:Update")
AddEventHandler("vrp_chest2:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_chest2:UpdateWeight")
AddEventHandler("vrp_chest2:UpdateWeight",function(invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)