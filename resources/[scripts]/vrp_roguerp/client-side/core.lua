local Tunnel = module("vrp","lib/Tunnel")

vSERVER = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeDrift = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function driftEnable()
	if timeDrift > GetGameTimer() then
		return
	end

	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) and not IsPedInAnyHeli(ped) and not IsPedInAnyBoat(ped) and not IsPedInAnyPlane(ped) then
		local Vehicle = GetVehiclePedIsIn(ped)
		if GetPedInVehicleSeat(Vehicle,-1) == ped then
			local speed = GetEntitySpeed(Vehicle) * 3.6
			if speed <= 100.0 and speed >= 5.0 then
				SetVehicleReduceGrip(Vehicle,true)
				timeDrift = GetGameTimer() + 5000

				if not GetDriftTyresEnabled(Vehicle) then
					SetDriftTyresEnabled(Vehicle,true)
					SetReduceDriftVehicleSuspension(Vehicle,true)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFTDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function driftDisable()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local Vehicle = GetLastDrivenVehicle()

		if GetDriftTyresEnabled(Vehicle) then
			SetVehicleReduceGrip(Vehicle,false)
			SetDriftTyresEnabled(Vehicle,false)
			SetReduceDriftVehicleSuspension(Vehicle,false)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEDRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+activeDrift",driftEnable)
RegisterCommand("-activeDrift",driftDisable)
RegisterKeyMapping("+activeDrift","Ativação do drift.","keyboard","LSHIFT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for i = 1,12 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDSWIMMING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedSwimming(ped) then
			timeDistance = 1

			vSERVER.removeSwimming()
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ 265.05,-1262.65,29.3,361,4,"Posto de Gasolina",0.4 },
	{ 819.02,-1027.96,26.41,361,4,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,4,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,4,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,4,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,4,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,4,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,4,"Posto de Gasolina",0.4 },
	{ 1782.33,3328.46,41.26,361,4,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,4,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,4,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,4,"Posto de Gasolina",0.4 },
	{ 1207.4,2659.93,37.9,361,4,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,4,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,4,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,4,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,4,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,4,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,4,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,4,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,4,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,4,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,4,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,4,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,4,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,4,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,4,"Posto de Gasolina",0.4 },

	{ -829.8,-1217.71,6.94,80,35,"Hospital",0.5 },
	{ -251.8,6322.98,37.62,80,35,"Hospital",0.5 },

	{ 55.43,-876.19,30.66,357,41,"Garagem",0.6 },
	{ 598.04,2741.27,42.07,357,53,"Garagem",0.6 },
	{ -136.36,6357.03,31.49,357,53,"Garagem",0.6 },
	{ 275.23,-345.54,45.17,357,53,"Garagem",0.6 },
	{ 596.40,90.65,93.12,357,53,"Garagem",0.6 },
	{ -340.76,265.97,85.67,357,53,"Garagem",0.6 },
	{ -2030.01,-465.97,11.60,357,53,"Garagem",0.6 },
	{ -1184.92,-1510.00,4.64,357,53,"Garagem",0.6 },
	{ 214.02,-808.44,31.01,357,53,"Garagem",0.6 },
	{ -348.88,-874.02,31.31,357,53,"Garagem",0.6 },
	{ 67.74,12.27,69.21,357,53,"Garagem",0.6 },
	{ 361.90,297.81,103.88,357,53,"Garagem",0.6 },
	{ 1035.89,-763.89,57.99,357,53,"Garagem",0.6 },
	{ -796.63,-2022.77,9.16,357,53,"Garagem",0.6 },
	{ 453.27,-1146.76,29.52,357,53,"Garagem",0.6 },
	{ 528.66,-146.3,58.38,357,53,"Garagem",0.6 },
	{ -1159.48,-739.32,19.89,357,53,"Garagem",0.6 },
	{ 101.22,-1073.68,29.38,357,53,"Garagem",0.6 },
	{ 204.7,-3133.04,5.78,357,53,"Garagem",0.6 },


	{ 441.04,-982.2,30.7,60,3,"Departamento Policial",0.6 },
	{ 1851.45,3686.71,34.26,60,3,"Departamento Policial",0.6 },
	{ -448.18,6011.68,31.71,60,3,"Departamento Policial",0.6 },

	{ 25.68,-1346.6,29.5,52,36,"Loja de Departamento",0.5 },
	{ 2556.47,382.05,108.63,52,36,"Loja de Departamento",0.5 },
	{ 1163.55,-323.02,69.21,52,36,"Loja de Departamento",0.5 },
	{ -707.31,-913.75,19.22,52,36,"Loja de Departamento",0.5 },
	{ -47.72,-1757.23,29.43,52,36,"Loja de Departamento",0.5 },
	{ 373.89,326.86,103.57,52,36,"Loja de Departamento",0.5 },
	{ -3242.95,1001.28,12.84,52,36,"Loja de Departamento",0.5 },
	{ 1729.3,6415.48,35.04,52,36,"Loja de Departamento",0.5 },
	{ 548.0,2670.35,42.16,52,36,"Loja de Departamento",0.5 },
	{ 1960.69,3741.34,32.35,52,36,"Loja de Departamento",0.5 },
	{ 2677.92,3280.85,55.25,52,36,"Loja de Departamento",0.5 },
	{ 1698.5,4924.09,42.07,52,36,"Loja de Departamento",0.5 },
	{ -1820.82,793.21,138.12,52,36,"Loja de Departamento",0.5 },
	{ 1393.21,3605.26,34.99,52,36,"Loja de Departamento",0.5 },
	{ -2967.78,390.92,15.05,52,36,"Loja de Departamento",0.5 },
	{ -3040.14,585.44,7.91,52,36,"Loja de Departamento",0.5 },
	{ 1135.56,-982.24,46.42,52,36,"Loja de Departamento",0.5 },
	{ 1166.0,2709.45,38.16,52,36,"Loja de Departamento",0.5 },
	{ -1487.21,-378.99,40.17,52,36,"Loja de Departamento",0.5 },
	{ -1222.76,-907.21,12.33,52,36,"Loja de Departamento",0.5 },
	
	{ 1692.62,3759.50,34.70,76,6,"Loja de Armas",0.4 },
	{ 252.89,-49.25,69.94,76,6,"Loja de Armas",0.4 },
	{ 843.28,-1034.02,28.19,76,6,"Loja de Armas",0.4 },
	{ -331.35,6083.45,31.45,76,6,"Loja de Armas",0.4 },
	{ -663.15,-934.92,21.82,76,6,"Loja de Armas",0.4 },
	{ -1305.18,-393.48,36.69,76,6,"Loja de Armas",0.4 },
	{ -1118.80,2698.22,18.55,76,6,"Loja de Armas",0.4 },
	{ 2568.83,293.89,108.73,76,6,"Loja de Armas",0.4 },
	{ -3172.68,1087.10,20.83,76,6,"Loja de Armas",0.4 },
	{ 21.32,-1106.44,29.79,76,6,"Loja de Armas",0.4 },
	{ 811.19,-2157.67,29.61,76,6,"Loja de Armas",0.4 },
	
	{ -1213.44,-331.02,37.78,207,46,"Banco",0.5 },
	{ -351.59,-49.68,49.04,207,46,"Banco",0.5 },
	{ 313.47,-278.81,54.17,207,46,"Banco",0.5 },
	{ 149.35,-1040.53,29.37,207,46,"Banco",0.5 },
	{ -2962.60,482.17,15.70,207,46,"Banco",0.5 },
	{ -112.81,6469.91,31.62,207,46,"Banco",0.5 },
	{ 1175.74,2706.80,38.09,207,46,"Banco",0.5 },
	
	{ 75.35,-1392.92,29.38,73,4,"Loja de Roupas",0.5 },
	{ -710.15,-152.36,37.42,73,4,"Loja de Roupas",0.5 },
	{ -163.73,-303.62,39.74,73,4,"Loja de Roupas",0.5 },
	{ -822.38,-1073.52,11.33,73,4,"Loja de Roupas",0.5 },
	{ -1193.13,-767.93,17.32,73,4,"Loja de Roupas",0.5 },
	{ -1449.83,-237.01,49.82,73,4,"Loja de Roupas",0.5 },
	{ 4.83,6512.44,31.88,73,4,"Loja de Roupas",0.5 },
	{ 1693.95,4822.78,42.07,73,4,"Loja de Roupas",0.5 },
	{ 125.82,-223.82,54.56,73,4,"Loja de Roupas",0.5 },
	{ 614.2,2762.83,42.09,73,4,"Loja de Roupas",0.5 },
	{ 1196.72,2710.26,38.23,73,4,"Loja de Roupas",0.5 },
	{ -3170.53,1043.68,20.87,73,4,"Loja de Roupas",0.5 },
	{ -1101.42,2710.63,19.11,73,4,"Loja de Roupas",0.5 },
	{ 425.6,-806.25,29.5,73,4,"Loja de Roupas",0.5 },

	{ -815.12,-184.15,37.57,71,4,"Barbearia",0.5 },
	{ 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 },
	{ -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 },
	{ 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 },
	{ 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 },
	{ -33.61,-154.52,57.08,71,4,"Barbearia",0.5 },
	{ -276.65,6226.76,31.7,71,4,"Barbearia",0.5 },

	{ -1082.22,-247.54,37.77,617,4,"Life Invader",0.6 },
	{ 1530.55,3777.33,34.52,317,4,"Central de Pesca",0.5 },

	{ -1798.72,-1224.95,1.6,427,4,"Embarcações",0.5 },
	{ 1733.09,3984.51,31.98,427,4,"Embarcações",0.5 },
	{ -787.54,-1489.59,1.6,427,4,"Embarcações",0.5 },
	{ -1604.36,5256.65,2.08,427,4,"Embarcações",0.5 },

	{ -428.56,-1728.33,19.79,467,11,"Reciclagem",0.6 },
	{ 180.07,2793.29,45.65,467,11,"Reciclagem",0.6 },
	{ -195.42,6264.62,31.49,467,11,"Reciclagem",0.6 },

	{ 905.0,-2106.75,34.87,544,47,"Mecânica",0.7 },

	{ 407.82,-1637.88,29.3,560,4,"Reboque",0.7 },
	{ 1706.07,4791.75,41.98,560,4,"Reboque",0.7 },

	{ -1207.55,-1134.06,7.71,89,48,"Cool Beans",0.4 },
	{ -580.93,-1074.92,22.33,141,62,"UwU Café",0.6 },
	{ -1254.32,-1443.71,4.38,211,11,"Market Place",0.4 },
	{ -1253.47,-1449.92,4.36,140,11,"LD Organics",0.4 },
	
	{ 132.6,-1305.06,29.2,93,4,"Bar",0.5 },
	{ -565.14,271.56,83.02,93,4,"Bar",0.5 },
	{ 984.89,-98.82,74.85,93,4,"Bar",0.5 },
	{ 4.04,220.47,107.78,93,4,"Bar",0.5 },

	{ 4.58,-705.95,45.98,351,4,"Escritório",0.7 },
	{ -117.29,-604.52,36.29,351,4,"Escritório",0.7 },
	{ -826.9,-699.89,28.06,351,4,"Escritório",0.7 },
	{ -935.68,-378.77,38.97,351,4,"Escritório",0.7 },
	
	{ -1388.69,-610.63,30.32,93,4,"Bahamas",0.7 },

	{ -741.56,5594.94,41.66,36,4,"Teleférico",0.6 },
	{ 454.46,5571.95,781.19,36,4,"Teleférico",0.6 },

	{ 1322.93,-1652.29,52.27,75,4,"Tatuagem",0.6 },
	{ -1154.42,-1425.9,4.95,75,4,"Tatuagem",0.6 },
	{ 322.84,180.16,103.58,75,4,"Tatuagem",0.6 },
	{ -3169.62,1075.8,20.83,75,4,"Tatuagem",0.6 },
	{ 1864.07,3747.9,33.03,75,4,"Tatuagem",0.6 },
	{ -293.57,6199.85,31.48,75,4,"Tatuagem",0.6 },
	
	{ -544.22,-205.93,38.05,419,4,"Tribunal",0.5 },
	{ -1274.7,-1411.63,4.38,459,11,"Loja de Eletrônicos",0.6 },

	{ 468.11,-585.95,28.5,513,4,"Motorista",0.5 },
	{ -598.51,-929.6,23.87,184,0,"Jornaleiro",0.5 },
	{ -344.99,-1562.31,25.24,318,4,"Lixeiro",0.5 },
	{ -43.92,-1096.39,27.29,225,4,"Benefactor",0.5 },
	{ 1240.74,-3257.13,6.92,477,4,"Caminhoneiro",0.5 },
	{ 912.71,-178.43,74.3,198,28,"Taxista",0.5 },
	{ -1168.99,-236.95,37.93,267,0,"Piscineiro",0.4 },
	{ -97.09,-1013.45,27.28,478,0,"Construtor",0.5 },
	-- { -941.18,-2954.95,13.95,90,28,"Fedex",0.5 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blip,v[4])
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v[5])
		SetBlipScale(blip,v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)
	SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",true,true)
	SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
	StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
	StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
	SetAudioFlag("PoliceScannerDisabled",true)
	SetAudioFlag("DisableFlightMusic",true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		N_0xf4f2c0d4ee209e20()
		N_0x9e4cfff989258472()

		DistantCopCarSirens(false)
		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		SetVehicleModelIsSuppressed(GetHashKey("jet"),true)
		SetVehicleModelIsSuppressed(GetHashKey("besra"),true)
		SetVehicleModelIsSuppressed(GetHashKey("luxor"),true)
		SetVehicleModelIsSuppressed(GetHashKey("blimp"),true)
		SetVehicleModelIsSuppressed(GetHashKey("polmav"),true)
		SetVehicleModelIsSuppressed(GetHashKey("buzzard2"),true)
		SetVehicleModelIsSuppressed(GetHashKey("mammatus"),true)
		SetVehicleModelIsSuppressed(GetHashKey("rhino"),true)
		SetPedModelIsSuppressed(GetHashKey("s_m_y_prismuscl_01"),true)
		SetPedModelIsSuppressed(GetHashKey("u_m_y_prisoner_01"),true)
		SetPedModelIsSuppressed(GetHashKey("s_m_y_prisoner_01"),true)

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 0
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if IsPedArmed(PlayerPedId(),6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		else
			DisableControlAction(0,140,true)
		end

		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL50"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_REVOLVER"),0.4)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL"),0.8)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"),0.8)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BATTLEAXE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BOTTLE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DAGGER"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STONE_HATCHET"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMPACTRIFLE"),0.4)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_APPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHINEPISTOL"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MICROSMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINISMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_VINTAGEPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GUSENBERG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"),1.3)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"),2.0)

		RemoveAllPickupsOfType("PICKUP_WEAPON_KNIFE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PISTOL")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MINISMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MICROSMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PUMPSHOTGUN")
		RemoveAllPickupsOfType("PICKUP_WEAPON_CARBINERIFLE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_SAWNOFFSHOTGUN")

		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(20)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)

		SetMaxWantedLevel(0)
		DisableVehicleDistantlights(true)
		ClearPlayerWantedLevel(PlayerId())
		DisablePlayerVehicleRewards(PlayerId())
		SetEveryoneIgnorePlayer(PlayerPedId(),true)
		SetPlayerCanBeHassledByGangs(PlayerPedId(),false)
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(),true)


		if LocalPlayer["state"]["Route"] > 0 then
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetAmbientVehicleRangeMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
			SetPedDensityMultiplierThisFrame(0.0)
		else
			SetVehicleDensityMultiplierThisFrame(0.50)
			SetRandomVehicleDensityMultiplierThisFrame(0.50)
			SetParkedVehicleDensityMultiplierThisFrame(1.0)
			SetAmbientVehicleRangeMultiplierThisFrame(1.0)
			SetScenarioPedDensityMultiplierThisFrame(1.0,1.0)
			SetPedDensityMultiplierThisFrame(1.0)
		end

		SetRandomBoats(false)
		SetGarbageTrucks(false)

		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			SetPedInfiniteAmmo(ped,true,"WEAPON_FIREEXTINGUISHER")
		end
		Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHAKESHOTTING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) and IsPedArmed(ped,6) then
			timeDistance = 1

			local selectWeapon = GetSelectedPedWeapon(ped)
			if (selectWeapon == GetHashKey("WEAPON_MACHINEPISTOL") or selectWeapon == GetHashKey("WEAPON_MICROSMG") or selectWeapon == GetHashKey("WEAPON_MINISMG") or selectWeapon == GetHashKey("WEAPON_APPISTOL")) then
				DisablePlayerFiring(ped,true)
				DisableControlAction(1,24,true)
				DisableControlAction(1,25,true)
				DisableControlAction(1,68,true)
				DisableControlAction(1,69,true)
				DisableControlAction(1,70,true)
				DisableControlAction(1,91,true)
				DisableControlAction(1,257,true)
			end

			if IsPedShooting(ped) then
				ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.10)
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEBY/HELMETBIKE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local timeDistance = 999
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            timeDistance = 1

            SetPedHelmet(ped,false)
        end
        Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	{ 4.58,-705.95,45.98,-139.85,-627.0,168.83,"ENTRAR",nil }, -- ESCRITORIO 1
	{ -139.85,-627.0,168.83,4.58,-705.95,45.98,"SAIR",nil }, -- ESCRITORIO 1

	{ -117.29,-604.52,36.29,-74.48,-820.8,243.39,"ENTRAR",nil },-- ESCRITORIO 2
	{ -74.48,-820.8,243.39,-117.29,-604.52,36.29,"SAIR",nil },-- ESCRITORIO 2

	{ -741.07,5593.13,41.66,446.19,5568.79,781.19,"SUBIR",nil }, -- TELEFERICO
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66,"DESCER",nil },

	{ -740.78,5597.04,41.66,446.37,5575.02,781.19,"SUBIR",nil }, -- TELEFERICO
	{ 446.37,5575.02,781.19,-740.78,5597.04,41.66,"DESCER",nil },

	{ -777.62,-1219.2,7.34,275.8,-1361.48,24.54,"ENTRAR",nil }, -- NECROTERIO
	{ 275.8,-1361.48,24.54,-777.62,-1219.2,7.34,"SAIR",nil },

	{ -829.89,-1255.5,6.59,-778.47,-1222.17,15.56,"SUBIR",nil },-- HOSPITAL HELIPONTO
	{ -778.47,-1222.17,15.56,-829.89,-1255.5,6.59,"DESCER",nil },

	{ 1085.28,214.19,-49.2,965.17,58.56,112.56,"SUBIR",nil },-- CASSINO SUBIR
	{ 965.17,58.56,112.56,1085.28,214.19,-49.2,"DESCER",nil },

	{ 936.05,47.14,81.1,1089.72,205.95,-48.99,"DESCER",nil },-- CASSINO SUBTERANEO 
	{ 1089.72,205.95,-48.99,936.05,47.14,81.1,"SUBIR",nil },

	{ -1388.69,-610.63,30.32,-1385.07,-606.36,30.32,"ENTRAR",nil }, -- BAHAMAS
	{ -1385.07,-606.36,30.32,-1388.69,-610.63,30.32,"SAIR",nil },

	{ -1380.97,-632.84,30.82,-1379.93,-630.8,30.82,"ENTRAR",nil }, -- BAHAMAS
	{ -1379.93,-630.8,30.82,-1380.97,-632.84,30.82,"SAIR",nil },

	{ -3050.93,3331.97,12.79,2542.63,4595.48,-39.3,"ENTRAR","Arma02" }, -- ARMA02
	{ 2542.63,4595.48,-39.3,-3050.93,3331.97,12.79,"SAIR","Arma02" },

	{ -1572.14,772.68,189.2,34.4,2241.37,28.59,"ENTRAR","Arma01" }, -- ARMA01
	{ 34.4,2241.37,28.59,-1572.14,772.68,189.2,"SAIR","Arma01" },

	{ -590.07,-912.5,23.88,-568.83,-927.7,36.79,"DESCER","News" },-- NEWS
	{ -568.83,-927.7,36.79,-590.07,-912.5,23.88,"SUBIR","News" },

	{ 254.01,225.22,101.88,253.14,223.14,101.69,"ENTRAR",nil }, -- BANCO CENTRAL
	{ 253.14,223.14,101.69,254.01,225.22,101.88,"SAIR",nil },

	{ -1486.71,-22.02,54.66,-1477.54,-34.92,63.01,"ENTRAR",nil },
	{ -1477.54,-34.92,63.01,-1486.71,-22.02,54.66,"ENTRAR",nil }, 

	{ -1371.39,-625.76,30.82,-1575.14,-569.15,108.53,"ENTRAR","Lavagem02" }, -- LAVAGEM02
	{ -1575.14,-569.15,108.53,-1371.39,-625.76,30.82,"SAIR","Lavagem02" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local innerTable = {}
	for k,v in pairs(teleport) do
		table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Porta de Acesso","Pressione para acessar" })
	end

	TriggerEvent("hoverfy:Insert",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(teleport) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4

					if IsControlJustPressed(1,38) then
						if vSERVER.checkPermission(v[8]) then
							DoScreenFadeOut(1000)
							Wait(2000)
							SetEntityCoords(ped,v[4],v[5],v[6])
							Wait(1000)
							DoScreenFadeIn(1000)
						end
					end
				end
			end
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASERTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			SetPedToRagdoll(ped,10000,10000,0,0,0,0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			tasertime = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			tasertime = false
			SetTimeout(5000,function()
				SetTimecycleModifier("hud_def_desat_Trevor")
				SetTimeout(10000,function()
					SetTimecycleModifier("")
					SetTransitionTimecycleModifier("")
					StopGameplayCamShaking()
				end)
			end)
		end
		Wait(1000)
	end
end)