-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
vPLAYER = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
hiro = {}
Tunnel.bindInterface("vrp_mdt",hiro)
vCLIENT = Tunnel.getInterface("vrp_mdt")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 9, texture = 4 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 7, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 22, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 0, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 145, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 1, texture = 3 },
		["tshirt"] = { item = 14, texture = 0 },
		["torso"] = { item = 118, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PRISONCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:prisonClothes")
AddEventHandler("police:prisonClothes",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRPC.getHealth(source) > 101 then
		if vRP.hasPermission(user_id,"Police") then
			local mHash = vRPC.ModelPlayer(entity[1])
			if mHash == "mp_m_freemode_01" or mHash == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",entity[1],preset[mHash])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getInfos(data)
    if data then
        local identity = vRP.getUserIdentity(data)
        local fines = 0
        local consult = vRP.getFines(data)
		if identity then
			for k,v in pairs(consult) do
				fines = parseInt(fines) + parseInt(v["price"])
			end
			return parseInt(data),identity["name"],identity["name2"],parseInt(identity["bank"]),identity["phone"],identity["registration"],parseInt(fines),parseInt(identity["weaponport"])
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFEMININO
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getGenero(user_id)
    local dataTable = vRP.getUData(user_id, "Datatable")
	local result = json.decode(dataTable) or {}
    return (result["skin"] and result["skin"] == -1667301416) and "Feminino" or "Masculino"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.checkPermission()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"ActionPolice") then
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.checkPermission2()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"PolMaster") then
            return true,1
        end
    end
    return false,0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET ARRESTS
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getArrests(user)
	local source = source
	if user then
		local data = vRP.query("vRP/get_mdt_type_user",{ user_id = user, type = "arrest" })
		local arrest = {}
		if data then
			for k,v in pairs(data) do
				local identity2 = vRP.getUserIdentity(v.user_id)
				if identity2 then
					local identity = vRP.getUserIdentity(v.officer)
					table.insert(arrest,{ officer = tostring(identity["name"].." "..identity["name2"]), date = v["date"], fine = parseInt(v["fine"]), prison = parseInt(v["prison"]), text = v["text"] })
				end
			end
			return arrest
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET FINES
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getFines(user)
	local source = source
	if user then
		local data = vRP.query("vRP/get_mdt_type_user",{ user_id = user, type = "fines" })
		local fine = {}
		if data then
			for k,v in pairs(data) do
				local identity2 = vRP.getUserIdentity(v.user_id)
				if identity2 then
					local identity = vRP.getUserIdentity(v["officer"])
					table.insert(fine,{ officer = tostring(identity["name"].." "..identity["name2"]), date = v["date"], fine = parseInt(v["fine"]), text = v["text"] })
				end
			end
			return fine
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getOccurrence()
	local source = source
	local data = vRP.query("vRP/get_mdt_type",{ type = "occurrence" })
	local occurrence = {}
	if data then
		for k,v in pairs(data) do
			local identity2 = vRP.getUserIdentity(v.user_id)
			local identity = vRP.getUserIdentity(v.officer)
			table.insert(occurrence,{ user_id = tostring(identity2["name"].." "..identity2["name2"]), number = tostring(identity2["phone"]), officer = tostring(identity["name"].." "..identity["name2"]), date = v["date"], text = v["text"] })
		end
		return occurrence
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getVehs(user)
    local source = source
    if user then
        local data = vRP.query("vRP/get_vehicle",{ user_id = parseInt(user) })
        local vehs = {}
        if data then
            for k,v in pairs(data) do
                if v.arrest == 1 then
                    arresttext = "Apreendido"
                else
                    arresttext = "Não Apreendido"
                end

                if vRP.vehicleClass(tostring(v["vehicle"])) == "cars" or vRP.vehicleClass(tostring(v["vehicle"])) == "bikes" or vRP.vehicleClass(tostring(v["vehicle"])) == "rental" or vRP.vehicleClass(tostring(v["vehicle"])) == "donate" then
                    table.insert(vehs,{ vehicle = vRP.vehicleName(v["vehicle"]), plate = tostring(v["plate"]), arrest = arresttext })
                end
            end
            return vehs
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getHomes(user)
	local source = source
	if user then
		local data = vRP.query("vRP/homeUserList",{ user_id = parseInt(user) })
		local homes = {}
		if data then
			for k,v in pairs(data) do
				table.insert(homes,{ homes = tostring(v["home"]) })
			end
			return homes
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.occurrenceUser(user,text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(parseInt(user))
		local identity2 = vRP.getUserIdentity(parseInt(user_id))
		if identity then
			vRP.execute("vRP/add_mdt",{ user_id = user, officer = tostring(user_id), type = "occurrence", fine = 0, prison = 0, date = os.date("%d/%m/%Y ás %H:%M:%S"), text = tostring(text) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"amarelo","Ocorrência de <b>"..identity["name"].." "..identity["name2"].."</b> registrada com sucesso.",10000, 'info')
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.weaponPortUser(nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		local nidentity = vRP.getUserIdentity(nuser_id)

		if nidentity["weaponport"] == 0 then
			vRP.execute("vRP/add_weaponport",{ id = parseInt(nuser_id) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"amarelo","Porte de armas de <b>"..identity["name"].." "..identity["name2"].."</b> retirado com sucesso.",10000, 'info')
		else
			vRP.execute("vRP/rem_weaponport",{ id = parseInt(nuser_id) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"amarelo","Porte de armas de <b>"..identity["name"].." "..identity["name2"].."</b> retirado com sucesso.",10000, 'info')
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET FINES
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.fineUser(user,price,text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(parseInt(user))
		local identity2 = vRP.getUserIdentity(parseInt(user_id))
		if identity then
			vRP.setFines(parseInt(user),parseInt(price),parseInt(user_id),tostring(text))

			vRP.execute("vRP/add_mdt",{ user_id = user, officer = tostring(user_id), type = "fines", fine = parseInt(price), prison = 0, date = os.date("%d/%m/%Y ás %H:%M:%S"), text = tostring(text) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"amarelo","Multa aplicada em <b>"..identity["name"].." "..identity["name2"].."</b> no valor de <b>$"..parseFormat(price).." dólares</b>.",10000, 'info')
			TriggerEvent("webhooks","multas","```ini\n[============== MULTAS ==============]\n[OFICIAL]: "..user_id.." "..identity2["name"].." "..identity2["name2"].."\n\n[MULTOU]: "..parseInt(user).." "..identity["name"].." "..identity["name2"].."\n[VALOR]: $"..parseFormat(price).."\n[MOTIVO]: "..text.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Multas")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.prisonUser(user,services,price,text)
    local source = source
    local user_id = vRP.getUserId(source)
    if user then

		local nplayer = vRP.getUserSource(parseInt(user))
		if nplayer then
			if vPLAYER.getHandcuff(nplayer) then
				vPLAYER.toggleHandcuff(nplayer)
				vRPC._stopAnim(nplayer,false)
			end
			vCLIENT.startPrison(nplayer,parseInt(1))
			vRPC.teleport(nplayer,1677.72,2509.68,45.57)
		end

        vRP.setFines(parseInt(user),parseInt(price),parseInt(user_id),tostring(text))
        vRP.execute("vRP/set_prison",{ user_id = parseInt(user), prison = parseInt(services), locate = 1 })
        vRP.execute("vRP/add_mdt",{ user_id = parseInt(user), officer = tostring(user_id), type = "arrest", fine = parseInt(price), prison = parseInt(services), date = os.date("%d.%m.%Y %H:%M:%S"), text = tostring(text) })

        local identity = vRP.getUserIdentity(parseInt(user))
		local oficial = vRP.getUserIdentity(parseInt(user_id))
        if identity then
			TriggerClientEvent("Notify",source,"verde","<b>"..identity.name.." "..identity.name2.."</b> enviado para a prisão <b>"..parseInt(services).." serviços</b>.",10000, 'success')
        	TriggerEvent("webhooks","prender","```ini\n[============== PRENDER ==============]\n[OFICIAL]: "..user_id.." "..oficial.name.." "..oficial.name2.."\n\n[PRENDEU]: "..parseInt(user).." "..identity.name.." "..identity.name2.."\n[MULTA]: $"..parseFormat(price).."\n[SERVIÇOS]: "..parseInt(services).." \n[MOTIVO]: "..text.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","PRISÃO")
		end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEL PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.delPrisonUser(user,services)
	local source = source
	local user_id = vRP.getUserId(source)
	if user then
		local consult = vRP.getInformation(parseInt(user))
		if parseInt(consult[1].prison) <= parseInt(services) then
			vRP.execute("vRP/fix_prison",{ user_id = parseInt(user) })
		else
			vRP.execute("vRP/rem_prison",{ user_id = parseInt(user), prison = parseInt(services) })
		end

		local identity = vRP.getUserIdentity(parseInt(user))
		if identity then
			TriggerClientEvent("Notify",source,"verde","<b>"..identity.name.." "..identity.name2.."</b> teve sua pena reduzida em <b>"..parseInt(services).."</b> serviços</b>.",10000, 'sucess')
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rprender",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasRank(user_id,"Admin",60) then
			local nuser_id = vRP.prompt(source,"Passaporte da pessoa:","")
			if nuser_id == "" then
				return
			end

			local services = vRP.prompt(source,"Serviços que a pessoa precisa fazer:","")
			if services == "" then
				return
			end

			local consult = vRP.getInformation(parseInt(nuser_id))
			if parseInt(consult[1].prison) <= parseInt(services) then
				vRP.execute("vRP/fix_prison",{ user_id = parseInt(nuser_id) })
			else
				vRP.execute("vRP/rem_prison",{ user_id = parseInt(nuser_id), prison = parseInt(services) })
			end

			local identity = vRP.getUserIdentity(parseInt(nuser_id))
			if identity then
				TriggerClientEvent("Notify",source,"azul","<b>"..identity.name.." "..identity.name2.."</b> teve sua pena reduzida em <b>"..parseInt(services).."</b> serviços</b>.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESLIGAR MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.desligarUser(user)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user)
	if user_id then
		vRP.execute("vRP/del_group",{ user_id = parseInt(user), permiss = "waitPolice" })
		vRP.execute("vRP/del_group",{ user_id = parseInt(user), permiss = "Police" })
		vRP.execute("vRP/del_group",{ user_id = parseInt(user), permiss = "ActionPolice" })
		vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify",source,"verde","Você demitiu <b>"..identity["name"].." "..identity["name2"].."</b> do grupo de <b>Oficiais</b>.",5000)
		TriggerClientEvent("vrp_mdt:Update",source,"functionFuncionario")	
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET SERVIÇO
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.getWorker()
	local service = vRP.numPermission("Police")
	local notservice = vRP.numPermission("waitPolice")
	local nonDuty = 0
	local resultservice = {}

	for k,v in pairs(service) do
		if v.user_id then
			local identity = vRP.getUserIdentity(v.user_id)

			table.insert(resultservice,{ name = tostring(identity["name"].." "..identity["name2"]), user_id = parseInt(v["user_id"]) })
			nonDuty = nonDuty + 1
		end
	end
	for k,v in pairs(notservice) do
		if v.user_id then
			local identity = vRP.getUserIdentity(v.user_id)

			table.insert(resultservice,{ name = tostring(identity["name"].." "..identity["name2"]), user_id = parseInt(v["user_id"]) })
			nonDuty = nonDuty + 1
		end
	end
	return resultservice,nonDuty
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTRATAR MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.contractPolice(passport)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(passport)
	if user_id then
        if not vRP.hasPermission(passport,"Police") then
			if not vRP.hasPermission(passport,"waitPolice") then
				vRP.execute("vRP/add_group",{ user_id = parseInt(passport), permiss = "waitPolice" })
				vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent("Notify",source,"amarelo","Você contratou <b>"..identity["name"].." "..identity["name2"].."</b> para o grupo de <b>Police</b>.",5000, 'info')
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>"..identity["name"].." "..identity["name2"].."</b> já faz parte do grupo de <b>Police</b>.",5000, 'error')
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","<b>"..identity["name"].." "..identity["name2"].."</b> já faz parte do grupo de <b>Police</b>.",5000, 'error')
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.anuncioPolice(text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/add_usermedic",{ user_id = user_id, type = "announcePolice", text = tostring(text), date = os.date("%d/%m/%Y ás %H:%M:%S") })
		local amountParamedic = vRP.numPermission("Police")
		for k,v in pairs(amountParamedic) do
			async(function()
				TriggerClientEvent("Notify",v,"amarelo","Anúncio da High Command",10000, 'warning')
				vRPC.playSound(v,"Enter_Area","DLC_Lowrider_Relay_Race_Sounds")
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.requestAnnounce()
	local data = vRP.query("vRP/get_allmedic",{ type = "announcePolice" })
	local announce = {}

	for k,v in pairs(data) do 
		local identity = vRP.getUserIdentity(v["user_id"])
		table.insert(announce,{ table = v["id"], medic = tostring(identity["name"].." "..identity["name2"]), date = v["date"], text = v["text"] })
	end
	return announce
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEL ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.delAnnounce(table)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/del_usermedic",{ id = table })
		TriggerClientEvent("mdt:Update",source,"functionAnnounce")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK-KEY
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.checkKey()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.tryGetInventoryItem(user_id,"key",1) then
            vCLIENT.stopPrison(source)
            vRP.execute("vRP/resgate_prison",{ user_id = parseInt(user_id) })
			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "prison:administrative", value = "" })
            return true
		else
			TriggerClientEvent("Notify",source,"vermelho","Você não tem uma <b>Chaves</b>.",3000, 'error')
        end
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVE-KEY
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.giveKey()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.giveInventoryItem(user_id,"key",1,true) then
			return true
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.checkCops()
	local source = source

	local copAmount = vRP.numPermission("Police")
	if #copAmount < 1 then
		TriggerClientEvent("Notify",source,"negado","Quantidade de policiais insuficiente!")
		return false
	end
	return true
end

function hiro.callPolice()
	local source = source

	local copAmount = vRP.numPermission("Police")
	local x,y,z = vRPC.getPositions(source)
	for k,v in pairs(copAmount) do
		async(function()
		 	TriggerClientEvent("Notify",v,"amarelo","Encontramos um fugitivo do presídio.",5000, 'info')
		end)
	end

	TriggerClientEvent("Notify",source,"aviso","Os policiais foram notificados sobre sua fuga! Sua <b>tornozeleira eletrônica</b> continuará a transmissão por <b>180 segundos</b>, informando sua localização", 30000)
	startFugitiveThread(source)
end


function startFugitiveThread(player)
	Wait(10000)
	Citizen.CreateThread(function()
		local fugitiveTime = 240
		while fugitiveTime > 0 do
			if fugitiveTime % 30 == 0 then
				local x,y,z = vRPC.getPositions(player)
				local copAmount = vRP.numPermission("Police")
				for k, v in pairs(copAmount) do
					async(function()
						TriggerClientEvent("prison:fugitive:setArea", v, x, y, z)
						vRPC.playSound(v,"Event_Message_Purple","GTAO_FM_Events_Soundset")
					end)
				end
			end
			fugitiveTime = fugitiveTime - 1
			Wait(1000)
		end
	end)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.reducePrison()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/rem_prison",{ user_id = parseInt(user_id), prison = 2 })

		local consult = vRP.getInformation(user_id)
		if parseInt(consult[1].prison) <= 0 then
			vCLIENT.stopPrison(source)
			vRPC.teleport(source,1849.24,2586.12,45.68)
			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "prison:administrative", value = "" })
		else
			local udata = vRP.getUData(user_id, "prison:administrative")
			local administrative = false
			if udata and udata ~= "" then
				administrative = true
			end
			
			vCLIENT.startPrison(source,parseInt(consult[1]["locate"]),administrative)
			TriggerClientEvent("Notify",source,"azul","Você ainda tem <b>"..parseInt(consult[1].prison).." serviços</b>.",5000)
		end
	end
end

function hiro.reduceTimePrison()
	local source = source
	local user_id =  vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/rem_prison",{ user_id = parseInt(user_id), prison = 1 })
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	checkForPrison(source, user_id)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANREC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cleanrec",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasPermission(user_id,{"PolMaster","Juridico"}) or vRP.hasRank(user_id,"Admin",80) then
			local nuser_id = parseInt(args[1])
			if nuser_id > 0 then
				vRP.execute("vRP/cleanRecords",{ nuser_id = nuser_id })
				TriggerClientEvent("Notify",source,"verde","Limpeza efetuada.",5000)
			end
		end
	end
end)



RegisterCommand("punicao", function(source)
	local user_id = vRP.getUserId(source)
	if vRP.hasRank(user_id,"Admin",80) then
		local uid = vRP.prompt(source, 'Usuário que será punido', '')
		if uid == "" or not tonumber(uid) then return end
		uid = parseInt(uid)

		local services = vRP.prompt(source, 'Qual a quantidade de serviços?', '')
		if services == "" or not tonumber(services) then return end
		services = parseInt(services)

		local nplayer = vRP.getUserSource(uid)
		if nplayer then
			vCLIENT.startPrison(nplayer, 1, true)
			vRPC.teleport(nplayer,1677.72,2509.68,45.57)
		end
		vRP.execute("vRP/set_prison",{ user_id = uid, prison = services, locate = 1 })
		
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "prison:administrative", value = "true" })
	end
end)

function checkForPrison(player)
	local user_id = vRP.getUserId(player)
	local consult = vRP.getInformation(user_id)
	if parseInt(consult[1].prison) > 0 then
		local udata = vRP.getUData(user_id, "prison:administrative")
		local administrative = false
		if udata and udata ~= "" then
			administrative = true
		end

		TriggerClientEvent("Notify",player,"amarelo","Você ainda tem <b>"..parseInt(consult[1].prison).." serviços</b>.",5000, 'warning')
		vCLIENT.startPrison(player,parseInt(consult[1]["locate"]), administrative)
		-- vRPC.teleport(player,1677.72,2509.68,45.57)
	end
end

Citizen.CreateThread(function()
	Wait(5000)
	for k, v in pairs(vRP.getUsers()) do
		checkForPrison(v)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATENAME
-----------------------------------------------------------------------------------------------------------------------------------------
local plateName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local plateName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
local plateSave = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('placa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,{"Police","actionPolice"}) then
			if vRPC.getHealth(source) > 101 then
				if args[1] then
					local plateUser = vRP.getVehiclePlate(tostring(args[1]))
					if plateUser then
						local identity = vRP.getUserIdentity(plateUser)
						if identity then
							vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
							TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..identity.id.."<br><b>RG:</b> "..identity.registration.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>Telefone:</b> "..identity.phone, 10000, 'info')
						end
					else
						if not plateSave[string.upper(args[1])] then
							plateSave[string.upper(args[1])] = { math.random(5000,9999),plateName[math.random(#plateName)].." "..plateName2[math.random(#plateName2)],vRP.generatePhoneNumber() }
						end

						vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
						TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..plateSave[args[1]][1].."<br><b>RG:</b> "..string.upper(args[1]).."<br><b>Nome:</b> "..plateSave[args[1]][2].."<br><b>Telefone:</b> "..plateSave[args[1]][3], 10000, 'info')
					end
				else
					local vehicle,vehNet,vehPlate = vRPC.vehList(source,7)
					if vehicle then
						local plateUser = vRP.getVehiclePlate(vehPlate)
						if plateUser then
							local identity = vRP.getUserIdentity(plateUser)
							if identity then
								vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
								TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..identity.id.."<br><b>RG:</b> "..identity.registration.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>Telefone:</b> "..identity.phone, 10000, 'info')
							end
						else
							if not plateSave[vehPlate] then
								plateSave[vehPlate] = { math.random(5000,9999),plateName[math.random(#plateName)].." "..plateName2[math.random(#plateName2)],vRP.generatePhoneNumber() }
							end

							vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
							TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..plateSave[vehPlate][1].."<br><b>RG:</b> "..vehPlate.."<br><b>Nome:</b> "..plateSave[vehPlate][2].."<br><b>Telefone:</b> "..plateSave[vehPlate][3], 10000, 'info')
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:runPlate")
AddEventHandler("police:runPlate",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,{"Police","actionPolice"}) then
			if vRPC.getHealth(source) > 101 then
					local vehicle,vehNet,vehPlate = vRPC.vehList(source,7)
					if vehicle then
						local plateUser = vRP.getVehiclePlate(vehPlate)
						if plateUser then
							local identity = vRP.getUserIdentity(plateUser)
							if identity then
								vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
								TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..identity.id.."<br><b>RG:</b> "..identity.registration.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>Telefone:</b> "..identity.phone, 10000, 'info')
							end
						else
							if not plateSave[vehPlate] then
								plateSave[vehPlate] = { math.random(5000,9999),plateName[math.random(#plateName)].." "..plateName2[math.random(#plateName2)],vRP.generatePhoneNumber() }
							end

						vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
						TriggerClientEvent("Notify",source,"amarelo", "<b>Passaporte:</b> "..plateSave[vehPlate][1].."<br><b>RG:</b> "..vehPlate.."<br><b>Nome:</b> "..plateSave[vehPlate][2].."<br><b>Telefone:</b> "..plateSave[vehPlate][3], 10000, 'info')
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DETIDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:runArrest")
AddEventHandler("police:runArrest",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPC.getPositions(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
				if vehicle then
					local plateUser = vRP.getVehiclePlate(vehPlate)
					local identity2 = vRP.getUserIdentity(plateUser)
					local inVehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(plateUser), vehicle = vehName })
					if inVehicle[1] then
						if inVehicle[1].arrest <= 0 then
							vRP.execute("vRP/set_arrest",{ user_id = parseInt(plateUser), vehicle = vehName, arrest = 1, time = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"verde", "O veículo foi apreendido no galpão da polícia.", 5000)
							TriggerEvent("webhooks","detido","```ini\n[============== VEICULO DETIDO ==============]\n[OFICIAL]: "..user_id.." "..identity.name.." "..identity.name2.." \n\n[DETEVE]: "..vehName.." \n[PLACA]: "..vehPlate.." \n[DONO]: "..plateUser.." "..identity2.name.." "..identity2.name2.." \n[COORDS]: "..x..","..y..","..z.." \n "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","POLICE - DETIDO")
						else
							TriggerClientEvent("Notify",source,"amarelo", "O veículo está no galpão da polícia.", 5000)
						end
					end
				end
			end
		end
	end
end)