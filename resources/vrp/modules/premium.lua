local PremiumType = {
	["Diamond"] = { ["Name"] = "Diamond", ["Days"] = 999, ["Salary"] = 1000, ["Priority"] = 80, ["Garage"] = 10, 
		["Item"] = {
			[1] = { ["ItemName"] = "rentalkey", ["ItemAmount"] = 2, },
			[4] = { ["ItemName"] = "premiumplate", ["ItemAmount"] = 2, },
			[5] = { ["ItemName"] = "homecont02", ["ItemAmount"] = 2, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 2, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 2, },
			[8] = { ["ItemName"] = "cardiscount", ["ItemAmount"] = 2, },
		}
	},
	["Platinum"] = { ["Name"] = "Platinum", ["Days"] = 30, ["Salary"] = 750, ["Priority"] = 50, ["Garage"] = 5, 
		["Item"] = {
			[1] = { ["ItemName"] = "rentalkey", ["ItemAmount"] = 1, },
			[4] = { ["ItemName"] = "premiumplate", ["ItemAmount"] = 1, },
			[5] = { ["ItemName"] = "homecont02", ["ItemAmount"] = 1, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 1, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 1, },
			[8] = { ["ItemName"] = "cardiscount", ["ItemAmount"] = 1, },
		}
	},
	["Gold"] = { ["Name"] = "Gold", ["Days"] = 30, ["Salary"] = 500, ["Priority"] = 50, ["Garage"] = 3, 
		["Item"] = {
			[1] = { ["ItemName"] = "rentalkey", ["ItemAmount"] = 1, },
			[4] = { ["ItemName"] = "premiumplate", ["ItemAmount"] = 1, },
			[5] = { ["ItemName"] = "homecont02", ["ItemAmount"] = 1, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 1, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 1, },
			[8] = { ["ItemName"] = "cardiscount", ["ItemAmount"] = 1, },
		}
	},
	["Silver"] = { ["Name"] = "Silver", ["Days"] = 30, ["Salary"] = 250, ["Priority"] = 50, ["Garage"] = 2, 
		["Item"] = {
			[1] = { ["ItemName"] = "rentalkey", ["ItemAmount"] = 1, },
			[4] = { ["ItemName"] = "premiumplate", ["ItemAmount"] = 1, },
			[5] = { ["ItemName"] = "homecont02", ["ItemAmount"] = 1, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 1, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 1, },
			[8] = { ["ItemName"] = "cardiscount", ["ItemAmount"] = 1, },
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PremiumType(Name,Type)
    if PremiumType[Name] then
        if Type == "all" then
            return PremiumType[Name]
        elseif PremiumType[Name][Type] then
            return PremiumType[Name][Type]
        end
    end

    return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- premiumExist
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PremiumExist(Name)
    if PremiumType[Name] then

        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasPremium(user_id)
	local identity = vRP.userIdentity(user_id)
	if identity then
		local infoAccount = vRP.infoAccount(identity["steam"])
		if infoAccount["premiumType"] then
			return infoAccount["premiumType"],true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPremium(user_id)
	local identity = vRP.userIdentity(user_id)
	if identity then
		local infoAccount = vRP.infoAccount(identity["steam"])
		if infoAccount and os.time() <= (infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEAMPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.steamPremium(steam)
	local infoAccount = vRP.infoAccount(steam)
	if infoAccount then
		if os.time() <= (infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
			return true
		end
	end

	return false
end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- DISCONNECT
-- -----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if not vRP.userPremium(user_id) then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
		end
	end
end)