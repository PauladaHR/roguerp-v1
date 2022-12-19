local vehList = {}

CreateThread(function()
	Wait(1000)

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