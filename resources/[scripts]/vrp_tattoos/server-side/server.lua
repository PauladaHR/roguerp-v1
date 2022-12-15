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
Tunnel.bindInterface("tattoos",Hiro)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSHARES
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.CheckWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(user_id) or vRP.reposeReturn(user_id) then
			return false
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTATTOO
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.getTattoo()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("tattoos:Apply",source,vRP.userData(user_id,"Tattoos"))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETATTOO
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.updateTattoo(Tattoos)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.query("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Tattoos", value = json.encode(Tattoos) })
	end
end