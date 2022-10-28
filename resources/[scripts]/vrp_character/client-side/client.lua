-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("vrp_character")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = -1
local cam2 = -1
local fadeOutNetwork = false
local currentCharacterMode = { fathersID = 0, mothersID = 0, skinColor = 0, shapeMix = 0, eyesColor = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0, noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0, cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0, jawHeight = 0, chinLength = 0, chinPosition = 0, chinWidth = 0, chinShape = 0, neckWidth = 0, hairModel = 0, hairOverlay = 0, firstHairColor = 0, secondHairColor = 0, eyebrowsModel = 0, eyebrowsIntensity = 0, eyebrowsColor = 0, beardModel = -1, beardIntensity = 0, beardColor = 0, chestModel = -1, chestColor = 0, blushModel = -1, blushColor = 0, lipstickModel = -1, lipstickColor = 0, blemishesModel = -1, ageingModel = -1, complexionModel = -1, sundamageModel = -1, frecklesModel = -1, makeupModel = -1 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_character:createCharacter")
AddEventHandler("vrp_character:createCharacter",function()
	local ped = PlayerPedId()
	SetEntityInvincible(ped,false) -- mqcu
	SetEntityVisible(ped,true,false)
	FreezeEntityPosition(ped,true)

	Wait(1000)

	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)

		SetCamCoord(cam,vector3(402.6,-997.2,-98.3))
		SetCamRot(cam,F(0),F(0),F(358),15)
		SetCamActive(cam,true)
		RenderScriptCams(true,true,20000000000000000000000000,0,0,0)
	end

	SetEntityCoordsNoOffset(ped,402.55,-996.37,-99.01,true,true,true) 
	SetEntityHeading(ped,F(180))

	SetTimeout(1000,function()
		DoScreenFadeOut(500)
		fadeOutNetwork = true
		vRP.applySkin("mp_m_freemode_01")
		defaultCharacter(false)
		updateSkinOptions()
		updateFaceOptions()
		updateHeadOptions()
		Wait(1000)
		DoScreenFadeIn(500)
		SetNuiFocus(true,true)
		SendNUIMessage({ CharacterMode = true })
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_CHARACTER:UPDATECHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_character:updateCharacter")
AddEventHandler("vrp_character:updateCharacter",function(data,barbershop)
	if not barbershop then
		currentCharacterMode = data
		defaultCharacter(true)
		updateSkinOptions()
		updateFaceOptions()
		updateHeadOptions()
	else
		displayBarbershop(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local innerTable = {}
	for k,v in pairs(cfg.locationsBarber) do
		table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Barbearia","Pressione para abrir" })
	end

	TriggerEvent("hoverfy:Insert",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPENBARBER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(cfg.locationsBarber) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					DrawMarker(23,v[1],v[2],v[3]-0.98,0,0,0,0,0,0,3.0,3.0,1.0,128,18,54,50,0,0,0,0)

					if IsControlJustPressed(1,38) and vSERVER.CheckWanted() then
						displayBarbershop(true)
					end
				end
			end
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPLAYBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function displayBarbershop(enable)
	local ped = PlayerPedId()

	if enable then
		SetNuiFocus(true,true)
		SendNUIMessage({ BarberMode = true, status = currentCharacterMode })

		FreezeEntityPosition(ped,true)
		SetPlayerInvincible(ped,false) -- mqcu

		if not DoesCamExist(cam2) then
			cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
			SetCamActive(cam2,true)
			RenderScriptCams(true,false,0,true,true)

			local x,y,z = table.unpack(GetEntityCoords(ped))
			SetCamCoord(cam2,x+0.2,y+0.5,z+0.7)
			SetCamRot(cam2,0.0,0.0,150.0)
			TriggerEvent("hoverfy:updateMenu",true)
		end
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ BarberMode = false })

		FreezeEntityPosition(ped,false)
		SetPlayerInvincible(ped,false)
		RenderScriptCams(false,false,0,1,0)
		DestroyCam(cam2,false)
		TriggerEvent("hoverfy:updateMenu",false)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFADEOUTNETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do 
		Wait(1)
		if fadeOutNetwork then
			for k,v in ipairs(GetActivePlayers()) do
				if v ~= PlayerId() and NetworkIsPlayerActive(v) then
					NetworkFadeOutEntity(GetPlayerPed(v),false)
				end
			end
		else
			Wait(1000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Save",function(data,cb)
	if not data.isBarberMode then
		SetNuiFocus(false,false)
		SendNUIMessage({ CharacterMode = false })

		SetEntityCoordsNoOffset(PlayerPedId(),-542.35,-209.98,37.65,true,true,true)
		
		fadeOutNetwork = false
		for k,v in ipairs(GetActivePlayers()) do
			if v ~= PlayerId() and NetworkIsPlayerActive(v) then
				NetworkFadeInEntity(GetPlayerPed(v),true)
			end
		end
	
		TriggerServerEvent("vrp_character:finishedCharacter",currentCharacterMode,true)
	else
		TriggerServerEvent("vrp_character:finishedCharacter",currentCharacterMode,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSEBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CloseBarbershop",function(data,cb)
	displayBarbershop(false)
	TriggerServerEvent("vrp_character:finishedCharacter",currentCharacterMode,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKINOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("UpdateSkinOptions",function(data,cb)
	currentCharacterMode.fathersID = data.fathersID
	currentCharacterMode.mothersID = data.mothersID
	currentCharacterMode.skinColor = data.skinColor
	currentCharacterMode.shapeMix = data.shapeMix
	updateSkinOptions()
	cb("ok")
end)

function updateSkinOptions()
	local data = currentCharacterMode
	SetPedHeadBlendData(PlayerPedId(),data.fathersID,data.mothersID,0,data.skinColor,0,0,F(data.shapeMix),0,0,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEFACEOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("UpdateFaceOptions",function(data,cb)
	currentCharacterMode.eyesColor = data.eyesColor
	currentCharacterMode.eyebrowsHeight = data.eyebrowsHeight
	currentCharacterMode.eyebrowsWidth = data.eyebrowsWidth
	currentCharacterMode.noseWidth = data.noseWidth
	currentCharacterMode.noseHeight = data.noseHeight
	currentCharacterMode.noseLength = data.noseLength
	currentCharacterMode.noseBridge = data.noseBridge
	currentCharacterMode.noseTip = data.noseTip
	currentCharacterMode.noseShift = data.noseShift
	currentCharacterMode.cheekboneHeight = data.cheekboneHeight
	currentCharacterMode.cheekboneWidth = data.cheekboneWidth
	currentCharacterMode.cheeksWidth = data.cheeksWidth
	currentCharacterMode.lips = data.lips
	currentCharacterMode.jawWidth = data.jawWidth
	currentCharacterMode.jawHeight = data.jawHeight
	currentCharacterMode.chinLength = data.chinLength
	currentCharacterMode.chinPosition = data.chinPosition
	currentCharacterMode.chinWidth = data.chinWidth
	currentCharacterMode.chinShape = data.chinShape
	currentCharacterMode.neckWidth = data.neckWidth
	updateFaceOptions()
	cb("ok")
end)

function updateFaceOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

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
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHEADOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("UpdateHeadOptions",function(data,cb)
	currentCharacterMode.hairModel = data.hairModel
	currentCharacterMode.hairOverlay = data.hairOverlay
	currentCharacterMode.firstHairColor = data.firstHairColor
	currentCharacterMode.secondHairColor = data.secondHairColor
	currentCharacterMode.eyebrowsModel = data.eyebrowsModel
	currentCharacterMode.eyebrowsIntensity = data.eyebrowsIntensity
	currentCharacterMode.eyebrowsColor = data.eyebrowsColor
	currentCharacterMode.beardModel = data.beardModel
	currentCharacterMode.beardIntensity = data.beardIntensity
	currentCharacterMode.beardColor = data.beardColor
	currentCharacterMode.chestModel = data.chestModel
	currentCharacterMode.chestColor = data.chestColor
	currentCharacterMode.blushModel = data.blushModel
	currentCharacterMode.blushColor = data.blushColor
	currentCharacterMode.lipstickModel = data.lipstickModel
	currentCharacterMode.lipstickColor = data.lipstickColor
	currentCharacterMode.blemishesModel = data.blemishesModel
	currentCharacterMode.ageingModel = data.ageingModel
	currentCharacterMode.complexionModel = data.complexionModel
	currentCharacterMode.sundamageModel = data.sundamageModel
	currentCharacterMode.frecklesModel = data.frecklesModel
	currentCharacterMode.makeupModel = data.makeupModel
	updateHeadOptions()
	cb("ok")
end)

function updateHeadOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	-- Cabelo
	SetPedComponentVariation(ped,2,data.hairModel,0,0)
	SetPedHairColor(ped,data.firstHairColor,data.secondHairColor)
	-- Hair Overlay
	if cfg.HairOverlays["Male"][data.hairOverlay] and GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		ClearPedDecorations(ped)
		AddPedDecorationFromHashesInCorona(ped,GetHashKey(cfg.HairOverlays["Male"][data.hairOverlay].collection), GetHashKey(cfg.HairOverlays["Male"][data.hairOverlay].overlay))
	elseif cfg.HairOverlays["Female"][data.hairOverlay] and GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		ClearPedDecorations(ped)
		AddPedDecorationFromHashesInCorona(ped,GetHashKey(cfg.HairOverlays["Female"][data.hairOverlay].collection), GetHashKey(cfg.HairOverlays["Female"][data.hairOverlay].overlay))
	end
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
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGEGENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChangeGender",function(data,cb)
	currentCharacterMode.gender = tonumber(data.gender)
	if tonumber(data.gender) == 1 then
		vRP.applySkin("mp_f_freemode_01")
	else
		vRP.applySkin("mp_m_freemode_01")
	end
	defaultCharacter(false)
	updateSkinOptions()
	updateFaceOptions()
	updateHeadOptions()
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(data,cb)
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)
	if data == "left" then
		SetEntityHeading(ped,heading+10)
	elseif data == "right" then
		SetEntityHeading(ped,heading-10)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEFAULTCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function defaultCharacter(changeClothes)
	local ped = PlayerPedId()
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
			SetPedComponentVariation(ped,3,7,0,2)
			SetPedComponentVariation(ped,4,116,0,2)
			SetPedComponentVariation(ped,5,-1,0,2)
			SetPedComponentVariation(ped,6,4,0,2)
			SetPedComponentVariation(ped,11,464,0,2)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea",function(x,y,z)
    ClearAreaOfVehicles(x,y,z,2000.0,false,false,false,false,false)
    ClearAreaOfEverything(x,y,z,2000.0,false,false,false,false)
end)