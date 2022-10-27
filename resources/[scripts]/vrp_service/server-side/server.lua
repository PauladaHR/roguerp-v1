-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_service",src)
vPLAYER = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Toggle",function(service)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vPLAYER.getHandcuff(source) then
            local identity = vRP.getUserIdentity(user_id)
            local groupWait = vRP.groupWait(service)
            if vRP.hasPermission(user_id,groupWait,false) then
                vRP.updatePermission(user_id,groupWait,service,false)

                Player(source).state[service] = true

                if service == "Police" then
                    TriggerEvent("vrp_blipsystem:serviceEnter",source,identity["name"].." "..identity["name2"],77)

                elseif service == "Paramedic" then
                    TriggerEvent("vrp_blipsystem:serviceEnter",source,identity["name"].." "..identity["name2"],83)
                end

                TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",5000)
                TriggerClientEvent("service:Label",source,service,"Sair de Serviço",5000)
             elseif vRP.hasPermission(user_id,service,false) then
                vRP.updatePermission(user_id,service,groupWait,false)

                Player(source).state[service] = false

                TriggerEvent("vrp_blipsystem:serviceExit",source)
                TriggerClientEvent("Notify",source,"amarelo","Você saiu de serviço.",5000)
                TriggerClientEvent("service:Label",source,service,"Entrar de Serviço")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("action",function(source,args,rawCommand)
	local service = "Police"
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if service == "Police" then
			if vRP.hasPermission(user_id,"Police",false) then
                vRP.updatePermission(user_id,"Police","actionPolice",false)
                TriggerEvent("vrp_blipsystem:serviceExit",source)
                TriggerEvent("vrp_blipsystem:serviceEnter",source,identity["name"].." "..identity["name2"],5)
				TriggerClientEvent("Notify",source,"sucesso","Você entrou em Ação.",5000)
			elseif vRP.hasPermission(user_id,"actionPolice",false) then
                vRP.updatePermission(user_id,"actionPolice","Police",false)
                TriggerEvent("vrp_blipsystem:serviceExit",source)
                TriggerEvent("vrp_blipsystem:serviceEnter",source,identity["name"].." "..identity["name2"],77)
				TriggerClientEvent("Notify",source,"amarelo","Você saiu de Ação.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("promover",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
	local nuser_id = args[1]
	if args[1] and args[2] then
		if vRP.hasPermission(user_id,"PolMaster") then
			exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET promotion = ? WHERE user_id = ? AND permiss = ?", { parseInt(args[2]), nuser_id, "Police" })
			TriggerClientEvent("Notify",source,"amarelo", "Promoveu o id <b>"..nuser_id.."</b> para o level <b>"..parseInt(args[2]).."</b> ", 10000)
		
		elseif vRP.hasPermission(user_id,"ParMaster") then
			exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET promotion = ? WHERE user_id = ? AND permiss = ?", { parseInt(args[2]), nuser_id, "Paramedic" })
			TriggerClientEvent("Notify",source,"amarelo", "Promoveu o id <b>"..nuser_id.."</b> para o level <b>"..parseInt(args[2]).."</b> ", 10000)
		
		elseif vRP.hasPermission(user_id,"MecMaster") then
			exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET promotion = ? WHERE user_id = ? AND permiss = ?", { parseInt(args[2]), nuser_id, "Mechanic" })
			TriggerClientEvent("Notify",source,"amarelo", "Promoveu o id <b>"..nuser_id.."</b> para o level <b>"..parseInt(args[2]).."</b> ", 10000)
		
		elseif vRP.hasPermission(user_id,"Mec02Master") then
			exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET promotion = ? WHERE user_id = ? AND permiss = ?", { parseInt(args[2]), nuser_id, "Mechanic02" })
			TriggerClientEvent("Notify",source,"amarelo", "Promoveu o id <b>"..nuser_id.."</b> para o level <b>"..parseInt(args[2]).."</b> ", 10000)
        end

        elseif vRP.hasPermission(user_id,"coolBeansMaster") then
            exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET promotion = ? WHERE user_id = ? AND permiss = ?", { parseInt(args[2]), nuser_id, "coolBeans" })
            TriggerClientEvent("Notify",source,"amarelo", "Promoveu o id <b>"..nuser_id.."</b> para o level <b>"..parseInt(args[2]).."</b> ", 10000)

    elseif vRP.hasPermission(user_id,"catCoffeMaster") then
        exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET promotion = ? WHERE user_id = ? AND permiss = ?", { parseInt(args[2]), nuser_id, "catCoffe" })
        TriggerClientEvent("Notify",source,"amarelo", "Promoveu o id <b>"..nuser_id.."</b> para o level <b>"..parseInt(args[2]).."</b> ", 10000)
		
	else
		TriggerClientEvent("Notify",source,"amarelo","Utilize <b>/promover (PASSAPORTE) (LEVEL)</b>")
	end
end)