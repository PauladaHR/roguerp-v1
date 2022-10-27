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
Hiro = {}
Tunnel.bindInterface("vrp_skinshop",Hiro)
vCLIENT = Tunnel.getInterface("vrp_skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.checkShares()
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
-- UPDATECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.updateClothes(Clothes)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Clothings", value = Clothes })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skinshop",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			TriggerClientEvent("skinshop:openShop",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.checkRoupas()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"clothes") >= 1 or vRP.hasClass(user_id,"Diamond") or vRP.hasClass(user_id,"Platinum") or vRP.hasClass(user_id,"Gold") or vRP.hasRank(user_id,"Admin",20) then
			return true 
		else
			TriggerClientEvent("Notify",source,"vermelho","Você não possui <b>Roupas</b> na mochila.",5000)
			return false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) and args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPC.applySkin(nplayer,GetHashKey(args[2]))
				vRP.updateSelectSkin(parseInt(args[1]),GetHashKey(args[2]))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVEPROPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:removeProps")
AddEventHandler("skinshop:removeProps",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local otherPlayer = vRP.nearestPlayer(source,1.1)
		if otherPlayer then
			if vRP.hasPermission(user_id,{"Police","actionPolice","Paramedic"}) then
				if mode == "mask" then
					TriggerClientEvent("skinshop:setMask",otherPlayer)
				elseif mode == "hat" then
					TriggerClientEvent("skinshop:setHat",otherPlayer)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mascara",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setMask(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /camisa
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("camisa",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setCamisa(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /colete
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("colete",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setColete(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /jaqueta
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("jaqueta",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setJaqueta(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("maos",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setMaos(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /calca
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("calca",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setCalca(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /acessorios
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("acessorios",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setAcessorios(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sapatos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("sapatos",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setSapatos(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /chapeu
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chapeu",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setChapeu(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mochila
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mochila",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setBag(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /oculos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("oculos",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.getHealth(source) > 101 then
				if not Player(source)["state"]["Handcuff"] then
					if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
						if user_id then
							vCLIENT.setOculos(source,args[1],args[2])
						end
					end
				end
			end
		end
	end
end)