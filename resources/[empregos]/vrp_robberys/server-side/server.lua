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
src = {}
Tunnel.bindInterface("vrp_robberys",src)
vCLIENT = Tunnel.getInterface("vrp_robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYAVAILABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local robberyAvailable = {
	["departamentStore"] = os.time(),
	["ammunation"] = os.time(),
	["fleecas"] = os.time(),
	["barbershop"] = os.time(),
	["banks"] = os.time(),
	["chicken"] = os.time()
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
local robberys = {
	["1"] = {
		["coords"] = { 28.24,-1338.832,29.5 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["2"] = {
		["coords"] = { 2548.883,384.850,108.63 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["3"] = {
		["coords"] = { 1159.156,-314.055,69.21 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["4"] = {
		["coords"] = { -710.067,-904.091,19.22 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["5"] = {
		["coords"] = { -43.652,-1748.122,29.43 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["6"] = {
		["coords"] = { 378.291,333.712,103.57 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["7"] = {
		["coords"] = { -3250.385,1004.504,12.84 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["8"] = {
		["coords"] = { 1734.968,6421.161,35.04 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 250,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["9"] = {
		["coords"] = { 546.450,2662.45,42.16 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["10"] = {
		["coords"] = { 1959.113,3749.239,32.35 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["11"] = {
		["coords"] = { 2672.457,3286.811,55.25 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["12"] = {
		["coords"] = { 1708.095,4920.711,42.07 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["13"] = {
		["coords"] = { -1829.422,798.491,138.2 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["14"] = {
		["coords"] = { -2959.66,386.765,14.05 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["15"] = {
		["coords"] = { -3048.155,585.519,7.91 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["16"] = {
		["coords"] = { 1126.75,-979.760,45.42 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["17"] = {
		["coords"] = { 1169.631,2717.833,37.16 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 250,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["18"] = {
		["coords"] = { -1478.67,-375.675,39.17 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["19"] = {
		["coords"] = { -1221.126,-916.213,11.33 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 200,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["20"] = {
		["coords"] = { 168.97,6644.71,31.69 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 250,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["21"] = {
		["coords"] = { -168.42,6318.8,30.58 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 250,
		["cops"] = 4,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["22"] = {
		["coords"] = { 1693.374,3761.669,34.71 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 120,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["23"] = {
		["coords"] = { 253.061,-51.643,69.95 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["24"] = {
		["coords"] = { 841.128,-1034.951,28.2 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["25"] = {
		["coords"] = { -330.467,6085.647,31.46 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 120,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["26"] = {
		["coords"] = { -660.987,-933.901,21.83 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["27"] = {
		["coords"] = { -1304.775,-395.832,36.7 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["28"] = {
		["coords"] = { -1117.765,2700.388,18.56 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Norte",
		["timer"] = 120,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["29"] = {
		["coords"] = { 2566.632,292.945,108.74 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["30"] = {
		["coords"] = { -3172.701,1089.462,20.84 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["31"] = {
		["coords"] = { 23.733,-1106.27,29.8 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["32"] = {
		["coords"] = { 808.914,-2158.684,29.62 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "bluecard",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 3,
		["payment"] = {
			{ "dollars2",80000,100000 }
		}
	},
	["33"] = {
		["coords"] = { -1210.409,-336.485,38.29 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "blackcard",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",48750,53750 }
		}
	},
	["34"] = {
		["coords"] = { -353.519,-55.518,49.54 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "blackcard",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",48750,53750 }
		}
	},
	["35"] = {
		["coords"] = { 311.525,-284.649,54.67 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "blackcard",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",48750,53750 }
		}
	},
	["36"] = {
		["coords"] = { 147.210,-1046.292,29.87 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "blackcard",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",48750,53750 }
		}
	},
	["37"] = {
		["coords"] = { -2956.449,482.090,16.2 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "blackcard",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",48750,53750 }
		}
	},
	["38"] = {
		["coords"] = { 1175.66,2712.939,38.59 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "blackcard",
		["locate"] = "Norte",
		["timer"] = 420,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",48750,53750 }
		}
	},
	["39"] = {
		["coords"] = { -822.23,-183.49,37.57 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["40"] = {
		["coords"] = { 136.42,-1709.84,29.3 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["41"] = {
		["coords"] = { -1284.54,-1118.05,7.0 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["42"] = {
		["coords"] = { 1933.27,3729.24,32.85 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Norte",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["43"] = {
		["coords"] = { 1210.49,-473.06,66.21 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["44"] = {
		["coords"] = { -33.16,-150.52,57.08 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Sul",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["45"] = {
		["coords"] = { -280.04,6228.79,31.7 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "lockpick",
		["locate"] = "Norte",
		["timer"] = 60,
		["cops"] = 2,
		["payment"] = {
			{ "dollars2",8750,11250 }
		}
	},
	["46"] = {
		["coords"] = { 990.79,-2149.75,30.21 },
		["name"] = "Açougueiro",
		["type"] = "chicken",
		["distance"] = 10.0,
		["cooldown"] = 360,
		["item"] = "lockpick",
		["locate"] = "Sul",
		["timer"] = 600,
		["cops"] = 6,
		["payment"] = {
			{ "dollars2",200000,250000 }
		}
	},
	["47"] = {
		["coords"] = { -104.386,6477.150,31.83 },
		["name"] = "Banco Paleto",
		["type"] = "banks",
		["distance"] = 10.0,
		["cooldown"] = 360,
		["item"] = "blackcard",
		["locate"] = "Norte",
		["timer"] = 900,
		["cops"] = 8,
		["payment"] = {
			{ "dollars2",350000,400000 }
		}
	},
	["48"] = {
		["coords"] = { 265.336,220.184,102.09 },
		["name"] = "Banco Central",
		["type"] = "banks",
		["distance"] = 20.0,
		["cooldown"] = 360,
		["item"] = "blackcard",
		["locate"] = "Sul",
		["timer"] = 900,
		["cops"] = 8,
		["payment"] = {
			{ "dollars2",1555555,1777777 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if robberys[robberyId] then
			local prev = robberys[robberyId]

			if os.time() >= robberyAvailable[prev["type"]] then
				local policeResult = vRP.numPermission("Police")
				if parseInt(#policeResult) >= parseInt(prev["cops"]) then
					if vRP.getInventoryItemAmount(user_id,prev["item"]) <= 0 then
						TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..vRP.itemNameList(prev["item"]).."</b>.",5000)
						return false
					end

					if vRP.tryGetInventoryItem(user_id,prev["item"],1) then
						robberyAvailable[prev["type"]] = os.time() + (prev["cooldown"] * 60)
						TriggerClientEvent("player:applyGsr",source)

						for k,v in pairs(policeResult) do
							async(function()
								TriggerClientEvent("NotifyPush",v,{ code = 31, title = prev["name"], x = prev["coords"][1], y = prev["coords"][2], z = prev["coords"][3], time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
								vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
							end)
						end

						return true
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function src.paymentRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.wantedTimer(user_id,900)
		for k,v in pairs(robberys[robberyId]["payment"]) do
			local value = math.random(v[2],v[3])
			vRP.generateItem(user_id,v[1],parseInt(value),true)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.inputRobberys(source,robberys)
end)
 -----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZEROBBERYES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("atualizerobberyes",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
		vCLIENT.inputRobberys(-1,robberys)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:JEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
local jewelryShowcase = {}
local jewelryTimers = os.time()
local jewelryCooldowns = os.time()
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:INITJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_robberys:initJewelry")
AddEventHandler("vrp_robberys:initJewelry",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if os.time() >= jewelryCooldowns then
			local policeResult = vRP.numPermission("Police")
			if parseInt(#policeResult) >= 5 then
				if vRP.getInventoryItemAmount(user_id,"pendrive") <= 0 then
					TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x Pendrive</b>.",5000)
					return false
				end

				if vRP.tryGetInventoryItem(user_id,"pendrive",1) then
					TriggerClientEvent("Notify",source,"SUCESSO","Sistema corrompido.",5000)
					jewelryCooldowns = os.time() + 7200
					jewelryTimers = os.time() + 600
					jewelryShowcase = {}

					for k,v in pairs(policeResult) do
						async(function()
							TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Joalheria", x = -633.07, y = -238.7, z = 38.06, time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
							vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
						end)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:JEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_robberys:jewelry")
AddEventHandler("vrp_robberys:jewelry",function(entity)
	local source = source
	local showcase = entity[1]
	local user_id = vRP.getUserId(source)
	if user_id then
		if os.time() <= jewelryTimers then
			if jewelryShowcase[showcase] == nil then
				jewelryShowcase[showcase] = true
				TriggerClientEvent("vRP:Cancel",source,true)
				vRPC.playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

				SetTimeout(20000,function()
					vRPC.stopAnim(source,false)
					vRP.upgradeStress(user_id,10)
					vRP.wantedTimer(user_id,60)
					TriggerClientEvent("vRP:Cancel",source,false)
					vRP.generateItem(user_id,"watch",math.random(10,20),true)
				end)
			else
				TriggerClientEvent("Notify",source,"vermelho","Vitrine vazia.",3000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Necessário corromper o sistema.",3000)
		end
	end
end)