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
Tunnel.bindInterface("vrp_shops",cRP)
vSERVER = Tunnel.getInterface("vrp_shops")
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
	local inventoryShop,inventoryUser,weight,maxweight,infos,slotShops = vSERVER.requestShop(data.shop)
	if inventoryShop then
		cb({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, weight = weight, maxweight = maxweight, infos = infos, slotShops = slotShops})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(data,cb)
	vSERVER.functionShops(data.shop,data.item,data.amount,data.slot)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("vrp_shops:populateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("vrp_shops:updateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_TRUNKCHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateShops(action)
	SendNUIMessage({ action = action })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS WEBHOOKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_shops:webhooks")
AddEventHandler("vrp_shops:webhooks",function(user_id,shopType,shopItem,shopAmount,date)
	if shopType == "departamentStore" or shopType == "registryStore" or shopType == "digitalDen" then
		TriggerServerEvent("webhooks","lojas","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Lojas")
	end

	if shopType == "ammunationStore" then
		TriggerServerEvent("webhooks","ammunation","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Ammunation")
	end

	if shopType == "rentalStore" then
		TriggerServerEvent("webhooks","rentalshop","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Rental Car")
	end

	if shopType == "pharmacyStore" or shopType == "pharmacyMasterStore" then
		TriggerServerEvent("webhooks","hospital","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Hospital")
	end

	if shopType == "corredor01" then
		TriggerServerEvent("webhooks","corredor01","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Corredor01")
	end

	if shopType == "corredor02" then
		TriggerServerEvent("webhooks","corredor02","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Corredor02")
	end

	if shopType == "CartelShop" then
		TriggerServerEvent("webhooks","cartel","```ini\n[ID]: "..user_id.." ( COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Compras Cartel")
	end

	if shopType == "fishingStore" or shopType == "fishingSell" then
		TriggerServerEvent("webhooks","peixe","```ini\n[ID]: "..user_id.." ( VENDEU/COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Vendas Peixe")
	end

	if shopType == "hunterStore" or shopType == "hunterSell" then
		TriggerServerEvent("webhooks","hunter","```ini\n[ID]: "..user_id.." ( VENDEU/COMPROU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Vendas Caçador")
	end

	if shopType == "lesterStore" then
		TriggerServerEvent("webhooks","lester","```ini\n[ID]: "..user_id.." ( VENDEU )\n[ITEM]: "..shopAmount.."x "..shopItem.." "..date.." \r```","Vendas Lester")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local shopList = {
	
	----------------------
	---- DEPARTAMENTO ----
	----------------------

	{ 25.65,-1346.3,29.49,"departamentStore",true,true },
	{ 2556.1,382.04,108.61,"departamentStore",true,true },
	{ 1163.7,-323.9,69.2,"departamentStore",true,true },
	{ -707.32,-914.66,19.21,"departamentStore",true,true },
	{ -48.32,-1757.96,29.42,"departamentStore",true,true },
	{ 374.0,327.3,103.56,"departamentStore",true,true },
	{ -3242.63,1001.25,12.84,"departamentStore",true,true },
	{ 1729.43,6415.76,35.03,"departamentStore",true,true },
	{ 548.05,2669.99,42.16,"departamentStore",true,true },
	{ 1960.5,3741.64,32.33,"departamentStore",true,true },
	{ 2677.6,3281.0,55.23,"departamentStore",true,true },
	{ 1697.91,4924.46,42.06,"departamentStore",true,true },
	{ -1820.33,792.68,138.1,"departamentStore",true,true },
	{ 1392.47,3605.03,34.98,"departamentStore",true,true },
	{ -2967.75,391.55,15.05,"departamentStore",true,true },
	{ -3040.48,585.3,7.9,"departamentStore",true,true },
	{ 1135.65,-982.83,46.4,"departamentStore",true,true },
	{ 1165.38,2709.45,38.15,"departamentStore",true,true },
	{ -1487.64,-378.59,40.15,"departamentStore",true,true },
	{ -1222.29,-906.88,12.32,"departamentStore",true,true },
	{ 161.87,6641.25,31.72,"departamentStore",true,true },

	{ -550.49,-192.48,38.22,"IdentityStore",true,true },
	{ -552.58,-193.67,38.22,"IdentityStore",true,true },

	{ 54.81,-1739.25,29.6,"megaMall",true,true },

	{ -1254.82,-1444.1,4.38,"ingredientsStore",true,true },

	{ 1692.62,3759.50,34.70,"ammunationStore",true,true },
	{ 252.89,-49.25,69.94,"ammunationStore",true,true },
	{ 843.28,-1034.02,28.19,"ammunationStore",true,true },
	{ -331.35,6083.45,31.45,"ammunationStore",true,true },
	{ -663.15,-934.92,21.82,"ammunationStore",true,true },
	{ -1305.18,-393.48,36.69,"ammunationStore",true,true },
	{ -1118.80,2698.22,18.55,"ammunationStore",true,true },
	{ 2568.83,293.89,108.73,"ammunationStore",true,true },
	{ -3172.68,1087.10,20.83,"ammunationStore",true,true },
	{ 21.32,-1106.44,29.79,"ammunationStore",true,true },
	{ 811.19,-2157.67,29.61,"ammunationStore",true,true },

	{ -32.13,-1114.32,26.43,"rentalStore",true,false,"Rental" },
	{ 1523.47,3782.22,34.51,"fishingStore",true,false,"Comprar" },
	{ 1528.3,3785.59,34.51,"fishingSell",false,false,"Vender" },

	{ -328.53,6078.48,31.46,"hunterStore",true,false },
	{ 985.57,-2120.61,30.48,"hunterSell",false,false },
	{ -1273.02,-1412.06,4.38,"digitalDen",true,false },
	{ -428.53,-1727.95,19.79,"recyclingSell",false,false },
	{ 716.46,-961.56,30.4,"lesterStore",false,false },
	


	{ 915.98,-2105.52,30.46,"advancedStore",false,false }, -- Los Santos
	{ 903.36,-2098.68,30.46,"mechanicStore",false,false }, -- Los Santos
	
	{ 873.74,-2099.28,30.48,"TiresTool",false,false },


	{ 988.03,-94.8,74.85,"motoclubeStore",true,false },
	{ 111.67,3615.78,40.48,"capsuleSell",true,false },
	{ -561.75,286.84,82.18,"TequilalaBar",true,false },
	{ -565.58,286.13,85.38,"TequilalaBar",true,false },
	{ -1700.37,-218.99,57.69,"TequilalaBar",true,false },
	
	
	{ 12.5,215.69,77.33,"Galaxy",true,false },
	{ 5.71,220.68,80.33,"Galaxy",true,false },

	{ -1391.38,-606.3,30.32,"Bahamas",true,false },
	{ -1373.91,-627.91,30.82,"Bahamas",true,false },

	{ 129.29,-1283.89,29.27,"Vanilla",true,false },
	
	{ 957.87,72.18,112.56,"Cassino",true,false },
	{ 1110.21,208.7,-49.44,"Cassino",true,false },

	{ -1200.68,-1146.09,7.84,"coolBeans",false,false},
	{ -585.69,-1062.14,22.35,"catCoffe",false,false},
	{ -1840.85,-1182.64,14.33,"Pearls",false,false},


	{ 487.3,-997.08,30.68,"policeStore",false,false },
	{ 481.19,-995.27,30.69,"PolicePort",false,false },
	{ -439.92,5992.03,31.72,"policeStore",false,false },

	{ -805.36,-1212.8,7.34,"pharmacyStore",true,false },
	{ -245.9,6315.89,32.43,"pharmacyStore",true,false },
	{ -804.51,-1206.57,7.34,"pediatraStore",true,false },
	{ -804.57,-1206.62,7.34,"pharmacyMasterStore",true,false },
	
	{ -1249.05,-1449.35,4.38,"weedStore",false,false },

	{ 124.61,-3011.84,7.05,"Desmanche01",false,false },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(shopList) do
		exports["vrp_target"]:AddCircleZone("vrp_shops:"..k,vector3(v[1],v[2],v[3]),1.25,{
			name = "vrp_shops:"..k,
			heading = 0.0
		},{
			shop = k,
			distance = 1.75,
			options = {
				{
					event = "vrp_shops:openSystem",
					label = v[7] or "Abrir",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:openSystem",function(shopId)
	if vSERVER.requestPerm(shopList[shopId][4]) then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showNUI", name = shopList[shopId][4], type = vSERVER.getShopType(shopList[shopId][4]) })
		TransitionToBlurred(1000)

		if shopList[shopId][5] then
			TriggerEvent("sounds:Private","shop",0.5)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:COFFEEMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:coffeeMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("coffeeMachine"), type = vSERVER.getShopType("coffeeMachine") })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:SODAMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:sodaMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("sodaMachine"), type = vSERVER.getShopType("sodaMachine") })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:COLAMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:colaMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("colaMachine"), type = vSERVER.getShopType("colaMachine") })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DONUTMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:donutMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("donutMachine"), type = vSERVER.getShopType("donutMachine") })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:BURGERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:burgerMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("burgerMachine"), type = vSERVER.getShopType("burgerMachine") })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:HOTDOGMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:hotdogMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("hotdogMachine"), type = vSERVER.getShopType("hotdogMachine") })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:WATERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vrp_shops:waterMachine",function()
	SendNUIMessage({ action = "showNUI", name = tostring("waterMachine"), type = vSERVER.getShopType("waterMachine") })
	SetNuiFocus(true,true)
end)