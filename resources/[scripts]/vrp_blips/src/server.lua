local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local userList = {}
local adminList = {}

CreateThread(function()
	while true do
		updatePlayers()
		Wait(15000)
	end
end)

AddEventHandler("vRP:playerSpawn",function()
	updatePlayers()
end)

CreateThread(function()
	updatePlayers()
end)

local updating = false
function updatePlayers()
	if updating then return end

	updating = true

	local players = {}
	for uid, player in pairs(vRP.getUsers()) do
		if not Player(player).state.playerName then
			local identity = vRP.getUserIdentity(uid)
			Player(player).state.playerName = identity.name .. " " .. identity.name2
		end

		players[tostring(player)] = {
			playerID = uid,
			playerName = Player(player).state.playerName,
			playerGroups = GetUserGroup(uid),
			wallStatus = Player(player).state.wallStatus,
		}
		Wait(100)
	end
	GlobalState.wall = players

	updating = false
end

function GetUserGroup(user_id)
	local groupList = vRP.getPermissions(user_id)
	local list = {}
	for k, v in ipairs(groupList) do
		table.insert(list, v.permission)
	end
	return json.encode(list)
end

RegisterCommand("am", function(source)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasRank(user_id, "Admin", 20) then
		TriggerClientEvent("heyy:toggleWall", source)
		TriggerEvent("playerBlips:statusOn")

		updatePlayers()
	end
	TriggerEvent("webhooks","am"," #"..user_id.." "..identity.name.." "..identity.name2.." | Ativou/Desativou o AM","AM")
end)

RegisterNetEvent("heyy:setWallStatus", function(status)
	Player(source).state.wallStatus = status
end)

RegisterCommand("blips",function(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id, "Admin", 20) or user_id == 131 then
			if adminList[source] == nil then
				adminList[source] = true
				TriggerClientEvent("playerBlips:Display",source,true)
				TriggerClientEvent("Notify",source,"amarelo", "<span style='color:#c7c7c7'> Blips ativados.", 5000)
			else
				adminList[source] = nil
				TriggerClientEvent("playerBlips:Display",source,false)
				TriggerClientEvent("playerBlips:cleanBlips",source)
				TriggerClientEvent("Notify",source,"amarelo", "<span style='color:#c7c7c7'> Blips desativados.", 5000)
			end
		end
	end
end)

CreateThread(function()
	while true do
		for k,v in pairs(userList) do
			local ped = GetPlayerPed(k)
			if DoesEntityExist(ped) then
				local coords = GetEntityCoords(ped)

				userList[k][1] = coords.x
				userList[k][2] = coords.y
				userList[k][3] = coords.z
			else
				userList[k] = nil
			end
		end

		for k,v in pairs(adminList) do
			async(function()
				TriggerClientEvent("playerBlips:updateBlips",k,userList)
			end)
		end

		Wait(1000)
	end
end)

RegisterServerEvent("playerBlips:serviceEnter")
AddEventHandler("playerBlips:serviceEnter",function(source,service,color)
	if userList[source] == nil then
		userList[source] = { tostring(service),parseInt(color) }
	end
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if vRP.hasPermission(user_id,"Admin") then
		userList[source] = { 0.0,0.0,0.0,"Administrador",8 }
	else
		userList[source] = { 0.0,0.0,0.0,"Jogador",2 }
	end
end)

AddEventHandler("playerDropped",function()
	if userList[source] then
		userList[source] = nil

		for k,v in pairs(adminList) do
			async(function()
				TriggerClientEvent("playerBlips:removeBlips",k,source)
			end)
		end
	end
end)