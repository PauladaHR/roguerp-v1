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
Tunnel.bindInterface("vrp_mdthospital",cRP)
-------------------------------------------------------------------------------------------------------------------------------------------
-- WORKINGTIMER
-------------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("vRP/addworkingtime","INSERT INTO vrp_worktime(user_id,job,time) VALUES(@user_id,@job,@time)")
vRP._prepare("vRP/getworkingtime","SELECT * FROM vrp_worktime WHERE user_id = @user_id AND job = @job")
vRP._prepare("vRP/updtworkingtime","UPDATE vrp_worktime SET time = time + 1 WHERE user_id = @user_id AND job = @job")
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLOR EMERGENCY
-----------------------------------------------------------------------------------------------------------------------------------------
local emergencyProntuarios = {
	[1] = "style='background: rgb(163, 46, 46); color: #cacaca;",
	[2] = "style='background: rgb(163, 103, 46); color: #cacaca;",
	[3] = "style='background: rgb(109, 102, 48); color: #cacaca;",
	[4] = "style='background: rgb(63, 109, 48); color: #cacaca;",
	[5] = "style='background: rgb(48, 65, 109); color: #cacaca;"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTA
-----------------------------------------------------------------------------------------------------------------------------------------
local emergencySpecialty = {
	[1] = "Clínico Geral",
	[2] = "Pediatria",
	[3] = "Cardiologia",
	[4] = "Ginecologia",
	[5] = "Endocrinologia",
	[6] = "Nefrologia",
	[7] = "Anestesiologia",
	[8] = "Cirurgia Geral",
	[9] = "Cirurgia Plástica",
	[10] = "Dermatologia",
	[11] = "Infectologia",
	[12] = "Neurologia",
	[13] = "Obstetrícia",
	[14] = "Oftalmologia",
	[15] = "Oncologia",
	[16] = "Ortopedia",
	[17] = "Patologia",
	[18] = "Proctologia",
	[19] = "Psiquiatria",
	[20] = "Sexologia",
	[21] = "Traumatologia",
	[22] = "Urologia",
	[23] = "Nutrologia"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXAMES
-----------------------------------------------------------------------------------------------------------------------------------------
local examesSpecialty = {
	[1] = "Ultrassonografia",
	[2] = "Raio X",
	[3] = "Beta HCG",
	[4] = "Hemograma Completo",
	[5] = "Tomografia",
	[6] = "Ressonância"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMEDIOS
-----------------------------------------------------------------------------------------------------------------------------------------
local drugsHospital = {
	--[1] = {
	--	["name"] = "adrenaline",
	--	["price"] = 3000,
	--	["pricemedic"] = 500,
	--	["maxquantity"] = 1
	--},
	[2] = {
		["name"] = "bandage",
		["price"] = 600,
		["pricemedic"] = 300,
		["maxquantity"] = 3
	},
	[3] = {
		["name"] = "gauze",
		["price"] = 700,
		["pricemedic"] = 300,
		["maxquantity"] = 3
	},
	[4] = {
		["name"] = "warfarin",
		["price"] = 1600,
		["pricemedic"] = 450,
		["maxquantity"] = 1
	},
	[5] = {
		["name"] = "sinkalmy",
		["price"] = 800,
		["pricemedic"] = 100,
		["maxquantity"] = 3
	},
	[6] = {
		["name"] = "ritmoneury",
		["price"] = 1300,
		["pricemedic"] = 300,
		["maxquantity"] = 1
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETORNO
-----------------------------------------------------------------------------------------------------------------------------------------
local needFeedback = {
	[1] = "Sim",
	[2] = "Não"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERMDT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.registerMDT(user,box,text,type,date)
	local source = source
	local user_id = vRP.getUserId(source)
	local finaldate = {}

	if date then
		finaldate = os.date("%d/%m/%Y ás %H:%M:%S")
	else
		finaldate = tostring("Aguardando")
	end

	if user_id then
		local identity = vRP.getUserIdentity(parseInt(user_id))
		local nidentity = vRP.getUserIdentity(parseInt(user))
		if nidentity then
			vRP.query("vRP/add_mdtmedic",{ user_id = user, medic = parseInt(user_id), type = tostring(type), box = parseInt(box), date = finaldate, text = tostring(text) })
			TriggerClientEvent("Notify",source,"amarelo","Solicitação de <b>"..nidentity["name"].." "..nidentity["name2"].."</b> registrado com sucesso.",5000)
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET TYPE USER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getTypeUser(user,type,utils)
	local data = vRP.query("vRP/get_medic_type_user",{ user_id = user, type = type })
	local request = {}
	local especialidade = {}

	if data then
		for k,v in pairs(data) do

			if utils then
				especialidade = emergencySpecialty[parseInt(v.box)]
			else
				especialidade = examesSpecialty[parseInt(v.box)]
			end
			
			local identity = vRP.getUserIdentity(v.user_id)
			if identity then
				local nidentity = vRP.getUserIdentity(v.medic)
				table.insert(request,{ medic = tostring(nidentity.name.." "..nidentity.name2), date = v.date, date2 = v.date2, text = v.text, text2 = v.text2, specialty = especialidade })
			end
		end
		return request
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET TRIAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getProntuarios(user_id)
	local data = vRP.query("vRP/get_medic_type_user",{ user_id = user_id, type = "Prontuarios" })
	local prontuarios = {}
	if data then
		for k,v in pairs(data) do
			local identity2 = vRP.getUserIdentity(v.user_id)
			if identity2 then
				local identity = vRP.getUserIdentity(v.medic)
				local identity3 = vRP.getUserIdentity(v.utils)
				table.insert(prontuarios,{ medic = tostring(identity.name.." "..identity.name2), socorrist = tostring(identity3.name.." "..identity3.name2), date = v.date2, text = v.text, text2 = v.text2, color = emergencyProntuarios[parseInt(v.box)] })
			end
		end
		return prontuarios
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CONSULTAS MEDICOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getExamesMedic()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.query("vRP/get_medic_type_user_medic",{ user_id = user_id, type = "myExames" })
		local myexames = {}
		if data then
			for k,v in pairs(data) do
				local identity2 = vRP.getUserIdentity(v.user_id)
				if identity2 then
					local identity = vRP.getUserIdentity(v.medic)
					table.insert(myexames,{ table = v.id, medic = tostring(identity.name.." "..identity.name2), user_id = tostring(identity2.name.." "..identity2.name2), user_passaporte = v.user_id, date = v.date, date2 = v.date2, text = v.text, text2 = v.text2, specialty = examesSpecialty[parseInt(v.box)] })
				end
			end
			return myexames
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CONSULTAS MEDICOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getConsultasMedic()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.query("vRP/get_medic_type_user_medic",{ user_id = user_id, type = "myConsults" })
		local myconsults = {}
		if data then
			for k,v in pairs(data) do
				local identity2 = vRP.getUserIdentity(v.user_id)
				if identity2 then
					local identity = vRP.getUserIdentity(v.medic)
					local retornowait = {}

					if v.utils == null then
						retornowait = "Aguardando"
					else
						retornowait = needFeedback[parseInt(v.utils)]
					end

					table.insert(myconsults,{ table = v.id, medic = tostring(identity.name.." "..identity.name2), user_id = tostring(identity2.name.." "..identity2.name2), user_passaporte = v.user_id, date = v.date, date2 = v.date2, text = v.text, text2 = v.text2, retorno = retornowait, especialidade = emergencySpecialty[parseInt(v.box)] })
				end
			end
			return myconsults
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET TRIAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getTriagem()
	local source = source
	local data = vRP.query("vRP/get_medic_type",{ type = "requestTriagem" })
	local triagem = {}
	if data then
		for k,v in pairs(data) do
			local identity2 = vRP.getUserIdentity(v.user_id)
			if identity2 then
				local identity = vRP.getUserIdentity(v.medic)
				table.insert(triagem,{ table = v.id, iduser = v.user_id, medic = tostring(identity.name.." "..identity.name2), user_id = tostring(identity2.name.." "..identity2.name2), user_passaporte = v.user_id, date = v.date, text = v.text, text2 = v.text2, color = emergencyProntuarios[parseInt(v.box)] })
			end
		end
		return triagem
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CONSULTAS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getConsultas()
	local source = source
	local data = vRP.query("vRP/get_medic_type",{ type = "requestConsulta" })
	local consultas = {}
	if data then
		for k,v in pairs(data) do
			local identity2 = vRP.getUserIdentity(v.user_id)
			local identity = vRP.getUserIdentity(v.medic)
			table.insert(consultas,{ table = v.id, medic = tostring(identity.name.." "..identity.name2), user_id = tostring(identity2.name.." "..identity2.name2), user_passaporte = v.user_id, number = tostring(identity2.phone), text = v.text, specialty = emergencySpecialty[parseInt(v.box)] })
		end
		return consultas
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CONSULTAS MEDICOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.ExamesMedic()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.query("vRP/get_medic_type",{ type = "resultExames" })
		local resultexames = {}
		if data then
			for k,v in pairs(data) do
				local identity2 = vRP.getUserIdentity(v.user_id)
				local identity = vRP.getUserIdentity(v.medic)
				table.insert(resultexames,{ medic = tostring(identity.name.." "..identity.name2), user_id = tostring(identity2.name.." "..identity2.name2), user_passaporte = v.user_id, date = v.date, date2 = v.date2, text = v.text, text2 = v.text2, specialty = examesSpecialty[parseInt(v.box)] })
			end
			return resultexames
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET EXAMES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getExames()
	local source = source
	local data = vRP.query("vRP/get_medic_type",{ type = "requestExames" })
	local exames = {}
	if data then
		for k,v in pairs(data) do
			local identity2 = vRP.getUserIdentity(v.user_id)
			local identity = vRP.getUserIdentity(v.medic)
			table.insert(exames,{ table = v.id, medic = tostring(identity.name.." "..identity.name2), user_id = tostring(identity2.name.." "..identity2.name2), user_passaporte = v.user_id, number = tostring(identity2.phone), specialty = examesSpecialty[parseInt(v.box)],  date = v.date, text = v.text, premium = true})
		end
		return exames
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE MDT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateMDT(table,name,type,update)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.query("vRP/update_consultas",{ id = table, user_id = user_id, type = type })
		vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify",source,"amarelo","Solicitação de <b>"..name.."</b> aceita e enviada para aba <b>Medicos</b> com sucesso.",5000)
		TriggerClientEvent("mdt:Update",source,update)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE TRIAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateTriagemUser(table,user,text)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.query("vRP/get_all_medic",{ id = table })
	local socorrist = data[1]["medic"]
	if user_id then
		local identity = vRP.getUserIdentity(parseInt(user))
		local identity2 = vRP.getUserIdentity(parseInt(user_id))
		if identity then
			vRP.query("vRP/update_prontuario",{ id = table, medic = user_id, utils = parseInt(socorrist), type = "Prontuarios", date2 = os.date("%d/%m/%Y ás %H:%M:%S"), text2 = tostring(text) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("mdt:Update",source,"functionMedic")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE EXAMES USER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateExamesUser(table,text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(parseInt(user_id))
		if identity then
			vRP.query("vRP/update_mdtmedic",{ id = table, medic = user_id, type = "resultExames", date2 = os.date("%d/%m/%Y ás %H:%M:%S"), text2 = tostring(text) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("mdt:Update",source,"myExames")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE INFOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateInfosUser(user,text,type)
	local source = source
	if user then
		local data = vRP.query("vRP/get_usermedic",{ user_id = user, type = type })
		if data[1] ~= nil then
			vRP.query("vRP/update_usermedic",{ user_id = user, type = type, text = tostring(text) })
		else
			vRP.query("vRP/add_usermedic",{ user_id = user, type = type, text = tostring(text) })
		end
		TriggerClientEvent("mdt:Update",source,"infoPage")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bloodUser(user)
	local source = source
	if user then
		local data = vRP.query("vRP/get_usermedic",{ user_id = user, type = "blood" })
		if data[1] ~= nil then
			vRP.query("vRP/update_blood",{ user_id = user, type = "blood", date = os.date("%d/%m/%Y ás %H:%M:%S") })
		else
			vRP.query("vRP/add_usermedic",{ user_id = user, type = "blood", quantity = parseInt(1), date = os.date("%d/%m/%Y ás %H:%M:%S") })
		end
		TriggerClientEvent("mdt:Update",source,"infoPage")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEL CONSULT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.delConsult(idconsult,name,type)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.query("vRP/del_consultas",{ id = idconsult })
		vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify",source,"verde","Consulta de <b>"..name.."</b> desmarcada com sucesso.",5000)
		if type == "Exames" then
			TriggerClientEvent("mdt:Update",source,"examesPendentes")
		end
		if type == "Consulta" then
			TriggerClientEvent("mdt:Update",source,"ocorrencyFunction")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET SERVIÇO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getWorker()
	local service = vRP.numPermission("Paramedic")
	local notservice = vRP.numPermission("waitParamedic")
	local nonDuty = 0
	local resultservice = {}

	for k,v in pairs(service) do
		if v.user_id then
			local identity = vRP.getUserIdentity(v.user_id)
			local parapusa = vRP.query("vRP/get_paramedic_promotion",{ user_id = parseInt(v.user_id), permiss = "Paramedic" })

			table.insert(resultservice,{ name = tostring(identity.name.." "..identity.name2), user_id = parseFormat(parseInt(v.user_id)), promotion = parseInt(parapusa[1].paramedic_time) })
			nonDuty = nonDuty + 1
		end
	end
	for k,v in pairs(notservice) do
		if v.user_id then
			local identity = vRP.getUserIdentity(v.user_id)
			local parapusa = vRP.query("vRP/get_paramedic_promotion",{ user_id = parseInt(v.user_id), permiss = "waitParamedic" })

			table.insert(resultservice,{ name = tostring(identity.name.." "..identity.name2), user_id = parseFormat(parseInt(v.user_id)), promotion = parseInt(parapusa[1].paramedic_time)  })
			nonDuty = nonDuty + 1
		end
	end
	return resultservice,nonDuty
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.medicPayment(passaporte,medicine,quantity)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPC.nearestPlayer(source,3)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id == passaporte then
		local medicname = drugsHospital[parseInt(medicine)]["name"]
		local maxmedic = drugsHospital[parseInt(medicine)]["maxquantity"]
		local price = drugsHospital[parseInt(medicine)]["price"]
		local pricemedic = drugsHospital[parseInt(medicine)]["pricemedic"]
		local data = vRP.query("vRP/get_all",{ user_id = passaporte, type = medicname })
		local quercomprar = {}

		if parseInt(quantity) > drugsHospital[parseInt(medicine)]["maxquantity"] then
			quercomprar = drugsHospital[parseInt(medicine)]["maxquantity"]
		else
			quercomprar = quantity
		end

		local nSource = vRP.getUserSource(passaporte)
		if data[1] ~= nil then
			local podecomprar = maxmedic - data[1]["quantity"]

			if parseInt(os.time()) <= parseInt(data[1]["create_at"]+1*60*60) then
				local request = vRP.request(nSource,"Você deseja concluir a compra de <b>"..vRP.itemNameList(medicname).."</b> por <b>$"..parseFormat(parseInt(price*quercomprar)).."</b> dólares?",30)
				if request then
					if parseInt(quercomprar) <= parseInt(podecomprar) then
						if vRP.paymentBank(parseInt(passaporte),parseInt(price*quercomprar)) then
							vRP.addBank(user_id,parseInt(pricemedic*quercomprar))
							vRP.giveInventoryItem(parseInt(passaporte),medicname,parseInt(quercomprar),true)
							vRP.query("vRP/update_quantity_medicine",{ user_id = parseInt(passaporte), type = tostring(medicname), quantity = parseInt(quercomprar) })
						else
							TriggerClientEvent("Notify",nSource,"vermelho","Dinheiro insuficiente.",5000)
						end
					else
						if podecomprar == 0 then
							TriggerClientEvent("Notify",source,"vermelho","O paciente atingiu o limite de compras momento.",5000)
						else
							TriggerClientEvent("Notify",source,"vermelho","O paciente só pode comprar <b>"..podecomprar.."</b> no momento.",5000)
						end
					end
				end
			else
				local request = vRP.request(nSource,"Hospital","Você deseja concluir a compra de <b>"..vRP.itemNameList(medicname).."</b> por <b>$"..parseFormat(parseInt(price*quantity)).."</b> dólares?",30)
				if request then
					if parseInt(quantity) <= parseInt(maxmedic) then
						if vRP.paymentBank(parseInt(passaporte),parseInt(price*quantity)) then
							vRP.addBank(user_id,parseInt(pricemedic*quantity))
							vRP.giveInventoryItem(parseInt(passaporte),medicname,parseInt(quantity),true)
							vRP.query("vRP/update_time_medicine",{ user_id = parseInt(passaporte), type = tostring(medicname), quantity = parseInt(quantity), create_at = parseInt(os.time()) })
						else
							TriggerClientEvent("Notify",nSource,"vermelho","Dinheiro insuficiente.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","O paciente só pode comprar <b>"..maxmedic.."</b> no momento.",5000)
					end
				end
			end
		else
			local request = vRP.request(nSource,"Hospital","Você deseja concluir a compra de <b>"..vRP.itemNameList(medicname).."</b> por <b>$"..parseFormat(parseInt(price*quantity)).."</b> dólares?",30)
			if request then
				if parseInt(quantity) <= parseInt(maxmedic) then
					if vRP.paymentBank(parseInt(passaporte),parseInt(price*quantity)) then
						vRP.addBank(user_id,parseInt(pricemedic*quantity))
						vRP.giveInventoryItem(parseInt(passaporte),medicname,parseInt(quantity),true)
						vRP.query("vRP/add_medicine",{ user_id = parseInt(passaporte), type = tostring(medicname), quantity = parseInt(quantity), create_at = parseInt(os.time()) })
					else
						TriggerClientEvent("Notify",nSource,"vermelho","Dinheiro insuficiente.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","O paciente só pode comprar <b>"..maxmedic.."</b> no momento.",5000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getInfos(data)
    if data then
        local identity = vRP.getUserIdentity(data)
		if identity then
			local userallergy = vRP.query("vRP/get_usermedic",{ user_id = data, type = "allergy" })
			local usersickness = vRP.query("vRP/get_usermedic",{ user_id = data, type = "sickness" })
			local userblood = vRP.query("vRP/get_usermedic",{ user_id = data, type = "blood" })
			local allergy = {}
			local sickness = {}
			local bloodquantity = {}
			local blooddate = {}

			if userallergy[1] then
				allergy = userallergy[1].text
			else
				allergy = "Sem relatos."
			end

			if usersickness[1] then
				sickness = usersickness[1].text
			else
				sickness = "Sem relatos."
			end

			if userblood[1] then
				bloodquantity = userblood[1].quantity
				blooddate = userblood[1].date
			else
				bloodquantity = "Nenhuma"
				blooddate = ""
			end

			return parseInt(data),identity.name,identity.name2,identity.phone,identity.registration,allergy,sickness,bloodquantity,blooddate
		end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.anuncioHosp(text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.query("vRP/add_usermedic",{ user_id = user_id, type = "announce", text = tostring(text), date = os.date("%d/%m/%Y ás %H:%M:%S") })
		local amountParamedic = vRP.numPermission("Paramedic")
		for k,v in pairs(amountParamedic) do
			async(function()
				TriggerClientEvent("Notify",v,"azul","Anúncio da diretoria do hospital.",10000)
				vRPC.playSound(v,"Enter_Area","DLC_Lowrider_Relay_Race_Sounds")
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestAnnounce()
	local data = vRP.query("vRP/get_allmedic",{ type = "announce" })
	local announce = {}

	for k,v in pairs(data) do 
		local identity = vRP.getUserIdentity(v.user_id)
		table.insert(announce,{ table = v.id, medic = tostring(identity.name.." "..identity.name2), date = v.date, text = v.text })
	end
	return announce
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEL ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.delAnnounce(table)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.query("vRP/del_usermedic",{ id = table })
		TriggerClientEvent("mdt:Update",source,"functionAnnounce")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTRATAR MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.contractMedic(passport)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(passport)
	if user_id then
        if not vRP.hasPermission(passport,"Paramedic") or not vRP.hasPermission(passport,"waitParamedic") then
			TriggerEvent("setPlayer",parseInt(passport),parseInt(2))
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"verde","Você contratou <b>"..identity["name"].." "..identity["name2"].."</b> para o grupo de <b>Paramedicos</b>.",10000)
		else
			TriggerClientEvent("Notify",source,"vermelho","<b>"..identity["name"].." "..identity["name2"].."</b> já faz parte do grupo de <b>Paramedicos</b>.",10000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESLIGAR MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.desligarUser(user)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user)
	if user_id then
		TriggerEvent("removePlayer",parseInt(user),parseInt(2))
		vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify",source,"verde","Você demitiu <b>"..identity["name"].." "..identity["name2"].."</b> do grupo de <b>Paramedicos</b>.",10000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMOVER MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.promoverUser(user)
	local source = source
	local user_id = vRP.getUserId(source)
	local promotion = vRP.query("vRP/get_paramedic_promotion",{ user_id = parseInt(user), permiss = "Paramedic" })
	if user_id then
		if vRP.hasPermission(user,"Paramedic") then
			if parseInt(promotion[1].paramedic_time) < 4 then
				vRP.query("vRP/set1_paramedic_promotion",{ user_id = parseInt(user), permiss = "Paramedic" })
				TriggerClientEvent("Notify",source,"verde","Você promoveu o passaporte <b>"..user.."</b>.",10000)
			else
				TriggerClientEvent("Notify",source,"vermelho","Passaporte <b>"..user.."</b> atingiu o nível máximo de promoção.",10000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REBAIXAR MÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.rebaixarUser(user)
	local source = source
	local user_id = vRP.getUserId(source)
	local promotion = vRP.query("vRP/get_paramedic_promotion",{ user_id = parseInt(user), permiss = "Paramedic" })
	if user_id then
		if vRP.hasPermission(user,"Paramedic") then
			if parseInt(promotion[1].paramedic_time) > 0 then
				vRP.query("vRP/rem_paramedic_promotion",{ user_id = parseInt(user), permiss = "Paramedic" })
				TriggerClientEvent("Notify",source,"verde","Você rebaixou o passaporte <b>"..user.."</b>.",10000)
			else
				TriggerClientEvent("Notify",source,"vermelho","Passaporte <b>"..user.."</b> atingiu o nível mais baixo de promoção.",10000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE MY CONSULTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateMyConsults(data)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if data["data"] ~= "" and data["hora"] ~= "" then
			if data["texto"] == "" and data["bottonselected"] == "0" then
				local datefinal = ""..data["data"].. " ás " ..data["hora"]..""
				vRP.query("vRP/update_myconsults",{ id = data["number"], date = tostring(datefinal) })
				vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent("mdt:Update",source,"minhasConsultas")
			end
		else
			if data["texto"] ~= "" and data["bottonselected"] ~= "0" then
				vRP.query("vRP/update_finalconsult",{ id = data["number"], date2 = os.date("%d/%m/%Y ás %H:%M:%S"), utils = data["bottonselected"], text2 = tostring(data["texto"]) })
				vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent("mdt:Update",source,"minhasConsultas")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFEMININO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getGenero(user_id)
	local DataTable = vRP.userData(parseInt(user_id),"Datatable")
	if DataTable then
		if DataTable["skin"] == 1885233650 then
			return "Masculino"
		elseif DataTable["skin"] == -1667301416 then
			return "Feminino"
		else
			return "Indefinido"
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"ParMaster") then
            return true,1
        end
    end
    return false,0
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkMedic()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"Paramedic") then
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET TOP RANK PLAYERS (user_id, race_id, final_time) 
-----------------------------------------------------------------------------------------------------------------------------------------
local playersNames = {}
local myNames = {}

function cRP.rankJob()
    local source = source
	local user_id = vRP.getUserId(source)
	local count = 0
    local limit = 10
	local topPlayers = vRP.query("vRP/get_top_working",{ job = tostring("Paramedic"), limit = parseInt(limit) })
	local playersrank = {}

	for k,v in pairs(topPlayers) do
		local identity = vRP.getUserIdentity(parseInt(v.user_id))
		count = count + 1
		
		table.insert(playersrank,{ tops = count, name = tostring(identity.name.." "..identity.name2), user_id = parseFormat(parseInt(v.user_id)), time = completeTimers(parseInt(v.time)*600) })
	end
	return playersrank
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKING TIME
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.workingTime()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local workingtime = vRP.query("vRP/getworkingtime",{ user_id = user_id, job = "Paramedic" })
        if workingtime[1] ~= nil then
            vRP.query("vRP/updtworkingtime",{ user_id = user_id, job = "Paramedic" })
        else
            vRP.query("vRP/addworkingtime",{ user_id = user_id, job = "Paramedic", time = parseInt(1) })
        end
    end
end