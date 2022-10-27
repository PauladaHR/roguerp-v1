-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local tempList = {}
		for k,v in pairs(userList) do
			local ped = GetPlayerPed(k)
			if DoesEntityExist(ped) then
				tempList[k] = { GetEntityCoords(ped),v[1],v[2] }
			end
		end

		for k,v in pairs(userList) do
			async(function()
				if v[1] ~= "Prisioneiro" and v[1] ~= "Corredor" then
					TriggerClientEvent("vrp_blipsystem:updateBlips",k,tempList)
				end
			end)
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_blipsystem:serviceEnter")
AddEventHandler("vrp_blipsystem:serviceEnter",function(source,service,color)
	if userList[source] == nil then
		userList[source] = { service,color }
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_blipsystem:serviceExit")
AddEventHandler("vrp_blipsystem:serviceExit",function(source)
	TriggerClientEvent("vrp_blipsystem:cleanBlips",source)
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
function serviceExit(source)
	if userList[source] then
		userList[source] = nil

		for k,v in pairs(userList) do
			async(function()
				TriggerClientEvent("vrp_blipsystem:removeBlips",k,source)
			end)
		end
	end
end