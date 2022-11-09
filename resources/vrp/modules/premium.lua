local PremiumType = {
	["Diamond"] = { ["Name"] = "Diamond", ["Days"] = 999, ["Salary"] = 1000, ["Priority"] = 80, ["Garage"] = 10, 
		["Item"] = {
			[1] = { ["ItemName"] = "carpass", ["ItemAmount"] = 2, },
			[2] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 2, },
			[3] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 2, },
			[4] = { ["ItemName"] = "keyplate", ["ItemAmount"] = 2, },
			[5] = { ["ItemName"] = "housekey", ["ItemAmount"] = 2, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 2, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 2, },
			[8] = { ["ItemName"] = "discount", ["ItemAmount"] = 2, },
		}
	},
	["Platinum"] = { ["Name"] = "Platinum", ["Days"] = 30, ["Salary"] = 750, ["Priority"] = 50, ["Garage"] = 5, 
		["Item"] = {
			[1] = { ["ItemName"] = "carpass", ["ItemAmount"] = 1, },
			[2] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 1, },
			[3] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 1, },
			[4] = { ["ItemName"] = "keyplate", ["ItemAmount"] = 1, },
			[5] = { ["ItemName"] = "housekey", ["ItemAmount"] = 1, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 1, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 1, },
			[8] = { ["ItemName"] = "discount", ["ItemAmount"] = 1, },
		}
	},
	["Gold"] = { ["Name"] = "Gold", ["Days"] = 30, ["Salary"] = 500, ["Priority"] = 50, ["Garage"] = 3, 
		["Item"] = {
			[1] = { ["ItemName"] = "carpass", ["ItemAmount"] = 1, },
			[2] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 1, },
			[3] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 1, },
			[4] = { ["ItemName"] = "keyplate", ["ItemAmount"] = 1, },
			[5] = { ["ItemName"] = "housekey", ["ItemAmount"] = 1, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 1, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 1, },
			[8] = { ["ItemName"] = "discount", ["ItemAmount"] = 1, },
		}
	},
	["Silver"] = { ["Name"] = "Silver", ["Days"] = 30, ["Salary"] = 250, ["Priority"] = 50, ["Garage"] = 2, 
		["Item"] = {
			[1] = { ["ItemName"] = "carpass", ["ItemAmount"] = 1, },
			[2] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 1, },
			[3] = { ["ItemName"] = "vehiclesound", ["ItemAmount"] = 1, },
			[4] = { ["ItemName"] = "keyplate", ["ItemAmount"] = 1, },
			[5] = { ["ItemName"] = "housekey", ["ItemAmount"] = 1, },
			[6] = { ["ItemName"] = "numberchange", ["ItemAmount"] = 1, },
			[7] = { ["ItemName"] = "rgchange", ["ItemAmount"] = 1, },
			[8] = { ["ItemName"] = "discount", ["ItemAmount"] = 1, },
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
-- GETPREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPremium(user_id)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local ConsultPremium = vRP.getInfos(identity.steam)
		if ConsultPremium[1] and os.time() >= (ConsultPremium[1]["premium"] + 24 * ConsultPremium[1]["predays"] * 60 * 60) then
			return false
		else
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local ConsultRental = vRP.query("vRP/get_rental_time",{ user_id = user_id })
	if #ConsultRental then 
		for k,v in pairs(ConsultRental) do
			if v["rental_time"] ~= 0 and v["rental"] == 1 then
				if parseInt(os.time()) >= parseInt(v["rental_time"]+3*24*60*60) then
					TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.vehicleName(v["vehicle"]).."</b> removido por falta de renovação.",20000)
					vRP.execute("vRP/rem_vehicle",{ user_id = parseInt(user_id), vehicle = v["vehicle"] })
					return
				end
				if parseInt(os.time()) >= v["rental_time"] then
					TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.vehicleName(v["vehicle"]).."</b> vencido, efetue a renovação para não perde-lo.",30000)
				end

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if not vRP.userPremium(user_id) then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
		end
	end
end)