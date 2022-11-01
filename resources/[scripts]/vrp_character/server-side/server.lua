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
Tunnel.bindInterface("character",Hiro)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.CheckWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTER:FINISHEDCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("character:finishedCharacter")
AddEventHandler("character:finishedCharacter",function(currentCharacterMode,status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/set_appearence",{ id = parseInt(user_id) })

		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Character", value = json.encode(currentCharacterMode) })
		
		if status then
			TriggerClientEvent("character:Apply",source,currentCharacterMode,false)
			
			TriggerClientEvent("vrp_spawn:justSpawn",source,true)
		else
			TriggerClientEvent("character:Apply",source,currentCharacterMode,true)
		end
		
		TriggerClientEvent("tattoos:Apply",source,vRP.userData(user_id,"Tattoos"))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("character:Debug")
AddEventHandler("character:Debug",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("character:Apply",source,vRP.userData(user_id,"Character"),false)
		TriggerClientEvent("skinshop:Apply",source,vRP.userData(user_id,"Clothings"))
		TriggerClientEvent("tattoos:Apply",source,vRP.userData(user_id,"Tattoos"))
		TriggerClientEvent("target:resetDebug",source)

		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)

		TriggerClientEvent("syncarea",-1,coords["x"],coords["y"],coords["z"],1)
	end
end)