local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if perm == nil then
		return true
	end
	return vRP.hasPermission(user_id,perm)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPEDSWIMMING
-----------------------------------------------------------------------------------------------------------------------------------------
local removeItens = { 
	"dollars2", "radio"
}

function src.removeSwimming()
	local source = source
	local user_id = vRP.getUserId(source)
	for k,v in pairs(removeItens) do
		local getAmount = vRP.getInventoryItemAmount(user_id,v)
		if getAmount > 0 then
			vRP.removeInventoryItem(user_id,v,parseInt(getAmount),true)
		end
	end
end

-- [ txAdmin ] --
local stage = 0
AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
	local word = "minuto"
	local time = (math.floor(eventData.secondsRemaining / 60))
	if time == 5 then
		stage = 1
		CreateThread(function()
			GlobalState["Weather"] = "CLEARING"
			while stage == 1 do
				TriggerClientEvent("vSync:forceBlackout", -1)
				Wait(10000)
			end
		end)
	elseif time == 3 then
		stage = 2
		CreateThread(function()
			GlobalState["Weather"] = "THUNDER"
			while stage == 2 do
				TriggerClientEvent("vSync:forceBlackout", -1)
				Wait(10000)
			end
		end)
	elseif time == 1 then
		stage = 3
		CreateThread(function()
			GlobalState["Weather"] = "THUNDER"
			while stage == 3 do
				TriggerClientEvent("vSync:forceBlackout", -1)
				Wait(10000)
			end
		end)
	end

	if time > 1 then
		word = "minutos"
	end

	TriggerClientEvent("smartphone:createSMS", -1, "Rogue Weather", "Há uma tempestade se aproximando da cidade, em aproximadamente " .. time .. " " .. word .. ". Risco de apagão!")
    print("^2[txAdmin] ^7Reinício em ^2" .. time .. " " .. word .. "^7")
	if eventData.secondsRemaining == 60 then
        TriggerClientEvent("smartphone:createSMS", -1, "Rogue Weather", "Abrigue-se IMEDIATAMENTE e aguarde o retorno da energia.")
		Wait(40000)
		TriggerEvent("vRP:saveServer")
		Wait(100)

		for _, pid in pairs(GetPlayers()) do
			DropPlayer(pid, "\n".."Houve um apagão na cidade. Voltaremos em alguns instantes!")
		end
    end
end)
