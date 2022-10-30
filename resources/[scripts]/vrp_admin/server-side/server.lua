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
Tunnel.bindInterface("vrp_admin",Hiro)
vCLIENT = Tunnel.getInterface("vrp_admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			if args[1] then
				local nplayer = vRP.getUserSource(parseInt(args[1]))
				local identity2 = vRP.getUserIdentity(parseInt(args[1]))
				if nplayer then
					vRPC.revivePlayer(nplayer,200)
					vRP.upgradeThirst(parseInt(args[1]),100)
					vRP.upgradeHunger(parseInt(args[1]),100)
					vRP.downgradeStress(parseInt(args[1]),100)
					TriggerClientEvent("resetDiagnostic",nplayer)
					TriggerEvent("webhooks","god","```ini\n[============== DEU GOD ==============]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[DEU GOD EM]: "..parseInt(args[1]).." "..identity2.name.." "..identity2.name2.." \n "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","GOD ADMIN")
				end
			else
				vRP.upgradeThirst(user_id,100)
				vRP.upgradeHunger(user_id,100)
				vRP.downgradeStress(user_id,10)
				vRPC.revivePlayer(source,200)
				TriggerClientEvent("resetDiagnostic",source)
				Player(source)["state"]["Commands"] = false
				Player(source)["state"]["Buttons"] = false
				TriggerEvent("webhooks","god","```ini\n[============== USOU GOD ==============]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","GOD ADMIN")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source)
	if source ~= 0 then
		local user_id = vRP.getUserId(source)
		if not vRP.hasRank(user_id,"Admin",40)  then
			return
		end
	end

	local List = vRP.getUsers()
	for Passport,_ in pairs(List) do
		vRP.kick(Passport,"Desconectado, a cidade reiniciou.")
		Wait(100)
	end

	TriggerEvent("admin:KickAll")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("bobsiri",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if vRP.hasPermission(user_id,"Bob") then
			vRP.generateItem(user_id,"Foodsiri",2,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]),true)
			TriggerEvent("webhooks","item","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[SPAWNOU]: "..parseInt(args[2]).." "..tostring(args[1]).." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","ITEM ADMIN")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemid",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local identity2 = vRP.getUserIdentity(parseInt(args[1]))
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			vRP.giveInventoryItem(parseInt(args[1]),tostring(args[2]),parseInt(args[3]),true)
			TriggerClientEvent("Notify",source,"verde","Você enviou " ..args[3].. " do item " ..vRP.itemNameList(args[2]).. " para o ID " ..args[1])
			TriggerEvent("webhooks","item","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[ENVIOU PARA]: "..parseInt(args[1]).." "..identity2.name.." "..identity2.name2.." \n[ITEM]: "..tostring(args[2]).." "..tostring(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","ITEMID ADMIN")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",80) then
			local users = vRP.getUsers()
			for k,v in pairs(users) do
				vRP.giveInventoryItem(parseInt(k),tostring(args[1]),parseInt(args[2]),true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) then
			TriggerEvent("webhooks","noclip"," #"..user_id.." "..identity.name.." "..identity.name2.." | Ativou/Desativou o NoClip","NC")
			vRPC.noClip(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local identity2 = vRP.getUserIdentity(parseInt(args[1]))
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) and parseInt(args[1]) > 0 then
			vRP.kick(parseInt(args[1]),"Você foi expulso da cidade.")
			TriggerEvent("webhooks","kick","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[KICKOU]: "..parseInt(args[1]).." "..identity2.name.." "..identity2.name2.." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","TESTE LOG")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TESTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wanted",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.wantedTimer(user_id,30)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLARE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("flare",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",100) then
			vRPC.giveWeapons(source,{["weapon_flaregun"] = { ammo = 15 }},false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAYPISTOL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("raypistol",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",100) then
			vRPC.giveWeapons(source,{["weapon_raypistol"] = { ammo = 15 }},false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 1 })
				TriggerClientEvent("Notify",source,"verde", "<b>Jogador com ID "..args[1].." Banido</b>", 5000)
			else
				local steam = vRP.getInformation(args[1])
				if steam[1].steam then
					vRP.execute("vRP/set_banned",{ steam = tostring(steam[1].steam), banned = 1 })
					TriggerClientEvent("Notify",source,"verde", "<b>Jogador com ID "..args[1].." Banido</b>", 5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("userhomes",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
            local nuser_id = parseInt(args[1])
            local identity = vRP.getUserIdentity(nuser_id)
				TriggerClientEvent("Notify",source,"verde", "Casas do passaporte: <b>"..nuser_id.." "..identity.name.." "..identity.name2.."</b>", 20000)
            if nuser_id then 
                local homes = vRP.query("vRP/get_homeuserid",{ user_id = parseInt(nuser_id) })
                for k,v in pairs(homes) do
					TriggerClientEvent("Notify",source,"verde", "<b>Casa:</b> "..tostring(v.home)"", 20000)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remhomes",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasRank(user_id,"Admin",60) then
		if args[1] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Casas","Deseja remover a casa <b>"..args[1].."</b> ?",30) then
				TriggerEvent("vrp_garages:removeGarages",tostring(args[1]))
				vRP.execute("vRP/rem_allpermissions",{ home = tostring(args[1]) })
				vRP.execute("vRP/rem_srv_data",{ dkey = "homesChest:"..tostring(args[1]) })
				vRP.execute("vRP/rem_srv_data",{ dkey = "homesFridge:"..tostring(args[1]) })
				vRP.execute("vRP/rem_srv_data",{ dkey = "wardrobe:"..tostring(args[1]) })
				TriggerClientEvent("Notify",source,"verde", "Você removeu a casa <b>"..args[1].."</b>.", 5000)
                SendWebhookMessage(webhookviphomes,"```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[REMOVEU]: "..tostring(args[1]).." \n[DO ID]: "..parseInt(args[2]).." "..identity2.name.." "..identity2.name2.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("uservehs",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
        	local nuser_id = parseInt(args[1])
            if nuser_id > 0 then 
                local vehicle = vRP.query("vRP/get_vehicle",{ user_id = parseInt(nuser_id) })
                local car_names = {}
                for k,v in pairs(vehicle) do
                	table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b>")
                end
                car_names = table.concat(car_names, ", ")
                local identity = vRP.getUserIdentity(nuser_id)
				TriggerClientEvent("Notify",source,"amarelo", "Veículos de <b>"..identity.name.." " .. identity.name2.. " ("..#vehicle..")</b>: "..car_names, 5000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remvehs",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasRank(user_id,"Admin",80) then
		if args[1] and args[2] then
            local nuser_id = vRP.getUserId(parseInt(args[2]))
			local identity2 = vRP.getUserIdentity(parseInt(args[2]))
			if vRP.request(source,"Casas","Deseja retirar o veículo <b>"..vRP.vehicleName(args[1]).."</b> do Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.name2.."</b> ?",30) then
				vRP.execute("vRP/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1]  }) 
				TriggerClientEvent("Notify",source,"verde", "Voce removeu o veículo <b>"..vRP.vehicleName(args[1]).."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.", 5000)
				TriggerClientEvent("Notify",nuser_id,"vermelho", "O veículo <b>"..vRP.vehicleName(args[1]).."</b> foi removido da sua garagem.", 5000)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addvehs",function(source,args)
    local user_id = vRP.getUserId(source)
	if vRP.hasRank(user_id,"Admin",80) then
        if args[1] and args[2] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            local nuser_id = vRP.getUserId(identity2)
			if vRP.request(source,"Casas","Deseja adicionar o carro <b>"..vRP.vehicleName(args[1]).."</b> para o Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.name2.."</b> ?",30) then
				vRP.execute("vRP/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], plate = vRP.generatePlateNumber(), work = tostring(false) })
				vRP.query("vehicles/updateVehiclesTax",{ user_id = parseInt(user_id), vehicle = args[1], tax = os.time() })
				TriggerClientEvent("Notify",source,"verde", "Voce adicionou o veículo <b>"..vRP.vehicleName(args[1]).."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.", 5000)
			end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR NOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rename",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)

	TriggerClientEvent("vrp_dynamic:closeSystem",source)

	if vRP.hasRank(user_id,"Admin",40) then
        local idjogador = vRP.prompt(source, "Qual id do jogador?", "")
        local name = vRP.prompt(source, "Novo nome", "")
        local name2 = vRP.prompt(source, "Novo sobrenome", "")
		vRP.execute("vRP/update_name",{ id = parseInt(idjogador), name = name, name2 = name2 })
		TriggerClientEvent("Notify",source,"verde", "Você alterou o nome do passaporte: <b>"..parseInt(idjogador).."</b> para <b>"..name.." "..name2.."</b>.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAR CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearchest",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	if vRP.hasRank(user_id,"Admin",60) then
        if args[1] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Casas","Deseja limpar o baú <b>"..args[1].."</b> ?",30) then
                vRP.execute("vRP/rem_srv_data",{ dkey = "chest:"..tostring(args[1]) })
				TriggerClientEvent("Notify",source,"verde", "Você limpou o baú <b>"..args[1].."</b>.", 5000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("uncuff",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
	if vRP.hasRank(user_id,"Admin",40) then
			TriggerClientEvent("resetHandcuff",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNCAPUZ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("uncapuz",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) or vRP.hasPermission(user_id,"Police") then
			TriggerClientEvent("hud:toggleHood",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNCORDA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("uncorda",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPC.nearestPlayer(source,2)
	if user_id then
	if vRP.hasRank(user_id,"Admin",40) then
			TriggerClientEvent("vrp_rope:toggleRope",nplayer,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
	if vRP.hasRank(user_id,"Admin",40) then
			vRP.execute("vRP/set_whitelist",{ steam = tostring(args[1]), whitelist = 1 })
			TriggerClientEvent("Notify",source,"verde","Você aprovou a wl da hex "  ..args[1],5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unwl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.execute("vRP/set_whitelist",{ steam = tostring(identity.steam), whitelist = 0 })
				TriggerClientEvent("Notify",source,"verde","Você retirou a wl da hex "  ..args[1],5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 0 })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			local fcoords = vRP.prompt(source,"Coordinates:","")
			if fcoords == "" then
				return
			end
			
			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end
			vRPC.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) then
			local x,y,z = vRPC.getPositions(source)
			vRP.prompt(source,"Coordinates:",x..","..y..","..z)
		end
	end
end)

RegisterCommand("cdsh",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) then
			local x,y,z,h = vRPC.getPositions(source)
			vRP.prompt(source,"Coordinates:",x..","..y..","..z..","..h)
		end
	end
end)

RegisterCommand("cds2",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) then
			local x,y,z,h = vRPC.getPositions(source)
			vRP.prompt(source,"Coordinates:","['x'] = "..x..", ['y'] = "..y..", ['z'] = "..z)
		end
	end
end)

RegisterCommand("cds3",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) then
			local x,y,z,h = vRPC.getPositions(source)
			vRP.prompt(source,"Cordenadas:","x = "..x..", y = "..y..", z = "..z)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
local codeGroup = {
	[200] = {"warn","Esse passaporte já faz parte deste grupo."},
	[300] = {"error","Este grupo atingiu o limite de pessoas."},
	[400] = {"error","Esse passaporte não pode ser contratado no momento."},
	[800] = {"success","Contratação efetuada com sucesso."}
}

RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local nidentity = vRP.getUserIdentity(parseInt(args[1]))
		if nidentity then
			if vRP.hasRank(user_id,"Admin",60) or vRP.hasPermission(user_id,vRP.groupMaster(tostring(args[2])),false) then
				if vRP.groupName(tostring(args[2])) ~= "" then
					local addPermiss = vRP.addPermission(parseInt(args[1]),tostring(args[2]),true)
					if codeGroup[addPermiss["code"]] then
						TriggerClientEvent("Notify",source,codeGroup[addPermiss["code"]][1],codeGroup[addPermiss["code"]][2],10000)
					else
						TriggerClientEvent("Notify",source,"amarelo","Entre em contato com algum desenvolvedor, erro incomum.",10000)
					end
				else
					if vRP.hasRank(user_id,"Admin",80) then
						local addPermiss = vRP.addPermission(parseInt(args[1]),tostring(args[2]),true)
						TriggerClientEvent("Notify",source,codeGroup[addPermiss["code"]][1],codeGroup[addPermiss["code"]][2],10000)
					end
				end
			end
			TriggerEvent("webhooks","group","```prolog\n[ID]: "..user_id.."\n[SETOUGRUPO]: "..args[2].." \n[PASSAPORTE]: "..parseInt(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
local remCodeGroup = {
	[200] = {"negado","Esse passaporte não faz parte desse grupo."},
	[800] = {"sucesso","Grupo retirado com sucesso."}
}

RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) or vRP.hasPermission(user_id,vRP.groupMaster(tostring(args[2])),false) then
			local remPermiss = vRP.removePermission(parseInt(args[1]),tostring(args[2]),true)
			if remPermiss and remCodeGroup[remPermiss["code"]] then
				TriggerClientEvent("Notify",source,remCodeGroup[remPermiss["code"]][1],remCodeGroup[remPermiss["code"]][2],10000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Entre em contato com algum desenvolvedor, erro incomum.",10000)
			end
		end
		TriggerEvent("webhooks","ungroup","```prolog\n[ID]: "..user_id.."\n[RETIROUGRUPO]: "..args[2].." \n[PASSAPORTE]: "..parseInt(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MASTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("master",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			if vRP.groupMaster(tostring(args[2])) ~= "" then
				local addPermiss = vRP.addPermission(parseInt(args[1]),tostring(vRP.groupMaster(tostring(args[2]))),true)
				if codeGroup[addPermiss["code"]] then
					TriggerClientEvent("Notify",source,codeGroup[addPermiss["code"]][1],codeGroup[addPermiss["code"]][2],10000)
				else
					TriggerClientEvent("Notify",source,"amarelo","Entre em contato com algum desenvolvedor, erro incomum.",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNMASTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unmaster",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			if vRP.hasPermission(parseInt(args[1]),vRP.groupMaster(tostring(args[2])),true) then
				local remPermiss = vRP.removePermission(parseInt(args[1]),tostring(vRP.groupMaster(tostring(args[2]))),true)
				if remCodeGroup[remPermiss["code"]] then
					TriggerClientEvent("Notify",source,remCodeGroup[remPermiss["code"]][1],remCodeGroup[remPermiss["code"]][2],10000)
				else
					TriggerClientEvent("Notify",source,"amarelo","Entre em contato com algum desenvolvedor, erro incomum.",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBLACKLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unblacklist",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			local nidentity = vRP.getUserIdentity(parseInt(args[1]))
			if nidentity then

				local checkBlacklist = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions_blacklist` WHERE user_id = ?", { parseInt(args[1])})
				if checkBlacklist[1] then
					exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions_blacklist` WHERE user_id = ?",{ parseInt(args[1])})
					TriggerClientEvent("Notify",source,"verde","Você limpou o ID: "..args[1].." com sucesso da blacklist.",8000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEEGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seegroups",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			local permp = exports["oxmysql"]:executeSync("SELECT `permiss` FROM `vrp_permissions` WHERE `user_id` = ?",{ parseInt(args[1] )})
			local permissione = ""
			for i=1,#permp do
				permissione = permissione.." "..tostring(permp[i].permiss)..","
			end
			TriggerClientEvent("Notify",source,"amarelo","O ID: <b>"..args[1].."</b> está setado nos seguintes grupos: "..permissione,8000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("verify",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) or vRP.hasPermission(user_id,vRP.groupMaster(tostring(args[1])),false) then

			local onSet = ""
			local service = vRP.numPermission(tostring(args[1]),true)
			for k,v in pairs(service) do
				if v["user_id"] then
					local identity = vRP.getUserIdentity(v["user_id"])

					onSet = onSet.."<b>#</b>"..parseFormat(v["user_id"]).." "..identity["name"].." "..identity["name2"].."<br>"
				end
			end

			TriggerClientEvent("Notify",source,"verde","Atualmente <b>"..#service.." "..vRP.groupName(tostring(args[1])).."</b> registrados.<br> "..onSet,15000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONDUTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("onduty",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) or vRP.hasPermission(user_id,vRP.groupMaster(tostring(args[1])),false) then

			local onDuty = ""
			local service = vRP.numPermission(tostring(args[1]),false)
			for k,v in pairs(service) do
				if v then
					local nuser_id = vRP.getUserId(v)
					local identity = vRP.getUserIdentity(nuser_id)

					onDuty = onDuty.."<b>#</b>"..parseFormat(nuser_id).." "..identity["name"].." "..identity["name2"].."<br>"
				end
			end

			TriggerClientEvent("Notify",source,"verde","Atualmente <b>"..#service.." "..vRP.groupName(tostring(args[1])).."</b> em serviço.<br> "..onDuty,15000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("changerank",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",100) then
			local nidentity = vRP.getUserIdentity(parseInt(args[1]))
			if nidentity then
				exports["oxmysql"]:executeSync("UPDATE `vrp_infos` SET `rank` = ? WHERE `steam` = ?",{ tostring(args[2]),nidentity["steam"] })
				TriggerClientEvent("Notify",source,"verde","Você adicionou o ID <b>"..parseFormat(args[1]).."</b> no rank <b>"..args[2].."</b> com sucesso.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
local levelAdmin = {
	["Support"] = 20,
	["Moderator"] = 40,
	["Admin"] = 60,
	["Coord"] = 80,
	["Owner"] = 100,
}

RegisterCommand("admin",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",80) then
			local nuser_id = parseInt(args[1])
			local nidentity = vRP.getUserIdentity(nuser_id)
			if nidentity then
				if levelAdmin[args[2]] then
					exports["oxmysql"]:executeSync("UPDATE vrp_infos SET rank = ?, rankLevel = ? WHERE steam = ?",{ "Admin",parseInt(levelAdmin[args[2]]),nidentity["steam"] })
					TriggerClientEvent("Notify",source,"verde","Você adicionou o ID <b>"..parseFormat(args[1]).."</b> no rank <b>"..args[2].."</b> com sucesso.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gems",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",100) and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.execute("vRP/update_gems",{ steam = tostring(identity.steam), gems = parseInt(args[2]) })
				TriggerClientEvent("Notify",source,"verde", "Gemas entregues com sucesso.", 5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPC.teleport(nplayer,vRPC.getPositions(source))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPC.teleport(source,vRPC.getPositions(nplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptoid",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			local nplayerid = vRP.getUserSource(parseInt(args[2]))
			if nplayer then
				vRPC.teleport(nplayer,vRPC.getPositions(nplayerid))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			vCLIENT.teleportWay(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) <= 101 then
			vCLIENT.teleportLimbo(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",20) then
			local vehicle = vRPC.getNearVehicle(source,7)
			if vehicle then
				vCLIENT.vehicleHash(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delnpcs",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			vCLIENT.deleteNpcs(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",80) then
			TriggerClientEvent("vrp_admin:vehicleTuning",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPC.getPositions(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
			if vehicle then
				TriggerClientEvent("inventory:repairAdmin",-1,vehNet,vehPlate)
				TriggerEvent("webhooks","fix","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[REPAROU]: "..vehName.." \n[COORDS]: "..x..","..y..","..z..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","FIX - ADMIN")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cleararea",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		if vRP.hasRank(user_id,"Admin",60) then
			local x,y,z = vRPC.getPositions(source)
			TriggerClientEvent("syncarea",-1,x,y,z,100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pon",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		if vRP.hasRank(user_id,"Admin",20) then
			local users = vRP.getUsers()
			local players = ""
			local quantidade = 0
			for k,v in pairsByKeys(users) do
				if k ~= #users then
					players = players
				end
				players = players.." "..k
				quantidade = quantidade + 1
			end

			TriggerClientEvent("Notify",source,"amarelo", "<b>Players Conectados:</b> "..quantidade, 5000)
			TriggerClientEvent("Notify",source,"amarelo", "<b>ID's Conectados:</b> "..players, 15000)
		end
	end
end)

function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do 
		table.insert(a, n) 
	end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then 
			return nil
		else 
			return a[i], t[a[i]]
		end
	end
	return iter
end
-------------------------------------------------------------------------------------------------------------------------------------------
---- CDS
-------------------------------------------------------------------------------------------------------------------------------------------
--function Hiro.buttonTxt()
--	local source = source
--	local user_id = vRP.getUserId(source)
--	if user_id then
--		if vRP.hasRank(user_id,"Admin",40) then
--			local x,y,z,h = vRPC.getPositions(source)
--			vRP.updateTxt("teste.txt",x..","..y..","..z..","..h)
--		end
--	end
--end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS VRP_RACE
-----------------------------------------------------------------------------------------------------------------------------------------
-- local numbers = 0	
-- local locs = {}

-- function Hiro.buttonTxt3()
-- 	local source = source
-- 	local user_id = vRP.getUserId(source)
-- 	if user_id then
-- 		if vRP.hasRank(user_id,"Admin",40) then
-- 			local x,y,z,h = vRPC.getPositions(source)
			
-- 			numbers = numbers + 1
-- 			locs = " ["..numbers.."] = { "..x..","..y..","..z..","..h.." }," 
-- 			vRP.updateTxt("Tabaco.txt",locs)
-- 		end
-- 	end
-- end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TXTENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.TxtEntity(m,c,r,h)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasRank(user_id,'Admin',60) then
		vRP.Archive('entity.lua','Model: '..m)
		vRP.Archive('entity.lua','Coords: '..mathLegth(c.x)..','..mathLegth(c.y)..','..mathLegth(c.z))
		vRP.Archive('entity.lua','Rotation: '..mathLegth(r.x)..','..mathLegth(r.y)..','..mathLegth(r.z))
		vRP.Archive('entity.lua','Heading: '..mathLegth(h)..'\n')
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		if vRP.hasRank(user_id,"Admin",40) then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end

			TriggerClientEvent("smartphone:createSMS",-1,"Governador",message)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anuncio",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasRank(user_id,"Admin",40) or vRP.hasPermission(user_id,{"Police","Paramedic","Mechanic","catCoffe","coolBeans","weedStore","Pearls"},true) then
            local message = vRP.prompt(source,"Mensagem:","")
            if message == "" then
                return
            end

            local name = vRP.prompt(source,"Nome:","")
            if name == "" then
                return
            end

            TriggerClientEvent("Notify",-1,"azul",message.."<br><br><b>Mensagem enviada por: </b>"..name,10000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("prop",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			TriggerClientEvent("vrp_admin:createProp",source,tostring(args[1]))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('apagao',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        if vRP.hasRank(user_id,"Admin",20) and args[1] ~= nil then
            local cond = tonumber(args[1])
            TriggerClientEvent("cloud:setApagao",-1,cond)     
			TriggerClientEvent("sounds:Private",-1,"warning",0.4)               
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then
			if parseInt(args[1]) > 0 then
				TriggerClientEvent("vrp_admin:clearInventory",parseInt(args[1]))
			else
				TriggerClientEvent("vrp_admin:clearInventory",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("idp",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,{"Police","actionPolice","Paramedic"}) or vRP.hasRank(user_id,"Admin",20) then
			if parseInt(args[1]) > 0 then
				local nuser_id = parseInt(args[1])
				local identity = vRP.getUserIdentity(nuser_id)
				if identity then
					local fines = 0
					local consult = vRP.getFines(nuser_id)
					for k,v in pairs(consult) do
						fines = parseInt(fines) + parseInt(v.price)
					end

					TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..identity.id.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone.."<br><b>Multas Pendentes:</b> $"..vRP.format(parseInt(fines)), 2000)
				end
			else
				local nplayer = vRPC.nearestPlayer(source,2)
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id then
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local fines = 0
							local consult = vRP.getFines(nuser_id)
							for k,v in pairs(consult) do
								fines = parseInt(fines) + parseInt(v.price)
							end

							TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..identity.id.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone.."<br><b>Multas Pendentes:</b> $"..vRP.format(parseInt(fines)), 2000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('callback',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasRank(user_id,"Admin",20) then
        if args[1] then
        	local id = vRP.getUserSource(parseInt(args[1]))
            local mensagem = vRP.prompt(source,"Mensagem:","")
            if mensagem == "" then
                return
            end
            TriggerClientEvent("NotifyAdmCallback",id,identity.name,mensagem)
            TriggerClientEvent("Notify",source,"verde","Callback Enviado ao ID: "..args[1],5000)
        end
    end
end)


RegisterCommand("setstaff", function(source,args,command)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) and not vRP.hasPermission(parseInt(args[1]),"player.blips",true) then
			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"player.blips","",os.time() })
		
			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"player.noclip","",os.time() })

			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"player.teleport","",os.time() })

			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"player.secret","",os.time() })

			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"player.spec","",os.time() })

			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"player.wall","",os.time() })

			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"mqcu.permissao","",os.time() })

			exports["oxmysql"]:executeSync("INSERT INTO vrp_permissions(user_id,permiss,type,hired) VALUES(?,?,?,?)", { parseInt(args[1]),"spec.permissao","",os.time() })

			TriggerClientEvent("Notify",source,"verde","Setado Staff ao ID: "..args[1],5000)
		end
	end
end)

RegisterCommand("remstaff", function(source,args,command)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) then

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"player.blips" })

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"player.noclip" })

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"player.teleport" })
			
			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"player.secret" })

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"player.spec" })

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"player.wall" })

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"mqcu.permissao" })

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ parseInt(args[1]),"spec.permissao" })

			TriggerClientEvent("Notify",source,"verde","Removido Staff ao ID: "..args[1],5000)
		end
	end
end)

vRP.prepare("characters/getVip","SELECT * FROM vrp_users WHERE id = @id")
vRP.prepare("characters/setInitialVip","UPDATE vrp_users SET vipinitial = 0 WHERE id = @id")


RegisterCommand("vipinicial", function(source,args,command)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if not vRP.userPremium(user_id) then
			local vip = vRP.query("characters/getVip",{ id = parseInt(user_id) })
			if vip[1].vipinitial == 1 then
				vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = "vwgolfgti", plate = vRP.generatePlateNumber(), work = tostring(false) })
				vRP.execute("vRP/set_rental_time",{ user_id = parseInt(user_id), vehicle = "vwgolfgti", rental_time = parseInt(os.time()+3*24*60*60) })
				vRP.execute("vRP/set_premium",{ steam = identity["steam"], premium = parseInt(os.time()), predays = 3, priority = 30 })
				vRP.execute("vRP/set_class",{ steam = identity["steam"], class = "Silver" })
				TriggerClientEvent("Notify",source,"verde","Vip Inicial resgatado com sucesso.")
				vRP.execute("characters/setInitialVip", { id = parseInt(user_id) })
			else
				TriggerClientEvent("Notify",source,"vermelho","Você já resgatou o mesmo.")
			end
		end
	end
end)

vRP.prepare("admin/registerVehicle", "INSERT INTO vrp_vehicles (spawn, name, price, class, hash, chestweight) VALUES (@spawn, @name, @price, @class, @hash, @chestweight)")
RegisterCommand('registerveh',function(source)
    local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",80) then
			local vehicle = vRP.prompt(source, "Nome de Spawn", "")
			if vehicle == "" then
				return
			end

			local vehicleName = vRP.prompt(source, "Nome de Exibição", vehicle)
			if vehicleName == "" then
				return
			end

			local hash = vRP.prompt(source, "Hash", GetHashKey(vehicle))
			if hash == "" or parseInt(hash) == 0 then
				return
			end

			local class = vRP.prompt(source, "Classe", "carros")
			if class == "" then
				class = nil
			end

			local price = vRP.prompt(source, "Valor", "1000")
			if price == "" or parseInt(price) == 0 then
				return
			end

			local weight = vRP.prompt(source, "Porta-malas", "50")
			if weight == "" or parseInt(weight) == 0 then
				return
			end

			vRP.execute("admin/registerVehicle", { spawn = vehicle, name = vehicleName, price = price, class = class, hash = hash, chestweight = weight })
			TriggerClientEvent("Notify",source,"sucesso",
				"Registrado<br/><br/>" ..
				"Spawn: <b>" .. vehicle .. "</b><br/>" ..
				"Nome: <b>" .. vehicleName .. "</b><br/>" ..
				"Class: <b>" .. tostring(class) .. "</b><br/>" ..
				"Hash: <b>" .. hash .. "</b><br/>" ..
				"Preço: <b>" .. price .. "</b><br/>" ..
				"Chest: <b>" .. weight .. "kg</b>"
			)
		end
    end
end)