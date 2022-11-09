local PremiumType = {
	["Diamond"] = { ["Name"] = "Diamond", ["Days"] = 999, ["Salary"] = 900, ["Prority"] = 80, ["Garage"] = 10, ["Item"] = { "carpass","vehiclesound,","keyplate","housekey","numberchange","rgchange","discount" } }
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
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasClass(user_id,class)
	local ConsultClass = vRP.query("vRP/get_class",{ id = user_id, class = tostring(class) })
	if ConsultClass[1] then
		return true
	else
		return false
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
			vRP.execute("vRP/update_priority",{ steam = identity.steam })
			if vRP.hasClass(user_id,"Gold") then
				vRP.execute("vRP/set_class",{ steam = identity.steam, class = nil})
			end
			if vRP.hasClass(user_id,"Silver") then
				vRP.execute("vRP/set_class",{ steam = identity.steam, class = nil})
			end
			if vRP.hasClass(user_id,"Bronze") then
				vRP.execute("vRP/set_class",{ steam = identity.steam, class = nil})
			end
		end
	end
end)