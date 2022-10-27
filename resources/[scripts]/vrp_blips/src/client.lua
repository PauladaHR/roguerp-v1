local weaponList = {
	WEAPON_UNARMED = "Desarmado",
	WEAPON_KNIFE = "Faca",
	WEAPON_NIGHTSTICK = "Cassetete",
	WEAPON_HAMMER = "Martelo",
	WEAPON_BAT = "Bastão",
	WEAPON_CROWBAR = "Pé de cabra",
	WEAPON_GOLFCLUB = "Taco de Golf",
	WEAPON_BOTTLE = "Garrafa",
	WEAPON_DAGGER = "Adaga",
	WEAPON_HATCHET = "Machado",
	WEAPON_KNUCKLE = "Soco Inglês",
	WEAPON_MACHETE = "Machete",
	WEAPON_FLASHLIGHT = "Lanterna",
	WEAPON_SWITCHBLADE = "Canivete",
	WEAPON_POOLCUE = "Taco de Sinuca",
	WEAPON_WRENCH = "Chave Inglêsa",
	WEAPON_BATTLEAXE = "Machado de Batalha",

	WEAPON_PISTOL = "Pistol",
	WEAPON_PISTOL_MK2 = "Pistol MK2",
	WEAPON_COMBATPISTOL = "Combat Pistol",
	WEAPON_PISTOL50 = "Pistol .50",
	WEAPON_SNSPISTOL = "SNS Pistol",
	WEAPON_HEAVYPISTOL = "Heavy Pistol",
	WEAPON_VINTAGEPISTOL = "Vintage Pistol",
	WEAPON_MARKSMANPISTOL = "Marksman Pistol",
	WEAPON_REVOLVER = "Revolver",
	WEAPON_APPISTOL = "AP Pistol",
	WEAPON_STUNGUN = "Taser",
	WEAPON_FLAREGUN = "Sinalizador",

	WEAPON_MICROSMG = "Micro SMG",
	WEAPON_MACHINEPISTOL = "Machine Pistol",
	WEAPON_SMG = "SMG",
	WEAPON_SMG_MK2 = "SMG MK2",
	WEAPON_ASSAULTSMG = "MTAR",
	WEAPON_COMBATPDW = "Sig Sauer",
	WEAPON_MG = "MG",
	WEAPON_COMBATMG = "CombatMG",
	WEAPON_COMBATMG_MK2 = "CombatMG MK2",
	WEAPON_GUSENBERG = "Thompson",
	WEAPON_MINISMG = "Mini SMG",

	WEAPON_ASSAULTRIFLE = "Assault Rifle",
	WEAPON_ASSAULTRIFLE_MK2 = "Assault Rifle MK2",
	WEAPON_CARBINERIFLE = "Carbine Rifle",
	WEAPON_CARBINERIFLE_MK2 = "Carbine Rifle MK2",
	WEAPON_ADVANCEDRIFLE = "Advanced Rifle",
	WEAPON_SPECIALCARBINE = "Special Carbine",
	WEAPON_SPECIALCARBINE_MK2 = "Special Carbine MK2",
	WEAPON_BULLPUPRIFLE = "Bullpup Rifle",
	WEAPON_BULLPUPRIFLE_MK2 = "Bullpup Rifle MK2",
	WEAPON_COMBATRIFLE = "Compact Rifle",

	WEAPON_SNIPERRIFLE = "Sniper Rifle",
	WEAPON_HEAVYRIFLE = "Heavy Sniper",
	WEAPON_HEAVYRIFLE_MK2 = "Heavy Sniper MK2",
	WEAPON_MARKSMANRIFLE = "Marksman Rifle",
	WEAPON_MARKSMANRIFLE_MK2 = "Marksman Rifle MK2",

	WEAPON_PUMPSHOTGUN = "Pump Shotgun",
	WEAPON_SAWNOFFSHOTGUN = "Sawnoff Shotgun",
	WEAPON_BULLPUPSHOTGUN = "Bullpup Shotgun",
	WEAPON_ASSAULTSHOTGUN = "Assault Shotgun",
	WEAPON_MUSKET = "Musket",
	WEAPON_HEAVYSHOTGUN = "Heavy Shotgun",
	WEAPON_DBSHOTGUN = "Double Barrel Shotgun",
	WEAPON_AUTOSHOTGUN = "Auto Shotgun",

	WEAPON_GRENADELAUNCHER = "Grenade Launcher",
	WEAPON_RPG = "RPG",
	WEAPON_MINIGUN = "Minigun",
	WEAPON_FIREWORK = "FireWork",
	WEAPON_RAILGUN = "RailGun",
	WEAPON_HOMINGLAUNCHER = "Homing Launcher",
	WEAPON_GRENADELAUNCHER_SMOKE = "Grenade Launcher Smoke",
	WEAPON_COMPACTLAUNCHER = "Compact Launcher",

	WEAPON_GRENADE = "Grenade",
	WEAPON_STICKYBOMB = "Sticky Bomb",
	WEAPON_PROXIMITYMINE = "ProximityMine",
	WEAPON_BZGAS = "BZGas",
	WEAPON_MOLOTOV = "Molotov",
	WEAPON_FIREEXTINGUISHER = "Extintor",
	WEAPON_PETROLCAN = "Petrolcan",
	WEAPON_FLARE = "Flare",
	WEAPON_BALL = "Bola",
	WEAPON_SNOWBALL = "Bola de Neve",
	WEAPON_SMOKEGRENADE = "Smoke Grenade",
	WEAPON_PIPEBOMB = "Pipe bomb",
}

local wallStatus = false

local weaponHashList = {}
CreateThread(function()
	TriggerServerEvent("heyy:setWallStatus", false)

	for k, v in pairs(weaponList) do
		weaponHashList[GetHashKey(k)] = v
	end
end)

RegisterNetEvent("heyy:toggleWall", function()
	wallStatus = not wallStatus
	TriggerServerEvent("heyy:setWallStatus", wallStatus)

	TriggerEvent("Notify", (wallStatus and "sucesso" or "aviso"), "Wall " .. (wallStatus and "ativado" or "desativado") .. " com sucesso!")

	CreateThread(function()
		while wallStatus do
			for _, pID in ipairs(GetActivePlayers()) do
				local pPed = GetPlayerPed(pID)
				local pServerID = GetPlayerServerId(pID)

				if pPed and pServerID and pPed ~= PlayerPedId() then
					local x, y, z = table.unpack(GetEntityCoords(pPed))
					local health = GetEntityHealth(pPed)
					local armour = GetPedArmour(pPed)
					local armed, currentWeapon = GetCurrentPedWeapon(pPed)

					local state = GlobalState.wall[tostring(pServerID)]
					
					local playerID
					local playerName
					local weaponName = weaponHashList[currentWeapon] or currentWeapon

					local wallStatus = false
					local playerGroups = ""
					if state then
						playerID = state.playerID
						playerName = state.playerName
						playerGroups = getGroups(state.playerGroups)
						wallStatus = state.wallStatus
					end

					local wallText = (playerName or "Indefinido") .. " (~g~" .. (playerID or ("#" .. pServerID)) .. "~w~)"
					local healthColor = "~g~"
					if health <= 101 then
						wallText = wallText .. " ~r~(MORTO)"
						healthColor = "~r~"
					end
					wallText = wallText .. "\n~w~HP: " .. (healthColor .. health)
					if armour > 0 then
						wallText = wallText .. " ~w~| AP: ~b~" .. armour .. "~w~"
					end

					if armed then
						wallText = wallText .. "\n~y~" .. weaponName .. ""
					end
					if playerGroups and playerGroups ~= "" then
						wallText = wallText .. "\n~o~" .. playerGroups .. ""
					end
					if wallStatus then
						wallText = wallText .. "\n~g~(WALL)"
					end

					drawText(x, y, z, wallText)
				end
			end
			Wait(5)
		end
	end)
end)

function getGroups(groupList)
	return table.concat((json.decode(groupList) or {}), ", ");	
end

function drawText(x, y, z, text)
	local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z);
	if not onScreen then return end

	SetTextFont(4)
	SetTextScale(0.4, 0.4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 255)
	SetTextEdge(1, 0, 0, 0, 150)
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text);
	DrawText(screenX, screenY);
end


local userList = {}
local userBlips = {}

RegisterNetEvent("playerBlips:Display")
AddEventHandler("playerBlips:Display",function(status)
	display = status
end)

RegisterNetEvent("playerBlips:updateBlips")
AddEventHandler("playerBlips:updateBlips",function(status)
	userList = status
end)

RegisterNetEvent("playerBlips:cleanBlips")
AddEventHandler("playerBlips:cleanBlips",function()
	for k,v in pairs(userBlips) do
		RemoveBlip(userBlips[k])
	end

	userList = {}
	userBlips = {}
end)

RegisterNetEvent("playerBlips:removeBlips")
AddEventHandler("playerBlips:removeBlips",function(source)
	if DoesBlipExist(userBlips[source]) then
		RemoveBlip(userBlips[source])
		userBlips[source] = nil
		userList[source] = nil
	end
end)

CreateThread(function()
	while true do
		for k,v in pairs(userList) do
			if DoesBlipExist(userBlips[k]) then
				SetBlipCoords(userBlips[k],v[1],v[2],v[3])
			else
				userBlips[k] = AddBlipForCoord(v[1],v[2],v[3])
				SetBlipSprite(userBlips[k],1)
				SetBlipScale(userBlips[k],0.5)
				SetBlipColour(userBlips[k],v[5])
				SetBlipAsShortRange(userBlips[k],false)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v[4])
				EndTextCommandSetBlipName(userBlips[k])
			end
		end

		Wait(500)
	end
end)