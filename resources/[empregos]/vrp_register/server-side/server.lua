-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_register",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local boxTimers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.applyTimers(boxId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if boxTimers[boxId] then
			if os.time() < boxTimers[boxId] then
				TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
				return false
			else
				startBox(boxId,source)
				return true
			end
		else
			startBox(boxId,source)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function startBox(boxId,source)
	boxTimers[boxId] = os.time() + 1200

	if math.random(100) >= 35 then
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		TriggerClientEvent("player:applyGsr",source)

		local policeResult = vRP.numPermission("Police")
		for k,v in pairs(policeResult) do
			async(function()
				vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
				TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Caixa Registradora", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function src.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPC.getPositions(source)
	if user_id then
		
		vRP.wantedTimer(user_id,30)
		vRP.generateItem(user_id,"dollars2",math.random(450,600),true)
	end
	TriggerEvent("webhooks","roubosregistradora","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.."\n[COORDS]: "..x..","..y..","..z.." \n "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Caixa Registradora")
end