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
vSERVER = Tunnel.getInterface("vrp_dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dynamic:buttonPlay")
AddEventHandler("vrp_dynamic:buttonPlay",function(title,description,trigger,par,server)
	SetNuiFocus(true,true)
	SendNUIMessage({ buttonadd = true, title = title, description = description, trigger = trigger, par = par, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dynamic:AddButton")
AddEventHandler("vrp_dynamic:AddButton",function(title,description,trigger,par,id,server,submenu,id2)
	SetNuiFocus(true,true)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server, submenu = submenu, id2 = id2 })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dynamic:addsubmenu")
AddEventHandler("vrp_dynamic:addsubmenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addsubmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dynamic:SubMenu")
AddEventHandler("vrp_dynamic:SubMenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server,submenu,id2)
	SetNuiFocus(true,true)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server, submenu = submenu, id2 = id2 })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("addsubmenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addsubmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("openMenu",function()
	SendNUIMessage({ show = true })
	SetNuiFocus(true,true)
	menuOpen = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("buttonPlay",function(title,description,trigger,par,server)
	SetNuiFocus(true,true)
	SendNUIMessage({ buttonadd = true, title = title, description = description, trigger = trigger, par = par, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(data,cb)
	if data["server"] == "true" then
		TriggerServerEvent(data["trigger"],data["param"])
	else
		TriggerEvent(data["trigger"],data["param"])
	end

	if data["trigger"] == "garages:vehicleTrust" then
		if data["param"] == "add" or data["param"] == "rem" then
			SendNUIMessage({ close = true })
			SetNuiFocus(false,false)
			menuOpen = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	menuOpen = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dynamic:closeSystem")
AddEventHandler("vrp_dynamic:closeSystem",function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		menuOpen = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dynamicHomes:closeSystem")
AddEventHandler("vrp_dynamicHomes:closeSystem",function()
	SendNUIMessage({ close = true })
	SetNuiFocus(false,false)
	menuOpen = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function(source)
	if not menuOpen then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			menuOpen = true

			exports["vrp_dynamic"]:AddButton("Vestir","Vestir as roupas salvas.","player:outfitFunctions","aplicar","outfit",true)
			exports["vrp_dynamic"]:AddButton("Guardar","Guardar as roupas do corpo.","player:outfitFunctions","salvar","outfit",true)
			exports["vrp_dynamic"]:AddButton("Roupas Íntimas","Remover a roupa atual.","player:outfitFunctions","remover","outfit",true)	
			exports["vrp_dynamic"]:AddButton("Sem roupas","Remover todas as roupas.","player:outfitFunctions","pelado","outfit",true)	

			exports["vrp_dynamic"]:AddButton("Desmanche","Listagem dos veículos.","hiro_dismantle:checkVehicleList","","others",true)

				if vSERVER.checkPremium() then
					exports["vrp_dynamic"]:AddButton("Premium","Checar tempo do premium.","player:checkPremium","","others",true)
					exports["vrp_dynamic"]:AddButton("Vestir Premium","Vestir as roupas salvas.","player:outfitFunctions","preaplicar","outfit",true)
					exports["vrp_dynamic"]:AddButton("Guardar Premium","Guardar as roupas do corpo.","player:outfitFunctions","presalvar","outfit",true)
				end

				if LocalPlayer["state"]["Mechanic"] then
					exports["vrp_dynamic"]:AddButton("Rebocar","Colocar veículo na prancha.","vrp_towdriver:invokeTow","","others",false)
				end

			exports["vrp_dynamic"]:AddButton("Propriedades","Ativa/Desativa as casas no mapa.","homes:togglePropertys","","others",false)

			if not IsPedInAnyVehicle(ped) then

				exports["vrp_dynamic"]:AddButton("Carregar pelos Braços","Carregar a pessoa mais próxima.","player:carryFunctions","bracos","player",true)
				exports["vrp_dynamic"]:AddButton("Carregar nos Ombros","Carregar a pessoa mais próxima.","player:carryFunctions","ombros","player",true)

				exports["vrp_dynamic"]:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:removeProps","hat","player",true)
				exports["vrp_dynamic"]:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:removeProps","mask","player",true)
				
				exports["vrp_dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","player")

				exports["vrp_dynamic"]:AddButton("Veículo","Colocar no veículo mais próximo.","","","vehicle",false,true,"vehicle2")

				exports["vrp_dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","vehicle2",true)
				exports["vrp_dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","vehicle2",true)

				exports["vrp_dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:rvFunctions","","vehicle",true)
				exports["vrp_dynamic"]:AddButton("Checar Porta-Malas","Verificar pessoa dentro do mesmo.","player:checkTrunk","","vehicle",true)

					exports["vrp_dynamic"]:AddButton("Funcionalidades","Outras funções de veículo.","","","vehicle",false,true,"vehicle4")

						exports["vrp_dynamic"]:AddButton("Transferir","Transferir veículo.","garages:vehicleFunctions","trans","vehicle4",true)
						exports["vrp_dynamic"]:AddButton("Rental","Checar veículos rental.","garages:vehicleFunctions","rental","vehicle4",true)
						exports["vrp_dynamic"]:AddButton("Veículos","Checar veículos.","garages:vehicleFunctions","vehs","vehicle4",true)

				exports["vrp_dynamic"]:AddButton("Chave","Emprestar chave do seu veículo.","","","vehicle",false,true,"vehicle3")

				exports["vrp_dynamic"]:AddButton("Emprestar","Emprestar chave.","garages:vehicleTrust","add","vehicle3",true)
				exports["vrp_dynamic"]:AddButton("Remover","Remover chave.","garages:vehicleTrust","rem","vehicle3",true)
				exports["vrp_dynamic"]:AddButton("Remover","Remover todas as chave.","garages:vehicleTrust","remAll","vehicle3",true)
				exports["vrp_dynamic"]:AddButton("Lista","Lista de permissões.","garages:vehicleTrust","remAll","vehicle3",true)

			else
				exports["vrp_dynamic"]:AddButton("Banco Dianteiro Esquerdo","Sentar no banco do motorista.","player:seatPlayer","1","vehicle",true)
				exports["vrp_dynamic"]:AddButton("Banco Dianteiro Direito","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",true)
				exports["vrp_dynamic"]:AddButton("Banco Traseiro Esquerdo","Sentar no banco do passageiro.","player:seatPlayer","3","vehicle",true)
				exports["vrp_dynamic"]:AddButton("Banco Traseiro Direito","Sentar no banco do passageiro.","player:seatPlayer","4","vehicle",true)
			end

			exports["vrp_dynamic"]:SubMenu("Roupas","Mudança de roupas rápidas.","outfit")

			exports["vrp_dynamic"]:SubMenu("Veículos","Todas as funções dos veículos.","vehicle")

			exports["vrp_dynamic"]:SubMenu("Outros","Outras funções.","others")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function(source)
	if LocalPlayer["state"]["Police"] or LocalPlayer["state"]["Paramedic"] or LocalPlayer["state"]["Mechanic"] or LocalPlayer["state"]["coolBeans"] or LocalPlayer["state"]["catCoffe"] or LocalPlayer["state"]["Bombeiro"] then
		if not menuOpen then

			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 then
				menuOpen = true

				exports["vrp_dynamic"]:AddButton("Serviço","Verificar companheiros em serviço.","player:servicoFunctions","","utilitys",true)

				if LocalPlayer["state"]["Police"] or LocalPlayer["state"]["Paramedic"] then
					if not IsPedInAnyVehicle(ped) then
						exports["vrp_dynamic"]:AddButton("Carregar pelos Braços","Carregar a pessoa mais próxima.","player:carryFunctions","bracos","player",true)
						exports["vrp_dynamic"]:AddButton("Carregar nos Ombros","Carregar a pessoa mais próxima.","player:carryFunctions","ombros","player",true)

						exports["vrp_dynamic"]:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:removeProps","hat","player",true)
						exports["vrp_dynamic"]:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:removeProps","mask","player",true)
						exports["vrp_dynamic"]:AddButton("Defusar","Desativar bomba do veículo.","vrp_race:defuseBomb","","player",true)


						exports["vrp_dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","player")

						exports["vrp_dynamic"]:AddButton("Veículo","Colocar no veículo mais próximo.","","","player",false,true,"vehicle2")

						exports["vrp_dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","vehicle2",true)
						exports["vrp_dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","vehicle2",true)

					end
				end

				if LocalPlayer["state"]["Police"] then
					exports["vrp_dynamic"]:AddButton("Computador","Abrir o dispositivo móvel.","police:openSystem","","utilitys",false)

					exports["vrp_dynamic"]:AddButton("LSPD","Fardamento de Aluno.","player:jobOutfitFunctions","PoliceAluno","prePolice",true)
					exports["vrp_dynamic"]:AddButton("LSPD","Fardamento de GRR.","player:jobOutfitFunctions","PoliceGRR","prePolice",true)
					exports["vrp_dynamic"]:AddButton("LSPD","Fardamento de RPD.","player:jobOutfitFunctions","PoliceRP","prePolice",true)
					exports["vrp_dynamic"]:AddButton("LSPD","Fardamento de RPD 2.","player:jobOutfitFunctions","PoliceRP2","prePolice",true)
					exports["vrp_dynamic"]:AddButton("LSPD","Fardamento de GIT.","player:jobOutfitFunctions","PoliceGIT","prePolice",true)

					exports["vrp_dynamic"]:SubMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
					exports["vrp_dynamic"]:SubMenu("Utilidades","Todas as funções dos policiais.","utilitys")

				elseif LocalPlayer["state"]["Paramedic"] then
					exports["vrp_dynamic"]:AddButton("Computador","Abrir o dispositivo móvel.","paramedic:openSystem","","utilitys",false)

					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Paramédico.","player:jobOutfitFunctions","Paramedico","preMedic",true)
					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Enfermeiro.","player:jobOutfitFunctions","Enfermeiro","preMedic",true)
					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Residente.","player:jobOutfitFunctions","Residente","preMedic",true)
					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Médico.","player:jobOutfitFunctions","Medico","preMedic",true)
					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Diretor.","player:jobOutfitFunctions","Diretor","preMedic",true)
					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Pediatria.","player:jobOutfitFunctions","Pediatria","preMedic",true)
					exports["vrp_dynamic"]:AddButton("Medical Center","Fardamento de Cirurgia.","player:jobOutfitFunctions","Cirurgia","preMedic",true)

					exports["vrp_dynamic"]:SubMenu("Fardamentos","Todos os fardamentos médicos.","preMedic")
					exports["vrp_dynamic"]:SubMenu("Utilidades","Todas as funções dos paramédicos.","utilitys")
				elseif LocalPlayer["state"]["Mechanic"] then
					exports["vrp_dynamic"]:AddButton("Barra Fix","Fardamento de Aluno.","player:jobOutfitFunctions","MecânicaAluno","preMec",true)
					exports["vrp_dynamic"]:AddButton("Barra Fix","Fardamento de Mecânico.","player:jobOutfitFunctions","Mecanica","preMec",true)
					exports["vrp_dynamic"]:AddButton("Barra Fix","Fardamento de Gerencia.","player:jobOutfitFunctions","MecânicaGerencia","preMec",true)

					exports["vrp_dynamic"]:SubMenu("Fardamentos","Todos os fardamentos de Mecânico.","preMec")
				elseif LocalPlayer["state"]["catCoffe"] then
					exports["vrp_dynamic"]:AddButton("UwU Café","Roupas de Restaurante.","player:jobOutfitFunctions","catCoffe","preCat",true)

					exports["vrp_dynamic"]:SubMenu("Roupas","Roupas de Restaurante.","preCat")
				elseif LocalPlayer["state"]["coolBeans"] then
					exports["vrp_dynamic"]:AddButton("Cool Beans","Roupas de Restaurante.","player:jobOutfitFunctions","coolBeans","preCool",true)

					exports["vrp_dynamic"]:SubMenu("Fardamentos","Roupas de Restaurante.","preCool")

				elseif LocalPlayer["state"]["Bombeiro"] then
					exports["vrp_dynamic"]:AddButton("Bombeiro","Roupas de Ação.","player:jobOutfitFunctions","coolBeans","BombeiroAcao",true)
					exports["vrp_dynamic"]:AddButton("Bombeiro","Roupas de QG.","player:jobOutfitFunctions","BombeiroQG","preBomb",true)
					exports["vrp_dynamic"]:AddButton("Bombeiro","Roupas de Atendimento.","player:jobOutfitFunctions","BombeiroAtendimento","preBomb",true)

					exports["vrp_dynamic"]:SubMenu("Fardamentos","Roupas de Bombeiro.","preBomb")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emergência.","keyboard","F10")