
-- VARIABLES
local noclip = false

-- NOCLIP
function tvRP.noClip()
	noclip = not noclip
	local ped = PlayerPedId()

	if noclip then
		LocalPlayer["state"]["Invisible"] = true
		SetEntityInvincible(ped,true)
		SetEntityVisible(ped,false,false)
		LocalPlayer["state"]["Noclip"]= true

		startNoClipThread()
	else
		LocalPlayer["state"]["Invisible"] = false
		LocalPlayer["state"]["Noclip"]= false
		SetEntityInvincible(ped,false)
		SetEntityVisible(ped,true,false)
	end
end

-- THREADNOCLIP
function startNoClipThread()
	CreateThread(function()
		while noclip do
			local ped = PlayerPedId()

			local speed = 1.0
			local scaleFactor = 0.5
			
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local dx,dy,dz = tvRP.getCamDirection()

			SetEntityVelocity(ped,0.0001,0.0001,0.0001)

			-- Shift
			if IsControlPressed(1,21) then
				speed = 5.0
				scaleFactor = 2.5
			end

			-- ALT
			if IsControlPressed(1,19) then
				speed = 0.3
				scaleFactor = 0.1
			end

			if IsControlPressed(1,32) then
				x = x + speed * dx
				y = y + speed * dy
				z = z + speed * dz
			end

			if IsControlPressed(1,269) then
				x = x - speed * dx
				y = y - speed * dy
				z = z - speed * dz
			end

			if IsControlPressed(1,10) then
				z = z + scaleFactor
			end
			if IsControlPressed(1,11) then
				z = z - scaleFactor
			end

			SetEntityCoordsNoOffset(ped,x,y,z,1,0,0)
			Wait(1)
		end
	end)
end

-- GETCAMDIRECTION
function tvRP.getCamDirection()
	local ped = PlayerPedId()
	local pitch = GetGameplayCamRelativePitch()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(ped)
	local x = -math.sin(heading * math.pi / 180.0)
	local y = math.cos(heading * math.pi / 180.0)
	local z = math.sin(pitch * math.pi / 180.0)
	local len = math.sqrt(x*x + y*y + z*z)
	if len ~= 0 then
		x = x / len
		y = y / len
		z = z / len
	end
	return x,y,z
end
