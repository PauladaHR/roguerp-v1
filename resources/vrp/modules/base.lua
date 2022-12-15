-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
vRP.userIds = {}
vRP.userInfos = {}
vRP.userTables = {}
vRP.userSources = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local preparedQueries = {}
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
-- UPDATETXT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(archive,text)
	archive = io.open("resources/logs/"..archive,"a")
	if archive then
		archive:write(text.."\n")
	end

	archive:close()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.prepare(name, query)
	preparedQueries[name] = query
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.query(name, params)
	return exports["oxmysql"]:query_async(preparedQueries[name], params)
end
vRP.execute = vRP.query
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISBANNED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CheckBanned(steam)
	local consultBanned = vRP.getInfos(steam)
	if consultBanned[1] then
		return consultBanned[1]["banned"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALLOWLISTED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Allowlisted(steam)
	local consultAllowlist = vRP.getInfos(steam)
	if consultAllowlist[1] then
		return consultAllowlist[1]["whitelist"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFOACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.infoAccount(steam)
	local infoAccount = vRP.query("vRP/get_vrp_infos",{ steam = steam })
	return infoAccount[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userData(user_id,key)
	local consult = vRP.query("playerdata/getUserdata",{ user_id = user_id, key = key })
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
	vRP.query("vRP/set_srvdata",{ key = key, value = value })
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
	return vRP.userTables[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInventory(user_id)
	local data = vRP.userTables[user_id]
	if data then
		return data["inventory"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESELECTSKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateSelectSkin(user_id,hash)
	local data = vRP.userTables[user_id]
	if data then
		data["skin"] = hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERID
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.userIds[ids[1]]
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsers()
	local users = {}
	for k,v in pairs(vRP.userSources) do
		users[k] = v
	end
	return users
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserSource(user_id)
	return vRP.userSources[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(reason)
	vRP.rejoinServer(source,reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.kick(user_id,reason)
	if vRP.userSources[user_id] then
		local source = vRP.userSources[user_id]

		vRP.rejoinServer(source,reason)
		DropPlayer(source,reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJOINSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.rejoinServer(source,reason)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			TriggerEvent("webhooks","exit","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[MOTIVO]: "..reason.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Exit")
			
			local DataTable = vRP.getUserDataTable(user_id)
			if DataTable then
				vRP.query("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(DataTable) })
				TriggerEvent("vRP:playerLeave",user_id,source)
				
				vRP.userIds[identity.steam] = nil
				vRP.userSources[user_id] = nil
				vRP.userTables[user_id] = nil
				vRP.userInfos[user_id] = nil
			end

			Wait(1000)
			
			TriggerEvent("leaveHomes",user_id)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEINFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.userUpdate(pArmour,pHealth,pCoords)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getUserDataTable(user_id)
		if dataTable then
			dataTable["armour"] = parseInt(pArmour)
			dataTable["health"] = parseInt(pHealth)
			dataTable["position"] = { x = mathLegth(pCoords["x"]), y = mathLegth(pCoords["y"]), z = mathLegth(pCoords["z"]) }
		end
	end
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
		vRP.query("vRP/update_discord",{ steam = info, discord = discord })
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
		if not vRP.CheckBanned(steam) then
			if vRP.Allowlisted(steam) then
				deferrals.done()
			else
				local newUser = vRP.getInfos(steam)
				if newUser[1] == nil then
					vRP.query("vRP/create_user",{ steam = steam, discord = discord })
				end

				deferrals.done("Envie na sala liberação: "..steam)
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
			end
		else
			deferrals.done("Você foi banido da cidade.")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWNED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("baseModule:idLoaded")
AddEventHandler("baseModule:idLoaded",function(source,user_id,model)
	local source = source
	if vRP.userInfos[user_id] == nil then
		local resultData = vRP.userData(parseInt(user_id),"Datatable")

		vRP.userTables[user_id] = resultData
		vRP.userSources[user_id] = source

		if model ~= nil then
			vRP.userTables[user_id].weaps = {}
			vRP.userTables[user_id].inventory = {}
			vRP.userTables[user_id].skin = GetHashKey(model)
			vRP.userTables[user_id].inventory["1"] = { item = "cellphone", amount = 1 }
			vRP.userTables[user_id].inventory["2"] = { item = "identity", amount = 1 }
			vRP.userTables[user_id].inventory["3"] = { item = "water", amount = 3 }
			vRP.userTables[user_id].inventory["4"] = { item = "Foodcookies", amount = 3 }
		end

		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.userIds[identity.steam] = user_id
			vRP.userInfos[user_id] = identity.steam
		end

		local registration = vRP.getUserRegistration(user_id)
		if registration == nil then
			vRP.query("vRP/update_characters",{ id = parseInt(user_id), registration = vRP.generateRegistrationNumber(), phone = vRP.generatePhoneNumber() })
		end

		TriggerEvent("vRP:playerSpawn",user_id,source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetGameType("Rogue")
	SetMapName("www.roguerp.com.br")
end)