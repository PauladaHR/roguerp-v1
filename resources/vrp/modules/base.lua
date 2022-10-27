-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
vRP.users = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_sources = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP)
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local db_driver
local showIds = {}
local addPlayer = {}
local db_drivers = {}
local cached_queries = {}
local cached_prepares = {}
local db_initialized = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERDBDRIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.registerDBDriver(name,on_init,on_prepare,on_query)
	if not db_drivers[name] then
		db_drivers[name] = { on_init,on_prepare,on_query }
		db_driver = db_drivers[name]
		db_initialized = true

		for _,prepare in pairs(cached_prepares) do
			on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
		end

		for _,query in pairs(cached_queries) do
			query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
		end

		cached_prepares = nil
		cached_queries = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORMAT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.format(n)
	return parseFormat(n)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETXT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(archive,text)
	archive = io.open("resources/[system]/logsystem/"..archive,"a")
	if archive then
		archive:write(text.."\n")
	end

	archive:close()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.prepare(name,query)
	if db_initialized then
		db_driver[2](name,query)
	else
		table.insert(cached_prepares,{ name,query })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.query(name,params,mode)
	if not mode then mode = "query" end

	if db_initialized then
		return db_driver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cached_queries,{{ name,params or {},mode },r })
		return r:wait()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.execute(name,params)
	return vRP.query(name,params,"execute")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInformation(user_id)
	return vRP.query("vRP/get_vrp_users",{ id = parseInt(user_id) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInfos(steam)
	return vRP.query("vRP/get_vrp_infos",{ steam = steam })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISBANNED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.isBanned(steam)
	local rows = vRP.getInfos(steam)
	if rows[1] then
		return rows[1].banned
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISWHITELISTED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.isWhitelisted(steam)
	local rows = vRP.getInfos(steam)
	if rows[1] then
		return rows[1].whitelist
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setUData(user_id,key,value)
	vRP.execute("vRP/set_userdata",{ user_id = parseInt(user_id), key = key, value = value })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUData(user_id,key)
	local rows = vRP.query("vRP/get_userdata",{ user_id = parseInt(user_id), key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userData(user_id,key)
	local consult = vRP.query("vRP/get_userdata",{ user_id = user_id, key = key })
	if consult[1] then
		return json.decode(consult[1]["dvalue"])
	else
		return {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setSData(key,value)
	vRP.execute("vRP/set_srvdata",{ key = key, value = value })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getSData(key)
	local rows = vRP.query("vRP/get_srvdata",{ key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERDATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserDataTable(user_id)
	return vRP.user_tables[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInventory(user_id)
	local data = vRP.user_tables[user_id]
	if data then
		return data.inventory
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESELECTSKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateSelectSkin(user_id,hash)
	local data = vRP.user_tables[user_id]
	if data then
		data.skin = hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERID
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.users[ids[1]]
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsers()
	local users = {}
	for k,v in pairs(vRP.user_sources) do
		users[k] = v
	end
	return users
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserSource(user_id)
	return vRP.user_sources[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(reason)
	vRP.rejoinServer(source,reason)

	if addPlayer[source] then
		addPlayer[source] = nil
	end
	TriggerClientEvent("vRP:updateList",-1,addPlayer)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.kick(user_id,reason)
	if vRP.user_sources[user_id] then
		local source = vRP.user_sources[user_id]

		vRP.rejoinServer(source,reason)
		DropPlayer(source,reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALVARDB
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		for k,v in pairs(vRP.user_tables) do
			vRP.setUData(parseInt(k),"Datatable",json.encode(v))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJOINSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.rejoinServer(source,reason)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			TriggerEvent("vRP:playerLeave",user_id,source)
			TriggerEvent("webhooks","exit","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[MOTIVO]: "..reason.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Exit")

			vRP.setUData(user_id,"Datatable",json.encode(vRP.user_tables[user_id]))
			vRP.users[identity.steam] = nil
			vRP.user_sources[user_id] = nil
			vRP.user_tables[user_id] = nil
			vRP.rusers[user_id] = nil
			showIds[source] = nil

			TriggerClientEvent("vRP:showIds",-1,showIds)

			Citizen.Wait(1000)
			
			TriggerEvent("leaveHomes",user_id)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSTEAM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getSteam(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,5) == "steam" then
			return v
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getDiscord(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,7) == "discord" then
			return v
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETIDENTIFIERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getIdentifiers(source)
	local identifiers = GetPlayerIdentifiers(source)
	local array = {}

	for k,v in ipairs(identifiers) do
		if string.sub(v,1,5) == "steam" then
			array["steam"] = v
		end

		if string.sub(v,1,7) == "discord" then
			array["discord"] = string.gsub(v,"discord:","")
		end
	end
	
	return array
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local identity = vRP.getUserIdentity(user_id)
	local info = vRP.getSteam(source)
	local accountInfo = vRP.getInfos(info)
	local discord = ""

	if accountInfo[1].discord then
		discord = accountInfo[1].discord
	else
		discord = string.gsub(vRP.getDiscord(source),"discord:","")
		vRP.execute("vRP/update_discord",{ steam = info, discord = discord })
	end

	if identity then
		TriggerEvent("webhooks-noembed","join",""..discord.." #"..user_id.." "..identity["name"].." "..identity["name2"],"Join")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
	deferrals.defer()

	local source = source
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)

	if discord then
		discord = string.gsub(discord,"discord:","")
	end

	if steam then
		if not vRP.isBanned(steam) then
			local newUser = vRP.getInfos(steam)
			if newUser[1] == nil then
				vRP.execute("vRP/create_user",{ steam = steam, discord = discord, login = os.date("%d/%m/%Y") })
			end

			if vRP.checkRoleDiscord(discord,"953468179940782083") then
				vRP.execute("vRP/dateLogin",{ steam = steam, login = os.date("%d/%m/%Y") })
				deferrals.done()
			else
				deferrals.done("Você não tem whitelist em nosso servidor, entre em nosso discord e garanta já a sua whitelist! https://discord.gg/roguerp")
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
			end
		else
			deferrals.done("Você foi banido da cidade.")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		end
	else
		deferrals.done("Steam não encontrada.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HAS ROLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.checkRoleDiscord(discord,role)
    local waitCheck = nil

    exports["vrp_whitelist"]:checkWhitelist(discord,role,{},function(hasRole,roles)
        waitCheck = hasRole
    end)

	while waitCheck == nil do
		Citizen.Wait(100)
	end

    return waitCheck
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEWHITELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateWhitelist(steam)
	if steam then
		if not vRP.isWhitelisted(steam) then
			vRP.execute("vRP/update_whitelist",{ steam = steam, whitelist = 1 })
		end
	end
end

--AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
--	deferrals.defer()
--	local source = source
--	local steam = vRP.getSteam(source)
--	local discord = vRP.getDiscord(source)
--
--	if discord then
--		discord = string.gsub(discord,"discord:","")
--	end
--	
--	if steam then
--		if not vRP.isBanned(steam) then
--			if vRP.isWhitelisted(steam) then
--				vRP.execute("vRP/dateLogin",{ steam = steam, login = os.date("%d/%m/%Y") })
--				deferrals.done()
--			else
--				local newUser = vRP.getInfos(steam)
--				if newUser[1] == nil then
--					vRP.execute("vRP/create_user",{ steam = steam, discord = discord, login = os.date("%d/%m/%Y") })
--				end
--
--				deferrals.done("Envie na sala liberação: "..steam)
--				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
--			end
--		else
--			deferrals.done("Você foi banido da cidade.")
--			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
--		end
--	end
--end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWNED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:playerSpawned")
AddEventHandler("vRP:playerSpawned",function()
	local source = source
	TriggerClientEvent("vrp_spawn:setupChars",source)

	addPlayer[source] = true
	TriggerClientEvent("vRP:updateList",-1,addPlayer)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWNED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("baseModule:idLoaded")
AddEventHandler("baseModule:idLoaded",function(source,user_id,model)
	local source = source
	if vRP.rusers[user_id] == nil then
		local playerData = vRP.getUData(parseInt(user_id),"Datatable")
		local resultData = json.decode(playerData) or {}

		vRP.user_tables[user_id] = resultData
		vRP.user_sources[user_id] = source

		if model ~= nil then
			vRP.user_tables[user_id].weaps = {}
			vRP.user_tables[user_id].inventory = {}
			vRP.user_tables[user_id].skin = GetHashKey(model)
			vRP.user_tables[user_id].inventory["1"] = { item = "cellphone", amount = 1 }
			vRP.user_tables[user_id].inventory["2"] = { item = "identity", amount = 1 }
			vRP.user_tables[user_id].inventory["3"] = { item = "water", amount = 3 }
			vRP.user_tables[user_id].inventory["4"] = { item = "Foodcookies", amount = 3 }
		end

		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.users[identity.steam] = user_id
			vRP.rusers[user_id] = identity.steam
		end

		showIds[source] = user_id
		TriggerClientEvent("vRP:showIds",-1,showIds)

		local registration = vRP.getUserRegistration(user_id)
		if registration == nil then
			vRP.execute("vRP/update_characters",{ id = parseInt(user_id), registration = vRP.generateRegistrationNumber(), phone = vRP.generatePhoneNumber() })
		end

		TriggerEvent("vRP:playerSpawn",user_id,source)
	end
end)