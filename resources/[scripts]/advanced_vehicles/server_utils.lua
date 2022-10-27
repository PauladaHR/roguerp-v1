-- Função para checar se é um veículo próprio
function IsOwnedVehicle(plate)
	local vehiclequery = vRP.getVehiclePlate(plate)
	if vehiclequery then
		return vehiclequery
	else
		return false
	end
end