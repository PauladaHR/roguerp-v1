-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local noclip = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.noClip()
	noclip = not noclip
	local ped = PlayerPedId()
	if noclip then
		LocalPlayer["state"]["Invisible"] = true
		SetEntityVisible(ped,false,false)
		SetEntityCollision(ped,false,false)
	else
		LocalPlayer["state"]["Invisible"] = false
		SetEntityVisible(ped,true,false)
		SetEntityCollision(ped,true,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADNOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 500
		if noclip then
			timeDistance = 4
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local dx,dy,dz = tvRP.getCamDirection()
			local speed = 1.0

			SetEntityVelocity(ped,0.0001,0.0001,0.0001)

			if IsControlPressed(1,21) then
				speed = 5.0
			end
			
			if IsControlPressed(1,19) then
				speed = 0.2
			end

			if IsControlPressed(1,36) then
				speed = 0.5
			end

			if IsControlPressed(1,32) then
				x = x+speed*dx
				y = y+speed*dy
				z = z+speed*dz
			end

			if IsControlPressed(1,269) then
				x = x-speed*dx
				y = y-speed*dy
				z = z-speed*dz
			end

			if IsControlPressed(1,10) then
				z = z + 1
			end

			if IsControlPressed(1,11) then
				z = z - 1
			end

			SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
		end
		Wait(timeDistance)
	end
end)