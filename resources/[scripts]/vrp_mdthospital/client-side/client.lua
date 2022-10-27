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
Tunnel.bindInterface("vrp_tablet",cRP)
vSERVER = Tunnel.getInterface("vrp_mdthospital")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local isOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:openSystem")
AddEventHandler("paramedic:openSystem",function()
	if vSERVER.checkMedic() then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "openSystem" })

		if not IsPedInAnyVehicle(PlayerPedId()) then
			vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
		end
		TriggerEvent("vrp_dynamic:closeSystem")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZE WORKING TIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local workTimers = GetGameTimer()

	while true do
		if LocalPlayer["state"]["Paramedic"] then
			if GetGameTimer() >= workTimers then
				workTimers = GetGameTimer() + (10 * 60000)
				vSERVER.workingTime()
			end

		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	vRP.removeObjects("one")
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeSystem" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINFOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestGetInfos",function(data,cb)
    local passaporte,nome,sobrenome,phone,identity,allergy,sickness,bloodquantity,blooddate = vSERVER.getInfos(data.passaporte)
	local genero = vSERVER.getGenero(data.passaporte)
    if passaporte then
        cb({ passaporte = passaporte, nome = nome, sobrenome = sobrenome, phone = phone, identity = identity, genero = genero, allergy = allergy, sickness = sickness, bloodquantity = bloodquantity, blooddate = blooddate })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRONTUARIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("triagemUser",function(data,cb)
	if data.passaporte then
		vSERVER.registerMDT(data["passaporte"],data["bottonselected"],data["texto"],"requestTriagem",true)
		--vSERVER.triagemUser(data.passaporte,data.bottonselected,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("consultaUser",function(data,cb)
	if data.passaporte then
		vSERVER.registerMDT(data["passaporte"],data["bottonselected"],data["texto"],"requestConsulta",false)
		--vSERVER.consultaUser(data.passaporte,data.bottonselected,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OCCURRENCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("examesUser",function(data,cb)
	if data.passaporte then
		vSERVER.registerMDT(data["passaporte"],data["bottonselected"],data["texto"],"requestExames",true)
		--vSERVER.examesUser(data.passaporte,data.bottonselected,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTA MEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("consultaMedicUser",function(data,cb)
	if data.passaporte then
		vSERVER.registerMDT(data["passaporte"],data["bottonselected"],data["texto"],"myConsults",false)
		--vSERVER.consultaMedicUser(data.passaporte,data.bottonselected,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("examesMedicUser",function(data,cb)
	if data.passaporte then
		vSERVER.registerMDT(data["passaporte"],data["bottonselected"],data["texto"],"myExames",true)
		--vSERVER.examesMedicUser(data.passaporte,data.bottonselected,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPRONTUARIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMyConsults",function(data,cb)
	local resultado = vSERVER.getTypeUser(data["passaporte"],"myConsults",true)
	if resultado then
		cb(json.encode(resultado))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTEXAMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMyExames",function(data,cb)
	local resultado = vSERVER.getTypeUser(data["passaporte"],"resultExames",false)
	if resultado then
		cb(json.encode(resultado))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPRONTUARIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestProntuarios",function(data,cb)
	local resultado = vSERVER.getProntuarios(data.passaporte)
	if resultado then
		cb(json.encode(resultado))
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTRIAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestTriagem",function(data,cb)
	local resultado = vSERVER.getTriagem()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCONSULTAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestConsultas",function(data,cb)
	local resultado = vSERVER.getConsultas()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCONSULTAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestExames",function(data,cb)
	local resultado = vSERVER.getExames()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCONSULTAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestConsultaMedic",function(data,cb)
	local resultado = vSERVER.getConsultasMedic()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCONSULTAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestExamesMedic",function(data,cb)
	local resultado = vSERVER.getExamesMedic()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCONSULTAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("resultExames",function(data,cb)
	local resultado = vSERVER.ExamesMedic()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAnnounce",function(data,cb)
	local resultado = vSERVER.requestAnnounce()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTO-UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("mdt:Update")
AddEventHandler("mdt:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALL CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CallConsult",function(data)
	if data.number then
		vRP.removeObjects("one")
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "closeSystem" })
		TriggerEvent('smartphone:pusher', 'REDIRECT', '/contacts/dial')
		Citizen.Wait(100)
		TriggerEvent('smartphone:pusher','CALL_TO', data.number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("SmsConsult",function(data)
	if data.number then
		vRP.removeObjects("one")
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "closeSystem" })
		Citizen.Wait(500)
		TriggerEvent('smartphone:pusher','REDIRECT','/whatsapp/'..data.number..'')
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateConsult",function(data)
	if data.id then
		if data.type == "Consulta" then
			vSERVER.updateMDT(data["id"],data["user_id"],"myConsults","ocorrencyFunction")
		elseif data.type == "Exames" then
			vSERVER.updateMDT(data["id"],data["user_id"],"myExames","examesPendentes")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE TRIAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateTriagem",function(data)
	if data.id then
		if data.type == "Consulta" then
			vSERVER.updateConsult(data.id,data.user_id)
		elseif data.type == "Exames" then
			vSERVER.updateExame(data.id,data.user_id)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEL CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("delConsult",function(data)
	if data.id then
		vSERVER.delConsult(data.id,data.user_id,data.type)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT MEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("paymentMedic",function(data)
	if data.passaporte and data.quantidade then
		vSERVER.medicPayment(data.passaporte,data.bottonselected,data.quantidade)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALLERGY USER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("allergyUser",function(data)
	if data then
		vSERVER.updateInfosUser(data["passaporte"],data["text"],"allergy")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SICKNESS USER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sicknessUser",function(data)
	if data then
		vSERVER.updateInfosUser(data["passaporte"],data["text"],"sickness")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SICKNESS USER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bloodUser",function(data)
	if data then
		vSERVER.bloodUser(data.passaporte)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("getPermission",function(data,cb)
    local result = vSERVER.checkPermission()
    cb({ result = result })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE TRIAGEM USER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateTriagemUser",function(data,cb)
	if data.table_id then
		vSERVER.updateTriagemUser(data.table_id,data.user_id,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE MYEXAMES USER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateMyExames",function(data,cb)
	if data.table then
		vSERVER.updateExamesUser(data.table,data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("anuncioAdm",function(data,cb)
	if data.texto then
		vSERVER.anuncioHosp(data.texto)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEL ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("delAnnounce",function(data,cb)
	if data.table_id then
		vSERVER.delAnnounce(data.table_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ContractMedic",function(data,cb)
	if data.passaporte then
		vSERVER.contractMedic(data.passaporte)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateMyConsults",function(data,cb)
	if data.number then
		vSERVER.updateMyConsults(data)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPRONTUARIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("meDaOsTrabalhadores",function(data,cb)
	local resultado,number = vSERVER.getWorker()
	if resultado then
		cb({ resultado = resultado, number = number })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPRONTUARIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rankParamedic",function(data,cb)
	local resultado = vSERVER.rankJob()
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("promoverUser",function(data,cb)
	if data.user_id then
		vSERVER.promoverUser(data.user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rebaixarUser",function(data,cb)
	if data.user_id then
		vSERVER.rebaixarUser(data.user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("desligarUser",function(data,cb)
	if data.user_id then
		vSERVER.desligarUser(data.user_id)
	end
end)