local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("vrp_checkin",src)
vCLIENT = Tunnel.getInterface("vrp_checkin")

function src.checkServices()
	local amountMedics = vRP.numPermission("Paramedic")
	if parseInt(#amountMedics) >= 1 then
		TriggerClientEvent("Notify",source,"vermelho", "Existem paramédicos em serviço.", 5000)
		return false
	end
	return true
end

function src.paymentCheckin()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			return true
		end

		local value = 100
		if GetEntityHealth(GetPlayerPed(source)) <= 101 then
			value = value + 300
		end

		if vRP.paymentBank(user_id,parseInt(value)) then
			return true
		else
			TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
		end
	end
	return false
end