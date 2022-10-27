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
Tunnel.bindInterface("vrp_impound",cRP)
vGARAGE = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local impoundVehs = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkImpound()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
		if vehicle then
			if impoundVehs[vehName.."-"..vehPlate] == nil then
				return
			else
				local value = math.random(840,910)
				local value2 = math.random(30,50)

				impoundVehs[vehName.."-"..vehPlate] = nil
				vRP.giveInventoryItem(user_id,"dollars",parseInt(value),true)

				local random = math.random(125)
				if parseInt(random) >= 100 then
					vRP.giveInventoryItem(user_id,"glass",parseInt(value2),true)
				elseif parseInt(random) >= 75 and parseInt(random) <= 99 then
					vRP.giveInventoryItem(user_id,"aluminum",parseInt(value2),true)
				elseif parseInt(random) >= 50 and parseInt(random) <= 74 then
					vRP.giveInventoryItem(user_id,"rubber",parseInt(value2),true)
				elseif parseInt(random) >= 25 and parseInt(random) <= 49 then
					vRP.giveInventoryItem(user_id,"plastic",parseInt(value2),true)
				elseif parseInt(random) <= 24 then
					vRP.giveInventoryItem(user_id,"copper",parseInt(value2),true)
				end
				vGARAGE.deleteVehicle(source,vehicle)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:impound")
AddEventHandler("police:impound",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,{"Police","actionPolice"}) then
			local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
			if vehicle then
				local x,y,z = vRPC.getPositions(source)
				local mecAmount = vRP.numPermission("Mechanic")
				if impoundVehs[vehName.."-"..vehPlate] == nil then
					impoundVehs[vehName.."-"..vehPlate] = true
					TriggerEvent("vrp_towdriver:alertPlayers",mecAmount,x,y,z,vRP.vehicleName(vehName).." - "..vehPlate)
					TriggerClientEvent("Notify",source,"verde", "Veículo <b>"..vRP.vehicleName(vehName).."</b> foi registrado no <b>DMV</b>.", 5000)
				else
					TriggerClientEvent("Notify",source,"amarelo", "Veículo <b>"..vRP.vehicleName(vehName).."</b> já está na lista do <b>DMV</b>.", 5000)
				end
			end
		end
	end
end)