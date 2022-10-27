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
Tunnel.bindInterface("vrp_eletronics",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local atmTimers = GetGameTimer() + (math.random(10,15) * 60000)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkSystems()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policeResult = vRP.numPermission("Police")
		if parseInt(#policeResult) <= 1 or GetGameTimer() < atmTimers then
		TriggerClientEvent("Notify",source,"vermelho","Sistema indisponível no momento.",5000)
			return false
		else
			if vRP.getInventoryItemAmount(user_id,"bluecard") <= 0 then
				TriggerClientEvent("Notify",source,"vermelho","Necessário possuir um <b>Cartão Azul</b>.",5000)
				return false
			end

			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			atmTimers = GetGameTimer() + (math.random(20,30) * 60000)

			for k,v in pairs(policeResult) do
				async(function()
					vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
					TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Caixa Eletrônico", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
				end)
			end

			vRP.removeInventoryItem(user_id,"bluecard",1,true)

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTSYSTEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentSystems()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if GetGameTimer() < atmTimers then
			vRP.wantedTimer(user_id,5)
			vRP.giveInventoryItem(user_id,"dollars2",math.random(1000,1300),true)
		end
	end
end