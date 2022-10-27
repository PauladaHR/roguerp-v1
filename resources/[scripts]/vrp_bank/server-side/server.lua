local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function src.isWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.wantedReturn(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSALDO
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getSaldo()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.getBank(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SACARVALOR
-----------------------------------------------------------------------------------------------------------------------------------------
function src.atmWithdraw(valor)
	local source = source
	if vCLIENT.checkConnection(source) then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
			local getFines = vRP.getFines(user_id)
			
			TriggerClientEvent("bankCloseEvent",source)
			if getFines[1] ~= nil then
				TriggerClientEvent("Notify",source,"negado","Encontramos multas pendentes.",3000)
				return
			end

			if parseInt(valor) > 0 then
				TriggerClientEvent("bankActived",source,true)
				if vRP.withdrawCash(user_id,parseInt(valor)) then
					TriggerClientEvent("Notify",source,"sucesso","Saque realizado com sucesso!",6000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
				end
				TriggerClientEvent("bankActived",source,false)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SACARVALOR
-----------------------------------------------------------------------------------------------------------------------------------------
function src.atmDeposit(valor)
	local source = source
	if vCLIENT.checkConnection(source) then
		local amount = valor
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
			if parseInt(amount) > 0 then
				TriggerClientEvent("bankActived",source,true)
				if vRP.tryGetInventoryItem(user_id,"dollars",parseInt(amount),true) then
					TriggerClientEvent("bankCloseEvent",source)
					vRP.addBank(user_id,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Depósito realizado com sucesso!",6000)
				else
					TriggerClientEvent("bankCloseEvent",source)
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta carteira.",5000)
				end
				TriggerClientEvent("bankActived",source,false)
			end
		end
	end
end