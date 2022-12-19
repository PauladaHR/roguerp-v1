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
-- USERPREMIUM
function vRP.userPremium(user_id)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local infoAccount = vRP.infoAccount(identity["steam"])
		if infoAccount and os.time() <= (infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
			return true
		end
	end

	return false
end

-- STEAMPREMIUM
function vRP.steamPremium(steam)
	local infoAccount = vRP.infoAccount(steam)
	if infoAccount then
		if os.time() <= (infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
			return true
		end
	end

	return false
end

-- PLAYERSPAWN
AddEventHandler("vRP:playerSpawn",function(user_id,source)
    local rentalVehicle = vRP.query("vRP/get_rental_time",{ user_id = user_id })
    if #rentalVehicle then 
        for k,v in pairs(rentalVehicle) do
            if v["rental_time"] ~= 0 and v["rental"] == 1 then
                if parseInt(os.time()) >= parseInt(v["rental_time"]+3*24*60*60) then
                    TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.vehicleName(v["vehicle"]).."</b> removido por falta de renovação.",20000)
                    vRP.query("vRP/rem_vehicle",{ user_id = parseInt(user_id), vehicle = v["vehicle"] })
                    goto remVIP
                end

                if parseInt(os.time()) >= v["rental_time"] then
                    TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.vehicleName(v["vehicle"]).."</b> vencido, efetue a renovação para não perde-lo.",30000)
                end
            end
        end
    end

    ::remVIP::
    local identity = vRP.getUserIdentity(user_id)
    if identity then
        local consult = vRP.getInfos(identity["steam"])
        if consult[1] then
            local daysRemove = consult[1]["predays"] + 3
            if parseInt(os.time()) >= (consult[1]["premium"] + 24 * daysRemove * 60 * 60) then
                exports["oxmysql"]:executeSync("UPDATE vrp_infos SET premiumType = ? WHERE steam = ?",{ '',identity["steam"] })
                TriggerClientEvent("Notify",source,"amarelo","Seus beneficios VIP foram removidos por falta de renovação.",30000)
                goto checkInsta
            end

            if parseInt(os.time()) >= (consult[1]["premium"] + 24 * consult[1]["predays"] * 60 * 60) then
                TriggerClientEvent("Notify",source,"amarelo","Seus beneficios VIP expiraram, efetue a renovação para não perde-lo.",30000)
            end
        end
    end

    ::checkInsta::
    -- local checkInsta = exports["oxmysql"]:executeSync("SELECT * FROM smartphone_instagram WHERE user_id = ?",{ user_id })
    -- if checkInsta[1] then
    --     local checkVerified = exports["oxmysql"]:executeSync("SELECT * FROM `instagram_verified` WHERE user_id = ?",{ user_id })
    --     if checkVerified[1] then
    --         if os.time() <= (checkVerified[1]["time"] + 24 * checkVerified[1]["predays"] * 60 * 60) then
    --             exports["oxmysql"]:executeSync("UPDATE `smartphone_instagram` SET verified = 1 WHERE user_id = ?",{ user_id })
    --         end
    --     end
    -- end
end)