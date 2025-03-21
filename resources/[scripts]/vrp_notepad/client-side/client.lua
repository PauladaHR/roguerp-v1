-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("notepad")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATENOTEPAD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_notepad:createNotepad")
AddEventHandler("vrp_notepad:createNotepad",function()
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "showNotepad" })
	vRP.createObjects("amb@medic@standing@timeofdeath@base","base","prop_notepad_01",49,60309)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESCAPE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("escape",function()
	SetNuiFocus(false)
	vRP.removeObjects("one")
	SendNUIMessage({ action = "hideNotepad" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EDITNOTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("editNote",function(data)
	SetNuiFocus(false)
	vRP.removeObjects("one")
	SendNUIMessage({ action = "hideNotepad" })
	vSERVER.editNotepad(data["id"],data["text"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPNOTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropNote",function(data)
	SetNuiFocus(false)
	vRP.removeObjects("one")
	vSERVER.createNotepad(data["text"])
	SendNUIMessage({ action = "hideNotepad" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADNOTEPAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(GlobalState["Notepad"]) do
				local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
				if distance <= 5 then
					timeDistance = 1
					DrawText3Ds(v["x"],v["y"],v["z"] - 0.8,"~g~G~w~   LER     ~y~H~w~   DESTRUIR")

					if distance <= 1.2 then
						if IsControlJustPressed(1,47) then
							SetNuiFocus(true,true)
							SendNUIMessage({ action = "showNotepad2", text = v["text"], id = v["id"] })
							vRP.createObjects("amb@medic@standing@timeofdeath@base","base","prop_notepad_01",49,60309)
						elseif IsControlJustPressed(1,304) then
							vSERVER.destroyNotepad(v["id"])
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 190 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,15,15,15,175)
	end
end