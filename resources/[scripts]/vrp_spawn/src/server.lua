-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hiro = {}
Tunnel.bindInterface("vrp_spawn",Hiro)
vCLIENT = Tunnel.getInterface("vrp_spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.getCharacters()
	local source = source
	local steam = vRP.getSteam(source)

	return {
		characters = getPlayerCharacters(steam),
		maxCharacters = getPlayerMaxCharacters(steam)
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.deleteChar(id)
	local source = source
	local steam = vRP.getSteam(source)

	vRP.execute("vRP/remove_characters", { id = parseInt(id) })
	return getPlayerCharacters(steam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLogin = {}
RegisterServerEvent("vrp_spawn:charChosen",function(id)
	local source = source
	TriggerEvent("baseModule:idLoaded",source,id,nil)
	TriggerEvent("CharacterSpawn",source,id)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vrp_spawn/getUser", "SELECT * FROM vrp_infos WHERE steam = @steam")
RegisterServerEvent("vrp_spawn:createChar",function(name,name2,sex)
	local source = source
	local steam = vRP.getSteam(source)

	if not canCreateNewChar(steam) then
		TriggerClientEvent("Notify",source,"negado","Você atingiu o limite de personagens.",5000)
		return
	end

	vRP.execute("vRP/create_characters",{ steam = steam, name = name, name2 = name2 })

	local newId = 0
	local chars = getPlayerCharacters(steam)
	for k,v in pairs(chars) do
		if v.id > newId then
			newId = tonumber(v.id)
		end
	end

	vCLIENT.closeNew(source)

	spawnLogin[parseInt(newId)] = true
	TriggerClientEvent("hud:Active",source,true)
	TriggerEvent("baseModule:idLoaded",source,newId,sex)
	TriggerEvent("CharacterSpawn",source,newId)
end)

function Hiro.canCreateNewChar()
	local source = source
	local steam = vRP.getSteam(source)
	return canCreateNewChar(steam)
end

function canCreateNewChar(steam)
	local persons = getPlayerCharacters(steam)
	return parseInt(#persons) < getPlayerMaxCharacters(steam)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function getPlayerCharacters(steam)
	return vRP.query("vRP/get_characters",{ steam = steam })
end
function getPlayerMaxCharacters(steam)
	return vRP.query("vrp_spawn/getUser", { steam = steam })[1].chars
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.getCustomization(user_id)
    local data = vRP.getUData(user_id,"Datatable")
    local dataTable = json.decode(data) or nil
	if data then
        local value = vRP.getUData(user_id,"Character")
        local custom = json.decode(value) or nil

        local playerData = vRP.getUData(user_id,"Clothings")
        local resultClothings = json.decode(playerData) or nil

        local tattooData = vRP.getUData(user_id,"Tattoos")
        local resultTattoo = json.decode(tattooData) or nil

        return dataTable.skin,custom,resultClothings,resultTattoo
    end
end