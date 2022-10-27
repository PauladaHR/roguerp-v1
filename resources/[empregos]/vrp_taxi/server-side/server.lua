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
Tunnel.bindInterface("vrp_taxi",cRP)
vCLIENT = Tunnel.getInterface("vrp_taxi")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initService(inService)
    local source = source 
    local user_id = vRP.getUserId(source)
    if user_id then

        if inService then
            vRP.addPermission(user_id,"Taxi",false)
            TriggerClientEvent("Notify",source,"amarelo", "Você iniciou o serviço de <b>Taxi</b>.", 5000)
        else
            vRP.removePermission(user_id,"Taxi",false)
            TriggerClientEvent("Notify",source,"amarelo", "Você finalizou o serviço de <b>Taxi</b>.", 5000)
        end

    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentService()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then 
        local payment = math.random(700,900)
        if vRP.computeInvWeight(user_id) + vRP.itemWeightList("dollars")*parseInt(payment) <= vRP.getBackpack(user_id) then
            vRP.upgradeStress(user_id,2)
            vRP.giveInventoryItem(user_id,"dollars",payment,true)
            TriggerClientEvent("sounds:Private",source,'coins',0.5)
        else
            TriggerClientEvent("Notify",source,"vermelho", "<b>Mochila</b> cheia.", 5000, 'negado')
        end
    end
end