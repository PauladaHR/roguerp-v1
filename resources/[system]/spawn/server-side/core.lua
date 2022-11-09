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
Tunnel.bindInterface("spawn",Hiro)
vCLIENT = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local charActived = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("accounts/getUser", "SELECT * FROM vrp_infos WHERE steam = @steam")
vRP.prepare("characters/lastCharacters","SELECT id FROM vrp_users WHERE steam = @steam ORDER BY id DESC LIMIT 1")
vRP.prepare("characters/getCharacters","SELECT * FROM vrp_users WHERE steam = @steam and deleted = 0")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.Init()
	local source = source
	local characterList = {}
	local steam = vRP.getSteam(source)
	local consult = vRP.query("characters/getCharacters",{ steam = steam })

	SetPlayerRoutingBucket(source,source)
	Player(source)["state"]["Route"] = source

	if consult[1] then
		for k,v in pairs(consult) do
			table.insert(characterList,{ user_id = v["id"], name = v["name"].." "..v["name2"] })
		end
	end

	return characterList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.CharacterChosen(user_id)
	local source = source
	SetPlayerRoutingBucket(source,0)
	Player(source)["state"]["Route"] = 0
	TriggerEvent("baseModule:idLoaded",source,user_id,nil)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.MyCharacters()
	local source = source
	local MyCharacters = {}
	local steam = vRP.getSteam(source)
	local consult = vRP.query("characters/getCharacters",{ steam = steam })

	if consult[1] then
		for k,v in pairs(consult) do
			local userTablesSkin = vRP.userData(v["id"],"Datatable")
			local userTablesBarber = vRP.userData(v["id"],"Character")
			local userTablesClotings = vRP.userData(v["id"],"Clothings")
			local userTablesTatto = vRP.userData(v["id"],"Tattoos")
			
			table.insert(MyCharacters,{ skin = userTablesSkin["skin"], barber = userTablesBarber, clothes = userTablesClotings, tattoos = userTablesTatto })
		end
	end

	return MyCharacters
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function getPlayerCharacters(steam)
	return vRP.query("vRP/get_characters",{ steam = steam })
end
function getPlayerMaxCharacters(steam)
	return vRP.query("accounts/getUser", { steam = steam })[1]["chars"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
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
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.CreateCharacter(name,name2,sex)
	local source = source
	if charActived[source] == nil then
		charActived[source] = true

		local steam = vRP.getSteam(source)
		if not canCreateNewChar(steam) then
			TriggerClientEvent("Notify",source,"negado","Você atingiu o limite de personagens.",5000)
			return
		end

		if sex == "mp_m_freemode_01" then
			vRP.execute("vRP/create_characters",{ steam = steam, name = name, name2 = name2 })
		else
			vRP.execute("vRP/create_characters",{ steam = steam, name = name, name2 = name2 })
		end

		local consult = vRP.query("characters/lastCharacters",{ steam = steam })
		if consult[1] then
			SetPlayerRoutingBucket(source,0)
			Player(source)["state"]["Route"] = 0
			TriggerEvent("baseModule:idLoaded",source,consult[1]["id"],sex)
			vCLIENT.closeNew(source)
			Wait(1000)

			TriggerClientEvent("character:createCharacter",source)
		end

		charActived[source] = nil
	end
end