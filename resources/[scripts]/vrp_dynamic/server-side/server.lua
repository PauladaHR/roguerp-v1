-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
hiro = {}
Tunnel.bindInterface("vrp_dynamic",hiro)

function hiro.checkPremium()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.userPremium(user_id) then
			return true
		end
		return false
	end
end