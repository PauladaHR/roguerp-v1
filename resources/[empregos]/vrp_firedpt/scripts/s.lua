local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent('lixeiroBombeiros:dinheiro')
AddEventHandler('lixeiroBombeiros:dinheiro', function()
	local user_id = vRP.getUserId(source)
	local rand = math.random(Config.valorMin, Config.valorMax)
	vRP.giveMoney(user_id,rand)
	TriggerClientEvent("sounds:Private",source,'coins',0.5)
	TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>R$"..parseFormat(parseInt(rand)).."</b>.")
end)

RegisterServerEvent('lixeiroBombeiros:getPerm')
AddEventHandler('lixeiroBombeiros:getPerm', function()
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,Config.permissao) then
		TriggerClientEvent('lixeiroBombeiros:getPerm', source, true)
	else
		TriggerClientEvent('lixeiroBombeiros:getPerm', source, false)
	end
end)
