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
Tunnel.bindInterface("vrp_garages",cRP)
vSERVER = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehPlates = {}
local openGarage = ""
local searchBlip = nil
local spawnSelected = {}
local vehHotwired = false
local anim = "machinic_loop_mechandplayer"
local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local garageLocates = {
	["1"] = { x = 55.44, y = -876.17, z = 30.67, ["name"] = "Garagem",
		["1"] = { 60.44,-866.47,30.23,340.16 },
		["2"] = { 57.26,-865.35,30.25,340.16 },
		["3"] = { 54.03,-864.21,30.25,340.16 },
		["4"] = { 50.73,-863.01,30.26,340.16 },
		["5"] = { 60.52,-866.53,30.14,340.16 },
		["6"] = { 50.73,-873.28,30.11,158.75 },
		["7"] = { 47.36,-872.07,30.13,158.75 },
		["8"] = { 44.15,-870.9,30.13,158.75 }
	},
	["2"] = { x = 599.04, y = 2745.33, z = 42.04, ["name"] = "Garagem",
		["1"] = { 604.82,2738.27,41.64,187.09 },
		["2"] = { 601.75,2738.08,41.65,184.26 },
		["3"] = { 598.63,2737.85,41.69,184.26 },
		["4"] = { 595.59,2737.55,41.7,184.26 }
	},
	["3"] = { x = -136.8, y = 6356.84, z = 31.49, ["name"] = "Garagem",
		["1"] = { -133.72,6349.01,31.16,42.52 },
		["2"] = { -136.1,6346.53,31.16,42.52 }
	},
	["4"] = { x = 275.23, y = -345.56, z = 45.17, ["name"] = "Garagem",
		["1"] = { 266.06,-332.07,44.58,252.29 },
		["2"] = { 267.18,-328.9,44.58,252.29 },
		["3"] = { 268.32,-325.67,44.58,252.29 },
		["4"] = { 269.53,-322.4,44.58,252.29 },
		["5"] = { 270.77,-319.14,44.58,252.29 }
	},
	["5"] = { x = 596.43, y = 90.68, z = 93.13, ["name"] = "Garagem",
		["1"] = { 599.82,102.03,92.57,249.45 },
		["2"] = { 598.69,98.42,92.57,249.45 }
	},
	["6"] = { x = -340.57, y = 266.04, z = 85.68, ["name"] = "Garagem",
		["1"] = { -349.47,272.54,84.77,272.13 },
		["2"] = { -349.5,275.91,84.69,272.13 },
		["3"] = { -349.56,279.3,84.62,272.13 },
		["4"] = { -349.67,282.6,84.59,274.97 },
		["5"] = { -349.74,286.16,84.59,272.13 },
		["6"] = { -349.8,289.76,84.6,272.13 },
		["7"] = { -349.85,293.28,84.6,272.13 },
		["8"] = { -349.87,296.72,84.6,272.13 }
	},
	["7"] = { x = -2030.03, y = -465.99, z = 11.59, ["name"] = "Garagem",
		["1"] = { -2037.4,-461.02,11.07,138.9 },
		["2"] = { -2039.78,-459.07,11.07,138.9 },
		["3"] = { -2042.12,-457.1,11.07,138.9 },
		["4"] = { -2044.47,-455.11,11.07,138.9 },
		["5"] = { -2046.85,-453.09,11.07,138.9 },
		["6"] = { -2049.12,-451.17,11.07,138.9 },
		["7"] = { -2051.51,-449.23,11.07,138.9 }
	},
	["8"] = { x = -1184.94, y = -1509.99, z = 4.65, ["name"] = "Garagem",
		["1"] = { -1183.29,-1495.81,4.04,121.89 },
		["2"] = { -1185.23,-1493.28,4.04,121.89 },
		["3"] = { -1186.87,-1490.71,4.04,121.89 },
		["4"] = { -1188.69,-1488.27,4.04,121.89 }
	},
	["9"] = { x = 101.23, y = -1073.64, z = 29.37, ["name"] = "Garagem",
		["1"] = { 105.9,-1063.14,28.88,246.62 },
		["2"] = { 107.42,-1059.61,28.88,246.62 },
		["3"] = { 108.88,-1056.23,28.88,246.62 },
		["4"] = { 110.27,-1052.86,28.88,246.62 }
	},
	["10"] = { x = 213.97, y = -808.43, z = 31.0, ["name"] = "Garagem",
		["1"] = { 221.93,-804.11,30.35,249.45 },
		["2"] = { 222.9,-801.61,30.33,249.45 },
		["3"] = { 223.92,-799.2,30.33,249.45 },
		["4"] = { 224.85,-796.69,30.33,249.45 }
	},
	["11"] = { x = -348.89, y = -874.02, z = 31.31, ["name"] = "Garagem",
		["1"] = { -343.62,-875.51,30.75,167.25 },
		["2"] = { -339.98,-876.27,30.75,167.25 },
		["3"] = { -336.35,-876.98,30.75,167.25 },
		["4"] = { -332.72,-877.71,30.75,167.25 }
	},
	["12"] = { x = 67.72, y = 12.3, z = 69.22, ["name"] = "Garagem",
		["1"] = { 63.87,16.5,68.87,340.16 },
		["2"] = { 60.78,17.6,68.92,340.16 },
		["3"] = { 57.76,18.76,69.03,340.16 },
		["4"] = { 54.8,19.92,69.25,340.16 }
	},
	["13"] = { x = 361.96, y = 297.8, z = 103.88, ["name"] = "Garagem",
		["1"] = { 371.06,284.68,102.94,340.16 },
		["2"] = { 374.8,283.39,102.85,340.16 },
		["3"] = { 378.62,282.06,102.78,340.16 }
	},
	["14"] = { x = 1035.84, y = -763.87, z = 58.0, ["name"] = "Garagem",
		["1"] = { 1046.56,-774.55,57.69,90.71 },
		["2"] = { 1046.56,-778.24,57.68,90.71 },
		["3"] = { 1046.55,-782.0,57.68,90.71 },
		["4"] = { 1046.54,-785.65,57.66,90.71 }
	},
	["15"] = { x = -796.69, y = -2022.85, z = 9.17, ["name"] = "Garagem",
		["1"] = { -779.77,-2040.03,8.56,314.65 },
		["2"] = { -777.36,-2042.58,8.56,314.65 },
		["3"] = { -774.92,-2044.9,8.56,314.65 }
	},
	["16"] = { x = 453.28, y = -1146.77, z = 29.5, ["name"] = "Garagem",
		["1"] = { 467.33,-1151.89,28.96,85.04 },
		["2"] = { 467.16,-1154.75,28.96,85.04 },
		["3"] = { 467.1,-1157.73,28.96,87.88 }
	},
	["17"] = { x = 528.65, y = -146.25, z = 58.37, ["name"] = "Garagem",
		["1"] = { 540.99,-136.2,59.13,178.59 },
		["2"] = { 544.84,-136.25,59.01,178.59 },
		["3"] = { 548.83,-136.31,59.01,181.42 },
		["4"] = { 552.81,-136.41,58.99,178.59 }
	},
	["18"] = { x = -1159.56, y = -739.39, z = 19.88, ["name"] = "Garagem",
		["1"] = { -1144.95,-745.49,19.34,104.89 },
		["2"] = { -1142.76,-748.44,19.19,107.72 },
		["3"] = { -1140.18,-751.41,19.06,107.72 },
		["4"] = { -1137.99,-754.36,18.91,107.72 },
		["5"] = { -1135.43,-757.3,18.75,107.72 },
		["6"] = { -1133.12,-760.4,18.59,107.72 },
		["7"] = { -1130.59,-763.27,18.43,107.72 }
	},
	["19"] = { x = -3005.69, y = 81.53, z = 11.61, ["name"] = "Garagem",
		["1"] = { -2996.65,85.23,11.61,51.03 }
	},
	["20"] = { x = 935.95, y = 0.36, z = 78.76, ["name"] = "Garagem",
		["1"] = { 933.29,-3.74,78.44,147.41 }
	},
	["21"] = { x = 441.62, y = -988.86, z = 25.7, ["name"] = "Policia",
		["1"] = { 425.99,-989.03,25.02,269.19 },
		["2"] = { 426.39,-991.78,25.38,269.79 },
		["3"] = { 425.79,-994.4,25.38,270.05 },
		["4"] = { 426.5,-996.99,25.38,270.15 }
	},
	["22"] = { x = 463.66, y = -982.38, z = 43.7, ["name"] = "PoliciaHeli",
		["1"] = { 449.45,-981.21,44.08,92.08 }
	},
	["23"] = { x = -849.05, y = -1244.07, z = 6.93, ["name"] = "Paramedico",
		["1"] = { -847.0,-1240.38,6.94,320.97 },
		["2"] = { -856.01,-1233.83,6.93,320.54 }
	},
	["24"] = { x = -777.36, y = -1226.24, z = 15.56, ["name"] = "Heliparamedico", 
		["1"] = { -788.51,-1231.9,15.56,48.58 }
	},
	["25"] = { x = -1182.33, y = -1128.42, z = 5.71 , ["name"] = "CoolBeans",
		["1"] = { -1177.19,-1125.28,5.71,30.47 }
	},
	["26"] = { x = -618.11, y = -1065.92, z = 21.79, ["name"] = "Uwucafe",
		["1"] = { -620.8,-1062.56,21.79,269.64 }
	},
	["27"] = { x = 453.89, y = -600.79, z = 28.59, ["name"] = "Motorista",
		["1"] = { 462.65,-605.33,28.5,214.42 }
	},
	["28"] = { x = -1728.08, y = -1050.8, z = 1.7, ["name"] = "Embarcações",
		["1"] = { -1751.06,-1068.59,0.54,136.2 }
	},
	["29"] = { x = 1966.55, y = 3976.07, z = 31.5, ["name"] = "Embarcações",
		["1"] = { 1985.93,3990.01,29.86,299.06 }
	},
	["30"] = { x = -774.46, y = -1495.19, z = 2.65, ["name"] = "Embarcações",
		["1"] = { -802.69,-1504.29,-0.07,108.87 }
	},
	["31"] = { x = -893.96, y = 5687.78, z = 3.29, ["name"] = "Embarcações",
		["1"] = { -945.05,5677.37,0.1,108.89 }
	},
	["32"] = { x = -614.08, y = -939.92, z = 22.12, ["name"] = "Jornaleiro",
		["1"] = { -615.42,-933.07,22.36,99.22 }
	},	
	["33"] = { x = -841.34, y = 5401.07, z = 34.61, ["name"] = "Lenhador",
		["1"] = { -839.4,5407.88,33.74,9.13 }
	},	
	["34"] = { x = -340.96, y = -1567.54, z = 25.23, ["name"] = "Lixeiro",
		["1"] = { -338.87,-1560.78,25.24,96.03 }
	},	
	["35"] = { x = 1241.72, y = -3262.74, z = 5.53, ["name"] = "Caminhoneiro",
		["1"] = { 1275.05,-3267.22,5.99,89.12 }
	},
	["36"] = { x = 905.32, y = -165.42, z = 74.11, ["name"] = "Taxi",
		["1"] = { 908.17,-176.09,73.77,237.87 }
	},
	["37"] = { x = 853.01, y = -2132.0, z = 30.55, ["name"] = "Mecanica",
		["1"] = { 872.57,-2134.21,30.64,83.18 }
	},	
	["38"] = { x = 55.0, y = -1739.3, z = 29.6, ["name"] = "Bicicletário",
		["1"] = { 48.64,-1733.21,29.31,53.09 }
	},
	["39"] = { x = -791.6, y = 336.51, z = 85.7, ["name"] = "Garagem",
		["1"] = { -791.81,331.34,84.97,181.42 }
	},
	["40"] = { x = -90.85, y = -1032.19, z = 28.02, ["name"] = "Construtor",
		["1"] = { -102.8,-1034.54,27.26,314.65 }
	},
	["41"] = { x = -1161.0, y = -217.72, z = 37.96, ["name"] = "Piscineiro",
		["1"] = { -1154.2,-227.81,37.9,314.65 }
	},
	["42"] = { x = -491.22, y = -69.91, z = 40.39, ["name"] = "Jardineiro",
		["1"] = { -498.42,-65.86,39.77,153.08 }
	},
	["43"] = { x = 741.34, y = 139.76, z = 80.76, ["name"] = "Eletricista",
		["1"] = { 747.66,130.84,79.36,238.12 }
	},
	["44"] = { x = 204.7, y = -3133.04, z = 5.78, ["name"] = "Garagem",
		["1"] = { 207.84,-3122.09,5.78,87.88 }
	},
	-- ["45"] = { x = -940.22, y = -2963.24, z = 13.95, ["name"] = "Fedex",
	-- 	["1"] = { -955.07,-2989.97,14.89,59.96 }
	-- },
	["46"] = { x = 857.17, y = -2107.98, z = 30.55, ["name"] = "Garagem Mec",
		["1"] = { 851.47,-2110.84,29.92,266.66 }
	},
	["47"] = { x = -521.62, y = -262.25, z = 35.5, ["name"] = "Bicletário",
		["1"] = { -521.06,-264.68,35.34,142.96 }
	},
	-- ["48"] = { x = 1401.99, y = 1114.68, z = 114.84, ["name"] = "Lavagem03",
	-- 	["1"] = { 1394.44,1117.83,114.17,90.67 }
	-- },
	["49"] = { x = -1568.67, y = -394.67, z = 41.99, ["name"] = "Municao01",
		["1"] = { -1564.43,-387.12,41.31,230.83  }
	},
	["50"] = { x = -766.44, y = -1282.56, z = 5.0, ["name"] = "Garagem",
		["1"] = { -769.91,-1281.79,5.0,167.25 },
		["2"] = { -772.74,-1281.29,5.0,161.58 }
	},
	["51"] = { x = 1370.77, y = -726.3, z = 67.2, ["name"] = "Garagem",
	    ["1"] = { 1369.1,-734.93,66.62,98.5 }
    },
    ["52"] = { x = 1463.42, y = -29.0, z = 141.86, ["name"] = "Garagem",
	    ["1"] = { 1463.06,-35.11,140.1,107.44 }
    },
    ["53"] = { x = 1888.68, y = -1024.92, z = 79.09, ["name"] = "Garagem",
	    ["1"] = { 1892.99,-1027.83,78.4,343.01 }
	 },
	 ["54"] = { x = 101.33, y = 3644.31, z = 40.61, ["name"] = "Lavagem02",
	 	["1"] = { 93.14,3637.95,39.28,88.65 }
  	},
	["55"] = { x = -1779.12, y = 3073.22, z = 32.81, ["name"] = "Arma03",
	 	["1"] = { -1780.31,3083.95,32.81,239.56 }
  	},
	["56"] = { x = -101.12, y = 831.02, z = 235.92, ["name"] = "CasaLago",
	 	["1"] = { -105.87,833.87,235.72,351.29 }
  	},
	["57"] = { x = -1799.98, y = -1225.17, z = 1.58, ["name"] = "Embarcações",
	 	["1"] = { -1788.65,-1235.13,-0.15,231.97 }
  	},
	["58"] = { x = 1733.08, y = 3984.95, z = 31.98, ["name"] = "Embarcações",
	 	["1"] = { 1730.21,4000.56,29.74,12.02 }
  	},
	["59"] = { x = -1604.54, y = 5256.96, z = 2.08, ["name"] = "Embarcações",
	 	["1"] = { -1595.89,5268.5,-0.33,334.78 }
  	},
	["60"] = { x = -806.96, y = -1497.91, z = 1.6, ["name"] = "Embarcações",
	 	["1"] = { -822.15,-1499.0,-0.39,99.56 }
  	},
	["61"] = { x = -1803.54, y = -1198.02, z = 13.02, ["name"] = "Pearls",
	 	["1"] = { -1804.18,-1190.89,13.02,317.71 }
  	},
	["62"] = { x = -1378.93, y = -589.02, z = 29.89, ["name"] = "Garagem",
	 	["1"] = { -1370.03,-583.98,29.78,28.88 }
  	},
	["63"] = { x = 218.32, y = -1646.88, z = 29.78, ["name"] = "Bombeiro",
	 	["1"] = { 216.58,-1638.29,29.57,320.78 }
  	},
	["64"] = { x = 144.11, y = -1290.14, z = 29.35, ["name"] = "Lavagem01",
	 	["1"] = { 148.41,-1282.73,29.02,215.44 }
  	},
	["65"] = { x = -89.59, y = 819.82, z = 227.75, ["name"] = "Lavagem01",
	 	["1"] = { -86.4,818.17,227.6,270.62 }
  	},
	["66"] = { x = -505.33, y = -255.05, z = 35.66, ["name"] = "Juiz",
	 	["1"] = { -504.18,-258.92,35.55,107.62 }
  	},
	["67"] = { x = -815.33, y = 188.58, z = 72.48, ["name"] = "Bombeiros",
	 	["1"] = { -823.89,181.46,71.69,145.67 }
  	},
	["68"] = { x = 137.17, y = -1300.01, z = 29.23, ["name"] = "Garagem",
	 	["1"] = { 141.2,-1302.3,29.09,119.97 }
  	},
    ["69"] = { x = 961.78, y = -122.95, z = 74.36, ["name"] = "Municao03", 
		["1"] = { 966.32,-128.91,74.38,148.05 }
   },
   ["70"] = { x = 1407.32, y = 1114.41, z = 114.84, ["name"] = "Garagem",   
   		["1"] = { 1394.68,1117.3,114.84,87.27 }
   },
	["71"] = { x = -3031.96, y = 3330.53, z = 10.05, ["name"] = "Arma02",   
		["1"] = { -3025.12,3332.97,10.11,274.37 }
	},
	["72"] = { x = 1249.01, y = -1591.99, z = 54.16, ["name"] = "Arma02",   
		["1"] = { 1256.33,-1596.97,52.93,308.51 }
},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openGarage(garageName)
	openGarage = garageName
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "openNUI" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleMods(veh,vehCustom)
	if vehCustom then
		SetVehicleModKit(veh,0)

		if vehCustom["wheeltype"] ~= nil then
			SetVehicleWheelType(veh,vehCustom["wheeltype"])
		end

		for i = 0,16 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				SetVehicleMod(veh,i,vehCustom["mods"][tostring(i)])
			end
		end

		for i = 17,22 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				ToggleVehicleMod(veh,i,vehCustom["mods"][tostring(i)])
			end
		end

		for i = 23,24 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				if vehCustom["var"] == nil then
					vehCustom["var"] = {}
					vehCustom["var"][tostring(i)] = 0
				end

				SetVehicleMod(veh,i,vehCustom["mods"][tostring(i)],vehCustom["var"][tostring(i)])
			end
		end

		for i = 25,48 do
			if vehCustom["mods"][tostring(i)] ~= nil then
				SetVehicleMod(veh,i,vehCustom["mods"][tostring(i)])
			end
		end

		for i = 0,3 do
			SetVehicleNeonLightEnabled(veh,i,vehCustom["neon"][tostring(i)])
		end

		if vehCustom["extras"] ~= nil then
			for i = 1,12 do
				local onoff = tonumber(vehCustom["extras"][i])
				if onoff == 1 then
					SetVehicleExtra(veh,i,0)
				else
					SetVehicleExtra(veh,i,1)
				end
			end
		end

		if vehCustom["liverys"] ~= nil and vehCustom["liverys"] ~= 24  then
			SetVehicleLivery(veh,vehCustom["liverys"])
		end

		if vehCustom["plateIndex"] ~= nil and vehCustom["plateIndex"] ~= 4 then
			SetVehicleNumberPlateTextIndex(veh,vehCustom["plateIndex"])
		end

		SetVehicleXenonLightsColour(veh,vehCustom["xenonColor"])
		SetVehicleColours(veh,vehCustom["colors"][1],vehCustom["colors"][2])
		SetVehicleExtraColours(veh,vehCustom["extracolors"][1],vehCustom["extracolors"][2])
		SetVehicleNeonLightsColour(veh,vehCustom["lights"][1],vehCustom["lights"][2],vehCustom["lights"][3])
		SetVehicleTyreSmokeColor(veh,vehCustom["smokecolor"][1],vehCustom["smokecolor"][2],vehCustom["smokecolor"][3])

		if vehCustom["tint"] ~= nil then
			SetVehicleWindowTint(veh,vehCustom["tint"])
		end

		if vehCustom["dashColour"] ~= nil then
			SetVehicleInteriorColour(veh,vehCustom["dashColour"])
		end

		if vehCustom["interColour"] ~= nil then
			SetVehicleDashboardColour(veh,vehCustom["interColour"])
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.spawnPosition()
	local checkSlot = 0
	local checkPos = nil

	repeat
		checkSlot = checkSlot + 1

		if garageLocates[openGarage][tostring(checkSlot)] ~= nil then
			local _,groundZ = GetGroundZAndNormalFor_3dCoord(garageLocates[openGarage][tostring(checkSlot)][1],garageLocates[openGarage][tostring(checkSlot)][2],garageLocates[openGarage][tostring(checkSlot)][3])
			spawnSelected = { garageLocates[openGarage][tostring(checkSlot)][1],garageLocates[openGarage][tostring(checkSlot)][2],groundZ,garageLocates[openGarage][tostring(checkSlot)][4] }
			checkPos = GetClosestVehicle(spawnSelected[1],spawnSelected[2],spawnSelected[3],2.501,0,71)
		end
	until not DoesEntityExist(checkPos) or garageLocates[openGarage][tostring(checkSlot)] == nil

	if garageLocates[openGarage][tostring(checkSlot)] == nil then
		TriggerEvent("Notify","INFORMAÇÃO","Vagas estão ocupadas.",5000,'info')

		return false
	end

	return true,spawnSelected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.createVehicle(vehHash,vehNet,vehPlate,vehEngine,vehBody,vehFuel,vehCustom,vehWindows,vehDoors,vehTyres)
	if NetworkDoesNetworkIdExist(vehNet) then
		local nveh = NetToEnt(vehNet)
		if DoesEntityExist(nveh) then
			NetworkRegisterEntityAsNetworked(nveh)
			while not NetworkGetEntityIsNetworked(nveh) do
				NetworkRegisterEntityAsNetworked(nveh)
				Citizen.Wait(1)
			end

			SetNetworkIdCanMigrate(vehNet,true)
			NetworkSetNetworkIdDynamic(vehNet,false)
			SetNetworkIdExistsOnAllMachines(vehNet,true)

			SetVehicleNumberPlateText(nveh,vehPlate)
			SetEntityAsMissionEntity(nveh,true,true)
			SetVehicleHasBeenOwnedByPlayer(nveh,true)
			SetVehicleNeedsToBeHotwired(nveh,false)
			SetVehRadioStation(nveh,"OFF")

			if vehCustom ~= nil then
				local vehMods = json.decode(vehCustom)
				vehicleMods(nveh,vehMods)
			end

			SetVehicleEngineHealth(nveh,vehEngine + 0.0)
			SetVehicleBodyHealth(nveh,vehBody + 0.0)
			SetVehicleFuelLevel(nveh,vehFuel + 0.0)

			if vehWindows then
				if json.decode(vehWindows) ~= nil then
					for k,v in pairs(json.decode(vehWindows)) do
						if not v then
							SmashVehicleWindow(nveh,parseInt(k))
						end
					end
				end
			end

			if vehTyres then
				if json.decode(vehTyres) ~= nil then
					for k,v in pairs(json.decode(vehTyres)) do
						if v < 2 then
							SetVehicleTyreBurst(nveh,parseInt(k),(v == 1),1000.01)
						end
					end
				end
			end

			if vehDoors then
				if json.decode(vehDoors) ~= nil then
					for k,v in pairs(json.decode(vehDoors)) do
						if v then
							SetVehicleDoorBroken(nveh,parseInt(k),parseInt(v))
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deleteVehicle(vehicle)
	if IsEntityAVehicle(vehicle) then
		local vehWindows = {}
		local vehDoors = {}
		local vehTyres = {}

		for i = 0,5 do
			vehDoors[i] = IsVehicleDoorDamaged(vehicle,i)
		end

		for i = 0,5 do
			vehWindows[i] = IsVehicleWindowIntact(vehicle,i)
		end

		for i = 0,7 do
			local tyre_state = 2

			if IsVehicleTyreBurst(vehicle,i,true) then
				tyre_state = 1
			elseif IsVehicleTyreBurst(vehicle,i,false) then
				tyre_state = 0
			end

			vehTyres[i] = tyre_state
		end

		vSERVER.tryDelete(NetworkGetNetworkIdFromEntity(vehicle),GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle),vehDoors,vehWindows,vehTyres,GetVehicleNumberPlateText(vehicle))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("myVehicles",function(data,cb)
	local vehicles = vSERVER.myVehicles(openGarage)
	if vehicles then
		cb({ vehicles = vehicles })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnVehicles",function(data)
	vSERVER.spawnVehicles(data["name"],openGarage)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deleteVehicles",function(data)
	cRP.deleteVehicle(vRP.getNearVehicle(15))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLELOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:vehicleLock")
AddEventHandler("vrp_garages:vehicleLock",function(vehIndex,vehLock)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			if vehLock then
				SetVehicleDoorsLockedForAllPlayers(v,false)
			else
				SetVehicleDoorsLockedForAllPlayers(v,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchBlip(vehCoords)
	if DoesBlipExist(searchBlip) then
		RemoveBlip(searchBlip)
		searchBlip = nil
	end

	searchBlip = AddBlipForCoord(vehCoords["x"],vehCoords["y"],vehCoords["z"])
	SetBlipSprite(searchBlip,225)
	SetBlipColour(searchBlip,2)
	SetBlipScale(searchBlip,0.6)
	SetBlipAsShortRange(searchBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo")
	EndTextCommandSetBlipName(searchBlip)

	SetTimeout(30000,function()
		RemoveBlip(searchBlip)
		searchBlip = nil
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(garageLocates) do
				local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
				if distance <= 5 then
					timeDistance = 1
					
					DrawText3D(v["x"],v["y"],v["z"],"~w~ACESSAR: ~r~GARAGEM ")

					if IsControlJustPressed(1,38) and distance <= 1.0 then
						vSERVER.returnGarages(k)
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SYNCPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:syncPlates")
AddEventHandler("vrp_garages:syncPlates",function(vehPlate)
	vehPlates[vehPlate] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SYNCPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:syncRemlates")
AddEventHandler("vrp_garages:syncRemlates",function(vehPlate)
	vehPlates[vehPlate] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:ALLPLATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:allPlates")
AddEventHandler("vrp_garages:allPlates",function(vehTable)
	vehPlates = vehTable
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTANIMHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startAnimHotwired()
	vehHotwired = true

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(1)
	end

	TaskPlayAnim(PlayerPedId(),animDict,anim,3.0,3.0,-1,49,5.0,0,0,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPANIMHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stopAnimHotwired(vehicle)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(1)
	end

	vehHotwired = false
	StopAnimTask(PlayerPedId(),animDict,anim,2.0)

	if vehicle ~= nil then
		NetworkRegisterEntityAsNetworked(vehicle)
		while not NetworkGetEntityIsNetworked(vehicle) do
			NetworkRegisterEntityAsNetworked(vehicle)
			Citizen.Wait(1)
		end

		local vehNet = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(vehNet,true)
		NetworkSetNetworkIdDynamic(vehNet,false)
		SetNetworkIdExistsOnAllMachines(vehNet,true)

		SetEntityAsMissionEntity(vehicle,true,true)
		SetVehicleHasBeenOwnedByPlayer(vehicle,true)
		SetVehicleNeedsToBeHotwired(vehicle,false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateHotwired(status)
	vehHotwired = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local platext = GetVehicleNumberPlateText(vehicle)
			if GetPedInVehicleSeat(vehicle,-1) == ped and not vehPlates[platext] then
				SetVehicleEngineOn(vehicle,false,true,true)
				DisablePlayerFiring(ped,true)
				timeDistance = 1
			end

			if vehHotwired and vehicle then
				DisableControlAction(1,75,true)
				DisableControlAction(1,20,true)
				timeDistance = 1
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATELOCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:updateLocs")
AddEventHandler("vrp_garages:updateLocs",function(homeName,homeInfos)
	garageLocates[homeName] = homeInfos
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATEREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:updateRemove")
AddEventHandler("vrp_garages:updateRemove",function(homeName,homeInfos)
	if garageLocates[homeName] then
		garageLocates[homeName] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:ALLLOCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_garages:allLocs")
AddEventHandler("vrp_garages:allLocs",function(garageTable)
	for k,v in pairs(garageTable) do
		garageLocates[k] = v
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,128,19,54,60)
	end
end