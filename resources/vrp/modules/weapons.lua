function tvRP.updateWeapons(Weapons)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local Datatable = vRP.getUserDataTable(user_id)
		if Datatable then
			Datatable["weaps"] = Weapons
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
local WeaponsList = {
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
	UpdateWeapon()
	print('^2[!] ^0Criação de armas ^2finalizada^0')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("updateweapon",function(source)
	if source ~= 0 then
		return
	end

	print('^3[!] ^0Criação de armas ^3iniciada^0')
	setupItemList()
	print('^2[!] ^0Criação de armas ^2finalizada^0')
end)

function UpdateWeapon()
	local selectAll = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_weapons`",{})
	for k,v in pairs(selectAll) do
		if v["available"] then

			WeaponsList["List"][v["weapon"]] = {
				name = v["name"] or nil,
				ammo = v["ammo"] or nil,
				police = v["police"],
				holster = v["holster"],
                banned = v["banned"]
			}

            if v["ammo"] then
				if WeaponsList["Ammo"][v["ammo"]] then
					table.insert(WeaponsList["Ammo"][v["ammo"]],v["weapon"])
				else
					WeaponsList["Ammo"][v["ammo"]] = {}
					table.insert(WeaponsList["Ammo"][v["ammo"]],v["weapon"])
				end
            end

			if v["holster"] then
				table.insert(WeaponsList["Holster"],v["weapon"])
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.weaponAmmo(weaponName)
	if WeaponsList["List"][weaponName] then
		if WeaponsList["List"][weaponName]["ammo"] then

			return WeaponsList["List"][weaponName]["ammo"]
		end
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawned",function()
    local source = source
	TriggerClientEvent("weapons:insertInit",source,WeaponsList)
end)