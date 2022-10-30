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
cRP = {}
Tunnel.bindInterface("vrp_garages",cRP)
vCLIENT = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehList = {}
local vehPlates = {}
local spawnTimers = {}
local searchTimers = {}
local vehSignal = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGELOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local garageLocates = {
	-- Garages
	["1"] = { name = "Garagem", payment = false },
	["2"] = { name = "Garagem", payment = true },
	["3"] = { name = "Garagem", payment = true },
	["4"] = { name = "Garagem", payment = true },
	["5"] = { name = "Garagem", payment = true },
	["6"] = { name = "Garagem", payment = true },
	["7"] = { name = "Garagem", payment = true },
	["8"] = { name = "Garagem", payment = true },
	["9"] = { name = "Garagem", payment = true },
	["10"] = { name = "Garagem", payment = true },
	["11"] = { name = "Garagem", payment = true },
	["12"] = { name = "Garagem", payment = true },
	["13"] = { name = "Garagem", payment = true },
	["14"] = { name = "Garagem", payment = true },
	["15"] = { name = "Garagem", payment = true },
	["16"] = { name = "Garagem", payment = true },
	["17"] = { name = "Garagem", payment = true },
	["18"] = { name = "Garagem", payment = true },
	["19"] = { name = "Garagem", payment = true },
	["20"] = { name = "Garagem", payment = true },
	["21"] = { name = "Policia", payment = false, perm = "Police" },
	["22"] = { name = "PoliciaHeli", payment = false, perm = "Police" },
	["23"] = { name = "Paramedico", payment = false, perm = "Paramedic" },
	["24"] = { name = "Heliparamedico", payment = false, perm = "Paramedic" },
	["25"] = { name = "coolBeans", payment = false, perm = "coolBeans" },
	["26"] = { name = "catCoffe", payment = false, perm = "catCoffe" },
	["27"] = { name = "Motorista", payment = false },
	["28"] = { name = "Embarcações", payment = true },
	["29"] = { name = "Embarcações", payment = true },
	["30"] = { name = "Embarcações", payment = true },
	["31"] = { name = "Embarcações", payment = true },
	["32"] = { name = "Jornaleiro", payment = false },
	["33"] = { name = "Lenhador", payment = false },
	["34"] = { name = "Lixeiro", payment = false },
	["35"] = { name = "Caminhoneiro", payment = false },
	["36"] = { name = "Taxi", payment = false },
	["37"] = { name = "Mecânica", payment = false, perm = "Mechanic" },
	["38"] = { name = "Bicicletário", payment = false },
	["39"] = { name = "Garagem", payment = true },
	["40"] = { name = "Construtor", payment = false },
	["41"] = { name = "Piscineiro", payment = false },
	["42"] = { name = "Jardineiro", payment = false },
	["43"] = { name = "Eletricista", payment = false },
	["44"] = { name = "Garagem", payment = true},
	-- ["45"] = { name = "Fedex", payment = false, perm = "Fedex" },
	["46"] = { name = "Garagem", payment = false },
	["47"] = { name = "Bicicletário", payment = false },
	-- ["48"] = { name = "Lavagem03", payment = false, perm = "Lavagem03" },
	["49"] = { name = "Municao01", payment = false, perm = "Municao01" },
	["50"] = { name = "Garagem", payment = false },
	["51"] = { name = "Garagem", payment = false },
	["52"] = { name = "Garagem", payment = false },
	["53"] = { name = "Garagem", payment = false },
	["54"] = { name = "Municao03", payment = false, perm = "Municao03" },
	["55"] = { name = "Arma03", payment = false, perm = "Arma03" },
	["56"] = { name = "CasaLago", payment = false, perm = "CasaLago" },
	["57"] = { name = "Embarcacao", payment = false },
	["58"] = { name = "Embarcacao", payment = false },
	["59"] = { name = "Embarcacao", payment = false },
	["60"] = { name = "Embarcacao", payment = false },
	["61"] = { name = "Pearls", payment = false, perm = "Pearls" },
	["62"] = { name = "Garagem", payment = true },
	["63"] = { name = "Bombeiro", payment = false, perm = "Bombeiro" },
	["64"] = { name = "Lavagem01", payment = false, perm = "Lavagem01" },
	["65"] = { name = "Garagem", payment = false, },
	["66"] = { name = "Juiz", payment = false, perm = "Juiz" },
	["67"] = { name = "CasaBombeiros", payment = false, perm = "CasaBombeiros" },
	["68"] = { name = "Garagem", payment = false },
	["69"] = { name = "Garagem", payment = false },
	["70"] = { name = "Garagem", payment = false }, 
	["71"] = { name = "Arma02", payment = false }, 
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("signalRemove")
AddEventHandler("signalRemove",function(vehPlate)
	vehSignal[vehPlate] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateReveryone")
AddEventHandler("plateReveryone",function(vehPlate)
	if vehPlates[vehPlate] then
		vehPlates[vehPlate] = nil

		TriggerClientEvent("vrp_garages:syncRemlates",-1,vehPlate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- setPlateEveryone
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("setPlateEveryone")
AddEventHandler("setPlateEveryone",function(vehPlate)
	if vehPlates[vehPlate] == nil then
		vehPlates[vehPlate] = true

		TriggerClientEvent("vrp_garages:syncPlates",-1,vehPlate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- setPlatePlayers
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("setPlatePlayers")
AddEventHandler("setPlatePlayers",function(vehPlate,user_id)
	local plateId = vRP.getVehiclePlate(vehPlate)
	if not plateId then
		vehPlates[vehPlate] = user_id
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local workgarage = {
	["Paramedico"] = {
		"ambulance",
		"paramedicotahoe"
	},
	["Heliparamedico"] = {
		"paramedicoheli",
		"seasparrow"
	},
	["Policia"] = {
		"lib18chargerrb",
		"polraptor",
		"poltaurus",
		"VRdm1200",
		"polmustang",
		"zr1RB",
		"pbus",
		"poltah"
	},
	["PoliciaHeli"] = {
		"B412"
	},
	["Prisão"] = {
		"pbus"
	},
	["Motorista"] = {
		"bus"
	},
	["Bombeiro"] = {
		"firetruk"
	},
	["Embarcacao"] = {
		"marquis",
		"seashark",
		"predator",
		"dinghy"
	},
	["Piscineiro"] = {
		"bison2"
	},
	["Lixeiro"] = {
		"trash"
	},
	["Juiz"] = {
		"baller5",
		"riot"
	},
	["Caminhoneiro"] = {
		"packer"
	},
	["Taxi"] = {
		"taxi"
	},
	["Mecânica"] = {
		"flatbed",
		"towtruck",
		"r1250"
	},
	["Bicicletário"] = {
        "bmx"
    },
	["Jornaleiro"] = {
        "bmx"
    },
	["coolBeans"] = {
        "taco4",
		"faggio"
    },
	["catCoffe"] = {
        "taco3",
		"faggio"
    },
	["Pearls"] = {
        "taco3",
		"faggio"
    },
	["Construtor"] = {
		"scrap"
	},
	["Lavagem01"] = {
		"rumpo"
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.myVehicles(garageWork)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myVehicle = {}
		local garageName = garageLocates[garageWork]["name"]
		local vehicle = vRP.query("vRP/get_vehicle",{ user_id = parseInt(user_id) })

		if workgarage[garageName] then
			for k,v in pairs(workgarage[garageName]) do
				local veh = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = v })
				if veh[1] then
					table.insert(myVehicle,{ name = veh[1]["vehicle"], name2 = vRP.vehicleName(veh[1]["vehicle"]), engine = parseInt(veh[1]["engine"] * 0.1), body = parseInt(veh[1]["body"] * 0.1), fuel = parseInt(veh[1]["fuel"]) })
				else
					table.insert(myVehicle,{ name = v, name2 = vRP.vehicleName(v), engine = 100, body = 100, fuel = 100 })
				end
			end
		else
			for k,v in ipairs(vehicle) do
				if v["work"] == "false" then
					table.insert(myVehicle,{ name = vehicle[k]["vehicle"], name2 = vRP.vehicleName(vehicle[k]["vehicle"]), engine = parseInt(vehicle[k]["engine"] * 0.1), body = parseInt(vehicle[k]["body"] * 0.1), fuel = parseInt(vehicle[k]["fuel"]) })
				end
			end
		end

		return myVehicle
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.spawnVehicles(vehName,garageName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if spawnTimers[user_id] == nil then
			spawnTimers[user_id] = true

			local vehNet = nil
			for k,v in pairs(vehList) do
				if parseInt(v[1]) == parseInt(user_id) and v[2] == vehName then
					vehNet = parseInt(k)
					break
				end
			end

			local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })

			if vehicle[1] == nil then
				vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlateNumber(), work = tostring(true) })
				vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })
			end

			if vehNet == nil then
				local vehPrice = vRP.vehiclePrice(vehName)

				if os.time() >= parseInt(vehicle[1]["tax"] + 24 * 10 * 60 * 60) then
						TriggerClientEvent("Notify",source,"amarelo","Taxa do veículo atrasada, efetue o pagamento<br>através do seu tablet no sistema da concessionária.",5000)
				elseif parseInt(os.time()) <= parseInt(vehicle[1]["time"] + 24 * 60 * 60) then
					local status = vRP.request(source,"Veículo detido, deseja acionar o seguro pagando <b>$"..parseFormat(vehPrice * 0.01).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,vehPrice * 0.01) then
							vRP.execute("vRP/set_arrest",{ user_id = parseInt(user_id), vehicle = vehName, arrest = 0, time = 0 })
						else
							TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
						end
					end
				elseif parseInt(vehicle[1]["arrest"]) >= 1 then
					local status = vRP.request(source,"Veículo detido, deseja acionar o seguro pagando <b>$"..parseFormat(vehPrice * 0.1).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,vehPrice * 0.1) then
							vRP.execute("vRP/set_arrest",{ user_id = parseInt(user_id), vehicle = vehName, arrest = 0, time = 0 })
						else
							TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
						end
					end
				else
					-- if parseInt(vehicle[1]["rental"]) > 0 then
					-- 	if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
					-- 		TriggerClientEvent("Notify",source,"amarelo","Validade do veículo expirou, efetue a renovação do mesmo.",5000)
					-- 		spawnTimers[user_id] = nil

					-- 		return
					-- 	end
					-- end

					local mHash = GetHashKey(vehName)
					local checkSpawn,vehCoords = vCLIENT.spawnPosition(source)
					if checkSpawn then

						local vehMods = nil
						local custom = vRP.query("vRP/get_srvdata",{ key = "custom:"..user_id..":"..vehName })
						if parseInt(#custom) > 0 then
							vehMods = custom[1]["dvalue"]
						end

						if garageLocates[garageName]["payment"] then
							if vRP.userPremium(user_id) then
								local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

								while not DoesEntityExist(vehObject) do
									Wait(1)
								end

								local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
								vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"])
								vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
								TriggerEvent("setPlateEveryone",vehicle[1]["plate"])
								vehPlates[vehicle[1]["plate"]] = user_id
							else
								local vehTax = vehPrice * 0.1
								if vehTax >= 2000 then
									vehTax = 2000
								end
								if vRP.request(source,"Deseja retirar o veículo pagando <b>$"..parseFormat(vehTax).."</b> dólares?",30) then
									if vRP.getBank(user_id) >= parseInt(vehTax) then
										local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)
										while not DoesEntityExist(vehObject) do
											Wait(1)
										end

										local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
										vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"])
	
		
										TriggerEvent("setPlateEveryone",vehicle[1]["plate"])
										vehPlates[vehicle[1]["plate"]] = user_id
										vehList[netVeh] = { user_id,vehName }
									else
										TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
									end
								end
							end
						else
							local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

							while not DoesEntityExist(vehObject) do
								Wait(1)
							end

							local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
							vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"])
							vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
							TriggerEvent("setPlateEveryone",vehicle[1]["plate"])
							vehPlates[vehicle[1]["plate"]] = user_id
						end
					end
				end
			else
				local vehPlate = vehicle[1]["plate"]
				if vehSignal[vehPlate] == nil then
					if GetGameTimer() >= searchTimers[user_id] then
						searchTimers[user_id] = GetGameTimer() + 60000

						local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
						if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) then
							vCLIENT.searchBlip(source,GetEntityCoords(idNetwork))
							TriggerClientEvent("Notify",source,"amarelo","Rastreador do veículo foi ativado por <b>30 segundos</b>, lembrando que<br>se o mesmo estiver em movimento a localização pode ser imprecisa.",10000)
						else
							if vehList[vehNet] then
								vehList[vehNet] = nil
							end

							if vehPlates[vehicle[1]["plate"]] then
								vehPlates[vehicle[1]["plate"]] = nil
							end

							TriggerClientEvent("Notify",source,"verde","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","O rastreador só pode ser ativado a cada <b>60 segundos</b>.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Rastreador está desativado.",5000)
				end
			end

			spawnTimers[user_id] = nil
		else
			TriggerClientEvent("Notify",source,"amarelo","Existe uma busca por seu veículo em andamento.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPC.getPositions(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",60) and args[1] then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			local mHash = GetHashKey(args[1])
			local vehObject = CreateVehicle(mHash,coords["x"],coords["y"],coords["z"],heading,true,true)

			while not DoesEntityExist(vehObject) do
				Wait(1)
			end

			local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
			local vehPlate = "VEH"..parseInt(math.random(10000,99999) + user_id)
			vCLIENT.createVehicle(-1,mHash,netVeh,vehPlate,1000,1000,100,nil,false,false,false,{ 1.25,0.75,0.95 })
			vehList[netVeh] = { user_id,vehName,vehPlate }
			TaskWarpPedIntoVehicle(ped,vehObject,-1)
			TriggerEvent("setPlateEveryone",vehPlate)
			vehPlates[vehPlate] = user_id

			TriggerEvent("webhooks","car","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[SPAWNOU]: "..args[1].." \n[COORDS]: "..x..","..y..","..z..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","CAR - ADMIN")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPC.getPositions(source)
	if user_id then
		if vRP.hasRank(user_id,"Admin",40) then
			local vehicle = vRPC.getNearVehicle(source,15)
			if vehicle then
				vCLIENT.deleteVehicle(source,vehicle)

				local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,7)
				if vehName then
					TriggerEvent("webhooks","dv","```ini\n[========== DEU DV ==========]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[DEU DV]: "..vehName.." \n[COORDS]: "..x..","..y..","..z..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","DV - ADMIN")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_garages:lockVehicle")
AddEventHandler("vrp_garages:lockVehicle",function(vehNet,vehPlate,vehLock)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vehPlates[vehPlate] == user_id or vRP.CheckPlateTrust(user_id, vehPlate) then
			TriggerClientEvent("vrp_garages:vehicleLock",-1,vehNet,vehLock)

			if vehLock then
				TriggerClientEvent("sounds:Private",source,"unlocked",0.4)
				TriggerClientEvent("Notify",source,"amarelo","Veículo destrancado.",5000)
			else
				TriggerClientEvent("sounds:Private",source,"locked",0.3)
				TriggerClientEvent("Notify",source,"amarelo","Veículo trancado.",5000)
			end

			if not vRPC.inVehicle(source) then
				vRPC.playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)
				Wait(400)
				vRPC.stopAnim(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.tryDelete(vehNet,vehEngine,vehBody,vehFuel,vehDoors,vehWindows,vehTyres,vehPlate)
	if vehList[vehNet] and vehNet ~= 0 then
		local user_id = vehList[vehNet][1]
		local vehName = vehList[vehNet][2]

		if parseInt(vehEngine) <= 100 then
			vehEngine = 100
		end

		if parseInt(vehBody) <= 100 then
			vehBody = 100
		end

		if parseInt(vehFuel) >= 100 then
			vehFuel = 100
		end

		if parseInt(vehFuel) <= 5 then
			vehFuel = 5
		end

		local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName) })
		if vehicle[1] ~= nil then
			vRP.execute("vRP/set_update_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName), engine = parseInt(vehEngine), body = parseInt(vehBody), fuel = parseInt(vehFuel), doors = json.encode(vehDoors), windows = json.encode(vehWindows), tyres = json.encode(vehTyres) })
		end
	end

	TriggerEvent("vrp_garages:deleteVehicle",vehNet,vehPlate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_garages:deleteVehicle")
AddEventHandler("vrp_garages:deleteVehicle",function(vehNet,vehPlate)
	TriggerClientEvent("player:deleteVehicle",-1,vehNet,vehPlate)
	TriggerEvent("plateReveryone",vehPlate)

	if vehList[vehNet] then
		vehList[vehNet] = nil
	end

	if vehSignal[vehPlate] then
		vehSignal[vehPlate] = nil
	end
end)

RegisterNetEvent("vrp_garages:deleteVehicles")
AddEventHandler("vrp_garages:deleteVehicles",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local vehicle = vRPC.getNearVehicle(source,15)
	if vehicle then
		vCLIENT.deleteVehicle(source,vehicle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.returnGarages(garageName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if workgarage[garageLocates[garageName]["name"]] == nil then
			local getFines = vRP.getFines(user_id)
			if getFines[1] then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				return false
			end
		end

		if not vRP.wantedReturn(user_id) then
			if string.sub(garageName,0,2) == "LS" or string.sub(garageName,0,5) == "Beach" or string.sub(garageName,0,7) == "Mansion" or string.sub(garageName,0,7) == "Trailer" or string.sub(garageName,0,6) == "Paleto" or string.sub(garageName,0,5) == "Hotel" or string.sub(garageName,0,6) == "Ghetto" or string.sub(garageName,0,6) == "Rancho" or string.sub(garageName,0,9) == "Container" then
				local consult = vRP.query("vRP/homeUserPermission",{ user_id = parseInt(user_id), name = garageName })
				if consult[1] == nil then
					return false
				end
			end

			if garageLocates[garageName]["perm"] ~= nil then
				if vRP.hasPermission(user_id,garageLocates[garageName]["perm"]) then
					return vCLIENT.openGarage(source,garageName)
				end
			else
				return vCLIENT.openGarage(source,garageName)
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:vehicleFunctions")
AddEventHandler("garages:vehicleFunctions",function(vehFunctions)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)

		if vehFunctions == "trans" then
			TriggerClientEvent("vrp_dynamic:closeSystem",source)

			local vehName = vRP.prompt(source,"Vehicle Model:","")
			if vehName == "" then
				return
			end

			local myvehicles = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName) })
			if myvehicles[1] then

				local nuser_id = vRP.prompt(source,"Passport:","")
				if nuser_id == "" or parseInt(nuser_id) <= 0 then
					return
				end

				local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(nuser_id), vehicle = tostring(vehName) })
				if vehicle[1] then
					TriggerClientEvent("Notify",source,"amarelo", "O mesmo já possui um <b>"..vRP.vehicleName(vehName).."</b>.",5000)
					return
				end

				local nidentity = vRP.getUserIdentity(parseInt(nuser_id))
				local maxVehs = vRP.query("vRP/con_maxvehs",{ user_id = parseInt(nuser_id) })
				if parseInt(maxVehs[1]["qtd"]) >= parseInt(nidentity["garage"]) then
					TriggerClientEvent("Notify",source,"amarelo", "O mesmo atingiu o máximo de veículos em sua garagem.",5000)
					return
				end

				if myvehicles[1]["rental"] == 1 then
					TriggerClientEvent("Notify",source,"vermelho", "Você não pode transferir véiculos rental.", 5000)
					return
				end

				if vRP.request(source,"Deseja transferir o veículo <b>"..vRP.vehicleName(vehName).."</b> para <b>"..nidentity["name"].." "..nidentity["name2"].."</b>?",30) then
					vRP.execute("vRP/move_vehicle",{ user_id = parseInt(user_id), nuser_id = parseInt(nuser_id), vehicle = tostring(vehName) })
					
					local custom = vRP.getSData("custom:"..parseInt(user_id)..":"..tostring(vehName))
					local custom2 = json.decode(custom) or {}
					if custom and custom2 ~= nil then
						vRP.setSData("custom:"..parseInt(nuser_id)..":"..tostring(vehName),json.encode(custom2))
						vRP.execute("vRP/rem_srv_data",{ dkey = "custom:"..parseInt(user_id)..":"..tostring(vehName) })
					end
					
					local chest = vRP.getSData("chest:"..parseInt(user_id)..":"..tostring(vehName))
					local chest2 = json.decode(chest) or {}
					if chest and chest2 ~= nil then
						vRP.setSData("chest:"..parseInt(nuser_id)..":"..tostring(vehName),json.encode(chest2))
						vRP.execute("vRP/rem_srv_data",{ dkey = "chest:"..parseInt(user_id)..":"..tostring(vehName) })
					end
					TriggerEvent("webhooks","enviarcarro","```ini\n[======== ENVIAR CARRO ========]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[TRANSFERIU]: "..vRP.vehicleName(tostring(vehName)).." [PARA ID:] "..parseInt(nuser_id).." "..nidentity.name.." "..nidentity.name2.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").. " \r```","ENVIAR CARRO")
					TriggerClientEvent("Notify",source,"verde", "Transferência concluída com sucesso.", 5000)
				end
			end
		end

		if vehFunctions == "rental" then
			local myVehicle = vRP.query("vRP/get_rental_time",{ user_id = parseInt(user_id) })
			if parseInt(#myVehicle) >= 1 then
				for k,v in pairs(myVehicle) do
					local ownerVehicles = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(v.vehicle) })
					if ownerVehicles[1] then
						if vRP.vehicleClass(tostring(v.vehicle)) == "rental" and ownerVehicles[1].rental == 1 then
							if parseInt(os.time()) <= parseInt(ownerVehicles[1].rental_time+24*30*60*60) then
								TriggerClientEvent("Notify",source,"amarelo", "<b>Modelo:</b> "..vRP.vehicleName(v.vehicle).." ( "..v.vehicle.." )<br> <b>Placa:</b> "..v["plate"].." <br>Vence em: "..completeTimers(parseInt(86400*0-(os.time()-ownerVehicles[1].rental_time))),20000)
								Wait(1)
							end
						end
					end
				end
			end
		end

		if vehFunctions == "vehs" then
			local vehicle = vRP.query("vRP/get_vehicle",{ user_id = parseInt(user_id) })
			for k,v in ipairs(vehicle) do
				
				local ownerVehicles = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(v["vehicle"]) })
				if ownerVehicles[1] then
					if vRP.vehicleClass(tostring(v["vehicle"])) == "cars" or vRP.vehicleClass(tostring(v["vehicle"])) == "bikes" or vRP.vehicleClass(tostring(v["vehicle"])) == "rental" and ownerVehicles[1]["rental"] == 0 then
						if parseInt(os.time()) >= parseInt(ownerVehicles[1].tax+24*30*60*60) then
							TriggerClientEvent("Notify",source,"vermelho", "<b>Modelo:</b> "..vRP.vehicleName(v.vehicle).." ( "..v.vehicle.." )<br> <b>Placa:</b> "..v["plate"].." <br><b>Veh Tax:</b> Atrasado", 5000)
						else
							TriggerClientEvent("Notify",source,"amarelo", "<b>Modelo:</b> "..vRP.vehicleName(v.vehicle).." ( "..v.vehicle.." )<br> <b>Placa:</b> "..v["plate"].." <br>Taxa em: "..completeTimers(parseInt(86400*10-(os.time()-ownerVehicles[1].tax))),20000)
							Wait(1)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_garages:updateGarages")
AddEventHandler("vrp_garages:updateGarages",function(homeName,homeInfos)
	garageLocates[homeName] = { ["name"] = homeName, ["payment"] = false }

	-- CONFIG
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)
	configTable[homeName] = { ["name"] = homeName, ["payment"] = false }
	SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)

	-- LOCATES
	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)
	locatesTable[homeName] = homeInfos
	SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)

	TriggerClientEvent("vrp_garages:updateLocs",-1,homeName,homeInfos)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:REMOVEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_garages:removeGarages")
AddEventHandler("vrp_garages:removeGarages",function(homeName)
	if garageLocates[homeName] then
		garageLocates[homeName] = nil

		local configFile = LoadResourceFile("logsystem","garageConfig.json")
		local configTable = json.decode(configFile)
		if configTable[homeName] then
			configTable[homeName] = nil
			SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)
		end

		local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
		local locatesTable = json.decode(locatesFile)
		if locatesTable[homeName] then
			locatesTable[homeName] = nil
			SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)
		end

		TriggerClientEvent("vrp_garages:updateRemove",-1,homeName)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)

	for k,v in pairs(configTable) do
		garageLocates[k] = v
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_garages:allPlates",source,vehPlates)

	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)

	TriggerClientEvent("vrp_garages:allLocs",source,locatesTable)

	searchTimers[user_id] = GetGameTimer()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATETRUST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:vehicleTrust");
AddEventHandler("garages:vehicleTrust",function(functionTrust)
	local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,5)
		if vehicle then
			local searchID = vRP.getVehiclePlate(vehPlate)
			if searchID and searchID ~= nil and searchID == user_id then

				local nplayer = vRPC.nearestPlayer(source,3)
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)

					if functionTrust == "add" then
						local identity = vRP.getUserIdentity(user_id)
						if identity then
							if vRP.AddPlateTrust(nuser_id,vehPlate) then
								TriggerClientEvent("Notify",source,"verde", "Permissão à placa <b>"..vehPlate.."</b> dada ao passaporte <b>"..nuser_id.."</b>.", 8000)
							else 
								TriggerClientEvent("Notify",source,"vermelho", "Essa pessoa já possui acesso a essa placa.", 8000)
							end
						end
					end

					if functionTrust == "rem" then
						if vRP.DelPlateTrust(nuser_id,vehPlate) then
							TriggerClientEvent("Notify",source,"verde", "Permissão à placa <b>"..vehPlate.."</b> removida do passaporte <b>"..nuser_id.."</b>.",8000,"sucesso")
						else
							TriggerClientEvent("Notify",source,"vermelho", "Essa pessoa não possui acesso a essa placa.",8000)
						end
					end
				end
			
				if functionTrust == "remAll" then
					if vRP.DelPlateTrust(nil,vehPlate,"all") then
						TriggerClientEvent("Notify",source,"verde", "Permissão à placa <b>"..vehPlate.."</b> removida de todos os passaportes.", 8000)
					else
						TriggerClientEvent("Notify",source,"vermelho", "Ninguém possui acesso a essa placa.", 8000)
					end
				end

				if functionTrust == "list" then
					local txt = ""

					for k, v in pairs(vRP.GetPlateTrusts(vehPlate)) do
						local name = ''
						local identity = vRP.getUserIdentity(v.user_id)
						if identity then
							name = '<br>- [' .. identity.id .. '] ' .. identity.name .. ' ' .. identity.name2
						end
						txt = txt .. name
					end
					if txt == "" then
						TriggerClientEvent("Notify",source,"amarelo", "Não há acessos externos à placa <b>"..vehPlate.."</b>.",8000)
					else
						TriggerClientEvent("Notify",source,"amarelo", "ACESSOS À PLACA <b>"..vehPlate.."</b>:"..txt,8000)
					end
				end
			end
		end

	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHSIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("vehSignal",function(vehPlate)
	return vehSignal[vehPlate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if searchTimers[user_id] then
		searchTimers[user_id] = nil
	end

	if spawnTimers[user_id] then
		spawnTimers[user_id] = nil
	end
end)