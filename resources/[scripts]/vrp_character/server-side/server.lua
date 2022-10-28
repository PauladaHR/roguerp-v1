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
Tunnel.bindInterface("vrp_character",Hiro)
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
-- VRP_CHARACTER:FINISHEDCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_character:finishedCharacter")
AddEventHandler("vrp_character:finishedCharacter",function(currentCharacterMode,status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/set_appearence",{ id = parseInt(user_id) })

		vRP.query("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Character", dalue = json.encode(currentCharacterMode) })
		if status then
			TriggerClientEvent("vrp_character:updateCharacter",source,currentCharacterMode,false)
			
			TriggerClientEvent("vrp_spawn:justSpawn",source,true)
		else
			TriggerClientEvent("vrp_character:updateCharacter",source,currentCharacterMode,true)
		end
		
		local PlayerTattoos = vRP.userData(user_id,"Tattoos")
		if PlayerTattoos then 
			TriggerClientEvent("tattoos:Apply",source,PlayerTattoos)
		end
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
		TriggerClientEvent("skinshop:apply",source,vRP.userData(user_id,"Clothings"))
		TriggerClientEvent("tattoos:apply",source,vRP.userData(user_id,"Tatuagens"))
		TriggerClientEvent("target:resetDebug",source)

		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)

		TriggerClientEvent("syncarea",-1,coords["x"],coords["y"],coords["z"],1)
	end
end)