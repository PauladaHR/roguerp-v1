-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hiro = {}
Tunnel.bindInterface("vrp_engine",Hiro)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehFuels = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.paymentFuel(price)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.paymentBank(user_id,parseInt(price)) then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",5000)
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GALLONBUYING
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.gallonBuying()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local request = vRP.request(source,"Posto","Deseja comprar um <b>Galão de Gasolina</b> por <b>$250 dólares</b>?",30)
		if request then
			if vRP.paymentBank(user_id,250) then
				vRP.giveInventoryItem(user_id,"WEAPON_PETROLCAN",1)
				vRP.giveInventoryItem(user_id,"WEAPON_PETROLCAN_AMMO",4500)
				return true
			else
				TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_engine:tryFuel")
AddEventHandler("vrp_engine:tryFuel",function(playerAround,vehicle,fuel)
	vehFuels[vehicle] = fuel

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("vrp_engine:syncFuel",v,vehicle,fuel)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_engine:syncFuelPlayers",source,vehFuels)
end)