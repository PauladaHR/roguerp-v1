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
Tunnel.bindInterface("spawn",Hiro)
vSERVER = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Peds = {}
local Locate = {}
local Camera = nil
local Destroy = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local pedCoords = {
	{ -425.9,1122.4,325.86,345.83,"random@shop_tattoo","_idle_a" },
	{ -427.3,1122.57,325.86,345.83,"anim@heists@heist_corona@single_team","single_team_loop_boss" },
	{ -424.39,1121.62,325.84,345.83,"jh_1_ig_3-2","cs_jewelass_dual-2" },
	{ -424.74,1119.14,326.2,343.0,"oddjobs@taxi@","idle_a" },
	{ -428.98,1120.26,326.23,340.16,"amb@world_human_bum_standing@twitchy@base","base" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OTHERLOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local otherLocates = {
	-- { -2205.92,-370.48,13.29,"Great Ocean Highway" },
	-- { -250.35,6209.71,31.49,"Duluoz Avenue" },
	{ 598.99,2742.68,42.07,"Garagem - Norte" },
	{ 100.23,-1077.85,29.21,"Garagem - Praça" },
	{ -778.6,-1279.62,5.01,"Garagem - Hospital" },
	{ 855.91,-2106.05,30.55,"Garagem - Mecânica" },
	{ 427.21,-978.3,30.71,"Departamento Policial" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onClientResourceStart",function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	Wait(5000)

	DoScreenFadeOut(0)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	local ped = PlayerPedId()
	SetEntityCoords(ped,-425.15,1124.58,325.94,false,false,false,false)
	SetEntityVisible(ped,false,false)
	FreezeEntityPosition(ped,true)
	SetEntityInvincible(ped,true)
	SetEntityHealth(ped,100)

	Wait(1000)

	local Characters = vSERVER.MyCharacters()
	if parseInt(#Characters) > 0 then
		for k,v in pairs(Characters) do
			RequestModel(v["skin"])
			while not HasModelLoaded(v["skin"]) do
				Wait(1)
			end

			if HasModelLoaded(v["skin"]) then
				Peds[k] = CreatePed(4,v["skin"],pedCoords[k][1],pedCoords[k][2],pedCoords[k][3] - 1,pedCoords[k][4],false,false)
				SetEntityInvincible(Peds[k],true)
				FreezeEntityPosition(Peds[k],true)
				SetBlockingOfNonTemporaryEvents(Peds[k],true)
				SetModelAsNoLongerNeeded(v["skin"])

				RequestAnimDict(pedCoords[k][5])
				while not HasAnimDictLoaded(pedCoords[k][5]) do
					Wait(1)
				end

				TaskPlayAnim(Peds[k],pedCoords[k][5],pedCoords[k][6],8.0,8.0,-1,49,0,0,0,0)

				Clothes(Peds[k],v["clothes"])
				Barber(Peds[k],v["barber"])

				for k,v in pairs(v["tattoos"]) do
					SetPedDecoration(Peds[k],GetHashKey(v[1]),GetHashKey(k))
				end
			end
		end
	end

	Wait(1000)

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamActive(Camera,true)
	RenderScriptCams(true,true,1,true,true)
	SetCamCoord(Camera,-425.15,1125.58,326.24)
	SetCamRot(Camera,0.0,0.0,165.0,2)

	SendNUIMessage({ action = "openSystem", infos = Characters })
	SetNuiFocus(true,true)

	DoScreenFadeIn(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEDISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("generateDisplay",function(data,cb)
	cb({ result = vSERVER.Init() })
	
	DoScreenFadeIn(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("characterChosen",function(data)
	DoScreenFadeOut(0)
	for k,v in pairs(Peds) do
		if DoesEntityExist(v) then
			DeleteEntity(v)
		end
	end

	DoScreenFadeIn(1000)
	vSERVER.CharacterChosen(data["id"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("newCharacter",function(data)
	vSERVER.CreateCharacter(data["name"],data["name2"],data["sex"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("generateSpawn",function(data,cb)
	cb({ result = Locate })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:createChar")
AddEventHandler("spawn:createChar",function()
	Open = false
	local ped = PlayerPedId()
	RenderScriptCams(false,false,0,true,true)
	SetCamActive(Camera,false)
	DestroyCam(Camera,true)
	Camera = nil
	SetEntityVisible(ped,true,false)
	SetEntityInvincible(ped,false)
	SetNuiFocus(false,false)
	TriggerEvent("hud:Active",true)
	Destroy = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JUSTSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:justSpawn")
AddEventHandler("spawn:justSpawn",function(Spawned)
	DoScreenFadeOut(0)

	local Ped = PlayerPedId()
	RenderScriptCams(false,false,0,true,true)
	SetCamActive(Camera,false)
	DestroyCam(Camera,true)
	Camera = nil

	if Spawned then
		SetEntityVisible(Ped,false,false)

		Locate = {}
		local Number = 0
		for k,v in pairs(otherLocates) do
			Number = Number + 1
			Locate[Number] = { x = v[1], y = v[2], z = v[3], name = v[4], hash = Number }
		end

		Wait(2000)

		local Coords = GetEntityCoords(Ped)
		Camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",Coords["x"],Coords["y"],Coords["z"] + 200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(Camera,true)
		RenderScriptCams(true,false,1,true,true)

		SendNUIMessage({ action = "openSpawn" })

		DoScreenFadeIn(1000)
	else
		SetEntityVisible(Ped,true,false)
		TriggerEvent("hud:Active",true)
		SetNuiFocus(false,false)
		FreezeEntityPosition(Ped,false)
		Destroy = false

		Wait(1000)

		DoScreenFadeIn(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSENEW
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.closeNew()
	SendNUIMessage({ action = "closeNew" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnChosen",function(data)
	local ped = PlayerPedId()

	if data["hash"] == "spawn" then
		DoScreenFadeOut(0)

		SendNUIMessage({ action = "closeSpawn" })
		TriggerEvent("hud:Active",true)
		SetNuiFocus(false,false)

		FreezeEntityPosition(ped,false)
		RenderScriptCams(false,false,0,true,true)
		SetCamActive(Camera,false)
		DestroyCam(Camera,true)
		SetEntityVisible(ped,true,false)
		Camera = nil
		Destroy = false

		Wait(1000)

		DoScreenFadeIn(1000)
	else
		Destroy = false
		DoScreenFadeOut(0)

		Wait(1000)

		SetCamRot(Camera,270.0)
		SetCamActive(Camera,true)
		Destroy = true
		local speed = 0.7
		weight = 270.0

		DoScreenFadeIn(1000)

		SetEntityCoords(ped,Locate[data["hash"]]["x"],Locate[data["hash"]]["y"],Locate[data["hash"]]["z"],false,false,false,false)
		local coords = GetEntityCoords(ped)

		SetCamCoord(Camera,coords["x"],coords["y"],coords["z"] + 200.0)
		local i = coords["z"] + 200.0

		while i > Locate[data["hash"]]["z"] + 1.5 do
			i = i - speed
			SetCamCoord(Camera,coords["x"],coords["y"],i)

			if i <= Locate[data["hash"]]["z"] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(Camera,weight)
			end

			if not Destroy then
				break
			end

			Wait(0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Clothes(ped,data)
    if data["backpack"] == nil then
        data["backpack"] = {}
        data["backpack"]["item"] = 0
        data["backpack"]["texture"] = 0
    end
	
    if data["pants"] == nil then
        data["pants"] = {}
        data["pants"]["item"] = 0
        data["pants"]["texture"] = 0
    end
	
    if data["arms"] == nil then
        data["arms"] = {}
        data["arms"]["arms"] = 0
        data["arms"]["arms"] = 0
    end
	
    if data["tshirt"] == nil then
        data["tshirt"] = {}
        data["tshirt"]["item"] = 0
        data["tshirt"]["texture"] = 0
    end
	
    if data["vest"] == nil then
        data["vest"] = {}
        data["vest"]["item"] = 0
        data["vest"]["texture"] = 0
    end
	
    if data["torso"] == nil then
        data["torso"] = {}
        data["torso"]["item"] = 0
        data["torso"]["texture"] = 0
    end
	
    if data["shoes"] == nil then
        data["shoes"] = {}
        data["shoes"]["item"] = 0
        data["shoes"]["texture"] = 0
    end
	
    if data["torso"] == nil then
        data["torso"] = {}
        data["torso"]["item"] = 0
        data["torso"]["texture"] = 0
    end
	
    if data["mask"] == nil then
        data["mask"] = {}
        data["mask"]["item"] = 0
        data["mask"]["texture"] = 0
    end
	
    if data["decals"] == nil then
        data["decals"] = {}
        data["decals"]["item"] = 0
        data["decals"]["texture"] = 0
    end
	
    if data["accessory"] == nil then
        data["accessory"] = {}
        data["accessory"]["item"] = 0
        data["accessory"]["texture"] = 0
    end
	
    if data["accessory"] == nil then
        data["accessory"] = {}
        data["accessory"]["item"] = 0
        data["accessory"]["texture"] = 0
    end
	
    if data["hat"] == nil then
        data["hat"] = {}
        data["hat"]["item"] = 0
        data["hat"]["texture"] = 0
    end
	
    if data["glass"] == nil then
        data["glass"] = {}
        data["glass"]["item"] = 0
        data["glass"]["texture"] = 0
    end
	
    if data["ear"] == nil then
        data["ear"] = {}
        data["ear"]["item"] = 0
        data["ear"]["texture"] = 0
    end
	
    if data["watch"] == nil then
        data["watch"] = {}
        data["watch"]["item"] = 0
        data["watch"]["texture"] = 0
    end
	
    if data["bracelet"] == nil then
        data["bracelet"] = {}
        data["bracelet"]["item"] = 0
        data["bracelet"]["texture"] = 0
    end

	SetPedComponentVariation(ped,4,data["pants"]["item"] or 0,data["pants"]["texture"] or 0,1)
	SetPedComponentVariation(ped,3,data["arms"]["item"] or 0,data["arms"]["texture"] or 0,1)
	SetPedComponentVariation(ped,5,data["backpack"]["item"] or 0,data["backpack"]["texture"] or 0,1)
	SetPedComponentVariation(ped,8,data["tshirt"]["item"] or 0,data["tshirt"]["texture"] or 0,1)
	SetPedComponentVariation(ped,9,data["vest"]["item"] or 0,data["vest"]["texture"] or 0,1)
	SetPedComponentVariation(ped,11,data["torso"]["item"] or 0,data["torso"]["texture"] or 0,1)
	SetPedComponentVariation(ped,6,data["shoes"]["item"] or 0,data["shoes"]["texture"] or 0,1)
	SetPedComponentVariation(ped,1,data["mask"]["item"] or 0,data["mask"]["texture"] or 0,1)
	SetPedComponentVariation(ped,10,data["decals"]["item"] or 0,data["decals"]["texture"] or 0,1)
	SetPedComponentVariation(ped,7,data["accessory"]["item"] or 0,data["accessory"]["texture"] or 0,1)

	if data["hat"]["item"] ~= -1 and data["hat"]["item"] ~= 0 then
		SetPedPropIndex(ped,0,data["hat"]["item"],data["hat"]["texture"],1)
	else
		ClearPedProp(ped,0)
	end

	if data["glass"]["item"] ~= -1 and data["glass"]["item"] ~= 0 then
		SetPedPropIndex(ped,1,data["glass"]["item"],data["glass"]["texture"],1)
	else
		ClearPedProp(ped,1)
	end

	if data["ear"]["item"] ~= -1 and data["ear"]["item"] ~= 0 then
		SetPedPropIndex(ped,2,data["ear"]["item"],data["ear"]["texture"],1)
	else
		ClearPedProp(ped,2)
	end

	if data["watch"]["item"] ~= -1 and data["watch"]["item"] ~= 0 then
		SetPedPropIndex(ped,6,data["watch"]["item"],data["watch"]["texture"],1)
	else
		ClearPedProp(ped,6)
	end

	if data["bracelet"]["item"] ~= -1 and data["bracelet"]["item"] ~= 0 then
		SetPedPropIndex(ped,7,data["bracelet"]["item"],data["bracelet"]["texture"],1)
	else
		ClearPedProp(ped,7)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBER
-----------------------------------------------------------------------------------------------------------------------------------------
function Barber(ped,data)
    if data ~= nil then

        SetPedHeadBlendData(ped,data.fathersID,data.mothersID,0,data.skinColor,0,0,F(data.shapeMix),0,0,false)

        SetPedEyeColor(ped,data.eyesColor)
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
        SetPedHeadOverlay(ped,1,data.beardModel,data.beardIntensity)
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