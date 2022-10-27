-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hiro = {}
Tunnel.bindInterface("vrp_spawn",Hiro)
vSERVER = Tunnel.getInterface("vrp_spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLocates = {}
local characterCamera = nil
local cam = nil
local charPed = nil
local currentCharacterMode = { fathersID = 0, mothersID = 0, skinColor = 0, shapeMix = 0, eyesColor = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0, noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0, cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0, jawHeight = 0, chinLength = 0, chinPosition = 0, chinWidth = 0, chinShape = 0, neckWidth = 0, hairModel = 0, hairOverlay = 0, firstHairColor = 0, secondHairColor = 0, eyebrowsModel = 0, eyebrowsIntensity = 0, eyebrowsColor = 0, beardModel = -1, beardIntensity = 0, beardColor = 0, chestModel = -1, chestColor = 0, blushModel = -1, blushColor = 0, lipstickModel = -1, lipstickColor = 0, blemishesModel = -1, ageingModel = -1, complexionModel = -1, sundamageModel = -1, frecklesModel = -1, makeupModel = -1 }
local oldID = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- OTHERLOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLocations = {
	{
		name = "Garagem - Los Santos",
		coords = {
			x = 101.26, y = -1080.48, z = 29.2
		},

		preview = function()
			previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 82.17,-1069.06,38.5, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(previewCamera, 119.65,-1070.86,29.66)

			SetCamActive(previewCamera, true)
			RenderScriptCams(true, false, 1, true, true)
		end,

		execute = function()
			local cam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
			SetCamFov(cam1, 40.0)
			SetCamCoord(cam1, 70.21,-1056.12,44.36)
			SetCamRot(cam1, -20.0, -0.0, -113.39, 2)
			
			local cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA")
			SetCamFov(cam2, 40.0)
			SetCamCoord(cam2, 94.29,-1065.04,31.88)
			SetCamRot(cam2, -18.40, -0.0, -114.24, 2)
			
			SetCamActiveWithInterp(cam2, cam1, 5000, 1, 1)	
			RenderScriptCams(true, false, 1, true, true)
			Wait(5000)

			DoScreenFadeOut(500)
			Wait(500)

			RenderScriptCams(false, false, 0, false, false)
			SetCamActive(cam1, false)
			SetCamActive(cam2, false)
			DestroyCam(cam1, true)
			DestroyCam(cam2, true)
		end
	},
	{
		name = "Garagem - Sandy Shores",
		coords = {
			x = 1140.85, y = 2652.49, z = 38.15
		},

		-- 11.21, -0, 139.44
		preview = function()
			previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1096.3,2675.64,43.36, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(previewCamera, 1141.37,2648.88,38.22)

			SetCamActive(previewCamera, true)
			RenderScriptCams(true, false, 1, true, true)
		end,

		execute = function()
			local cam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
			SetCamFov(cam1, 40.0)
			SetCamCoord(cam1, 1120.83,2693.27,39.36)
			SetCamRot(cam1, 7.23, -0.0, -137.80, 2)
			
			local cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA")
			SetCamFov(cam2, 40.0)
			SetCamCoord(cam2, 1120.83,2693.27,39.36)
			SetCamRot(cam2, -3.20, -0.0, -175.18, 2)
			
			SetCamActiveWithInterp(cam2, cam1, 5000, 1, 1)	
			RenderScriptCams(true, false, 1, true, true)
			Wait(5000)

			DoScreenFadeOut(500)
			Wait(500)

			RenderScriptCams(false, false, 0, false, false)
			SetCamActive(cam1, false)
			SetCamActive(cam2, false)
			DestroyCam(cam1, true)
			DestroyCam(cam2, true)
		end
	},
	{
		name = "Garagem - Paleto Bay",
		coords = {
			x = -138.78, y = 6364.1, z = 31.49
		}
	},
	{
		name = "Garagem - D. P. Freeway",
		coords = {
			x = -2026.46, y = -469.12, z = 11.42
		},

		preview = function()
			previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1605.0,-1128.88,41.03, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(previewCamera, -1662.24,-1126.74,31.55)

			SetEntityCoords(PlayerPedId(), -1651.2,-1108.6,33.76)

			SetCamActive(previewCamera, true)
			RenderScriptCams(true, false, 1, true, true)
		end,

		execute = function()
			local cam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
			SetCamFov(cam1, 40.0)
			SetCamCoord(cam1, -1619.49,-1129.64,35.58)
			SetCamRot(cam1, -5.43, -0.0, 85.37, 2)
			SetEntityCoords(PlayerPedId(), -1651.2,-1108.6,33.76)
			
			local cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA")
			SetCamFov(cam2, 40.0)
			SetCamCoord(cam2, -1623.9,-1140.58,4.66)
			SetCamRot(cam2, -0.11, -0.0, 162.34, 2)
			
			SetCamActiveWithInterp(cam2, cam1, 6000, 1, 1)	
			RenderScriptCams(true, false, 1, true, true)
			Wait(6000)

			DoScreenFadeOut(500)
			Wait(500)
			DoScreenFadeIn(500)

			local cam3 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
			SetCamFov(cam3, 40.0)
			SetCamCoord(cam3, -2043.29,-522.83,12.07)
			SetCamRot(cam3, -0.54, -0.0, 167.57, 2)
			SetEntityCoords(PlayerPedId(), -2043.29,-522.83,12.07)
			
			local cam4 = CreateCam("DEFAULT_SCRIPTED_CAMERA")
			SetCamFov(cam4, 40.0)
			SetCamCoord(cam4, -2043.29,-522.83,26.53)
			SetCamRot(cam4, -14.19, -0.0, -14.95, 2)
			
			SetCamActiveWithInterp(cam4, cam3, 4000, 1, 1)	
			RenderScriptCams(true, false, 1, true, true)
			Wait(4000)

			DoScreenFadeOut(500)
			Wait(500)

			local coord = { x = -2026.46, y = -469.12, z = 11.42 }
			SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)

			RenderScriptCams(false, false, 0, false, false)
			SetCamActive(cam1, false)
			SetCamActive(cam2, false)
			DestroyCam(cam1, true)
			DestroyCam(cam2, true)
		end
	},
	{
		name = "Departamento Policial",
		coords = {
			x = 427.16, y = -980.85, z = 30.72
		},

		preview = function()
			previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 380.67,-981.18,51.05, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(previewCamera, 424.58,-971.66,34.19)

			SetCamActive(previewCamera, true)
			RenderScriptCams(true, false, 1, true, true)
		end,

		execute = function()
			local cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 510.22,-1008.65,35.74, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(cam1, 497.27,-1007.33,30.65)

			local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 395.24,-1032.52,35.31, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(cam2, 427.11,-1025.52,30.38)
			
			local cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 412.69,-946.74,40.28, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(cam3, 424.58,-971.66,34.19)

			SetCamActiveWithInterp(cam2, cam1, 6000, 1, 1)	
			RenderScriptCams(true, false, 1, true, true)
			Wait(6000)
			SetCamActiveWithInterp(cam3, cam2, 6000, 1, 1)	
			Wait(6000)

			DoScreenFadeOut(500)
			Wait(500)

			RenderScriptCams(false, false, 0, false, false)
			SetCamActive(cam1, false)
			SetCamActive(cam2, false)
			SetCamActive(cam3, false)
			DestroyCam(cam1, true)
			DestroyCam(cam2, true)
			DestroyCam(cam3, true)
		end
	},
	{
		name = "Hospital",
		coords = {
			x = -875.34, y = -1201.17, z = 4.87
		},

		preview = function()
			previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -862.87,-1212.61,12.31, 0.0, 0.0, 0.0, 40.00, false, 0)
			PointCamAtCoord(previewCamera, -837.42,-1213.89,7.72)

			SetCamActive(previewCamera, true)
			RenderScriptCams(true, false, 1, true, true)
		end,

		execute = function()
			local cam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
			SetCamFov(cam1, 40.0)
			SetCamCoord(cam1, -823.27,-1222.32,8.29)
			SetCamRot(cam1, -6.3, -0.0, -129.42, 2)
			
			local cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA")
			SetCamFov(cam2, 40.0)
			SetCamCoord(cam2, -854.33,-1196.24,11.91)
			SetCamRot(cam2, -6.57, -0.0, -130.21, 2)
			
			SetCamActiveWithInterp(cam2, cam1, 6000, 1, 1)	
			RenderScriptCams(true, false, 1, true, true)
			Wait(6000)

			DoScreenFadeOut(500)
			Wait(500)

			RenderScriptCams(false, false, 0, false, false)
			SetCamActive(cam1, false)
			SetCamActive(cam2, false)
			DestroyCam(cam1, true)
			DestroyCam(cam2, true)
		end
	},
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:GENERATEJOIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_spawn:setupChars",function()
	Wait(5000)
    showSelector()
end)

function showSelector()
	DoScreenFadeOut(0)
	Wait(500)

    ClearScreen()
    Wait(0)
    SetEntityCoords(PlayerPedId(),-1448.95,-548.47,72.84)
	SwitchInPlayer(PlayerPedId())

    local timer = GetGameTimer()
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	FreezeEntityPosition(PlayerPedId(), true)
    SetEntityVisible(PlayerPedId(), false, false)
    CreateThread(function()
        RequestCollisionAtCoord(-1453.29, -551.6, 72.84)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(0)
        end
    end)
    Wait(1000)
    NetworkSetTalkerProximity(0.0)

	FreezeEntityPosition(PlayerPedId(), false)
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1456.11, -547.92, 73.1, 0.0 ,0.0, 216.53, 45.00, false, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)

	DoScreenFadeIn(1000)
	Wait(500)

	local result = vSERVER.getCharacters()

	SendNUIMessage({ action = "openSelector", characters = result.characters, maxCharacters = result.maxCharacters })
	SetNuiFocus(true,true)
end

function ClearScreen()
    SetCloudHatOpacity(1.0)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("chooseCharacter",function(data)
	TaskGoStraightToCoord(charPed,-1457.13,-546.06,72.85,1.0,-1,72.84,786603,1.0)
	Wait(3500)
	SetEntityAsMissionEntity(charPed,true,true)
	DeleteEntity(charPed)
	charPed = nil
	oldID = nil

	DoScreenFadeOut(1000)
	Wait(1000)
	TriggerServerEvent("vrp_spawn:charChosen",tonumber(data["id"]))
end)

RegisterNUICallback("deletePed",function()
	if charPed then
		TaskGoStraightToCoord(charPed,-1459.32,-551.79,72.85,1.0,-1,72.84,786603,1.0)
		Wait(2500)
		SetEntityAsMissionEntity(charPed,true,true)
		DeleteEntity(charPed)

        charPed = nil
        oldID = nil 
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("visualizeCharacter",function(data,cb)
	if charPed then
		if oldID == tonumber(data["id"]) then
			cb("ok")
			return
		end

        SendNUIMessage({ action = "closeSelect" })

		TaskGoStraightToCoord(charPed,-1459.32,-551.79,72.85,1.0,-1,72.84,786603,1.0)
		Wait(2500)
		SetEntityAsMissionEntity(charPed,true,true)
		DeleteEntity(charPed)
	end

    if data ~= nil then
		oldID = tonumber(data["id"])
        local model,character,clothings,tattoo = vSERVER.getCustomization(tonumber(data["id"]))
        if model ~= nil then
            CreateThread(function()
                local mHash = model

                RequestModel(mHash)
                while not HasModelLoaded(mHash) do
                    RequestModel(mHash)
                    Wait(10)
                end

                if HasModelLoaded(mHash) then
                    charPed = CreatePed(2,mHash,-1451.05,-554.69,72.84-0.98,36.04,false,true)
                    SetPedComponentVariation(charPed,0,0,0,2)
                    updateCharacter(charPed,character)
                    updateClothings(charPed,clothings)
                    updateTattoos(charPed,tattoo)

                    PlaceObjectOnGroundProperly(charPed)
                    TaskGoStraightToCoord(charPed,-1453.66,-551.25,72.84,1.0,-1,72.84,786603,1.0)
                    Wait(5000)

                    FreezeEntityPosition(charPed,false)
                    SetEntityInvincible(charPed,true)
                    SetBlockingOfNonTemporaryEvents(charPed,true)
                end
            end)
        else
            CreateThread(function()
                local randommodels = {
                    "mp_m_freemode_01",
                    "mp_f_freemode_01",
                }
                local model = GetHashKey(randommodels[math.random(1, #randommodels)])

                local mHash = model

                RequestModel(mHash)
                while not HasModelLoaded(mHash) do
                    RequestModel(mHash)
                    Wait(10)
                end

                if HasModelLoaded(mHash) then
                    charPed = CreatePed(2,mHash,-1451.05,-554.69,72.84-0.98,36.04,false,true)
                    SetPedComponentVariation(charPed,0,0,0,2)
                    
                    PlaceObjectOnGroundProperly(charPed)
                    TaskGoStraightToCoord(charPed,-1453.66,-551.25,72.84, 1.0, -1, 72.84, 786603, 1.0)
                    Wait(5000)

                    FreezeEntityPosition(charPed,false)
                    SetEntityInvincible(charPed,true)
                    SetBlockingOfNonTemporaryEvents(charPed,true)
                end
            end)
        end

        Wait(3600)
		cb("ok")
        SendNUIMessage({ action = "showSelectButton", id = data.id })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("newCharacter",function(data)
	if charPed then
		TaskGoStraightToCoord(charPed,-1459.32,-551.79,72.85,1.0,-1,72.84,786603,1.0)
		Wait(2500)
		SetEntityAsMissionEntity(charPed,true,true)
		DeleteEntity(charPed)
		charPed = nil
	end

	if not vSERVER.canCreateNewChar() then
		TriggerEvent("Notify","negado","Você já atingiu o número máximo de personagens!")
		SendNUIMessage({ action = "openSystem" })
		return
	end

	CreateThread(function()
		local mHash = data.gender

		RequestModel(mHash)
		while not HasModelLoaded(mHash) do
			RequestModel(mHash)
			Wait(10)
		end

		if HasModelLoaded(mHash) then
			charPed = CreatePed(2,mHash,-1451.05,-554.69,72.84-0.98,36.04,false,true)
			SetPedComponentVariation(charPed,0,0,0,2)

			updateCharacter(ped,currentCharacterMode)

			PlaceObjectOnGroundProperly(charPed)
			TaskGoStraightToCoord(charPed,-1457.13,-546.06,72.85,1.0,-1,72.84,786603,1.0)
			Wait(5000)

			FreezeEntityPosition(charPed, false)
			SetEntityInvincible(charPed, true)
			SetBlockingOfNonTemporaryEvents(charPed,true)
		end
	end)

	Wait(6500)
	SetEntityAsMissionEntity(charPed,true,true)
	DeleteEntity(charPed)
	charPed = nil
	oldID = nil

	TriggerServerEvent("vrp_spawn:createChar", data.name, data.name2, data.gender)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JUSTSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_spawn:justSpawn",function(spawnType)
	DoScreenFadeOut(0)

	spawnLocates = {}
	local ped = PlayerPedId()
	RenderScriptCams(false,false,0,true,true)
	SetCamActive(characterCamera,false)
	DestroyCam(characterCamera,true)
	characterCamera = nil

	if spawnType then
		SetNuiFocus(true,true)

		SetEntityVisible(ped,false,false)
		SetEntityInvincible(ped,false)--mqcu

		for k,v in ipairs(spawnLocations) do
			spawnLocates[k] = { x = v.coords.x, y = v.coords.y, z = v.coords.z, name = v.name, id = k }
		end

		Wait(2000)
		DoScreenFadeIn(1000)

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		characterCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",coords.x,coords.y,coords.z + 200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(characterCamera,true)
		RenderScriptCams(true,false,1,true,true)

		SendNUIMessage({ action = "openSpawn", spawnLocations = spawnLocates })
	else
		SetEntityVisible(ped,true,false)
		FreezeEntityPosition(ped,false)
		TriggerEvent("hud:Active",true)
		SetEntityInvincible(ped,false)
		SetNuiFocus(false,false)

		Wait(1000)
		DoScreenFadeIn(1000)
	end

	TriggerEvent("hud:Active", true)
	LocalPlayer["state"]["Commands"] = false
	LocalPlayer["state"]["Buttons"] = false
end)

RegisterCommand("openspawn", function()
	DoScreenFadeIn(0)

	spawnLocates = {}
	local ped = PlayerPedId()
	RenderScriptCams(false,false,0,true,true)
	SetCamActive(characterCamera,false)
	DestroyCam(characterCamera,true)
	characterCamera = nil

	SetNuiFocus(true,true)

	SetEntityVisible(ped,false,false)
	SetEntityInvincible(ped,false)--mqcu

	for k,v in ipairs(spawnLocations) do
		spawnLocates[k] = { x = v.coords.x, y = v.coords.y, z = v.coords.z, name = v.name, id = k }
	end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	characterCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",coords.x,coords.y,coords.z + 200.0,270.00,0.0,0.0,80.0,0,0)
	SetCamActive(characterCamera,true)
	RenderScriptCams(true,false,1,true,true)

	SendNUIMessage({ action = "openSpawn", spawnLocations = spawnLocates })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("previewSpawn",function(data)
	local spawn = spawnLocations[data.id]

	DoScreenFadeOut(0)
	Wait(250)
	SetCamActive(characterCamera, false)

	if characterCamera then
		RenderScriptCams(false,false,0,true,true)
		SetCamActive(characterCamera,false)
		DestroyCam(characterCamera,true)
		characterCamera = nil
	end

	if previewCamera then
		RenderScriptCams(false,false,0,true,true)
		SetCamActive(previewCamera,false)
		DestroyCam(previewCamera,true)
		previewCamera = nil
	end

	SetEntityVisible(PlayerPedId(), false)
	SetEntityCoords(PlayerPedId(), spawn.coords.x, spawn.coords.y, spawn.coords.z)

	SetTimeout(10000,function()
		NetworkResurrectLocalPlayer(spawn.coords.x, spawn.coords.y, spawn.coords.z,true,true,false)
	end)
	
	if spawn.preview then
		spawn.preview()
	else
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",coords.x,coords.y,coords.z + 200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(previewCamera, true)
		RenderScriptCams(true,false,1,true,true)
	end

	Wait(500)
	DoScreenFadeIn(500)
end)

RegisterNUICallback("selectSpawn",function(data)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityVisible(PlayerPedId(), false)

	SendNUIMessage({ action  = "closeSpawn" })
	SetNuiFocus(false, false)

	DoScreenFadeOut(500)
	Wait(500)

	if characterCamera then
		RenderScriptCams(false, false, 0, false, false)
		SetCamActive(characterCamera, false)
		DestroyCam(characterCamera, true)
		characterCamera = nil
	end
	
	if previewCamera then
		RenderScriptCams(false, false, 0, false, false)
		SetCamActive(previewCamera, false)
		DestroyCam(previewCamera, true)
		previewCamera = nil
	end

	Wait(500)
	DoScreenFadeIn(500)

	-- Cutscene
	local spawn = spawnLocations[data.id]
	if spawn and spawn.execute then
		spawn.execute()
	end

	DoScreenFadeOut(500)
	Wait(500)

	-- Spawn player
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityVisible(PlayerPedId(), true)
	SetEntityInvincible(PlayerPedId(), false)
	
	Wait(500)
	DoScreenFadeIn(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSENEW
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.closeNew()
	SendNUIMessage({ action = "closeCreator" })

	DoScreenFadeOut(1000)
	Wait(1000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function updateCharacter(ped,data)
    defaultCharacter(ped,true)

    if data ~= nil then
        SetPedHeadBlendData(ped,data.fathersID,data.mothersID,0,data.skinColor,0,0,F(data.shapeMix),0,0,false)

        -- Olhos
        SetPedEyeColor(ped,data.eyesColor)
        -- Sobrancelha
        SetPedFaceFeature(ped,6,data.eyebrowsHeight)
        SetPedFaceFeature(ped,7,data.eyebrowsWidth)
        -- Nariz
        SetPedFaceFeature(ped,0,data.noseWidth)
        SetPedFaceFeature(ped,1,data.noseHeight)
        SetPedFaceFeature(ped,2,data.noseLength)
        SetPedFaceFeature(ped,3,data.noseBridge)
        SetPedFaceFeature(ped,4,data.noseTip)
        SetPedFaceFeature(ped,5,data.noseShift)
        -- Bochechas
        SetPedFaceFeature(ped,8,data.cheekboneHeight)
        SetPedFaceFeature(ped,9,data.cheekboneWidth)
        SetPedFaceFeature(ped,10,data.cheeksWidth)
        -- Boca/Mandibula
        SetPedFaceFeature(ped,12,data.lips)
        SetPedFaceFeature(ped,13,data.jawWidth)
        SetPedFaceFeature(ped,14,data.jawHeight)
        -- Queixo
        SetPedFaceFeature(ped,15,data.chinLength)
        SetPedFaceFeature(ped,16,data.chinPosition)
        SetPedFaceFeature(ped,17,data.chinWidth)
        SetPedFaceFeature(ped,18,data.chinShape)
        -- Pescoço
        SetPedFaceFeature(ped,19,data.neckWidth)

        -- Cabelo
        SetPedComponentVariation(ped,2,data.hairModel,0,0)
        SetPedHairColor(ped,data.firstHairColor,data.secondHairColor)
        -- Hair Overlay

        -- Sobracelha 
        SetPedHeadOverlay(ped,2,data.eyebrowsModel,data.eyebrowsIntensity)
        SetPedHeadOverlayColor(ped,2,1,data.eyebrowsColor,data.eyebrowsColor)
        -- Barba
        SetPedHeadOverlay(ped,1,data.beardModel,data.beardIntensity or 1.0)
        SetPedHeadOverlayColor(ped,1,1,data.beardColor,data.beardColor)
        -- Pelo Corporal
        SetPedHeadOverlay(ped,10,data.chestModel,0.99)
        SetPedHeadOverlayColor(ped,10,1,data.chestColor,data.chestColor)
        -- Blush
        SetPedHeadOverlay(ped,5,data.blushModel,0.99)
        SetPedHeadOverlayColor(ped,5,2,data.blushColor,data.blushColor)
        -- Battom
        SetPedHeadOverlay(ped,8,data.lipstickModel,0.99)
        SetPedHeadOverlayColor(ped,8,2,data.lipstickColor,data.lipstickColor)
        -- Manchas
        SetPedHeadOverlay(ped,0,data.blemishesModel,0.99)
        SetPedHeadOverlayColor(ped,0,0,0,0)
        -- Envelhecimento
        SetPedHeadOverlay(ped,3,data.ageingModel,0.99)
        SetPedHeadOverlayColor(ped,3,0,0,0)
        -- Aspecto
        SetPedHeadOverlay(ped,6,data.complexionModel,0.99)
        SetPedHeadOverlayColor(ped,6,0,0,0)
        -- Pele
        SetPedHeadOverlay(ped,7,data.sundamageModel,0.99)
        SetPedHeadOverlayColor(ped,7,0,0,0)
        -- Sardas
        SetPedHeadOverlay(ped,9,data.frecklesModel,0.99)
        SetPedHeadOverlayColor(ped,9,0,0,0)
        -- Maquiagem
        SetPedHeadOverlay(ped,4,data.makeupModel,0.99)
        SetPedHeadOverlayColor(ped,4,0,0,0)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function defaultCharacter(ped,changeClothes)
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,3,15,0,2)
		SetPedComponentVariation(ped,4,0,0,2)
		SetPedComponentVariation(ped,6,1,0,2)
		SetPedComponentVariation(ped,8,15,0,2)
		SetPedComponentVariation(ped,11,15,0,2)

		if changeClothes then
			SetPedComponentVariation(ped,3,5,0,2)
			SetPedComponentVariation(ped,11,5,0,2)
		end
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,3,15,0,2)
		SetPedComponentVariation(ped,4,0,0,2)
		SetPedComponentVariation(ped,6,0,0,2)
		SetPedComponentVariation(ped,8,7,0,2)
		SetPedComponentVariation(ped,11,5,0,2)

		if changeClothes then
			SetPedComponentVariation(ped,11,0,0,2)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN --ROUPAS SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
function updateClothings(ped,data)
    if data ~= nil then
        SetPedComponentVariation(ped,4,data["pants"].item,data["pants"].texture,2)
        SetPedComponentVariation(ped,3,data["arms"].item,data["arms"].texture,2)
        SetPedComponentVariation(ped,8,data["tshirt"].item,data["tshirt"].texture,2)
        SetPedComponentVariation(ped,9,data["vest"].item,data["vest"].texture,2)
        SetPedComponentVariation(ped,11,data["torso"].item,data["torso"].texture,2)
        SetPedComponentVariation(ped,6,data["shoes"].item,data["shoes"].texture,2)
        SetPedComponentVariation(ped,1,data["mask"].item,data["mask"].texture,2)
        SetPedComponentVariation(ped,10,data["decals"].item,data["decals"].texture,2)
        SetPedComponentVariation(ped,7,data["accessory"].item,data["accessory"].texture,2)

        if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
            SetPedPropIndex(ped,0,data["hat"].item,data["hat"].texture,2)
        else
            ClearPedProp(ped,0)
        end

        if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
            SetPedPropIndex(ped,1,data["glass"].item,data["glass"].texture,2)
        else
            ClearPedProp(ped,1)
        end

        if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
            SetPedPropIndex(ped,2,data["ear"].item,data["ear"].texture,2)
        else
            ClearPedProp(ped,2)
        end

        if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
            SetPedPropIndex(ped,6,data["watch"].item,data["watch"].texture,2)
        else
            ClearPedProp(ped,6)
        end

        if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
            SetPedPropIndex(ped,7,data["bracelet"].item,data["bracelet"].texture,2)
        else
            ClearPedProp(ped,7)
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function updateTattoos(ped,data)
	ClearPedDecorations(ped)

	if data ~= nil then
        for k,v in pairs(data) do
            AddPedDecorationFromHashes(ped,GetHashKey(v[1]),GetHashKey(k))
        end
    end
end