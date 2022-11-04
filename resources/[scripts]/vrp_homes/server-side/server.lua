-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_homes",cRP)
vCLIENT = Tunnel.getInterface("vrp_homes")
vSKINSHOP = Tunnel.getInterface("vrp_skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local homeLock = {}	
local homeEnter = {}
local homeChest = {}
local homesInterior = {}
local theftTimes = {}
local homesConfig = {}
local homesVisit = {}
local homesInteriorVisit = {}
local homeCheck = {}
local houseNetwork = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNEARESTHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function getNearestHomes(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	for k,v in pairs(homesList) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 2 then
			return k
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTAXHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function getTaxHomes(homeName)
	local checkHome = vRP.query("vRP/homePermission", { name = homeName })
	if checkHome[1]['tax'] and checkHome[1]['premium'] ~= 1 then
		if parseInt(os.time()) >= parseInt(checkHome[1]['tax']+24*15*60*60) then
			return false
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:openSystem")
AddEventHandler("homes:openSystem",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = getNearestHomes(source)
		if homeName then

			if vRP.wantedReturn(user_id) then
				return
			end
			
			homeCheck[user_id] = homeName

			local checkExist = vRP.query("vRP/homePermission", { name = homeName })
			if checkExist[1] then
				local consult = vRP.query("vRP/homeUserPermission", { name = homeName, user_id = user_id })
				if consult[1] then

					if consult[1]["owner"] >= 1 then
						TriggerClientEvent("vrp_dynamic:SubMenu",source,"Proprietário","Gerencie sua residência.","OwnerPropertys")
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Vender","Vender residência.","homes:invokeSystem","vender","OwnerPropertys",true)
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Transferir","Transferir residência.","homes:invokeSystem","transferir","OwnerPropertys",true)
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Adicionar","Dar chave da residência.","homes:invokeSystem","adicionar","OwnerPropertys",true)
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Retirar","Retirar chave da residência.","homes:invokeSystem","remover","OwnerPropertys",true)

						if string.find(homeName,"Mansion") then

						elseif string.find(homeName,"Trailer") then

						elseif string.find(homeName,"Container") then

						else
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Interior","Trocar interior da residência.","","","OwnerPropertys",false,true,"OwnerPropertys2")

							TriggerClientEvent("vrp_dynamic:AddButton",source,"Hotel","Trocar interior para um Hotel.","homes:changeInterior",1,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Trailer","Trocar interior para um Trailer.","homes:changeInterior",2,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Motel","Trocar interior para um Motel.","homes:changeInterior",3,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Franklin","Trocar interior para um Franklin.","homes:changeInterior",4,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Middle","Trocar interior para um Middle.","homes:changeInterior",5,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Modern","Trocar interior para um Modern.","homes:changeInterior",6,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Beach","Trocar interior para um Beach.","homes:changeInterior",7,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Mansion","Trocar interior para um Mansion.","homes:changeInterior",8,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Simple","Trocar interior para um Simple.","homes:changeInterior",9,"OwnerPropertys2",true)
							TriggerClientEvent("vrp_dynamic:AddButton",source,"Container","Trocar interior para um Container.","homes:changeInterior",10,"OwnerPropertys2",true)
						end

					end

					if consult[1]["premium"] >= 1 then
						TriggerClientEvent("vrp_dynamic:SubMenu",source,"Premium","Gerencie sua residência premium.","propertysPremium")
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Verificar","Verificar tempo residência premium.","homes:invokeSystem","verificarPremium","propertysPremium",true)
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Renovar","Renovar residência premium.","homes:invokeSystem","renovarPremium","propertysPremium",true)
					end

					TriggerClientEvent("vrp_dynamic:SubMenu",source,"Residência","Gerencie sua residência.","propertys")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Baú","Aumentar o armário da residência.","homes:invokeSystem","bau","propertys",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Geladeira","Aumentar a galadeira da residência.","homes:invokeSystem","geladeira","propertys",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Morador","Aumentar os moradores da residência.","homes:invokeSystem","morador","propertys",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Garagem","Comprar garagem da residência.","homes:invokeSystem","garagem","propertys",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Seguro","Contratar seguro para residência.","homes:invokeSystem","seguro","propertys",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Permissões","Checar permissões da residência.","homes:invokeSystem","checar","propertys",true)

					TriggerClientEvent("vrp_dynamic:SubMenu",source,"Taxas","Gerencie suas taxas.","propertysTax")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Verificar","Verificar taxa da residência","homes:invokeSystem","checkTax","propertysTax",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Pagar","Pagar taxa da residência.","homes:invokeSystem","taxa","propertysTax",true)
					
					TriggerClientEvent("vrp_dynamic:buttonPlay",source,"Trancar","Trancar a residência.","homes:invokeSystem","trancar",true)
				end

				TriggerClientEvent("vrp_dynamic:buttonPlay",source,"Entrar","Entrar na residência.","homes:invokeSystem","entrar",true)
				
				if vRP.hasPermission(user_id,{"Police","actionPolice"}) then
					TriggerClientEvent("vrp_dynamic:buttonPlay",source,"Invadir","Invadir a residência.","homes:invokeInvade","",true)
				end
			else
				TriggerClientEvent("vrp_dynamic:SubMenu",source,"Interiores","Informações sobre os interiores.","propertysBuy")

				if string.find(homeName,"Mansion") then
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Mansion","Informações sobre interior mansion.","","","propertysBuy",false,true,"propertyMansion")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do mansion.","homes:buySystem",8,"propertyMansion",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do mansion.","homes:visitSystem",8,"propertyMansion",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior mansion.","homes:infoSystem",8,"propertyMansion",true)
				elseif string.find(homeName,"Trailer") then
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Trailer","Informações sobre o trailer.","","","propertysBuy",false,true,"propertyTrailer")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior de trailer.","homes:buySystem",2,"propertyTrailer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior de trailer.","homes:visitSystem",2,"propertyTrailer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior de trailer.","homes:infoSystem",2,"propertyTrailer",true)
				elseif string.find(homeName,"Container") then
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Container","Informações sobre interior container.","","","propertysBuy",false,true,"propertyContainer")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do container.","homes:buySystem",10,"propertyContainer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do container.","homes:visitSystem",10,"propertyContainer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior container.","homes:infoSystem",10,"propertyContainer",true)
				else
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Hotel","Informações sobre o hotel.","","","propertysBuy",false,true,"propertyHotel")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior de hotel.","homes:buySystem",1,"propertyHotel",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior de hotel.","homes:visitSystem",1,"propertyHotel",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior de hotel.","homes:infoSystem",1,"propertyHotel",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Trailer","Informações sobre o trailer.","","","propertysBuy",false,true,"propertyTrailer")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior de trailer.","homes:buySystem",2,"propertyTrailer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior de trailer.","homes:visitSystem",2,"propertyTrailer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior de trailer.","homes:infoSystem",2,"propertyTrailer",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Motel","Informações sobre o motel.","","","propertysBuy",false,true,"propertyMotel")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior de motel.","homes:buySystem",3,"propertyMotel",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior de motel.","homes:visitSystem",3,"propertyMotel",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior de motel.","homes:infoSystem",3,"propertyMotel",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Franklin","Informações sobre interior franklin.","","","propertysBuy",false,true,"propertyFranklin")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do franklin.","homes:buySystem",4,"propertyFranklin",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do franklin.","homes:visitSystem",4,"propertyFranklin",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior do franklin.","homes:infoSystem",4,"propertyFranklin",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Middle","Informações sobre interior middle.","","","propertysBuy",false,true,"propertyMiddle")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do middle.","homes:buySystem",5,"propertyMiddle",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do middle.","homes:visitSystem",5,"propertyMiddle",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior do middle.","homes:infoSystem",5,"propertyMiddle",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Modern","Informações sobre interior modern.","","","propertysBuy",false,true,"propertyModern")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do modern.","homes:buySystem",6,"propertyModern",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do modern.","homes:visitSystem",6,"propertyModern",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior do modern.","homes:infoSystem",6,"propertyModern",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Beach","Informações sobre interior beach.","","","propertysBuy",false,true,"propertyBeach")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do beach.","homes:buySystem",7,"propertyBeach",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do beach.","homes:visitSystem",7,"propertyBeach",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior do beach.","homes:infoSystem",7,"propertyBeach",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Mansion","Informações sobre interior mansion.","","","propertysBuy",false,true,"propertyMansion")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do mansion.","homes:buySystem",8,"propertyMansion",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do mansion.","homes:visitSystem",8,"propertyMansion",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior mansion.","homes:infoSystem",8,"propertyMansion",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Simple","Informações sobre interior simple.","","","propertysBuy",false,true,"propertySimple")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do simple.","homes:buySystem",9,"propertySimple",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do simple.","homes:visitSystem",9,"propertySimple",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior simple.","homes:infoSystem",9,"propertySimple",true)

					TriggerClientEvent("vrp_dynamic:AddButton",source,"Container","Informações sobre interior container.","","","propertysBuy",false,true,"propertyContainer")
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do container.","homes:buySystem",10,"propertyContainer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Visitar","Conhecer interior do container.","homes:visitSystem",10,"propertyContainer",true)
					TriggerClientEvent("vrp_dynamic:AddButton",source,"Informações","Informações sobre o interior container.","homes:infoSystem",10,"propertyContainer",true)
				end

				
				if vRP.getInventoryItemAmount(user_id,"housekey") >= 1 then
					TriggerClientEvent("vrp_dynamic:SubMenu",source,"Premium","Adquira sua residência premium.","propertysRental")
					for k,v in pairs(infoInterior) do
						TriggerClientEvent("vrp_dynamic:AddButton",source,"Comprar","Efetuar compra do interior do "..v["interior"]..".","homes:buySystem",k,"propertysRental",true)
					end
				end

				TriggerClientEvent("vrp_dynamic:buttonPlay",source,"Informações","Informações do exterior a vênda","homes:infoSystem","",true)

				if vRP.hasPermission(user_id,{"Police","actionPolice"}) then
					TriggerClientEvent("vrp_dynamic:buttonPlay",source,"Invadir","Invadir a residência.","homes:invokeInvade","",true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:buySystem")
AddEventHandler("homes:buySystem",function(numberHome)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = getNearestHomes(source)
		if homeName then
			if homeName == homeCheck[user_id] then
				TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

				local getFines = vRP.getFines(user_id)
				if getFines[1] then
					TriggerClientEvent("Notify",source,"vermelho", "Encontramos faturas/multas pendentes.", 5000)
					return
				end

				local maxHomes = vRP.query("vRP/homesCount",{ user_id = user_id })
				if vRP.userPremium(user_id) then
					if parseInt(maxHomes[1]["qtd"]) >= 4 then
						TriggerClientEvent("Notify",source,"vermelho", "Você atingiu o máximo de residências em seu nome.", 5000)
						return
					end
				else
					if parseInt(maxHomes[1]["qtd"]) >= 2 then
						TriggerClientEvent("Notify",source,"vermelho", "Você atingiu o máximo de residências em seu nome.", 5000)
						return
					end
				end

				if vRP.getInventoryItemAmount(user_id,"housekey") >= 1 then
					if vRP.hasClass(user_id,"Silver") then
						if string.find(homeName,"Mansion") then
							return
						end
					end

					local interiorSelect = infoInterior[parseInt(numberHome)]
					local request = vRP.request(source,"Casas","Deseja ativar a residência <b>"..homeName.."</b> com interior <b>"..interiorSelect["interior"].."</b> utilizando sua <b>"..vRP.itemNameList("housekey").."</b>?.",30)
					if request then
						if vRP.tryGetInventoryItem(user_id,"housekey",1,true,slot) then
							vRP.execute("vRP/homesBuy", { name = homeName, user_id = user_id, interior = interiorSelect["interior"], price = interiorSelect["price"], pricemin = interiorSelect["price"], residents = interiorSelect["residents"], vault = interiorSelect["vault"], fridge = interiorSelect["fridge"], tax = parseInt(os.time()), premium = 1 })
							TriggerClientEvent("Notify",source,"verde", "Compra efetuada.", 5000)
							atualizeBlip("update",homeName)
						end
					end
					return
				end

				for k,v in pairs(infoArea) do
					if string.find(homeName,k) then
						areaPrice = parseInt(v)
					end
				end

				local interiorSelect = infoInterior[parseInt(numberHome)]
				local homesPrice = parseInt(interiorSelect["price"]) + areaPrice
				local priceFinal = parseInt(interiorSelect["price"]) + areaPrice

				local request = vRP.request(source,"Casas","Você deseja comprar a residência por <b>$"..vRP.format(homesPrice).."</b> dólares?",30)
				if request then
					if vRP.paymentBank(user_id,homesPrice) then
						vRP.execute("vRP/homesBuy", { name = homeName, user_id = user_id, interior = interiorSelect["interior"], price = priceFinal, pricemin = priceFinal, residents = interiorSelect["residents"], vault = interiorSelect["vault"], fridge = interiorSelect["fridge"], tax = parseInt(os.time()), premium = 0 })
						TriggerClientEvent("Notify",source,"verde", "Compra efetuada.", 5000)
						atualizeBlip("update",homeName)
					else
						TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- INFO SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:changeInterior")
AddEventHandler("homes:changeInterior",function(numberInterior)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = getNearestHomes(source)
		if homeName then
			if homeName == homeCheck[user_id] then
				local consult = vRP.query("vRP/homeUserPermission", { name = homeName, user_id = user_id })
				if consult[1] then
					local checkTax = getTaxHomes(homeName)
					if checkTax then
						local interiorSelect = infoInterior[parseInt(numberInterior)]

						if interiorSelect["interior"] == consult[1]["interior"] then
							TriggerClientEvent("Notify",source,"vermelho","Você já está utilizando esse interior.", 5000)
							return
						end

						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						for k,v in pairs(infoArea) do
							if string.find(consult[1]["name"],k) then
								areaPrice = parseInt(v)
							end
						end

						local interiorPriceSelect = interiorSelect["price"] + areaPrice
						local interiorOwnerPrice = parseInt(consult[1]["price"] * 0.7)

						local interiorPayment = interiorPriceSelect - interiorOwnerPrice

						if interiorPayment < 0 then
							interiorPayment = 1
						end

						local request = vRP.request(source,"Casas","Deseja alterar o interior pagando <b>$"..vRP.format(interiorPayment).."</b> dólares?",30)
						if request then
							if vRP.paymentBank(user_id,interiorPayment) then
								vRP.execute("vRP/homesInterior", { name = homeName, user_id = user_id, interior = interiorSelect["interior"], price = interiorPriceSelect, pricemin = interiorPriceSelect, residents = interiorSelect["residents"], vault = interiorSelect["vault"], fridge = interiorSelect["fridge"], tax = parseInt(os.time()) })
								vRP.execute("vRP/homesInteriorPermission", { name = homeName, interior = interiorSelect["interior"], pricemin = interiorPriceSelect })
							else
								TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
							end
						end
					end
				end
			end
		end
	end

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFO SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:infoSystem")
AddEventHandler("homes:infoSystem",function(numberInterior)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = getNearestHomes(source)
		if homeName then
			if homeName == homeCheck[user_id] then
				if numberInterior == "" then
					for k,v in pairs(infoArea) do
						if string.find(homeName,k) then
							areaPrice = parseInt(v)
							areaName = k
						end
					end

					if string.find(homeName,"Hotel") then
						areaGarage = "Não"
					else
						areaGarage = "Sim"
					end

					TriggerClientEvent("Notify",source,"amarelo","Area do exterior: <b>"..areaName.."</b><br> Valor da area: <b>$"..vRP.format(areaPrice).."</b><br> Garagem: <b>"..areaGarage.."</b> ",10000)
				else
					local interiorPrice = infoInterior[parseInt(numberInterior)]["price"]
					local interiorResidents = infoInterior[parseInt(numberInterior)]["residents"]
					local interiorVault = infoInterior[parseInt(numberInterior)]["vault"]
					local interiorFridge = infoInterior[parseInt(numberInterior)]["fridge"]
					local interiorName = infoInterior[parseInt(numberInterior)]["interior"]

					for k,v in pairs(infoArea) do
						if string.find(homeName,k) then
							areaPrice = parseInt(v)
						end
					end

					if string.find(interiorName,"Motel") or string.find(interiorName,"Hotel") or string.find(homeName,"Hotel") then
						areaGarage = "Não"
					else
						areaGarage = "Sim"
					end

					finalPrice = interiorPrice + areaPrice

					if string.find(interiorName,"Hotel") then
						TriggerClientEvent("Notify",source,"amarelo","Valor do interior: <b>$"..vRP.format(interiorPrice).."</b><br> Numero de residentes: <b>"..interiorResidents.."</b><br> Baú: <b>"..interiorVault.."Kg</b><br> Garagem: <b>"..areaGarage.."</b><br> Valor com area: <b>$"..vRP.format(finalPrice).."</b>",10000)
					else
						TriggerClientEvent("Notify",source,"amarelo","Valor do interior: <b>$"..vRP.format(interiorPrice).."</b><br> Numero de residentes: <b>"..interiorResidents.."</b><br> Baú: <b>"..interiorVault.."Kg</b><br> Geladeira: <b>"..interiorFridge.."</b><br> Garagem: <b>"..areaGarage.."</b><br> Valor com area: <b>$"..vRP.format(finalPrice).."</b>",10000)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOKE SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:invokeSystem")
AddEventHandler("homes:invokeSystem",function(functionName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = getNearestHomes(source)
		if homeName then
			if homeName == homeCheck[user_id] then

				if functionName == "entrar" then
					local checkTax = getTaxHomes(homeName)
					if checkTax then
						local checkExist = vRP.query("vRP/homePermission", { name = homeName })
						if checkExist[1] then
							local consult = vRP.query("vRP/homeUserPermission", { name = homeName, user_id = user_id })
							if consult[1] then
								TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

								enterHomes(source,homeName,false,false,false)
							else
								if not homeLock[homeName] then
									TriggerClientEvent("Notify",source,"amarelo", "Porta Trancada", 5000)
								else
									TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

									enterHomes(source,homeName,false,false,false)
								end
							end
						end
					else
						TriggerClientEvent("Notify",source,"amarelo", "Taxa da casa atrasada, efetue o pagamento para poder entrar.", 5000)
					end
				end

				local consult = vRP.query("vRP/homeUserPermission", { name = homeName, user_id = user_id })
				if consult[1] then
					local checkTax = getTaxHomes(homeName)
					if functionName == "trancar" then
						if checkTax then
							local checkExist = vRP.query("vRP/homePermission", { name = homeName })
							if checkExist[1] then
								local consult = vRP.query("vRP/homeUserPermission", { name = homeName, user_id = user_id })
								if consult[1] then
									if homeLock[homeName] then
										homeLock[homeName] = nil
										TriggerClientEvent("Notify",source,"amarelo", "Porta Trancada", 5000)
									else
										homeLock[homeName] = true
										TriggerClientEvent("Notify",source,"amarelo", "Porta Destrancada", 5000)
									end
								end
							end
						end
					end

					if functionName == "transferir" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local nuser_id = vRP.prompt(source,"Passport:","")
						if nuser_id == "" or parseInt(nuser_id) <= 0 then
							return
						end

						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local request = vRP.request(source,"Casas","Você transferir sua residência para <b>"..identity["name"].." "..identity["name2"].."</b>?",30)
							if request then

								local userConsult = vRP.query("vRP/homeUserPermission", { user_id = nuser_id, name = homeName })
								if userConsult[1] then
									vRP.execute("vRP/homesRemPermission", { name = homeName, user_id = nuser_id })
								end
								vRP.execute("vRP/homesClearPermission",{ name = homeName })
								vRP.execute("vRP/updateOwnerHomes", { name = homeName, user_id = user_id, nuser_id = nuser_id })
								TriggerClientEvent("Notify",source,"verde", "Transferencia da residência para <b>"..identity["name"].." "..identity["name2"].."</b> concluída.", 5000)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho", "Passaporte inválido.", 5000)
						end

					end

					if functionName == "vender" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local homesPrice = parseInt(consult[1]["price"] * 0.5)
						local request = vRP.request(source,"Casas","Você deseja concluir a venda da residência por <b>$"..vRP.format(homesPrice).."</b> dólares?",30)
						if request then
							TriggerEvent("vrp_garages:removeGarages",homeName)
							vRP.execute("vRP/homesRemAllPermission",{ name = homeName })
							vRP.execute("vRP/rem_srv_data",{ dkey = "homesChest:"..homeName })
							vRP.execute("vRP/rem_srv_data",{ dkey = "homesFridge:"..homeName })
							atualizeBlip("remove",homeName)
							vRP.addBank(user_id,homesPrice)
						end
					end

					if functionName == "seguro" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local priceMin = parseInt(consult[1]["pricemin"])
						local priceMax = parseInt(consult[1]["price"])
						local pricePay = parseInt(consult[1]["price"]*0.50)
						if priceMax <= priceMin then
							local request = vRP.request(source,"Casas","Deseja ativar o seguro pagando <b>$"..vRP.format(pricePay).."</b> dólares?",30)
							if request then
								if vRP.paymentBank(user_id,pricePay) then
									vRP.execute("vRP/homesSeg",{ name = homeName, pricemin = pricePay })
								else
									TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
								end
							end
						end
					end

					if functionName == "adicionar" then
						local homesCount = vRP.query("vRP/homesCountPermiss", { name = homeName})
						if homesCount[1]["qtd"] >= consult[1]["residents"] then
							TriggerClientEvent("Notify",source,"vermelho", "Residência atingiu o máximo de moradores.", 5000)
							return
						end

						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)
						local nuser_id = vRP.prompt(source,"Passport:","")
						if nuser_id == "" or parseInt(nuser_id) <= 0 then
							return
						end

						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local userConsult = vRP.query("vRP/homeUserPermission", {user_id = nuser_id, name = homeName })
							if userConsult[1] then
								TriggerClientEvent("Notify",source,"amarelo", "<b>"..identity["name"].." "..identity["name2"].." </b> já pertence a residência.", 5000)
								return
							else
								vRP.execute("vRP/homesNewPermission", { user_id = nuser_id, name = homeName, pricemin = consult[1]["pricemin"], interior = consult[1]["interior"], tax = consult[1]["tax"], owner = 0, premium = consult[1]["premium"]})
								TriggerClientEvent("Notify",source,"verde", "Adicionado o(a) <b>"..identity["name"].." "..identity["name2"].." </b> a residência.", 5000)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho", "Passaporte inválido.", 5000)
						end
					end

					if functionName == "remover" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local nuser_id = vRP.prompt(source,"Passport:","")
						if nuser_id == "" or parseInt(nuser_id) <= 0 then
							return
						end

						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local userConsult = vRP.query("vRP/homeUserPermission", { user_id = nuser_id, name = homeName})
							if userConsult[1] then
								vRP.execute("vRP/homesRemPermission", { name = homeName, user_id = nuser_id })
								TriggerClientEvent("Notify",source,"verde", "Permissão de residência removida de <b>"..identity.name.." "..identity.name2.."</b>.", 5000)
							else
								TriggerClientEvent("Notify",source,"vermelho", "Não foi possível encontrar o passaporte <b>"..vRP.format(nuser_id).."</b> na residência.", 5000)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho", "Passaporte inválido.", 5000)
						end
					end

					if functionName == "morador" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local homesResidents = 25000
						if vRP.request(source,"Casas","Deseja adicionar mais um morador pagando <b>$"..vRP.format(homesResidents).."</b> dólares?",30) then
							if vRP.paymentBank(user_id,homesResidents) then
								vRP.execute("vRP/homesResidents",{ name = homeName, residents = 1 })
								TriggerClientEvent("Notify",source,"verde", "Compra efetuada.", 5000)
							else
								TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
							end
						end
					end

					if functionName == "garagem" then
						if not string.find(consult[1]["interior"],"Motel") or not string.find(consult[1]["interior"],"Hotel") or string.find(consult[1]["name"],"Hotel") then
							TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

							local homesGarage = 7500
							if vRP.request(source,"Casas","Deseja adicionar a garagem pagando <b>$"..vRP.format(homesGarage).."</b> dólares?",30) then
								if vRP.paymentBank(user_id,homesGarage) then
									TriggerClientEvent("Notify",source,"amarelo", "Fique no local onde vai abrir a garagem e pressione a tecla <b>E</b>.", 10000)
									vCLIENT.homeGarage(source,homeName)
								else
									TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
								end
							end
						else
							TriggerClientEvent("Notify",source,"vermelho","Garagem indisponível.", 5000)
						end
					end

					if functionName == "bau" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local vaultHomes = 25000
						local request = vRP.request(source,"Casas","Deseja aumentar o baú pagando <b>$"..vRP.format(vaultHomes).."</b> dólares?",30)
						if request then
							if vRP.paymentBank(user_id,vaultHomes) then
								vRP.execute("vRP/homesVault",{ name = homeName, vault = 50 })
								TriggerClientEvent("Notify",source,"verde", "Compra efetuada.", 5000)
							else
								TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
							end
						end
					end

					if functionName == "geladeira" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local fridgeHomes = 25000
						local request = vRP.request(source,"Casas","Deseja aumentar a geladeira pagando <b>$"..vRP.format(fridgeHomes).."</b> dólares?",30)
						if request then
							if vRP.paymentBank(user_id,fridgeHomes) then
								vRP.execute("vRP/homesFridge",{ name = homeName, fridge = 25 })
								TriggerClientEvent("Notify",source,"verde", "Compra efetuada.", 5000)
							else
								TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
							end
						end
					end

					if functionName == "checar" then
						local checkExist = vRP.query("vRP/homePermission", { name = homeName })
						if checkExist[1] then 
							local permList = ""
							for k,v in pairs(checkExist) do
								local identity = vRP.getUserIdentity(v["user_id"])
								if identity then
									permList = permList.."#<b>"..v["user_id"].."</b> " ..identity["name"].." "..identity["name2"].." "
									if k ~= #checkExist then
										permList = permList.."<br>"
									end
								end
							end
							TriggerClientEvent("Notify",source,"amarelo", "Listagem de permissões da residência <b>"..homeName.."</b>: <br>"..permList, 20000)
						end
					end

					if functionName == "taxa" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local homesTax = parseInt(consult[1]["pricemin"]*0.07)
						local request = vRP.request(source,"Casas","Deseja pagar a taxa da casa por <b>$"..vRP.format(homesTax).."</b>?",30)
						if request then
							if vRP.paymentBank(user_id,homesTax) then
								vRP.execute("vRP/homesTax",{ name = homeName, tax = parseInt(os.time()) })
								TriggerClientEvent("Notify",source,"verde", "Pagamento do <b>Homes Tax</b> conclúido com sucesso.", 5000)
							else
								TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
							end
						end
					end

					if functionName == "checkTax" then
						local homesList = vRP.query("vRP/homeUserList",{ user_id = user_id })
						for k,v in ipairs(homesList) do
							local homesOwners = vRP.query("vRP/homeUserPermission",{ name = tostring(v.name), user_id = user_id})
							if homesOwners[1] then
								if parseInt(os.time()) >= parseInt(homesOwners[1].tax+24*15*60*60) then
									TriggerClientEvent("Notify",source,"amarelo", "<b>Residência:</b> "..v["name"].." - <b>Homes Tax:</b> Atrasado.", 20000)
								else
									TriggerClientEvent("Notify",source,"amarelo", "<b>Residência:</b> "..v["name"].." - <b>Homes Tax:</b> em "..completeTimers(parseInt(86400*15-(os.time()-homesOwners[1].tax))), 20000)
									Citizen.Wait(1)
								end
							end
						end
					end

					if functionName == "verificarPremium" then
						local homesListPremium = vRP.query("vRP/homeUserListPremium",{ user_id = user_id })
						for k,v in ipairs(homesListPremium) do 
							local homesOwners = vRP.query("vRP/homeUserPermission",{ name = tostring(v.name), user_id = user_id})
							if homesOwners[1] then
								if parseInt(os.time()) >= parseInt(homesOwners[1].tax+24*30*60*60) then
									TriggerClientEvent("Notify",source,"amarelo", "<b>Residência Premium:</b> "..v["name"].." - <b>Vencimento:</b> Atrasado", 20000)
								else
									TriggerClientEvent("Notify",source,"amarelo", "<b>Residência Premium:</b> "..v["name"].." - <b>Vence:</b> em "..completeTimers(parseInt(86400*30-(os.time()-homesOwners[1].tax))), 20000)
									Citizen.Wait(1)
								end
							end
						end
					end

					if functionName == "renovarPremium" then
						TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

						local request = vRP.request(source,"Casas","Deseja renovar a sua <b>Casa Premium</b>?",30)
						if request then
							if vRP.tryGetInventoryItem(user_id,"housekey",1,true,slot) then
								vRP.execute("vRP/homesTax",{ name = homeName, tax = parseInt(os.time()) })
								TriggerClientEvent("Notify",source,"verde", "Renovação da <b>Casa Premium</b> conclúida com sucesso.", 5000)
							end
						end
					end

				end
			end
		end
	end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:invokeInvade")
AddEventHandler("homes:invokeInvade",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"PolMaster") then
			local homeName = getNearestHomes(source)
			if homeName then
				if homeName == homeCheck[user_id] then

					TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

					enterHomes(source,homeName,false,false,false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.updateHomes(source)

	local checkPremium = vRP.query("vRP/homeUserPermissionPremium", { user_id = user_id })
	if #checkPremium then

		for k,v in pairs(checkPremium) do 
			if parseInt(os.time()) >= parseInt(v['tax']+24*33*60*60) then
				TriggerEvent("vrp_garages:removeGarages",v['name'])
				vRP.execute("vRP/homesRemAllPermission",{ name = v['name'] })
				vRP.execute("vRP/rem_srv_data",{ dkey = "homesChest:"..v['name'] })
				vRP.execute("vRP/rem_srv_data",{ dkey = "homesFridge:"..v['name'] })
				atualizeBlip("remove",v["name"])
				TriggerClientEvent("Notify",source,"amarelo", "<b>Casa Premium</b> removida por falta de renovação.", 20000)
				return
			end
			if parseInt(os.time()) >= parseInt(v['tax']+24*30*60*60) then
				TriggerClientEvent("Notify",source,"amarelo", "<b>Casa Premium</b> vencida, efetue a renovação para não perde-la.", 20000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local checkExist = vRP.query("vRP/homePermission", { name = homeName })
		if checkExist[1] then
			local consult = vRP.query("vRP/homeUserPermission",{ name = homeName, user_id = user_id })
			if consult[1] or vRP.hasPermission(user_id,{"Police","actionPolice"}) then

				for k,v in pairs(homeChest) do
					if v == homeName then
						return false
					end
				end

				homeChest[user_id] = homeName

				return true
			else
				if not homeLock[homeName] then
					TriggerClientEvent("Notify",source,"vermelho", "A porta está trancada.", 5000)
				else

					for k,v in pairs(homeChest) do
						if v == homeName then
							return false
						end
					end
	
					homeChest[user_id] = homeName

					return true
				end
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VISIT SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:visitSystem")
AddEventHandler("homes:visitSystem",function(numberInterior)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = getNearestHomes(source)
		if homeName then
			if homeName == homeCheck[user_id] then
				local interiorName = infoInterior[parseInt(numberInterior)]["interior"]

				if homesVisit[homeName] then
					for k,v in pairs(homesVisit[homeName]) do
						if v == user_id then
							return
						end
					end
				end

				if homesVisit[homeName] then
					if homesInteriorVisit[homeName] == interiorName then
						table.insert(homesVisit[homeName],user_id)
					else
						TriggerClientEvent("Notify",source,"vermelho", "Outro interior está sendo avaliado",5000,'negado')
						return
					end
				else
					homesInteriorVisit[homeName] = interiorName
					homesVisit[homeName] = { user_id }
				end
				TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

				enterHomes(source,homeName,false,true,interiorName)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE VISIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeVisit(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if homesVisit[homeName] then
			for k,v in pairs(homesVisit[homeName]) do
				table.remove(homesVisit[homeName],k)
			end
			if #homesVisit[homeName] == 0 then
				homesInteriorVisit[homeName] = nil
				homesVisit[homeName] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHES SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:clothesSystem")
AddEventHandler("homes:clothesSystem",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("vrp_dynamic:SubMenu",source,"Aplicar","Roupas salvas.","clothesSystem")
		local data = vRP.getSData("wardrobe:"..user_id)
		local result = json.decode(data) or {}
		for k,v in pairs(result) do
			async(function()
				TriggerClientEvent("vrp_dynamic:AddButton",source,string.upper(k),"Vestir roupa.","homes:invokeClothes",k,"clothesSystem",true)
			end)
		end
		TriggerClientEvent("vrp_dynamic:SubMenu",source,"Remover","Roupas salvas.","clothesSystem2")
		local data = vRP.getSData("wardrobe:"..user_id)
		local result = json.decode(data) or {}
		for k,v in pairs(result) do
			async(function()
				TriggerClientEvent("vrp_dynamic:AddButton",source,string.upper(k),"Remover roupa.","homes:removeClothes",k,"clothesSystem2",true)
			end)
		end
		TriggerClientEvent("vrp_dynamic:buttonPlay",source,"Salvar","Salvar roupas vestida","homes:saveClothes","",true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOKE CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:invokeClothes")
AddEventHandler("homes:invokeClothes",function(clothesName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getSData("wardrobe:"..user_id)
		local result = json.decode(data) or {}
		if data and result ~= nil then
			TriggerClientEvent("updateRoupas",source,result[clothesName])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:saveClothes")
AddEventHandler("homes:saveClothes",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

		local data = vRP.getSData("wardrobe:"..user_id)
		local result = json.decode(data) or {}
		if data and result ~= nil then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then

				local clothesName = vRP.prompt(source,"Nome da roupa:","")
				if clothesName == "" then
					return
				end

				local nameCheck = sanitizeString(clothesName,"abcdefghijklmnopqrstuvwxyz",true)
				if string.len(nameCheck) < 12 then
					if result[nameCheck] == nil and string.len(nameCheck) > 0 then
						result[nameCheck] = custom
						vRP.setSData("wardrobe:"..user_id,json.encode(result))
						TriggerClientEvent("Notify",source,"verde", "Outfit <b>"..clothesName.."</b> adicionado.",5000,'sucesso')
					else
						TriggerClientEvent("Notify",source,"amarelo", "O nome escolhido já existe na lista de <b>outfits</b>.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Utilize apenas <b>12</b> caracteres",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("homes:removeClothes")
AddEventHandler("homes:removeClothes",function(clothesName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("vrp_dynamicHomes:closeSystem",source)

		local data = vRP.getSData("wardrobe:"..user_id)
		local result = json.decode(data) or {}
		if data and result ~= nil then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then

				local nameCheck = sanitizeString(clothesName,"abcdefghijklmnopqrstuvwxyz",true)
				if result[nameCheck] ~= nil and string.len(nameCheck) > 0 then
					result[nameCheck] = nil
					vRP.setSData("wardrobe:"..user_id,json.encode(result))
					TriggerClientEvent("Notify",source,"verde","Outfit <b>"..clothesName.."</b> removido.",5000,'sucesso')
				else
					TriggerClientEvent("Notify",source,"amarelo", "O nome escolhido já existe na lista de <b>outfits</b>.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkClothes(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local checkExist = vRP.query("vRP/homePermission",{ name = homeName })
		if checkExist[1] then
			local consult = vRP.query("vRP/homeUserPermission", { name = homeName, user_id = user_id })
			if consult[1] then
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if homeChest[user_id] then
			homeChest[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openChest(homeName,vaultMode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myInventory = {}
		local inv = vRP.getInventory(user_id)
		for k,v in pairs(inv) do
			v.amount = parseInt(v.amount)
			v.name = vRP.itemNameList(v.item)
			v.peso = vRP.itemWeightList(v.item)
			v.index = vRP.itemIndexList(v.item)
			v.max = vRP.itemMaxAmount(v.item)
			v.type = vRP.itemTypeList(v.item)
			v.hunger = vRP.itemHungerList(v.item)
			v.thirst = vRP.itemWaterList(v.item)
			v.economy = vRP.itemEconomyList(v.item)
			v.desc = vRP.itemDescList(v.item)
			v.key = v.item
			v.slot = k
			
			myInventory[k] = v
		end
		
		local myChest = {}
		local consult = vRP.getSData(vaultMode..":"..tostring(homeName))
		local result = json.decode(consult) or {}
		if result ~= nil then
			for k,v in pairs(result) do
				v.amount = parseInt(v.amount)
				v.name = vRP.itemNameList(v.item)
				v.peso = vRP.itemWeightList(v.item)
				v.index = vRP.itemIndexList(v.item)
				v.max = vRP.itemMaxAmount(v.item)
				v.type = vRP.itemTypeList(v.item)
				v.hunger = vRP.itemHungerList(v.item)
				v.thirst = vRP.itemWaterList(v.item)
				v.economy = vRP.itemEconomyList(v.item)
				v.desc = vRP.itemDescList(v.item)
				v.key = v.item
				v.slot = k
				
				myChest[k] = v
			end
		end
		
		local gems = vRP.getUserGems(user_id)
		local identity = vRP.getUserIdentity(user_id)
		local checkInfos = vRP.query("vRP/homePermission", { name = homeName })
		if checkInfos[1] then
			if vaultMode == "homesChest" then
				return myInventory,myChest,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["vault"])
			elseif vaultMode == "homesFridge" then
				return myInventory,myChest,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["fridge"])
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeItem(itemName,slot,amount,target,homeName,vaultMode)
	local source = source
	local user_id = vRP.getUserId(source)
	local checkInfos = vRP.query("vRP/homePermission", { name = homeName })
	local consult = vRP.getSData(vaultMode..":"..tostring(homeName))
	local result = json.decode(consult) or {}
	if user_id then
		if checkInfos[1] then
			local vaultWeight = 15
			local vWeight = vRP.query("vRP/homePermission", { name = homeName })
			if vWeight[1] then
				if vaultMode == "homesFridge" then
					if not vRP.itemHungerList(itemName) or not vRP.itemWaterList(itemName) or itemName == "identity" then
						vCLIENT.updateWeight(source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["vault"]))
						TriggerClientEvent("vrp_homes:Update",source,"requestChest")
						TriggerClientEvent("Notify",source,"amarelo", "Você não pode armazenar este item.", 5000)
						return
					end
					
					vaultWeight = parseInt(vWeight[1].fridge)
				elseif vaultMode == "homesChest" then
					if vRP.itemHungerList(itemName) or vRP.itemWaterList(itemName) or itemName == "identity" then
						vCLIENT.updateWeight(source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["vault"]))
						TriggerClientEvent("vrp_homes:Update",source,"requestChest")
						TriggerClientEvent("Notify",source,"amarelo", "Você não pode armazenar este item.", 5000)
						return
					end
					
					vaultWeight = parseInt(vWeight[1].vault)
				end
				
				if not vRP.storeChest(user_id,vaultMode..":"..tostring(homeName),itemName,amount,vaultWeight,slot,target) then
					TriggerClientEvent("vrp_homes:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["vault"]))
				end

				TriggerEvent("discordlogs","Homes","**Passaporte:** "..parseFormat(user_id).."\n**Guardou:** "..parseFormat(amount).."x "..vRP.itemNameList(itemName).."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
			end
			TriggerClientEvent("vrp_homes:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(itemName,slot,amount,target,homeName,vaultMode)
	local source = source
	local user_id = vRP.getUserId(source)
	local checkInfos = vRP.query("vRP/homePermission", { name = homeName })
	local consult = vRP.getSData(vaultMode..":"..tostring(homeName))
	local result = json.decode(consult) or {}
	if user_id then
		if checkInfos[1] then
			if vRP.tryChest(user_id,vaultMode..":"..tostring(homeName),itemName,amount,slot,target) then
				TriggerClientEvent("vrp_homes:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["vault"]))
			end
			TriggerEvent("discordlogs","Homes","**Passaporte:** "..parseFormat(user_id).."\n**Retirou:** "..parseFormat(amount).."x "..vRP.itemNameList(itemName).."\n**Horário:** "..os.date("%H:%M:%S"),9317187)
		end
		TriggerClientEvent("vrp_homes:Update",source,"requestChest")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateChest(itemName,slot,target,amount,homeName,vaultMode)
	local source = source
	local user_id = vRP.getUserId(source)
	local checkInfos = vRP.query("vRP/homePermission", { name = homeName })
	local consult = vRP.getSData(vaultMode..":"..tostring(homeName))
	local result = json.decode(consult) or {}
	if user_id then
		if checkInfos[1] then
			if not vRP.updateChest(user_id,vaultMode..":"..tostring(homeName),itemName,slot,target,amount) then
				TriggerClientEvent("vrp_homes:UpdateWeight",source,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.chestWeight(result),parseInt(checkInfos[1]["vault"]))
			end
		end
		TriggerClientEvent("vrp_homes:Update",source,"requestChest")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEHOUSEOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeHouseOpen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if homeEnter[user_id] then
			homeEnter[user_id] = nil
		end
		SetPlayerRoutingBucket(source,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("leaveHomes")
AddEventHandler("leaveHomes",function(user_id)
	if homeEnter[user_id] then
		local DataTable = vRP.userData(parseInt(user_id),"Datatable")
		if DataTable then
			if DataTable["position"] then
				DataTable["position"] = { x = homesList[homeEnter[user_id]][1], y = homesList[homeEnter[user_id]][2], z = homesList[homeEnter[user_id]][3] }
			end
		end

		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(DataTable) })
		homeEnter[user_id] = nil
	end

	if homeChest[user_id] then
		homeChest[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROBERRYS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(theftTimes) do
			if theftTimes[k] > 0 then
				theftTimes[k] = v - 1
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function enterHomes(source,homeName,theft,visit,interiorName)
	local checkExist = vRP.query("vRP/homePermission", { name = homeName })
	if checkExist[1] then
		homesInterior[homeName] = checkExist[1]["interior"]
	else
		if homesInterior[homeName] == nil then
			homesInterior[homeName] = infoInterior[math.random(#infoInterior)]["interior"]
		end
	end

	if houseNetwork[homeName] then
		SetPlayerRoutingBucket(source,houseNetwork[homeName])
	else
		local homeDimension = math.random(1,9999)
		for k,v in pairs(houseNetwork) do
			repeat
				if homeDimension == v then
					homeDimension = math.random(1,9999)
				end
				Citizen.Wait(0)
			until homeDimension ~= v
		end

		houseNetwork[homeName] = homeDimension
		SetPlayerRoutingBucket(source,houseNetwork[homeName])
	end
	
	homeEnter[vRP.getUserId(source)] = homeName

	if visit then
		vCLIENT.entranceHomes(source,homeName,homesList[homeName],interiorName,theft,visit)
	else
		vCLIENT.entranceHomes(source,homeName,homesList[homeName],homesInterior[homeName],theft,visit)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTTHEFT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentTheft(mobile)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local randItem = math.random(#mobileTheft[mobile])
		if vRP.computeInvWeight(user_id) + vRP.itemWeightList(mobileTheft[mobile][randItem][1]) * parseInt(mobileTheft[mobile][randItem][2]) <= vRP.getBackpack(user_id) then
			if math.random(100) <= 80 then
				vRP.giveInventoryItem(user_id,mobileTheft[mobile][randItem][1],parseInt(mobileTheft[mobile][randItem][2]),true)
			else
				TriggerClientEvent("Notify",source,"amarelo", "Compartimento vazio.", 5000)
			end
		else
			TriggerClientEvent("Notify",source,"vermelho", "Mochila cheia.", 5000)
		end
		
		vRP.upgradeStress(user_id,2)
		
		if math.random(1000) >= 750 then
			vRP.updateWanted(user_id,180)
			vRPC.playSound(source,"Enter_Area","DLC_Lowrider_Relay_Race_Sounds")
			TriggerClientEvent("Notify",source,"amarelo", "As autoridades foram notificadas da tentativa de roubo.", 5000)

			if math.random(100) >= 60 then
				TriggerClientEvent("vrp_evidence:RegisterFingerprint",source)
			end
			
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local copAmount = vRP.numPermission("Police")
			for k,v in pairs(copAmount) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Roubo a Residência", x = coords.x, y = coords.y, z = coords.z, time = "Recebido às "..os.date("%H:%M"), criminal = "Alarme de segurança" })
				end)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKHOMESTHEFT
-----------------------------------------------------------------------------------------------------------------------------------------
function checkHomesTheft(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	for homeName,v in pairs(homesList) do 
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 2.5 then

			if parseInt(theftTimes[homeName]) > 0 then
				TriggerClientEvent("Notify",source,"amarelo", "Aguarde "..completeTimers(parseInt(theftTimes[homeName])), 5000)
				return false
			else
				theftTimes[homeName] = 3600
				return homeName
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETHOMESTHEFT
-----------------------------------------------------------------------------------------------------------------------------------------
function resetHomesTheft(homeName)
	theftTimes[homeName] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.homeBlips()
	return homesConfig
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function atualizeBlip(type,homeName)
	if type == "remove" then
		homesConfig[homeName] = { ["color"] = 69, ["scale"] = 0.3, ["id"] = 411, ["x"] = homesList[homeName][1], ["y"] = homesList[homeName][2], ["z"] = homesList[homeName][3] }
	end

	if type == "update" then
		homesConfig[homeName] = { ["color"] = 49, ["scale"] = 0.3, ["id"] = 411, ["x"] = homesList[homeName][1], ["y"] = homesList[homeName][2], ["z"] = homesList[homeName][3] }
	end

end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLOAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for k,v in pairs(homesList) do
		local checkExist = vRP.query("vRP/homePermission", { name = k })
		if checkExist[1] == nil then
			homesConfig[k] = { ["color"] = 69, ["scale"] = 0.3, ["id"] = 411, ["x"] = v[1], ["y"] = v[2], ["z"] = v[3] }
		else
			homesConfig[k] = { ["color"] = 49, ["scale"] = 0.3, ["id"] = 411, ["x"] = v[1], ["y"] = v[2], ["z"] = v[3] }
		end
		Citizen.Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("enterHomes",enterHomes)
exports("checkHomesTheft",checkHomesTheft)
exports("resetHomesTheft",resetHomesTheft)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG COMENTAR
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)
--  	vCLIENT.updateHomes(-1)
-- end)
