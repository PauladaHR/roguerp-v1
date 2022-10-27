local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

hRP = {}
Tunnel.bindInterface("vrp_animacoes", hRP)
Proxy.addInterface("vrp_animacoes", hRP)
vCLIENT = Tunnel.getInterface("vrp_animacoes")
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('e',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nplayer = vRPC.nearestPlayer(source,1)	
	if nplayer and not vRPC.inVehicle(nplayer) and not vRPC.getHandcuff(nplayer) and vRPC.getHealth(nplayer) > 101 then
		if args[1] == "beijar" then
			if vRP.request(nplayer,"Animação","Deseja beijar <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,1.2)
				TriggerClientEvent("syncAnimAll",source,"beijar")
				TriggerClientEvent("syncAnimAll",nplayer,"beijar")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o beijo.",3000)
			end
		elseif args[1] == "abracar" then
			if vRP.request(nplayer,"Animação","Deseja abraçar <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,0.8)
				TriggerClientEvent("syncAnimAll",source,"abracar")
				TriggerClientEvent("syncAnimAll",nplayer,"abracar")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o abraço.",3000)
			end
		elseif args[1] == "abracar2" then
			if vRP.request(nplayer,"Animação","Deseja abraçar <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,1.2)
				TriggerClientEvent("syncAnimAll",source,"abracar2")
				TriggerClientEvent("syncAnimAll",nplayer,"abracar2")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o abraço.",3000)
			end
		elseif args[1] == "abracar3" then
			if vRP.request(nplayer,"Animação","Deseja abraçar <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,0.8)
				TriggerClientEvent("syncAnimAll",source,"abracar3")
				TriggerClientEvent("syncAnimAll",nplayer,"abracar3")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o abraço.",3000)
			end
		elseif args[1] == "abracar4" then
			if vRP.request(nplayer,"Animação","Deseja abraçar <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,1.4)
				TriggerClientEvent("syncAnimAll",source,"abracar4")
				TriggerClientEvent("syncAnimAll",nplayer,"abracar4")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o abraço.",3000)
			end
		elseif args[1] == "dancar257" then
			if vRP.request(nplayer,"Animação","Deseja dançar com <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,1.0)
				TriggerClientEvent("syncAnimAll",source,"dancar257")
				TriggerClientEvent("syncAnimAll",nplayer,"dancar257")
				Citizen.Wait(13000)
				vRPC._removeObjects(source,"one")
				vRPC._removeObjects(nplayer,"one")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o dança.",3000)
			end
		elseif args[1] == "dancar258" then
			if vRP.request(nplayer,"Animação","Deseja dançar com <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,1.0)
				TriggerClientEvent("syncAnimAll",source,"dancar258")
				TriggerClientEvent("syncAnimAll",nplayer,"dancar258")
				Citizen.Wait(12000)
				vRPC._removeObjects(source,"one")
				vRPC._removeObjects(nplayer,"one")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o dança.",3000)
			end
		elseif args[1] == "dancar259" then
			if vRP.request(nplayer,"Animação","Deseja dançar com <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,1.0)
				TriggerClientEvent("syncAnimAll",source,"dancar259")
				TriggerClientEvent("syncAnimAll",nplayer,"dancar259")
				Citizen.Wait(11000)
				vRPC._removeObjects(source,"one")
				vRPC._removeObjects(nplayer,"one")
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o dança.",3000)
			end
		elseif args[1] == "casal" then
			if vRP.request(nplayer,"Animação","Deseja casal com <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim",source,0.3)
				TriggerClientEvent("syncAnimAll",source,"casal",1)
				TriggerClientEvent("syncAnimAll",nplayer,"casal",2)
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o casal.",3000)
			end
		elseif args[1] == "casal2" then
			if vRP.request(nplayer,"Animação","Deseja casal com <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim2",source,0.8,-0.1,1)
				TriggerClientEvent("syncAnimAll",source,"casal2",1)
				TriggerClientEvent("syncAnimAll",nplayer,"casal2",2)
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o casal.",3000)
			end
		elseif args[1] == "casal3" then
			if vRP.request(nplayer,"Animação","Deseja casal com <b>"..identity.name.." "..identity.name2.."</b> ?",10) then
				TriggerClientEvent("syncAnim2",source,0.75,-0.1,1)
				TriggerClientEvent("syncAnimAll",source,"casal3",1)
				TriggerClientEvent("syncAnimAll",nplayer,"casal3",2)
			else
				TriggerClientEvent("Notify",source,"vermelho","A pessoa negou o casal.",3000)
			end
		end
	end
	TriggerClientEvent("emotes",source,args[1])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('e2', function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if vRP.hasRank(user_id,"Admin",40) or vRP.hasPermission(user_id,"Paramedic") then
			local nplayer = vRPC.nearestPlayer(source,2)
			if nplayer then
				TriggerClientEvent("emotes",nplayer,args[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /e2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('e3', function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if vRP.hasRank(user_id,"Admin",40) then
			local nplayer = vRPC.nearestPlayers(source,parseInt(args[1]))
			
			for k,v in pairs(nplayer) do
				local nuser_id = vRP.getUserId(k)
				local nsource = vRP.getUserSource(nuser_id)
				async(function()
					TriggerClientEvent("emotes",nsource,args[2])
					TriggerClientEvent("emotes",source,args[2])
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC PARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trySyncParticle")
AddEventHandler("trySyncParticle",function(asset,v)
    TriggerClientEvent("startSyncParticle",-1,asset,v)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOP SYNC PARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryStopParticle")
AddEventHandler("tryStopParticle",function(v)
    TriggerClientEvent("stopSyncParticle",-1,v)
end)