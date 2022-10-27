-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUT:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackout:Init")
AddEventHandler("Blackout:Init",function(Lights)
	for Number,Engines in pairs(Lights) do
		exports["vrp_target"]:AddCircleZone("Blackout:"..Number,Engines["Coords"],1.25,{
			name = "Blackout:"..Number,
			heading = 0.0
		},{
			shop = Number,
			distance = 1.75,
			options = {
				{
					event = "Blackout:MakeBlackout",
					label = "Ligar Energia",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackout:Status")
AddEventHandler("Blackout:Status", function(Blackout)
    local Status = false
    if Blackout == 1 then
        Status = true
    end
    SetBlackout(Status)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackout:Stop")
AddEventHandler("Blackout:Stop",function()
    TriggerServerEvent("Blackout:Stop")
end)