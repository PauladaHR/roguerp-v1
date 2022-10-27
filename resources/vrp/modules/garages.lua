local vehList = {}

Citizen.CreateThread(function()
	Citizen.Wait(1000)

	print('^3[!] ^0Criação de veículos ^3iniciada^0')
	setupVehicleList()
	print('^2[!] ^0Criação de veículos ^2finalizada^0!')
end)

RegisterCommand("updatevehicle",function(source,args,rawCommand)
	if source ~= 0 then
		return
	end

	print('^3[!] ^0Atualização de veículos ^3iniciada^0')
	setupVehicleList()
	print('^2[!] ^0Atualização de veículos ^2finalizada^0')
end)

function setupVehicleList()
    vehList = {}
    local consult = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_vehicles`",{})
    for k,v in pairs(consult) do
        vehList[v["spawn"]] = {
            name = v["name"],
            price = parseInt(v["price"]),
            class = v["class"],
            stock = parseInt(v["stock"]),
            hash = parseInt(v["hash"]),
            chestweight = parseInt(v["chestweight"]),
            banned = parseInt(v["banned"]),
        }
    end
end

function vRP.vehicleGlobal()
	return exports["oxmysql"]:executeSync("SELECT * FROM vrp_vehicles", {})
end

function vRP.vehicleName(spawn)
    if vehList[spawn] then
        return vehList[spawn]["name"]
    end
end

function vRP.vehiclePrice(spawn)
    if vehList[spawn] then
        return parseInt(vehList[spawn]["price"])
    end
end

function vRP.vehicleClass(spawn)
    if vehList[spawn] then
        return vehList[spawn]["class"]
    end
end

function vRP.vehicleData(spawn)
    if vehList[spawn] then
        return vehList[spawn]
    end
end

function vRP.vehicleChest(spawn)
    if vehList[spawn] then
        return parseInt(vehList[spawn]["chestweight"])
    end
end

function vRP.vehicleStock(spawn)
    if vehList[spawn] then
        return parseInt(vehList[spawn]["stock"])
    end
end

function vRP.vehicleChest(spawn)
    if vehList[spawn] then
        return parseInt(vehList[spawn]["chestweight"])
    end
end

function tvRP.vehicleHash(hash)
	local vehHash = exports["oxmysql"]:executeSync("SELECT * FROM vrp_vehicles WHERE hash = ? ", { hash })
	if vehHash then
        return vehHash[1]
	end
end

function vRP.vehicleHashName(hash)
    local hashName = exports["oxmysql"]:executeSync("SELECT * FROM vrp_vehicles WHERE hash = ? ", { hash })
    if hashName then
        return hashName[1]["name"]
    end
end

function vRP.CheckPlateTrust(user_id, plate)
    local query = vRP.query('vRP/platetrust_select', {user_id = user_id, plate = plate})
    if query[1] and query[1] ~= nil then
        return true
    end
    return false
end

function vRP.GetPlateTrusts(plate)
    local query = vRP.query('vRP/platetrust_selecatall', {plate = plate})
    if query[1] and query[1] ~= nil then
        return query
    end
    return {}
end

function vRP.AddPlateTrust(user_id, plate)
    if not vRP.CheckPlateTrust(user_id, plate) then
        vRP.execute('vRP/platetrust_insert', {user_id = user_id, plate = plate})
        return true
    end
    return false
end

function vRP.DelPlateTrust(user_id, plate, status)
    if status and status == 'all' then
        if #vRP.GetPlateTrusts(plate) > 0 then
            vRP.execute('vRP/platetrust_deleteall', {plate = plate})
            return true
        end
    else
        if vRP.CheckPlateTrust(user_id, plate) then
            vRP.execute('vRP/platetrust_delete', {user_id = user_id, plate = plate})
            return true
        end
    end
    return false
end