-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Treatment = false
local DeadPlayer = false
local DeathCount = 600
local invencibleCount = 0
local updateTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Active"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:playerActive")
AddEventHandler("vRP:playerActive",function(user_id)
	LocalPlayer["state"]["Active"] = true

	SetDiscordAppId(942835016449278012)
	SetDiscordRichPresenceAsset("rogue")
	SetDiscordRichPresenceAssetSmall("rogue")
	SetRichPresence(user_id.." - ROGUE RP")
	SetDiscordRichPresenceAssetText("ROGUE")
	SetDiscordRichPresenceAssetSmallText("ROGUE")
	SetDiscordRichPresenceAction(0, "DISCORD", "https://discord.gg/rogueroleplay")
    SetDiscordRichPresenceAction(1, "INSTAGRAM", "https://www.instagram.com/rogue_roleplay/")

	ReplaceHudColourWithRgba(116,128,19,54,255)
	SetPlayerCanUseCover(PlayerId(),false)
    SetEntityInvincible(PlayerPedId(),true)

	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_LOST"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_MEXICAN"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_FAMILY"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_BALLAS"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_MARABUNTE"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_CULT"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_SALVA"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_WEICHENG"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AMBIENT_GANG_HILLBILLY"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("AGGRESSIVE_INVESTIGATE"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("GANG_1"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("GANG_2"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("GANG_9"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("GANG_10"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("FIREMAN"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("MEDIC"),GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1,GetHashKey("COP"),GetHashKey('PLAYER'))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			if GetGameTimer() >= updateTimers then
				local ped = PlayerPedId()
				updateTimers = GetGameTimer() + 10000

				if invencibleCount < 3 then
					invencibleCount = invencibleCount + 1

					if invencibleCount >= 3 then
						SetEntityInvincible(ped,false)
					end
				end
			end
		end

		Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if LocalPlayer["state"]["Active"] then

			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			if GetEntityHealth(ped) <= 101 then
				if not DeadPlayer then
					DeathCount = 1200
					DeadPlayer = true

					SendNUIMessage({ death = true })

					NetworkResurrectLocalPlayer(coords,true,true,false)

					SetEntityHealth(ped,101)
					SetEntityInvincible(ped,true)

					TriggerServerEvent("vrp_inventory:Cancel")
					TriggerEvent("pma-voice:toggleMute",true)
					TriggerEvent("vrp_radio:outServers")
					TriggerEvent("inventory:Close")
					LocalPlayer["state"]["Buttons"] = true
				else
					timeDistance = 1
					if DeathCount > 0 then
						SetEntityHealth(ped,101)
						SendNUIMessage({ deathtext = "NOCAUTEADO, AGUARDE <color>"..DeathCount.." SEGUNDOS</color>" })
					else
						SendNUIMessage({ deathtext = "DIGITE /GG PARA DESISTIR IMEDIATAMENTE" })
					end

					if not IsEntityPlayingAnim(ped,"dead","dead_a",3) and not IsPedInAnyVehicle(ped) then
						tvRP.playAnim(false,{"dead","dead_a"},true)
					end

				end
			end
		end


		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.finishDeath()
	local ped = PlayerPedId()
	if GetEntityHealth(ped) <= 101 then
		DeadPlayer = false
		SendNUIMessage({ death = false })
		tvRP.createBodyBag()
		ClearPedBloodDamage(ped)
		SetEntityHealth(ped,200)
		SetEntityInvincible(ped,false)
		TriggerServerEvent("clearInventory")
		TriggerEvent("pma-voice:toggleMute",false)
		LocalPlayer["state"]["Buttons"] = false
		LocalPlayer["state"]["Commands"] = false
		SetEntityCoords(ped,-773.68,-1274.75,5.24,170.08+0.5)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEBODYBAG
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.createBodyBag()
	RequestModel("xm_prop_body_bag")
	while not HasModelLoaded("xm_prop_body_bag") do
		Citizen.Wait(10)
	end
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	bodybag = CreateObject(GetHashKey("xm_prop_body_bag"),x,y,z,true,true,true)
	PlaceObjectOnGroundProperly(bodybag)
	SetModelAsNoLongerNeeded(bodybag)
	Citizen.InvokeNative(0xAD738C3085FE7E11,bodybag,true,true)
	SetEntityAsNoLongerNeeded(bodybag)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
		SetPlayerHealthRechargeLimit(PlayerId(),0)

		if GetEntityMaxHealth(PlayerPedId()) ~= 200 then
			SetEntityMaxHealth(PlayerPedId(),200)
			SetPedMaxHealth(PlayerPedId(),200)
		end

		Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DeathCount
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local DeathCounts = GetGameTimer()

	while true do
		if GetGameTimer() >= DeathCounts then
			DeathCounts = GetGameTimer() + 1000

			if DeadPlayer then
				if DeathCount > 0 then
					DeathCount = DeathCount - 1
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.checkDeath()
	if DeadPlayer and DeathCount <= 0 then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INKNOCKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.inKnockout()
	return DeadPlayer
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVEPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.revivePlayer(health)
	SetEntityHealth(PlayerPedId(),health)
	SetEntityInvincible(PlayerPedId(),false)
	TriggerEvent("pma-voice:toggleMute",false)
	LocalPlayer["state"]["Buttons"] = false
	LocalPlayer["state"]["Commands"] = false
	SendNUIMessage({ death = false })

	if DeadPlayer then
		DeadPlayer = false
		ClearPedTasks(PlayerPedId())
		ClearPedBloodDamage(PlayerPedId())
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCOMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if DeadPlayer then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,69,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CURE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.startCure()
	if not Treatment then
		LocalPlayer["state"]["Commands"] = true
		LocalPlayer["state"]["Buttons"] = true
		TriggerEvent("resetDiagnostic")
		TriggerServerEvent("resetPulse")
		Treatment = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREAT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local TreatmentTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= TreatmentTimers then
			TreatmentTimers = GetGameTimer() + 1000

			if Treatment then
				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)

				if health < 200 then
					SetEntityHealth(ped,health + 1)
				else
					Treatment = false
					LocalPlayer["state"]["Commands"] = false
					LocalPlayer["state"]["Buttons"] = false
					TriggerEvent("Notify","verde","Tratamento concluido.",5000)
				end
			end
		end

		Wait(500)
	end
end)

CreateThread(function()
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	Wait(1000)
	if health >= 102 then
		DeadPlayer = false
	end
end)