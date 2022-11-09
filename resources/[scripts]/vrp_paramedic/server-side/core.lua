-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
vCLIENT = Tunnel.getInterface("paramedic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Repose")
AddEventHandler("paramedic:Repose",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPC.nearestPlayer(source,5)
	if user_id and vRPC.getHealth(source) > 101 and vRPC.getHealth(nplayer) > 101 then
		if vRP.hasPermission(user_id,"Paramedic") then
			local timer = vRP.prompt(source,"Minutos:","")
			if timer == "" or parseInt(timer) <= 0 then
				return
			end

			local nuser_id = vRP.getUserId(nplayer)
			local playerTimer = parseInt(timer * 60)
			local identity = vRP.getUserIdentity(nuser_id)
			if identity then
				if vRP.request(source,"Repouso","Adicionar <b>"..timer.." minutos</b> de repouso no(a) <b>"..identity["name"].."</b>?.",60) then
					TriggerClientEvent("Notify",source,"amarelo","Aplicou <b>"..timer.." minutos</b> de repouso.",10000)
					TriggerClientEvent("Notify",nplayer,"amarelo","Aplicou <b>"..timer.." minutos</b> de repouso.",10000)
					vRP.reposeTimer(nuser_id,playerTimer)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:diagnostic")
AddEventHandler("paramedic:diagnostic",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Paramedic") then
		local nplayer = vRPC.nearestPlayer(source,5)
		if nplayer then
			local hurt = false
			local diagnostic = vCLIENT.Diagnostic(nplayer)
			if diagnostic then
				local damaged = {}
				for k,v in pairs(diagnostic) do
					damaged[k] = Bones(k)
				end

				if next(damaged) then
					hurt = true
					TriggerClientEvent("drawInjuries",source,nplayer,damaged)
				end
			end

			local text = ""

			if diagnostic["taser"] then
				text = text .. "- <b>Marca de Taser</b><br>"
			end

			if diagnostic["vehicle"] then
				text = text .. "- <b>Marca de acidente de veículo</b><br>"
			end

			if diagnostic["pistol"] then
				text = text .. "- <b>Dano de Pistola</b><br>"
			end

			if diagnostic["fuzil"] then
				text = text .. "- <b>Dano de Fuzil</b><br>"
			end

			if diagnostic["branca"] then
				text = text .. "- <b>Dano de Corpo a Corpo</b><br>"
			end

			if text ~= "" then
				TriggerClientEvent("Notify",source,"amarelo", "Status do paciente:<br>" .. text, 5000, 'info')
			elseif not hurt then
				TriggerClientEvent("Notify",source,"amarelo", "Status do paciente:<br>- <b>Nada encontrado</b>", 5000, 'info')
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PULSE
-----------------------------------------------------------------------------------------------------------------------------------------
local Pulse = {}
local PulseReturn = {
	[1] = "morto",
	[2] = "vivo"
}
RegisterServerEvent("paramedic:pulse")
AddEventHandler("paramedic:pulse",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"Paramedic") then
		local nplayer = vRPC.nearestPlayer(source,5)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			local nidentity = vRP.getUserIdentity(nuser_id)
			if vRP.checkDeath(nplayer) then
				local diagnostic = vCLIENT.Diagnostic(nplayer)
				if Pulse[nuser_id] == nil then
					if diagnostic["fuzil"] then
						local chanceAlive = math.random(100)
						if chanceAlive <= 70 then
							Pulse[nuser_id] = PulseReturn[1]
						else
							Pulse[nuser_id] = PulseReturn[2]
						end
						text = "<b>Fuzil Damage</b>"
					elseif diagnostic["pistol"] then
						local chanceAlive = math.random(100)
						if chanceAlive <= 60 then
							Pulse[nuser_id] = PulseReturn[1]
						else
							Pulse[nuser_id] = PulseReturn[2]
						end
						text = "<b>Pistol Damage</b>"
					elseif diagnostic["branca"] then
						local chanceAlive = math.random(100)
						if chanceAlive <= 50 then
							Pulse[nuser_id] = PulseReturn[1]
						else
							Pulse[nuser_id] = PulseReturn[2]
						end
						text = "<b>Meele Damage</b>"
					elseif diagnostic["vehicle"] then
						local chanceAlive = math.random(100)
						if chanceAlive <= 30 then
							Pulse[nuser_id] = PulseReturn[1]
						else
							Pulse[nuser_id] = PulseReturn[2]
						end
						text = "<b>Vehicle Damage</b>"
					elseif diagnostic["taser"] then
						local chanceAlive = math.random(100)
						if chanceAlive <= 20 then
							Pulse[nuser_id] = PulseReturn[1]
						else
							Pulse[nuser_id] = PulseReturn[2]
						end
						text = "<b>Taser Damage</b>"
					else
						local chanceAlive = math.random(100)
						if chanceAlive <= 50 then
							Pulse[nuser_id] = PulseReturn[1]
						else
							Pulse[nuser_id] = PulseReturn[2]
						end
						text = "<b>Undefined Damage</b>"
					end
				end
				TriggerClientEvent("Notify",source,"amarelo", "O indivíduo recebeu "..text.." e se encontra <b>"..Pulse[nuser_id].."</b>!", 5000)
				TriggerClientEvent("Notify",nplayer,"amarelo", "Você recebeu "..text.." e se encontra <b>"..Pulse[nuser_id].."</b>!", 5000)
				TriggerEvent("webhooks","Pulse","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[VERIFICOU Pulse]: "..nuser_id.." "..nidentity["name"].." "..nidentity["name2"].."\n[RESULTADO]: "..Pulse[nuser_id].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Checagem Pulse")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETPULSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("resetPulse")
AddEventHandler("resetPulse",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		Pulse[user_id] = nil
	end
end)
