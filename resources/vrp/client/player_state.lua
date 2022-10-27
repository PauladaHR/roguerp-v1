-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSAVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local coords = GetEntityCoords(PlayerPedId())
			vRPS._updatePositions(coords.x,coords.y,coords.z)
			vRPS._updateHealth(GetEntityHealth(PlayerPedId()))
			vRPS._updateArmour(GetPedArmour(PlayerPedId()))
			vRPS._updateWeapons(tvRP.getWeapons())
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADREADY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(),true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getHealth()
	return GetEntityHealth(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setHealth(health)
	SetEntityHealth(PlayerPedId(),parseInt(health))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.updateHealth(number)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	if health > 101 then
		SetEntityHealth(ped,parseInt(health+number))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.downHealth(number)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)

	SetEntityHealth(ped,parseInt(health-number))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getArmour()
	return GetPedArmour(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setArmour(amount)
	local ped = PlayerPedId()
	local armour = GetPedArmour(ped)
	--SetPedArmour(ped,parseInt(armour+amount))
	amount = amount+armour
	if amount>100 then amount = 100 end
	TriggerEvent("armour:rogue",amount)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPOSITIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getPositions()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	return vRPS.mathLegth(coords.x),vRPS.mathLegth(coords.y),vRPS.mathLegth(coords.z),vRPS.mathLegth(GetEntityHeading(ped))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYSKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.applySkin(model)
	local mHash = model

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Wait(10)
	end

	if HasModelLoaded(mHash) then
		SetPlayerModel(PlayerId(),mHash)
		SetModelAsNoLongerNeeded(mHash)
	end

	SetPedComponentVariation(PlayerPedId(),1,0,0,2)
end