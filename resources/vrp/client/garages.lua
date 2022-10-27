-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNEARVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getNearVehicles(radius)
	local r = {}
	local coords = GetEntityCoords(PlayerPedId())

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)

	for _,veh in pairs(vehs) do
		local coordsVeh = GetEntityCoords(veh)
		local distance = #(coords - coordsVeh)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNEARVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getNearVehicle(radius)
	local veh
	local vehs = tvRP.getNearVehicles(radius)
	local min = radius + 0.0001
	for _veh,dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.inVehicle()
	return IsPedSittingInAnyVehicle(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.vehList(radius)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		veh = GetVehiclePedIsUsing(ped)
	else
		veh = tvRP.getNearVehicle(radius)
	end

	if IsEntityAVehicle(veh) then
		local v = vRPS.vehicleHash(GetEntityModel(veh))
		if v then
			if parseInt(v.hash) == GetEntityModel(veh) then
				if v.spawn then
					local model = GetEntityModel(veh)
					return veh,VehToNet(veh),GetVehicleNumberPlateText(veh),v.spawn,GetVehicleDoorsLockedForPlayer(veh,PlayerId()),v.banned,GetVehicleBodyHealth(veh),model,GetVehicleClass(veh)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.vehiclePlate()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(veh) then
		return GetVehicleNumberPlateText(veh)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LASTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.lastVehicle(vehName)
	local ped = PlayerPedId()
	local vehHash = GetHashKey(vehName)
	local vehicle = GetLastDrivenVehicle()
	if IsVehicleModel(vehicle,vehHash) then
		return true
	end

	return false
end