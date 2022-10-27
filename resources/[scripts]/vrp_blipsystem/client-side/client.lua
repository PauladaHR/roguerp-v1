-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
local userBlips = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:UPDATEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_blipsystem:updateBlips")
AddEventHandler("vrp_blipsystem:updateBlips",function(userTable)
	userList = userTable

	for k,v in pairs(userList) do
		if DoesBlipExist(userBlips[k]) then
			SetBlipCoords(userBlips[k],v[1]["x"],v[1]["y"],v[1]["z"])
		else
			userBlips[k] = AddBlipForCoord(v[1]["x"],v[1]["y"],v[1]["z"])
			SetBlipSprite(userBlips[k],1)
			SetBlipAsShortRange(userBlips[k],true)
			SetBlipScale(userBlips[k],0.7)
			SetBlipColour(userBlips[k],v[3])
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v[2])
			EndTextCommandSetBlipName(userBlips[k])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_blipsystem:cleanBlips")
AddEventHandler("vrp_blipsystem:cleanBlips",function()
	for k,v in pairs(userBlips) do
		RemoveBlip(userBlips[k])
	end

	userBlips = {}
	userList = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_blipsystem:removeBlips")
AddEventHandler("vrp_blipsystem:removeBlips",function(source)
	if DoesBlipExist(userBlips[source]) then
		RemoveBlip(userBlips[source])
		userBlips[source] = nil
		userList[source] = nil
	end
end)