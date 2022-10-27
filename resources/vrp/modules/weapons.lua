function tvRP.updateWeapons(weapons)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.weaps = weapons
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
local weapon = {
	["List"] = {},
	["Ammo"] = {},
	["Holster"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD INSERT INIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)

	print('^3[!] ^0Criação de armas ^3iniciada^0')
	local selectAll = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_weapons`",{})
	for k,v in pairs(selectAll) do
		if v["available"] then

			weapon["List"][v["weapon"]] = {
				name = v["name"] or nil,
				ammo = v["ammo"] or nil,
				police = v["police"],
				holster = v["holster"],
                banned = v["banned"]
			}

            if v["ammo"] then
				if weapon["Ammo"][v["ammo"]] then
					table.insert(weapon["Ammo"][v["ammo"]],v["weapon"])
				else
					weapon["Ammo"][v["ammo"]] = {}
					table.insert(weapon["Ammo"][v["ammo"]],v["weapon"])
				end
            end

			if v["holster"] then
				table.insert(weapon["Holster"],v["weapon"])
			end
		end
	end
	print('^2[!] ^0Criação de armas ^2finalizada^0')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("updateweapon",function(source,args,rawCommand)
	if source ~= 0 then
		return
	end
	Wait(1000)

	print('^3[!] ^0Atualização de armas ^3iniciada^0')

	itemlist = {}
	local selectAll = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_weapons`",{})
	for k,v in pairs(selectAll) do
		if v["available"] then

			weapon["List"][v["weapon"]] = {
				name = v["name"] or nil,
				ammo = v["ammo"] or nil,
				police = v["police"],
				holster = v["holster"],
                banned = v["banned"]
			}

            if v["ammo"] then
				if weapon["Ammo"][v["ammo"]] then
					table.insert(weapon["Ammo"][v["ammo"]],v["weapon"])
				else
					weapon["Ammo"][v["ammo"]] = {}
					table.insert(weapon["Ammo"][v["ammo"]],v["weapon"])
				end
            end

			if v["holster"] then
				table.insert(weapon["Holster"],v["weapon"])
			end
		end
	end
	print('^2[!] ^0Atualização de armas ^2finalizada^0')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.weaponAmmo(weaponName)
	if weapon["List"][weaponName] then
		if weapon["List"][weaponName]["ammo"] then

			return weapon["List"][weaponName]["ammo"]
		end
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawned",function()
    local source = source
	TriggerClientEvent("weapons:insertInit",source,weapon)
end)