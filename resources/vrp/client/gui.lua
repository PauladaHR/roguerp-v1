-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Walk = nil
local crouch = false
local uPoint = false
local object = nil
local animDict = nil
local animName = nil
local animActived = false
local cdBtns = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Drunk"] = false
LocalPlayer["state"]["Cancel"] = false
LocalPlayer["state"]["Route"] = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Cancel")
AddEventHandler("vRP:Cancel",function(status)
	LocalPlayer["state"]["Cancel"] = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if LocalPlayer["state"]["Cancel"] then
			timeDistance = 1
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,38,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,137,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WALKMODE
-----------------------------------------------------------------------------------------------------------------------------------------
local walkMode = {
	"move_m@alien","anim_group_move_ballistic","move_f@arrogant@a","move_m@brave","move_m@casual@a","move_m@casual@b","move_m@casual@c",
	"move_m@casual@d","move_m@casual@e","move_m@casual@f","move_f@chichi","move_m@confident","move_m@business@a","move_m@business@b",
	"move_m@business@c","move_m@drunk@a","move_m@drunk@slightlydrunk","move_m@buzzed","move_m@drunk@verydrunk","move_f@femme@",
	"move_characters@franklin@fire","move_characters@michael@fire","move_m@fire","move_f@flee@a","move_p_m_one","move_m@gangster@generic",
	"move_m@gangster@ng","move_m@gangster@var_e","move_m@gangster@var_f","move_m@gangster@var_i","anim@move_m@grooving@","move_f@heels@c",
	"move_m@hipster@a","move_m@hobo@a","move_f@hurry@a","move_p_m_zero_janitor","move_p_m_zero_slow","move_m@jog@","anim_group_move_lemar_alley",
	"move_heist_lester","move_f@maneater","move_m@money","move_m@posh@","move_f@posh@","move_m@quick","female_fast_runner","move_m@sad@a",
	"move_m@sassy","move_f@sassy","move_f@scared","move_f@sexy@a","move_m@shadyped@a","move_characters@jimmy@slow@","move_m@swagger",
	"move_m@tough_guy@","move_f@tough_guy@","move_p_m_two","move_m@bag","move_m@injured"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("andar",function(source,args,rawCommand)
	if exports["chat"]:statusChat() and MumbleIsConnected() then
		local ped = PlayerPedId()

		if args[1] then
			local mode = parseInt(args[1])
			if walkMode[mode] then
				RequestAnimSet(walkMode[mode])
				while not HasAnimSetLoaded(walkMode[mode]) do
					Wait(1)
				end

				SetPedMovementClipset(ped,walkMode[mode],0.25)
				Walk = walkMode[mode]
			end
		else
			ResetPedMovementClipset(ped,0.25)
			Walk = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.request(id,titulo,text,time)
	SendNUIMessage({ act = "request", id = id, titulo = tostring(titulo), text = tostring(text), time = time })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUIPROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("prompt",function(data,cb)
	if data["act"] == "close" then
		SetNuiFocus(false,false)
		vRPS._promptResult(data["result"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.prompt(title,default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("request",function(data,cb)
	if data.act == "response" then
		vRPS._requestResult(data.id,data.ok)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIMSET
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.loadAnimSet(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(10)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.createObjects(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
	if DoesEntityExist(object) then
		TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
		object = nil
	end

	local ped = PlayerPedId()
	local mHash = GetHashKey(prop)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Wait(10)
	end

	if anim ~= "" then
		tvRP.loadAnimSet(dict)
		TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
	end

	if pos1 then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObjectNoOffset(mHash,coords.x,coords.y,coords.z,true,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),pos1,pos2,pos3,pos4,pos5,pos6,true,true,false,true,1,true)
	else
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObjectNoOffset(mHash,coords.x,coords.y,coords.z,true,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
	end
	SetEntityAsMissionEntity(object,true,true)
	SetModelAsNoLongerNeeded(mHash)

	NetworkRegisterEntityAsNetworked(object)
	while not NetworkGetEntityIsNetworked(object) do
		Wait(10)
	end

	animDict = dict
	animName = anim
	animFlags = flag
	animActived = true

	local netid = ObjToNet(object)
	SetNetworkIdExistsOnAllMachines(netid,true)
	NetworkSetNetworkIdDynamic(netid,true)
	SetNetworkIdCanMigrate(netid,false)
	for _,i in ipairs(GetActivePlayers()) do
		SetNetworkIdSyncToPlayer(netid,i,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeActived()
	if animActived then
		if DoesEntityExist(object) then
			TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
			object = nil
		end
		animActived = false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if animActived and LocalPlayer["state"]["Active"] then
			local ped = PlayerPedId()
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
		local timeDistance = 999
		local ped = PlayerPedId()
		if animActived then
			timeDistance = 4
			DisableControlAction(1,16,true)
			DisableControlAction(1,17,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeObjects(status)
	if status == "one" then
		tvRP.stopAnim(true)
	elseif status == "two" then
		tvRP.stopAnim(false)
	else
		tvRP.stopAnim(true)
		tvRP.stopAnim(false)
	end

	animActived = false
	TriggerEvent("camera")
	TriggerEvent("binoculos")
	if DoesEntityExist(object) then
		TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
		object = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVcrouch",function(source,args)
	if GetGameTimer() >= cdBtns and LocalPlayer["state"]["Active"] and MumbleIsConnected() then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 101 and not LocalPlayer["state"]["Cancel"] and not IsPedReloading(ped) then
			if not IsPedInAnyVehicle(ped) then

				RequestAnimSet("move_ped_crouched")
				while not HasAnimSetLoaded("move_ped_crouched") do
					Wait(1)
				end

				if crouch then
					ResetPedMovementClipset(ped,0.25)
					crouch = false

					if Walk ~= nil then
						RequestAnimSet(Walk)
						while not HasAnimSetLoaded(Walk) do
							Wait(1)
						end

						SetPedMovementClipset(ped,Walk,0.25)
					end
				else
					SetPedMovementClipset(ped,"move_ped_crouched",0.25)
					crouch = true
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 100
		if uPoint and LocalPlayer["state"]["Active"] then
			timeDistance = 1
			local ped = PlayerPedId()
			local camPitch = GetGameplayCamRelativePitch()

			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local nn = 0
			local blocked = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped,(cosCamHeading*-0.2)-(sinCamHeading*(0.4*camHeading+0.3)),(sinCamHeading*-0.2)+(cosCamHeading*(0.4*camHeading+0.3)),0.6)
			local ray = Cast_3dRayPointToPoint(coords["x"],coords["y"],coords["z"]-0.2,coords.x,coords.y,coords.z+0.2,0.4,95,ped,7);
			nn,blocked,coords,coords = GetRaycastResult(ray)

			SetTaskMoveNetworkSignalFloat(ped,"Pitch",camPitch)
			SetTaskMoveNetworkSignalFloat(ped,"Heading",camHeading * -1.0 + 1.0)
			SetTaskMoveNetworkSignalBool(ped,"isBlocked",blocked)
			SetTaskMoveNetworkSignalBool(ped,"isFirstPerson",GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		DisableControlAction(1,157,false)
		DisableControlAction(1,158,false)
		DisableControlAction(1,160,false)
		DisableControlAction(1,164,false)
		DisableControlAction(1,165,false)
		DisableControlAction(1,159,false)
		DisableControlAction(1,161,false)
		DisableControlAction(1,162,false)
		DisableControlAction(1,163,false)

		DisableControlAction(0,36,true)
		Wait(4)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIGARVEH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVengine",function(source,args)
	if GetGameTimer() >= cdBtns and LocalPlayer["state"]["Active"] and MumbleIsConnected() then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 101 and not LocalPlayer["state"]["Cancel"] and not IsPedReloading(ped) then
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				if GetPedInVehicleSeat(vehicle,-1) == ped then
					tvRP.removeObjects("two")
					local running = GetIsVehicleEngineRunning(vehicle)
					SetVehicleEngineOn(vehicle,not running,true,true)
					if running then
						SetVehicleUndriveable(vehicle,true)
					else
						SetVehicleUndriveable(vehicle,false)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVbind",function(source,args)
	if GetGameTimer() >= cdBtns and LocalPlayer["state"]["Active"] and MumbleIsConnected() then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and GetEntityHealth(ped) > 100 and not LocalPlayer["state"]["Cancel"] and not IsPedReloading(ped) then
			if parseInt(args[1]) >= 1 and parseInt(args[1]) <= 5 then
				TriggerServerEvent("vrp_inventory:useItem",args[1],1)
			elseif args[1] == "6" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",3) then
						StopAnimTask(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",8.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"anim@heists@heist_corona@single_team","single_team_loop_boss"},true)
					end
				end
			elseif args[1] == "7" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"mini@strip_club@idles@bouncer@base","base",3) then
						StopAnimTask(ped,"mini@strip_club@idles@bouncer@base","base",8.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"mini@strip_club@idles@bouncer@base","base"},true)
					end
				end
			elseif args[1] == "8" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
						StopAnimTask(ped,"anim@mp_player_intupperfinger","idle_a_fp",8.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"anim@mp_player_intupperfinger","idle_a_fp"},true)
					end
				end
			elseif args[1] == "9" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
						StopAnimTask(ped,"random@arrests@busted","idle_a",8.0)
						tvRP.stopActived()
					else
						tvRP.playAnim(true,{"random@arrests@busted","idle_a"},true)
					end
				end
			elseif args[1] == "left" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intupperthumbs_up","enter"},false)
				end
			elseif args[1] == "right" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intcelebrationmale@face_palm","face_palm"},false)
				end
			elseif args[1] == "up" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"anim@mp_player_intcelebrationmale@salute","salute"},false)
				end
			elseif args[1] == "down" then
				if not IsPedInAnyVehicle(ped) and not IsPedArmed(ped,6) and not IsPedSwimming(ped) then
					tvRP.playAnim(true,{"rcmnigel1c","hailing_whistle_waive_a"},false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDELETEENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncDeleteEntity")
AddEventHandler("syncDeleteEntity",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCCLEANENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncCleanEntity")
AddEventHandler("syncCleanEntity",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetVehicleDirtLevel(v,0.0)
			SetVehicleUndriveable(v,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lockVehicles",function(source,args)
	if GetGameTimer() >= cdBtns then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not IsPedSwimming(ped) and GetEntityHealth(ped) > 101 and not IsPedReloading(ped) then
			local vehicle,vehNet,vehPlate,vehName,vehLock = tvRP.vehList(5)
			if vehicle then
				TriggerServerEvent("vrp_garages:lockVehicle",vehNet,vehPlate,vehLock)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELF6
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVcancelf6",function(source,args,rawCommand)
	if GetGameTimer() >= cdBtns and LocalPlayer["state"]["Active"] and MumbleIsConnected() then
		cdBtns = GetGameTimer() + 1000

		local ped = PlayerPedId()
		if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 101 and not LocalPlayer["state"]["Cancel"] and not IsPedReloading(ped) then
			TriggerServerEvent("vrp_inventory:Cancel")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDSUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVhandsup",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not LocalPlayer["state"]["Cancel"] and LocalPlayer["state"]["Active"] and MumbleIsConnected() and not IsPedReloading(ped) then
		if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
			StopAnimTask(ped,"random@mugging3","handsup_standing_base",2.0)
			tvRP.stopActived()
		else
			tvRP.playAnim(true,{"random@mugging3","handsup_standing_base"},true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVpoint",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if not IsPauseMenuActive() and not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Cancel"] and not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 100 and LocalPlayer["state"]["Active"] and MumbleIsConnected() and not IsPedReloading(ped) then
		tvRP.loadAnimSet("anim@mp_point")

		if not uPoint then
			tvRP.stopActived()
			SetPedConfigFlag(ped,36,true)
			TaskMoveNetwork(ped,"task_mp_pointing",0.5,0,"anim@mp_point",24)
			uPoint = true
		else
			RequestTaskMoveNetworkStateTransition(ped,"Stop")
			if not IsPedInjured(ped) then
				ClearPedSecondaryTask(ped)
			end

			SetPedConfigFlag(ped,36,false)
			ClearPedSecondaryTask(ped)
			uPoint = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCEPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVaccept",function(source,args,rawCommand)
	SendNUIMessage({ act = "event", event = "Y" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("HVreject",function(source,args,rawCommand)
	SendNUIMessage({ act = "event", event = "U" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("HVhandsup","Levantar as mãos","keyboard","x")
RegisterKeyMapping("HVpoint","Apontar os dedos","keyboard","b")
RegisterKeyMapping("HVengine","Ligar o veículo","keyboard","z")
RegisterKeyMapping("HVcrouch","Agachar.","keyboard","LCONTROL")
RegisterKeyMapping("HVbind 1","Bind 1","keyboard","1")
RegisterKeyMapping("HVbind 2","Bind 2","keyboard","2")
RegisterKeyMapping("HVbind 3","Bind 3","keyboard","3")
RegisterKeyMapping("HVbind 4","Bind 4","keyboard","4")
RegisterKeyMapping("HVbind 5","Bind 5","keyboard","5")
RegisterKeyMapping("HVbind 6","Bind 6","keyboard","6")
RegisterKeyMapping("HVbind 7","Bind 7","keyboard","7")
RegisterKeyMapping("HVbind 8","Bind 8","keyboard","8")
RegisterKeyMapping("HVbind 9","Bind 9","keyboard","9")
RegisterKeyMapping("HVbind left","Bind Left","keyboard","left")
RegisterKeyMapping("HVbind right","Bind Right","keyboard","right")
RegisterKeyMapping("HVbind up","Bind Up","keyboard","up")
RegisterKeyMapping("HVbind down","Bind Down","keyboard","down")
RegisterKeyMapping("HVmoc","Abrir a mochila","keyboard","oem_3")
RegisterKeyMapping("HVnotify","Abrir as notificações","keyboard","f2")
RegisterKeyMapping("HVtencode","Abrir o código dez","keyboard","f3")
RegisterKeyMapping("HVcancelf6","Cancelar animações","keyboard","f6")
RegisterKeyMapping("HVaccept","Aceitar chamado","keyboard","y")
RegisterKeyMapping("HVreject","Rejeitar chamado","keyboard","u")
RegisterKeyMapping("lockVehicles","Trancar veículo","keyboard","L")