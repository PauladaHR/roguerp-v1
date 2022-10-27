-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_character",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_CHARACTER:FINISHEDCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_character:finishedCharacter")
AddEventHandler("vrp_character:finishedCharacter",function(currentCharacterMode,status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/set_appearence",{ id = parseInt(user_id) })
		vRP.setUData(user_id,"Character",json.encode(currentCharacterMode))
		if status then
			TriggerClientEvent("vrp_character:updateCharacter",source,currentCharacterMode,false)
			
			TriggerClientEvent("vrp_spawn:justSpawn",source,true)
		else
			TriggerClientEvent("vrp_character:updateCharacter",source,currentCharacterMode,true)
		end
		
		local tattooData = vRP.getUData(user_id,"Tattoos")
		local result = json.decode(tattooData)
		if result then 
			TriggerClientEvent("tattoos:Apply",source,result)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_CHARACTER:RESETBARBER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_character:resetBarber")
AddEventHandler("vrp_character:resetBarber",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local playerData = vRP.getUData(user_id,"Character")
		local resultData = json.decode(playerData)
		if resultData then
			TriggerClientEvent("vrp_character:updateCharacter",source,resultData,true)
		end

		local tattooData = vRP.getUData(user_id,"Tattoos")
		local result = json.decode(tattooData)
		if result then 
			TriggerClientEvent("tattoos:Apply",source,result)
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkOpen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
			return true
		end
	end
	return false
end