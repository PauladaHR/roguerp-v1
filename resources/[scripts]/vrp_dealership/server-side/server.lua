-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("dealership",src)
vCLIENT = Tunnel.getInterface("dealership")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Cars"] = {}
GlobalState["Bikes"] = {}
GlobalState["Import"] = {}
GlobalState["Rental"] = {}
local cooldown = {}
local beneModels = {
    [1] = { model = "akuma" },
	[2] = { model = "zentorno" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local Cars = {}
	local Bikes = {}
	local Import = {}
	local Rental = {}
	local vehicles = vRP.vehicleGlobal()
	for k,v in pairs(vehicles) do

		if v["class"] == "cars" then
			table.insert(Cars,{ k = v["spawn"], nome = v["name"], price = parseInt(v["price"]), chest = parseInt(v["chestweight"]) or 50, stock = parseInt(v["stock"]), gems = parseInt(v["gems"]) })
		end
		
		if v["class"] == "bikes" then
			table.insert(Bikes,{ k = v["spawn"], nome = v["name"], price = parseInt(v["price"]), chest = parseInt(v["chestweight"]) or 50, stock = parseInt(v["stock"]), gems = parseInt(v["gems"]) })
		end

		if v["class"] == "import" then
			table.insert(Import,{ k = v["spawn"], nome = v["name"], price = parseInt(v["price"]), chest = parseInt(v["chestweight"]) or 50, stock = parseInt(v["stock"]), gems = parseInt(v["gems"]) })
		end

		if v["class"] == "rental" then
			table.insert(Rental,{ k = v["spawn"], nome = v["name"], price = parseInt(v["price"]), chest = parseInt(v["chestweight"]) or 50, stock = parseInt(v["stock"]), gems = parseInt(v["gems"])})
		end
	end

	GlobalState["Cars"] = Cars
	GlobalState["Bikes"] = Bikes
	GlobalState["Import"] = Import
	GlobalState["Rental"] = Rental
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("dealership:syncVehicles",source,beneModels)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dealership:setVehicles")
AddEventHandler("dealership:setVehicles",function(veh,slot)
	beneModels[slot].model = veh
	TriggerClientEvent("dealership:syncVehicles",-1,beneModels)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getVehicles(vehClass)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vehClass == "Carros" then
			return GlobalState["Cars"]
		end

		if vehClass == "Motos" then
			return GlobalState["Bikes"]
		end

		if vehClass == "Import" then
			return GlobalState["Import"]
		end

		if vehClass == "Aluguel" then
			return GlobalState["Rental"]
		end

		if vehClass == "Possuidos" then
			local possuidos = {}
			local vehicle = vRP.query("vRP/get_vehicle",{ user_id = parseInt(user_id) })
			for k,v in pairs(vehicle) do
				if vRP.vehicleClass(tostring(v.vehicle)) == "cars" or vRP.vehicleClass(tostring(v.vehicle)) == "bikes" or vRP.vehicleClass(tostring(v.vehicle)) == "rental" then

					local taxas = taxTimers(parseInt(86400*0-(os.time()-v.tax)))
					if parseInt(os.time()) >= parseInt(v.tax+24*10*60*60) then
						taxas = "Taxa Atrasada"
						table.insert(possuidos,{ k = v.vehicle, nome = vRP.vehicleName(v.vehicle), price = parseInt(vRP.vehiclePrice(v.vehicle)*0.75), chest = parseInt(vRP.vehicleChest(v.vehicle)), tax = taxas })
					else
						local taxas = taxTimers(parseInt(86400*10-(os.time()-v.tax)))
						table.insert(possuidos,{ k = v.vehicle, nome = vRP.vehicleName(v.vehicle), price = parseInt(vRP.vehiclePrice(v.vehicle)*0.75), chest = parseInt(vRP.vehicleChest(v.vehicle)), tax = taxas })
					end
				end
			end
			return possuidos
		end
		return GlobalState["Cars"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
local updateVehicle = {
	["cars"] = "updateCarros",
	["bikes"] = "updateMotos",
	["import"] = "updateImports",
	["rental"] = "updateImport"
}

function src.buyDealer(vehName)
	local source = source
	if vCLIENT.checkConnection(source) then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then

			local amountDealer = vRP.numPermission("Dealership")
			if parseInt(#amountDealer) >= 1 then
				if not vRP.hasPermission(user_id,"Dealership") and vRP.vehicleClass(vehName) ~= "rental" then
					TriggerClientEvent("Notify",source,"amarelo", "Há funcionarios da concessionária em serviço, faça um chamado!",10000)
					return
				end
			end

			local getFines = vRP.getFines(user_id)
			if getFines[1] then
				TriggerClientEvent("Notify",source,"vermelho", "Encontramos faturas/multas pendentes.", 5000)
				return
			end

			local maxVehs = vRP.query("vRP/con_maxvehs",{ user_id = parseInt(user_id) })
			if parseInt(maxVehs[1]["qtd"]) >= parseInt(identity["garage"]) then
				TriggerClientEvent("Notify",source,"amarelo", "Você atingiu o máximo de veículos em sua garagem.",5000)
				return
			end

			local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })
			if vehicle[1] then
				TriggerClientEvent("Notify",source,"amarelo", "Você já possui um <b>"..vRP.vehicleName(vehName).."</b>.",5000)
				return
			end

			local vehicleData = vRP.vehicleData(vehName)
			if parseInt(vehicleData["stock"]) <= 0 then
				TriggerClientEvent("Notify",source,"amarelo", "Estoque de <b>"..vehicleData["name"].."</b> indisponivel.",5000)
				return
			end

			if vehicleData["class"] == "cars" or vehicleData["class"] == "bikes" then
				local paymentPrice = 1.00
				if vRP.itemAmount(user_id,"discount") >= 1 then
					paymentPrice = 0.80
					vRP.removeInventoryItem(user_id,"discount",1,true)
					TriggerClientEvent("Notify",source,"verde","Desconto utilizado!")
				elseif vRP.hasPermission(user_id,"Dealership") then
					paymentPrice = 0.92
				end

				if vRP.paymentBank(user_id,parseInt(vehicleData["price"]*paymentPrice)) then
					setVehicle(user_id,vehName,parseInt(vehicleData["stock"])-1,vehicleData["class"])

					TriggerClientEvent("dealership:Update",source,updateVehicle[vehicleData["class"]])
				else
					TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.",5000)
				end
			elseif vehicleData["class"] == "rental" then
				if vRP.userPremium(user_id) then
					if vRP.paymentBank(user_id,parseInt(vehicleData["price"]*0.92)) then
						setVehicle(user_id,vehName,parseInt(vehicleData["stock"])-1,vehicleData["class"])

						TriggerClientEvent("dealership:Update",source,updateVehicle[vehicleData["class"]])
					else
						TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho", "Você não pode comprar veículos nesta categoria.",5000)
				end
			end
		end
	end 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT TAX
-----------------------------------------------------------------------------------------------------------------------------------------
function src.payTax(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local status = vRP.request(source,"Deseja efetuar o pagamento da taxa de <b>$"..vRP.format(parseInt(vRP.vehiclePrice(vehName)*0.10)).."</b> dólares?",60)
		if status then
			if vRP.paymentBank(user_id,parseInt(vRP.vehiclePrice(vehName)*0.10)) then
				vRP.execute("vRP/set_tax",{ user_id = parseInt(user_id), vehicle = vehName, tax = parseInt(os.time()) })
				TriggerClientEvent("vrp_dealership:Update",source,"requestPossuidos")
				TriggerClientEvent("Notify",source,"verde", "Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sellDealer(vehName)
	local source = source
	if vCLIENT.checkConnection(source) then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then

			local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })
			if vehicle[1] then
				local vehicleData = vRP.vehicleData(vehName)

					if parseInt(os.time()) >= parseInt(vehicle[1]["tax"]+24*10*60*60) then
						TriggerClientEvent("Notify",source,"negado","Seu <b>Vehicle Tax</b> está atrasado.",10000)
						return
					end

					local getFines = vRP.getFines(user_id)

					if getFines[1] then
						TriggerClientEvent("Notify",source,"vermelho", "Encontramos faturas/multas pendentes.", 5000,'negado')
						return
					end

					if vehicle[1]["rental"] == 1 then
						TriggerClientEvent("Notify",source,"vermelho", "Você não pode vender véiculos rental.", 5000)
						return
					end

					if user_id and cooldown[user_id] == 0 or not cooldown[user_id] then
						cooldown[parseInt(user_id)] = os.time() + 4
						local tax = 0.75

					
						vRP.execute("vRP/rem_srv_data",{ dkey = "custom:"..parseInt(user_id)..":"..vehName })
						vRP.execute("vRP/rem_srv_data",{ dkey = "chest:"..parseInt(user_id)..":"..vehName })
						vRP.execute("vRP/rem_vehicle",{ user_id = parseInt(user_id), vehicle = vehName })
						exports["oxmysql"]:executeSync("UPDATE vrp_vehicles SET stock = ? WHERE spawn = ?", { parseInt(vehicleData["stock"]) + 1, vehName })
						TriggerClientEvent("Notify",source,"amarelo", "Você vendeu um <b>"..vehicleData["name"].."</b> por <b>$"..vRP.format(parseInt(vehicleData["price"]*tax)).." dólares</b>.", 5000)
						vRP.addBank(user_id,parseInt(vehicleData["price"]*tax))
						TriggerClientEvent("dealership:Update",source,"updatePossuidos")
						TriggerClientEvent("dealership:Close",source)

						TriggerEvent("webhooks","cssvendas","```ini\n[======== VENDEDOR ========]\n[ID]: "..user_id.." "..identity["name"].." "..identity["name2"].." \n[VENDEU]: "  ..vehicleData["name"].. " por "..vRP.format(parseInt(vehicleData["price"]*tax)).." dólares. "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").. " \r```","VENDAS CSS - DEALERSHIP")
					end
				end
			if os.time() >= parseInt(cooldown[user_id]) then
				cooldown[user_id] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
function setVehicle(user_id,vehName,vehStock,vehClass)
	exports["oxmysql"]:executeSync("UPDATE vrp_vehicles SET stock = ? WHERE spawn = ?", { vehStock, vehName })
	vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlateNumber(), work = tostring(false) })
	vRP.execute("vRP/set_tax",{ user_id = parseInt(user_id), vehicle = vehName, tax = parseInt(os.time()) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local plateVehs = {}
function src.startDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if not vRP.wantedReturn(user_id) then
				if vRP.request(source,"Concessíonaria","Iniciar o teste por <b>$100</b> dólares?",60) then
					-- if vRP.paymentFull(user_id,100) then
						plateVehs[user_id] = "PDMS"..(1000 + user_id)

						TriggerEvent("setPlateEveryone",plateVehs[user_id])
						SetPlayerRoutingBucket(source,user_id)
						actived[user_id] = nil

						return true,plateVehs[user_id]
					-- else
					-- 	TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
					-- end
				end
			end

			actived[user_id] = nil
		end
	end
	
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.removeDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerEvent("plateReveryone",plateVehs[user_id])
		SetPlayerRoutingBucket(source,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id)
	if actived[user_id] then
		actived[user_id] = nil
	end

	if plateVehs[user_id] then
		plateVehs[user_id] = nil
	end
end)