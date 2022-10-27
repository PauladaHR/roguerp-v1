-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND TO OPEN UI
-----------------------------------------------------------------------------------------------------------------------------------------	

RegisterCommand(Config.command, function()
	local open = false
	if Config.mechanicLocations.enabled then
		for k,mark in pairs(Config.mechanicLocations.locations) do
			local distance = #(GetEntityCoords(PlayerPedId()) - vector3(mark.x,mark.y,mark.z))
			if distance <= mark.radius then
				open = true
				TriggerEvent('advanced_vehicles:showStatusUI')
				break
			end
		end
		if open == false then
			TriggerEvent("advanced_vehicles:Notify","negado",Lang[Config.lang]['not_on_location'])
		end
	else
		TriggerEvent('advanced_vehicles:showStatusUI')
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFICATION SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------	

RegisterNetEvent('advanced_vehicles:Notify')
AddEventHandler('advanced_vehicles:Notify', function(title, message, time)
    TriggerEvent("Notify",title,message,5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- 3D TEXT
-----------------------------------------------------------------------------------------------------------------------------------------	

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)

	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end