-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
tvRP = {}
Tunnel.bindInterface("vRP",tvRP)
vRPS = Tunnel.getInterface("vRP")
Proxy.addInterface("vRP",tvRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:playerActive")
AddEventHandler("vRP:playerActive",function(user_id,name)
	LocalPlayer["state"]["Active"] = true
	LocalPlayer["state"]["Id"] = user_id

	SetDiscordAppId(1052669376119189544)
	SetDiscordRichPresenceAsset("logo")
	SetRichPresence("#"..user_id.." "..name)
	
	SetDiscordRichPresenceAssetText("Hiro Dev")
	-- SetDiscordRichPresenceAction(0, "DISCORD", "https://discord.gg/rogueroleplay")
    -- SetDiscordRichPresenceAction(1, "INSTAGRAM", "https://www.instagram.com/rogue_roleplay/")

	ReplaceHudColourWithRgba(116,128,19,54,255)
	SetPlayerCanUseCover(PlayerId(),false)
    SetEntityInvincible(PlayerPedId(),true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.teleport(x,y,z)
	SetEntityCoords(PlayerPedId(),x + 0.0001,y + 0.0001,z + 0.0001,1,0,0,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Players()
	local Players = {}
	for _,v in ipairs(GetActivePlayers()) do
		Players[#Players + 1] = GetPlayerServerId(v)
	end

	return Players
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.nearestPlayer(Radius)
	local Selected = false
	local Min = Radius + 0.0001
	local List = tvRP.nearestPlayers(Radius)

	for _,v in pairs(List) do
		if v[1] <= Min then
			Selected = v[2]
			Min = v[1]
		end
	end

	return Selected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEARESTPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.nearestPlayers(Radius)
	local List = {}
	local Ped = PlayerPedId()
	local Players = GetPlayers()
	local Coords = GetEntityCoords(Ped)

	for Source,v in pairs(Players) do
		local uPlayer = GetPlayerFromServerId(Source)
		if uPlayer ~= PlayerId() and NetworkIsPlayerConnected(uPlayer) then
			local uPed = GetPlayerPed(uPlayer)
			local uCoords = GetEntityCoords(uPed)
			local Distance = #(Coords - uCoords)
			if Distance <= Radius then
				List[uPlayer] = { Distance,Source }
			end
		end
	end

	return List
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARANIM
-----------------------------------------------------------------------------------------------------------------------------------------
local animActived = false
local animDict = nil
local animName = nil
local animFlags = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.playAnim(upper,seq,looping)
	local ped = PlayerPedId()
	if seq.task then
		tvRP.stopAnim(true)
		if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
			local coords = GetEntityCoords(ped)
			TaskStartScenarioAtPosition(ped,seq.task,coords.x,coords.y,coords.z-1,GetEntityHeading(ped),0,0,false)
		else
			TaskStartScenarioInPlace(ped,seq.task,0,not seq.play_exit)
		end
	else
		tvRP.stopAnim(upper)

		local flags = 0

		if upper then
			flags = flags + 48
		end

		if looping then
			flags = flags + 1
		end

		CreateThread(function()
			RequestAnimDict(seq[1])
			while not HasAnimDictLoaded(seq[1]) do
				RequestAnimDict(seq[1])
				Wait(10)
			end

			if HasAnimDictLoaded(seq[1]) then
				animDict = seq[1]
				animName = seq[2]
				animFlags = flags
				if flags == 49 then
					animActived = true
				end
				TaskPlayAnim(ped,seq[1],seq[2],3.0,3.0,-1,flags,0,0,0,0)
			end
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if animActived then
			if not IsEntityPlayingAnim(ped,animDict,animName,3) then
				TaskPlayAnim(ped,animDict,animName,3.0,3.0,-1,animFlags,0,0,0,0)
				timeDistance = 1
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if animActived then
			TimeDistance = 1
			DisableControlAction(1,16,true)
			DisableControlAction(1,17,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisablePlayerFiring(Ped,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.stopAnim(upper)
	animActived = false
	if upper then
		ClearPedSecondaryTask(PlayerPedId())
	else
		ClearPedTasks(PlayerPedId())
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.stopActived()
	animActived = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADQUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if NetworkIsSessionStarted() then
			TriggerServerEvent("Queue:playerActivated")
			return
		end
		Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYSOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.playSound(dict,name)
	PlaySoundFrontend(-1,dict,name,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYSOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.deleteNpcs()
	local handle,ped = FindFirstPed()
	local finished = false
	repeat
		local coords = GetEntityCoords(ped)
		local coordsPed = GetEntityCoords(PlayerPedId())
		local distance = #(coords - coordsPed)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			TriggerServerEvent("tryDeleteEntity",PedToNet(ped))
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end