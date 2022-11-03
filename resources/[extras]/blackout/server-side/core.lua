local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local BlackoutTimer = os.time()
local BlackoutCooldown = os.time()
GlobalState["Blackout"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGHTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Lights = {
    ["1"] = { ["Coords"] = vec3(2838.7,1502.68,24.72) },
    ["2"] = { ["Coords"] = vec3(2282.27,2963.52,46.74) },
    ["3"] = { ["Coords"] = vec3(751.03,1274.23,360.3) },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackout:MakeBlackout")
AddEventHandler("Blackout:MakeBlackout",function(Number)
	local source = source
	local Passport = vRP.getUserId(source)
	if Passport then
        if Lights[Number] then
            if os.time() < BlackoutCooldown then 
                TriggerClientEvent("Notify",source,"vermelho","O blecaute foi feito recentemente.",5000)
                return
            else
                vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
                TriggerClientEvent("Progress",source,60000)
                Player(source)["state"]["Buttons"] = true
                Player(source)["state"]["Cancel"] = true

                Wait(60000)
                       
                Player(source)["state"]["Buttons"] = false
                Player(source)["state"]["Cancel"] = false
                vRPC.removeObjects(source)

                TriggerClientEvent("Blackout:Status",-1,0)
                TriggerClientEvent("Notify",source,"verde","O blecaute foi reparado.",5000)

                TriggerClientEvent("Notify",source,"verde","Governador: Informamos que o problema com a rede elétrica foi corrigido.",15000)
                return true
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("Blackout:Init",source,Lights)
end)
 -----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZEROBBERYES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blackout",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        TriggerClientEvent("Blackout:Init",-1,Lights)
    end
end)