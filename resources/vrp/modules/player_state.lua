-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
local SpawnLogin = {}
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local DataTable = vRP.getUserDataTable(user_id)
	if DataTable then
		if DataTable["position"] then
			if DataTable["position"]["x"] == nil or DataTable["position"]["y"] == nil or DataTable["position"]["z"] == nil then
				DataTable["position"] = { x = 27.66, y = -1763.32, z = 29.32 }
			end
		else
			DataTable["position"] = { x = 27.66, y = -1763.32, z = 29.32 }
		end
		vRPC.teleport(source,DataTable["position"]["x"],DataTable["position"]["y"],DataTable["position"].z+0.5)


		if DataTable["skin"] then
			vRPC.applySkin(source,DataTable["skin"])
		end

		if DataTable["stress"] == nil then
			DataTable["stress"] = 0
		end

		if DataTable["oxigen"] == nil then
			DataTable["oxigen"] = 100
		end

		if DataTable["inventory"] == nil then
			DataTable["inventory"] = {}
		end

		if DataTable["weaps"] then
			vRPC.giveWeapons(source,DataTable["weaps"],true)
		end

		if DataTable["health"] then
			vRPC.setHealth(source,DataTable["health"])
			local colete = DataTable["armour"]
			SetTimeout(10000,function()
				if DataTable.armour then
					source = vRP.getUserSource(user_id)
					if(source~=nil)then
						vRPC.setArmour(source,colete)
					end
				end
			end)
			TriggerClientEvent("statusHunger",source,DataTable.hunger)
			TriggerClientEvent("statusThirst",source,DataTable.thirst)
			TriggerClientEvent("statusStress",source,DataTable.stress)
		end

		Wait(1000)

		local consultAppearence = vRP.query("vRP/get_appearence",{ id = parseInt(user_id) })
		if consultAppearence[1]["appearence"] == 0 then
			local PlayerAppearence = vRP.userData(user_id,"Character")
			if SpawnLogin[parseInt(user_id)] then
				TriggerClientEvent("character:Apply",source,PlayerAppearence,false)
				TriggerClientEvent("vrp_spawn:justSpawn",source,false)
			else
				SpawnLogin[parseInt(user_id)] = true
				TriggerClientEvent("character:Apply",source,PlayerAppearence,false)
				TriggerClientEvent("vrp_spawn:justSpawn",source,true)
			end
			TriggerClientEvent("skinshop:apply",source,vRP.userData(user_id,"Clothings"))
		else
			TriggerClientEvent("character:createCharacter",source)
		end

		Wait(1000)

		TriggerClientEvent("tattoos:Apply",source,vRP.userData(user_id,"Tattoos"))

		Wait(1000)

		TriggerClientEvent("vRP:playerActive",source,user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.mathLegth(n)
	return math.ceil(n*100)/100
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryDeleteEntity")
AddEventHandler("tryDeleteEntity",function(index)
	TriggerClientEvent("syncDeleteEntity",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYCLEANENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryCleanEntity")
AddEventHandler("tryCleanEntity",function(index)
	TriggerClientEvent("syncCleanEntity",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("clearInventory")
AddEventHandler("clearInventory",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local DataTable = vRP.getUserDataTable(user_id)
		if DataTable["inventory"] then

			if vRP.userPremium(user_id) then
				DataTable["backpack"] = 100
			else
				DataTable["backpack"] = 50
			end

			DataTable["inventory"] = {}
			vRP.generateItem(user_id,"identity",(1),false)
			vRP.upgradeThirst(user_id,100)
			vRP.upgradeHunger(user_id,100)
			vRPC._clearWeapons(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD THIRST/HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(100000)
		for k,v in pairs(vRP.users) do
			vRP.downgradeThirst(v,1)
			vRP.downgradeHunger(v,1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDAGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.upgradeThirst(user_id,amount)
	local source = vRP.getUserSource(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		if data.thirst == nil then
			data.thirst = 100
		else
			data.thirst = data.thirst + amount
			if data.thirst >= 100 then
				data.thirst = 100
			end
		end

		TriggerClientEvent("statusThirst",source,data.thirst)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.upgradeHunger(user_id,amount)
	local source = vRP.getUserSource(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		if data.hunger == nil then
			data.hunger = 100
		else
			data.hunger = data.hunger + amount
			if data.hunger >= 100 then
				data.hunger = 100
			end
		end

		TriggerClientEvent("statusHunger",source,data.hunger)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.downgradeThirst(user_id,amount)
	local source = vRP.getUserSource(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		if data.thirst == nil then
			data.thirst = 100
		else
			data.thirst = data.thirst - amount
			if data.thirst <= 0 then
				data.thirst = 0
			end
		end

		TriggerClientEvent("statusThirst",source,data.thirst)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.downgradeHunger(user_id,amount)
	local source = vRP.getUserSource(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		if data.hunger == nil then
			data.hunger = 100
		else
			data.hunger = data.hunger - amount
			if data.hunger <= 0 then
				data.hunger = 0
			end
		end

		TriggerClientEvent("statusHunger",source,data.hunger)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.upgradeStress(user_id,amount)
	local userSource = vRP.getUserSource(user_id)
	local dataTable = vRP.getUserDataTable(user_id)
	if dataTable and userSource then
		if dataTable["stress"] == nil then
			dataTable["stress"] = 0
		end

		dataTable["stress"] = dataTable["stress"] + amount

		if dataTable["stress"] > 100 then
			dataTable["stress"] = 100
		end

		TriggerClientEvent("statusStress",userSource,dataTable["stress"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.downgradeStress(user_id,amount)
	local userSource = vRP.getUserSource(user_id)
	local dataTable = vRP.getUserDataTable(user_id)
	if dataTable and userSource then
		if dataTable["stress"] == nil then
			dataTable["stress"] = 0
		end

		dataTable["stress"] = dataTable["stress"] - amount

		if dataTable["stress"] < 0 then
			dataTable["stress"] = 0
		end

		TriggerClientEvent("statusStress",userSource,dataTable["stress"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.clientOxigen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getUserDataTable(user_id)
		if dataTable then
			if dataTable["oxigen"] == nil then
				dataTable["oxigen"] = 100
			end

			dataTable["oxigen"] = dataTable["oxigen"] - 1
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.rechargeOxigen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getUserDataTable(user_id)
		if dataTable then
			dataTable["oxigen"] = 100
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
	return math.floor((x + 8192) / 128)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
	return (v.x << 8) | v.y
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ModelPlayer(source)
	local Ped = GetPlayerPed(source)
	if GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01") then
		return "mp_m_freemode_01"
	elseif GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
		return "mp_f_freemode_01"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:BUCKET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:Bucket")
AddEventHandler("vRP:Bucket",function(Mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if Mode == "Enter" then
			Player(source)["state"]["Route"] = user_id
			SetPlayerRoutingBucket(source,user_id)
		elseif Mode == "Exit" then
			Player(source)["state"]["Route"] = 0
			SetPlayerRoutingBucket(source,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gg",function(source)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		local x,y,z = vRPC.getPositions(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
			if vRPC.checkDeath(source) then
				vRPC.finishDeath(source)
				vRPC.revivePlayer(source,200)
				TriggerClientEvent("resetHandcuff",source)
				TriggerClientEvent("resetDiagnostic",source)
				TriggerEvent("webhooks","gg","```ini\n[============== DEU GG ==============]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[COORDS]: "..x..","..y..","..z.."\n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","GG")
			end
		end
	end
end)