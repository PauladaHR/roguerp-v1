-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_radio",cRP)
vSERVER = Tunnel.getInterface("vrp_radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local activeRadio = false
local activeFrequencys = 0
local timeCheck = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("radioClose",function(data,cb)
	SetNuiFocus(false,false)
	vRP.removeObjects("one")
    SendNUIMessage({ action = "hideMenu" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_radio:openSystem")
AddEventHandler("vrp_radio:openSystem",function()
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "showMenu" })

	if not IsPedInAnyVehicle(PlayerPedId()) then
		vRP.createObjects("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("activeFrequency",function(data)
	if parseInt(data["freq"]) >= 1 and parseInt(data["freq"]) <= 999 then
		vSERVER.activeFrequency(data["freq"])
		TriggerEvent("sounds:Private","radioChatter",0.5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("inativeFrequency",function(data)
	TriggerEvent("vrp_radio:outServers")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startFrequency(frequency)
	if activeFrequencys ~= 0 then
		exports["pma-voice"]:removePlayerFromRadio()
	end

	exports["pma-voice"]:setRadioChannel(frequency)
	activeFrequencys = frequency
	activeRadio = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_radio:outServers")
AddEventHandler("vrp_radio:outServers",function()
	if activeFrequencys ~= 0 then
		TriggerEvent("Notify","amarelo","Rádio desativado.",5000)
		TriggerEvent("sounds:Private","radioOff",0.5)
		exports["pma-voice"]:removePlayerFromRadio()
		TriggerEvent("hud:RadioDisplay",0)
		activeFrequencys = 0
		activeRadio = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:THREADCHECKRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		if GetGameTimer() >= timeCheck and activeRadio then
			timeCheck = GetGameTimer() + 60000

			local ped = PlayerPedId()
			if vSERVER.checkRadio() or IsPedSwimming(ped) then
				TriggerEvent("vrp_radio:outServers")
			end
		end

		Wait(10000)
	end
end)