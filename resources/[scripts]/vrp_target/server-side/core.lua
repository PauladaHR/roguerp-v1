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
Hiro = {}
Tunnel.bindInterface("target",Hiro)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.PayCheckin()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) <= 100 then
			vRP.upgradeHunger(user_id,20)
			vRP.upgradeThirst(user_id,20)
			vRP.upgradeStress(user_id,10)
			vRP.wantedTimer(user_id,120)

			return true
		else
			if vRP.request(source,"Macas","Prosseguir o tratamento por <b>$750</b> dólares?",60) then
				if vRP.paymentFull(user_id,750) then
					vRP.upgradeHunger(user_id,20)
					vRP.upgradeThirst(user_id,20)
					vRP.upgradeStress(user_id,10)
					vRP.wantedTimer(user_id,120)

					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end

	return false
end