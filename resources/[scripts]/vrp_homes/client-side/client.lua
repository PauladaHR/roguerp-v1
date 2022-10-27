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
Tunnel.bindInterface("vrp_homes",cRP)
vSERVER = Tunnel.getInterface("vrp_homes")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local houseOpen = ""
local vaultMode = ""
local theftOpen = ""
local homesList = {}
local homesCurrent = {}
local houseNetwork = {}
local internLocates = {}
local theftRobberys = {}
local blips = {}
local showBlips = false
local objectsLocker = nil
local objectsShells = nil
local houseVisit = false
local debugx
local debugy
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	vSERVER.chestClose()
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
	TransitionFromBlurred(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(data.item,data.slot,data.amount,data.target,houseOpen,vaultMode)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(data.item,data.slot,data.amount,data.target,houseOpen,vaultMode)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateChest",function(data,cb)
	vSERVER.updateChest(data.item,data.slot,data.target,data.amount,houseOpen,vaultMode)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.openChest(houseOpen,vaultMode)
	if myInventory then
		cb({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_homes:UpdateWeight")
AddEventHandler("vrp_homes:UpdateWeight",function(invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_HOMES:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_homes:Update")
AddEventHandler("vrp_homes:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKERCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local lockerCoords = {
	["Middle"] = { 4.52,-1.13,1499.00,180.0 },
	["Mansion"] = { -2.37,11.14,1499.20,90.0 },
	["Trailer"] = { 3.49,-2.00,1499.00,180.0 },
	["Beach"] = { 8.62,0.46,1499.05,270.0 },
	["Motel"] = { -5.10,2.78,1499.80,90.0 },
	["Modern"] = { 4.64,6.27,1499.10,270.0 },
	["Hotel"] = { -1.04,3.87,1499.10,0.0 },
	["Simple"] = { 2.60,2.68,1500.45,0.0 },
	["Container"] = { 2.80,1.33,1499.9,0.0 },
	["Franklin"] = { 1.19,3.43,1499.00,0.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTRANCEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.entranceHomes(homeName,v,interior,theft,visit)
	DoScreenFadeOut(0)

	homesCurrent = v
	houseOpen = homeName
	houseVisit = visit
	TriggerEvent("homes:Hours",true)
	TriggerEvent("sounds:Private","enterhouse",0.7)

	local ped = PlayerPedId()
	debugx = v[1]
	debugy = v[2]

	if interior == "Trailer" then
		SetTimecycleModifier("INT_mall")
		createShells(v[1],v[2],1500.0,"creative_trailer")
		SetEntityCoords(ped,v[1] - 1.44,v[2] - 2.02,1501.0 - 1,1,0,0,0)
		table.insert(internLocates,{ v[1] - 1.44,v[2] - 2.02,1500.0,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] - 4.36,v[2] - 1.97,1500.0 - 0.5,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] + 0.20,v[2] + 1.70,1500.0,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] + 5.57,v[2] - 1.46,1500.0 - 0.5,"homesClothes","ABRIR"})
		end
	elseif interior == "Hotel" then
		SetTimecycleModifier("mp_gr_int01_white")
		createShells(v[1],v[2],1500.0,"creative_hotel")
		SetEntityCoords(ped,v[1] - 1.69,v[2] - 3.91,1500.0 - 0.5,1,0,0,0)
		table.insert(internLocates,{ v[1] - 1.69,v[2] - 3.91,1499.8,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] - 2.25,v[2] + 0.95,1499.4,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] - 1.78,v[2] + 2.60,1499.4,"homesClothes","ABRIR" })
		end
	elseif interior == "Motel" then
		SetTimecycleModifier("INT_mall")
		createShells(v[1],v[2],1500.0,"creative_motel")
		SetEntityCoords(ped,v[1] + 4.6,v[2] - 6.36,1498.5 - 0.5,1,0,0,0)
		table.insert(internLocates,{ v[1] + 4.6,v[2] - 6.36,1498.5,"exit","SAIR" })
		if not theft then
			table.insert(internLocates,{ v[1] + 5.08,v[2] + 2.05,1500.3,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] + 4.89,v[2] + 3.40,1500.5,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] - 3.60,v[2] + 0.45,1500.5,"homesClothes","ABRIR" })
		end
	elseif interior == "Middle" then
		SetTimecycleModifier("INT_mall")
		createShells(v[1],v[2],1500.0,"creative_middle")
		SetEntityCoords(ped,v[1] + 1.36,v[2] - 14.23,1501.0)
		table.insert(internLocates,{ v[1] + 1.36,v[2] - 14.23,1499.5,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] + 7.15,v[2] - 1.00,1499.0,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] - 0.54,v[2] - 2.46,1499.5,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] + 5.75,v[2] + 5.58,1499.5,"homesClothes","ABRIR" })
		end
	elseif interior == "Modern" then
		SetTimecycleModifier("mp_gr_int01_white")
		createShells(v[1],v[2],1500.0,"creative_modern")
		SetEntityCoords(ped,v[1] - 1.63,v[2] - 5.94,1500.0 - 0.75,1,0,0,0)
		table.insert(internLocates,{ v[1] - 1.63,v[2] - 5.94,1499.7,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] - 1.05,v[2] + 0.39,1499.8 - 0.5,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] + 1.92,v[2] + 7.23,1499.8,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] - 0.49,v[2] + 2.88,1499.8,"homesClothes","ABRIR" })
		end
	elseif interior == "Beach" then
		SetTimecycleModifier("mp_gr_int01_white")
		createShells(v[1],v[2],1500.0,"creative_beach")
		SetEntityCoords(ped,v[1] + 0.11,v[2] - 3.68,1500.0 - 1,1,0,0,0)
		table.insert(internLocates,{ v[1] + 0.18,v[2] - 3.80,1499.5,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] + 0.73,v[2] + 1.97,1500.0,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] - 1.58,v[2] - 0.98,1500.0,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] + 3.60,v[2] + 2.98,1500.0,"homesClothes","ABRIR" })
		end
	elseif interior == "Franklin" then
		SetTimecycleModifier("mp_gr_int01_grey")
		createShells(v[1],v[2],1500.0,"creative_franklin")
		SetEntityCoords(ped,v[1] - 0.47,v[2] - 5.91,1500.0 - 1,1,0,0,0)
		table.insert(internLocates,{ v[1] - 0.47,v[2] - 5.91,1499.6,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] - 2.60,v[2] - 5.59,1499.3,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] + 4.31,v[2] + 4.58,1499.8,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] - 5.32,v[2] - 3.94,1499.8,"homesClothes","ABRIR" })
		end
	elseif interior == "Mansion" then
		SetTimecycleModifier("mp_gr_int01_white")
		createShells(v[1],v[2],1499.0,"creative_mansion")
		SetEntityCoords(ped,v[1] - 8.69,v[2] - 3.43,1501.0 - 0.5,1,0,0,0)
		table.insert(internLocates,{ v[1] - 8.69,v[2] - 3.05,1501.0,"exit","SAIR" })
		

		if not theft then
			table.insert(internLocates,{ v[1] - 3.97,v[2] - 13.58,1500.5,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] + 5.81,v[2] - 11.88,1500.5,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] + 1.53,v[2] + 8.29,1500.5 - 1.0,"homesClothes","ABRIR" })
		end
	elseif interior == "Simple" then
		SetTimecycleModifier("mp_gr_int01_black")
		createShells(v[1],v[2],1500.0,"creative_simple")
		SetEntityCoords(ped,v[1] - 4.89,v[2] - 4.15,1501.0 - 0.5,1,0,0,0)
		table.insert(internLocates,{ v[1] - 4.89,v[2] - 4.15,1501.0,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] - 5.73,v[2] - 1.83,1501.2 - 0.5,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] - 3.33,v[2] + 2.63,1501.2,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] + 1.43,v[2] - 2.11,1501.2,"homesClothes","ABRIR" })
		end
	elseif interior == "Container" then
		SetTimecycleModifier("mp_gr_int01_grey")
		createShells(v[1],v[2],1499.0,"creative_container")
		SetEntityCoords(ped,v[1] - 1.14,v[2] - 1.38,1500.0,1,0,0,0)
		table.insert(internLocates,{ v[1] - 1.14,v[2] - 1.38,1500.5,"exit","SAIR" })

		if not theft then
			table.insert(internLocates,{ v[1] + 4.47,v[2] - 1.32,1500.5,"homesChest","ABRIR" })
			table.insert(internLocates,{ v[1] + 1.45,v[2] - 1.29,1500.5,"homesFridge","ABRIR" })
			table.insert(internLocates,{ v[1] + 1.72,v[2] + 1.55,1500.5 - 0.5,"homesClothes","ABRIR" })
		end
	end

	if theft then
		theftOpen = interior

		if math.random(100) >= 75 then
			if DoesEntityExist(objectsLocker) then
				DeleteEntity(objectsLocker)
				objectsLocker = nil
			end

			local mHash = GetHashKey("prop_ld_int_safe_01")

			RequestModel(mHash)
			while not HasModelLoaded(mHash) do
				Citizen.Wait(1)
			end

			if HasModelLoaded(mHash) then
				objectsLocker = CreateObjectNoOffset(mHash,v[1] + lockerCoords[interior][1],v[2] + lockerCoords[interior][2],lockerCoords[interior][3],false,false,false)

				SetEntityHeading(objectsLocker,lockerCoords[interior][4])
				FreezeEntityPosition(objectsLocker,true)
				SetModelAsNoLongerNeeded(mHash)
			end
		else
			theftRobberys["LOCKER"] = true
		end
	end
	
	FreezeEntityPosition(ped,true)
	Citizen.Wait(4500)
	FreezeEntityPosition(ped,false)
	DoScreenFadeIn(1000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATESHELLS
-----------------------------------------------------------------------------------------------------------------------------------------
function createShells(x,y,z,hash)
	if DoesEntityExist(objectsShells) then
		DeleteEntity(objectsShells)
		objectsShells = nil
	end

	objectsShells = CreateObjectNoOffset(GetHashKey(hash),x,y,z,false,false,false)
	FreezeEntityPosition(objectsShells,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEFTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local theftCoords = {
	["Trailer"] = {
		["MOBILE01"] = { 5.57,-1.36,-0.7 },
		["MOBILE02"] = { 1.82,-1.79,-0.7 },
		["MOBILE03"] = { 0.22,1.70,-0.5 },
		["MOBILE04"] = { -6.10,-1.47,-0.3 },
		["MOBILE05"] = { -4.39,-1.97,-0.8 },
		["MOBILE06"] = { -3.25,-1.85,-0.2 },
		["LOCKER"] = { 3.49,-2.00,-1.0 }
	},
	["Hotel"] = {
		["MOBILE01"] = { 2.40,-1.78,-0.8 },
		["MOBILE02"] = { -1.78,2.59,-0.1 },
		["MOBILE03"] = { -2.24,0.95,-0.6 },
		["MOBILE04"] = { -2.26,-0.49,-0.7 },
		["LOCKER"] = { -1.04,3.87,-0.8 }
	},
	["Motel"] = {
		["MOBILE01"] = { 5.08,2.05,0.3 },
		["MOBILE02"] = { 4.89,3.40,0.6 },
		["MOBILE03"] = { 2.31,6.13,0.2 },
		["MOBILE04"] = { 1.05,6.16,0.0 },
		["MOBILE05"] = { -3.55,0.30,0.6 },
		["LOCKER"] = { -5.10,2.78,0.0 }
	},
	["Middle"] = {
		["MOBILE01"] = { 0.45,-2.87,-0.8 },
		["MOBILE02"] = { -4.26,-5.36,-0.3 },
		["MOBILE03"] = { -5.61,-5.21,-0.8 },
		["MOBILE04"] = { -7.57,2.04,-1.0 },
		["MOBILE05"] = { -3.91,2.08,-1.0 },
		["MOBILE06"] = { 0.77,2.96,0.1 },
		["MOBILE07"] = { 5.68,-1.13,-0.8 },
		["MOBILE08"] = { 7.15,-1.00,-1.0 },
		["MOBILE09"] = { 6.38,5.78,-0.3 },
		["MOBILE10"] = { 3.59,3.83,-0.9 },
		["MOBILE11"] = { 1.60,4.58,-0.7 },
		["MOBILE12"] = { -0.54,-2.46,-0.3 },
		["LOCKER"] = { 4.47,-1.00,-0.9 }
	},
	["Modern"] = {
		["MOBILE01"] = { -1.01,0.42,-0.6 },
		["MOBILE02"] = { 3.07,-2.66,-0.8 },
		["MOBILE03"] = { 2.14,7.27,-0.1 },
		["MOBILE04"] = { 1.02,7.27,-0.1 },
		["MOBILE05"] = { 0.05,7.27,-0.1 },
		["MOBILE06"] = { -1.98,7.26,-0.6 },
		["MOBILE07"] = { -3.46,4.33,-0.6 },
		["MOBILE08"] = { -0.56,4.34,-0.6 },
		["MOBILE09"] = { -0.59,2.92,-0.1 },
		["MOBILE10"] = { -0.59,1.53,-0.1 },
		["LOCKER"] = { 4.64,6.27,-0.8 }
	},
	["Beach"] = {
		["MOBILE01"] = { -0.62,-0.95,-0.6 },
		["MOBILE02"] = { 3.14,-3.75,-0.6 },
		["MOBILE03"] = { 8.36,-3.60,-0.1 },
		["MOBILE04"] = { 7.86,-0.49,-0.8 },
		["MOBILE05"] = { 6.47,0.34,-0.8 },
		["MOBILE06"] = { 7.80,3.72,-0.8 },
		["MOBILE07"] = { 3.63,3.00,-0.1 },
		["MOBILE08"] = { 0.78,2.10,-0.3 },
		["MOBILE09"] = { -1.07,2.79,-0.6 },
		["MOBILE10"] = { -8.31,3.55,-0.9 },
		["MOBILE11"] = { -5.39,-3.83,-0.2 },
		["MOBILE12"] = { -1.45,-2.98,-0.7 },
		["LOCKER"] = { 8.76,0.49,-0.8 }
	},
	["Franklin"] = {
		["MOBILE01"] = { -1.81,-5.41,-0.7 },
		["MOBILE02"] = { -2.59,-5.59,-0.8 },
		["MOBILE03"] = { -5.45,-5.75,-1.0 },
		["MOBILE04"] = { -2.68,-0.50,-1.0 },
		["MOBILE05"] = { -3.74,3.31,-0.6 },
		["MOBILE06"] = { 2.01,7.33,-0.7 },
		["MOBILE07"] = { 4.40,5.50,-0.7 },
		["MOBILE08"] = { 4.31,4.59,-0.2 },
		["MOBILE09"] = { 5.15,-0.81,-0.8 },
		["MOBILE10"] = { 0.93,-0.25,-0.9 },
		["MOBILE11"] = { 4.81,-6.93,-0.8 },
		["LOCKER"] = { 1.19,3.43,-0.9 }
	},
	["Mansion"] = {
		["MOBILE01"] = { 0.93,-14.28,-0.2 },
		["MOBILE02"] = { -0.41,-18.88,-0.2 },
		["MOBILE03"] = { -5.93,-18.00,-0.1 },
		["MOBILE04"] = { -3.97,-13.54,0.5 },
		["MOBILE05"] = { 5.80,-11.88,0.5 },
		["MOBILE06"] = { 8.98,0.43,-0.5 },
		["MOBILE07"] = { 4.97,5.94,-0.1 },
		["MOBILE08"] = { -2.41,9.43,-0.6 },
		["MOBILE09"] = { 1.48,8.29,-0.5 },
		["MOBILE10"] = { 3.19,14.13,-0.9 },
		["MOBILE11"] = { -0.08,14.00,-0.9 },
		["MOBILE12"] = { -2.80,17.30,-0.7 },
		["LOCKER"] = { -2.37,11.14,-0.7 }
	},
	["Simple"] = {
		["MOBILE01"] = { -5.74,-1.80,0.6 },
		["MOBILE02"] = { -5.49,2.60,0.8 },
		["MOBILE03"] = { -4.06,2.62,0.8 },
		["MOBILE04"] = { -3.30,2.63,1.2 },
		["MOBILE05"] = { 1.41,-2.15,1.2 },
		["MOBILE06"] = { 5.61,-3.89,0.5 },
		["MOBILE07"] = { 5.53,-0.58,0.5 },
		["MOBILE08"] = { 5.57,0.66,0.8 },
		["LOCKER"] = { 2.60,2.68,0.7 }
	},
	["Container"] = {
		["MOBILE01"] = { 1.45,-1.29,0.7 },
		["MOBILE02"] = { 4.46,-1.30,0.6 },
		["MOBILE03"] = { 4.62,0.72,0.1 },
		["MOBILE04"] = { 1.75,1.55,0.1 },
		["MOBILE05"] = { 0.59,1.44,0.7 },
		["MOBILE06"] = { -0.51,1.44,0.7 },
		["MOBILE07"] = { -1.63,1.55,0.1 },
		["MOBILE08"] = { -4.62,0.76,0.1 },
		["MOBILE09"] = { -4.44,-1.31,0.6 },
		["LOCKER"] = { 2.80,1.33,0.0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	DoScreenFadeIn(0)


	while true do
		local timeDistance = 500
		if theftOpen ~= "" then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)

				for k,v in pairs(theftCoords[theftOpen]) do
					if not theftRobberys[k] then
						local distance = #(coords - vector3(homesCurrent[1] + v[1], homesCurrent[2] + v[2],1500.0))
						if distance <= 1.5 then
							timeDistance = 4
							DrawText3D(homesCurrent[1] + v[1],homesCurrent[2] + v[2],1500.0 + v[3],"~b~E~w~   VASCULHAR")

							if IsControlJustPressed(1,38) then
								TriggerEvent("vRP:Cancel",true)

								if k == "LOCKER" then
									local taskBar = exports["vrp_taskbar"]:taskHomes()
									if taskBar then
										vSERVER.paymentTheft(k)
									end
									theftRobberys[k] = true
								else
									local taskBar = exports["vrp_taskbar"]:taskHomes()
									if taskBar then
										vSERVER.paymentTheft(k)
										theftRobberys[k] = true
									end
								end

								TriggerEvent("vRP:Cancel",false)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTERN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and houseOpen ~= "" then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(internLocates) do
				if coords["z"] <= 1450 and v[4] == "exit" then
					SetEntityCoords(ped,v[1],v[2],v[3],1,0,0,0)
				end

				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 1.5 then
					timeDistance = 4
					DrawText3D(v[1],v[2],v[3],"~b~E~w~   "..v[5])

					if IsControlJustPressed(1,38) then
						if v[4] == "exit" then
							if distance <= 0.9 then
								DoScreenFadeOut(0)

								SetEntityCoords(ped,homesCurrent[1],homesCurrent[2],homesCurrent[3] - 0.75,1,0,0,0)

								TriggerEvent("sounds:Private","outhouse",0.5)
								TriggerEvent("homes:Hours",false)
								if houseVisit then
									houseVisit = false
									vSERVER.removeVisit(houseOpen)
								end
								vSERVER.removeHouseOpen()
								internLocates = {}
								theftRobberys = {}
								houseOpen = ""
								theftOpen = ""

								if DoesEntityExist(objectsShells) then
									DeleteEntity(objectsShells)
									objectsShells = nil
								end

								if DoesEntityExist(objectsLocker) then
									DeleteEntity(objectsLocker)
									objectsLocker = nil
								end

								ClearTimecycleModifier()
								FreezeEntityPosition(ped,true)
								Citizen.Wait(3000)
								FreezeEntityPosition(ped,false)
								DoScreenFadeIn(1000)
							end
						elseif v[4] == "homesChest" or v[4] == "homesFridge" then
							if vSERVER.checkPermissions(houseOpen) then
								TriggerEvent("sounds:Private","chest",0.7)
								SendNUIMessage({ action = "showMenu" })
								SetNuiFocus(true,true)
								TransitionToBlurred(1000)
								vaultMode = v[4]
							end
						elseif v[4] == "homesClothes" then
							if vSERVER.checkClothes(houseOpen) then
								TriggerServerEvent("homes:clothesSystem")
							end
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:togglePropertys")
AddEventHandler("homes:togglePropertys",function()
	if showBlips then
		showBlips = false
		TriggerEvent("Notify","amarelo","Marcações desativadas.",3000)

		for k,v in pairs(blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end
	else
		showBlips = true
		local result = vSERVER.homeBlips()
		TriggerEvent("Notify","amarelo","Marcações ativadas.",3000)

		for k,v in pairs(result) do
			blips[k] = AddBlipForCoord(v["x"],v["y"],v["z"])
			SetBlipSprite(blips[k],v["id"])
			SetBlipAsShortRange(blips[k],true)
			SetBlipScale(blips[k],v["scale"])
			SetBlipColour(blips[k],v["color"])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
local makeGarage = false
local makePoints = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMEGARAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.homeGarage(homeName)
	makePoints = 0
	local homeCoords = {}
	homeCoords[homeName] = {}
	homeCoords[homeName]["1"] = {}

	Citizen.CreateThread(function()
		while true do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			if makePoints >= 2 then
				TriggerServerEvent("vrp_garages:updateGarages",homeName,homeCoords[homeName])
				break
			end

			if IsControlJustPressed(1,38) then
				makePoints = makePoints + 1

				if makePoints <= 1 then
					TriggerEvent("Notify","amarelo", "Fique no <b>local olhando</b> pra onde deseja que o veículo<br>apareça e pressione a tecla <b>E</b> novamente.", 10000)
					homeCoords[homeName] = { name = homeName, x = mathLegth(coords["x"]), y = mathLegth(coords["y"]), z = mathLegth(coords["z"]) }
				else
					TriggerEvent("Notify","verde", "Garagem adicionada.", 10000)
					homeCoords[homeName]["1"] = { mathLegth(coords["x"]),mathLegth(coords["y"]),mathLegth(coords["z"]),mathLegth(heading) }
				end
			end

			Citizen.Wait(1)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLegth(n)
	return math.ceil(n*100) / 100
end
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
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("enterHomes",function(source,args)
	if not IsPlayerFreeAiming(PlayerId()) and GetEntityHealth(PlayerPedId()) > 101 then
		TriggerServerEvent("homes:openSystem")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("enterHomes","Abrir menu de casas.","keyboard","E")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG QUEM MEXER E CORNO
-----------------------------------------------------------------------------------------------------------------------------------------
--[[Citizen.CreateThread(function()
	while true do
		if debugx and debugy then
			local ped = PlayerPedId()
			local coordss = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,1.0)
			print(coordss.x - debugx,coordss.y - debugy,coordss.z - 1501.0)
		end
		Citizen.Wait(1000)
	end
end)]]