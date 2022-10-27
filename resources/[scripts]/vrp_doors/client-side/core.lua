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
Tunnel.bindInterface("doors",Hiro)
vSERVER = Tunnel.getInterface("doors")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	while true do
		local timeDistance = 2000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for Index, door in pairs(GlobalState["Doors"] or {}) do
			local distance = GetDistanceBetweenCoords(coords, door["x"], door["y"], door["z"], true)
			if distance <= door.distance * 2 then
				if timeDistance > 200 then
					timeDistance = 200
				end

				local closestDoor = GetClosestObjectOfType(door["x"], door["y"], door["z"], door.distance + 1.0, door.hash, false, false, false)
				if closestDoor ~= 0 then
					if door.lock then
						local _,h = GetStateOfClosestDoorOfType(door.hash, door["x"], door["y"], door["z"])
						if h > -0.02 and h < 0.02 then
							FreezeEntityPosition(closestDoor,true)
						end
					else
						FreezeEntityPosition(closestDoor,false)
					end

					if distance <= door.press then
						timeDistance = 4

						if door.text and IsEntityVisible(closestDoor) then
							local emote = "🔓"
							if door.lock then
								emote = "🔒"
							end
							DrawText3D(door["x"], door["y"], door["z"], emote)
						end

						if IsControlJustPressed(1,38) and vSERVER.doorsPermission(Index) then
							door.lock = not door.lock
							vRP.playAnim(true,{"anim@heists@keycard@","exit"},false)
							vSERVER.doorsStatistics(Index, door.lock)
							Wait(350)
							vRP.stopAnim()
						end
					end
				end
			end
		end
		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.3,0.3)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)
	end
end