local userHolster = false
local weaponlist = {
	["List"] = {},
	["Ammo"] = {},
	["Holster"] = {}
}

local attachsList = {
	"COMPONENT_ADVANCEDRIFLE_CLIP_02",
	"COMPONENT_SPECIALCARBINE_MK2_CLIP_02",
	"COMPONENT_AT_SIGHTS",
	"COMPONENT_AT_SCOPE_MACRO_MK2",
	"COMPONENT_AT_SCOPE_MEDIUM_MK2",
	"COMPONENT_AT_SC_BARREL_02",
	"COMPONENT_AT_MUZZLE_01",
	"COMPONENT_AT_MUZZLE_02",
	"COMPONENT_AT_MUZZLE_03",
	"COMPONENT_AT_MUZZLE_04",
	"COMPONENT_AT_MUZZLE_05",
	"COMPONENT_AT_MUZZLE_06",
	"COMPONENT_AT_MUZZLE_07",
	"COMPONENT_AT_AR_AFGRIP_02",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_02",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_03",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_04",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_05",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_06",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_07",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_08",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_09",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_10",
	"COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01",
	"COMPONENT_VINTAGEPISTOL_CLIP_02",
	"COMPONENT_ASSAULTSMG_CLIP_02",
	"COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER",
	"COMPONENT_PISTOL50_CLIP_02",
	"COMPONENT_PISTOL50_VARMOD_LUXE",
	"COMPONENT_MARKSMANRIFLE_CLIP_02",
	"COMPONENT_AT_AR_FLSH",
	"COMPONENT_AT_AR_SUPP",
	"COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM",
	"COMPONENT_AT_AR_AFGRIP",
	"COMPONENT_MARKSMANRIFLE_VARMOD_LUXE",
	"COMPONENT_HEAVYPISTOL_CLIP_02",
	"COMPONENT_AT_PI_FLSH",
	"COMPONENT_AT_PI_SUPP",
	"COMPONENT_HEAVYPISTOL_VARMOD_LUXE",
	"COMPONENT_ASSAULTRIFLE_CLIP_02",
	"COMPONENT_ASSAULTRIFLE_CLIP_03",
	"COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
	"COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
	"COMPONENT_SPECIALCARBINE_CLIP_02",
	"COMPONENT_SPECIALCARBINE_CLIP_03",
	"COMPONENT_RAYPISTOL_VARMOD_XMAS18",
	"COMPONENT_GUSENBERG_CLIP_02",
	"COMPONENT_MICROSMG_CLIP_02",
	"COMPONENT_AT_AR_SUPP_02",
	"COMPONENT_AT_SCOPE_MACRO",
	"COMPONENT_MICROSMG_VARMOD_LUXE",
	"COMPONENT_MACHINEPISTOL_CLIP_02",
	"COMPONENT_MACHINEPISTOL_CLIP_03",
	"COMPONENT_COMBATPISTOL_CLIP_02",
	"COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
	"COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
	"COMPONENT_AT_AR_BARREL_02",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_02",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_03",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_04",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_05",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_06",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_07",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_08",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_09",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_10",
	"COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01",
	"COMPONENT_MINISMG_CLIP_02",
	"COMPONENT_HEAVYSHOTGUN_CLIP_02",
	"COMPONENT_HEAVYSHOTGUN_CLIP_03",
	"COMPONENT_HEAVYSNIPER_MK2_CLIP_02",
	"COMPONENT_MARKSMANRIFLE_MK2_CLIP_02",
	"COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2",
	"COMPONENT_AT_MRFL_BARREL_02",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_02",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_03",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_04",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_05",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_06",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_07",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_08",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_09",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_10",
	"COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01",
	"COMPONENT_APPISTOL_CLIP_02",
	"COMPONENT_APPISTOL_VARMOD_LUXE",
	"COMPONENT_AT_SR_SUPP_03",
	"COMPONENT_AT_MUZZLE_08",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_02",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_03",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_04",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_05",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_06",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_07",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_08",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_09",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_10",
	"COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01",
	"COMPONENT_SNSPISTOL_MK2_CLIP_02",
	"COMPONENT_AT_PI_RAIL_02",
	"COMPONENT_AT_PI_FLSH_03",
	"COMPONENT_AT_PI_COMP_02",
	"COMPONENT_SNSPISTOL_MK2_CAMO",
	"COMPONENT_SNSPISTOL_MK2_CAMO_02",
	"COMPONENT_SNSPISTOL_MK2_CAMO_03",
	"COMPONENT_SNSPISTOL_MK2_CAMO_04",
	"COMPONENT_SNSPISTOL_MK2_CAMO_05",
	"COMPONENT_SNSPISTOL_MK2_CAMO_06",
	"COMPONENT_SNSPISTOL_MK2_CAMO_07",
	"COMPONENT_SNSPISTOL_MK2_CAMO_08",
	"COMPONENT_SNSPISTOL_MK2_CAMO_09",
	"COMPONENT_SNSPISTOL_MK2_CAMO_10",
	"COMPONENT_SNSPISTOL_MK2_CAMO_IND_01",
	"COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE",
	"COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE",
	"COMPONENT_AT_SCOPE_MAX",
	"COMPONENT_SNIPERRIFLE_VARMOD_LUXE",
	"COMPONENT_PISTOL_CLIP_02",
	"COMPONENT_AT_PI_SUPP_02",
	"COMPONENT_PISTOL_VARMOD_LUXE",
	"COMPONENT_COMBATMG_CLIP_02",
	"COMPONENT_AT_SCOPE_MEDIUM",
	"COMPONENT_COMBATMG_VARMOD_LOWRIDER",
	"COMPONENT_SNSPISTOL_CLIP_02",
	"COMPONENT_SNSPISTOL_VARMOD_LOWRIDER",
	"COMPONENT_SMG_CLIP_02",
	"COMPONENT_SMG_CLIP_03",
	"COMPONENT_AT_SCOPE_MACRO_02",
	"COMPONENT_SMG_VARMOD_LUXE",
	"COMPONENT_COMBATPDW_CLIP_02",
	"COMPONENT_COMBATPDW_CLIP_03",
	"COMPONENT_CERAMICPISTOL_CLIP_02",
	"COMPONENT_CERAMICPISTOL_SUPP",
	"COMPONENT_ASSAULTSHOTGUN_CLIP_02",
	"COMPONENT_KNUCKLE_VARMOD_PIMP",
	"COMPONENT_KNUCKLE_VARMOD_BALLAS",
	"COMPONENT_KNUCKLE_VARMOD_DOLLAR",
	"COMPONENT_KNUCKLE_VARMOD_DIAMOND",
	"COMPONENT_KNUCKLE_VARMOD_HATE",
	"COMPONENT_KNUCKLE_VARMOD_LOVE",
	"COMPONENT_KNUCKLE_VARMOD_PLAYER",
	"COMPONENT_KNUCKLE_VARMOD_KING",
	"COMPONENT_KNUCKLE_VARMOD_VAGOS",
	"COMPONENT_PISTOL_MK2_CLIP_02",
	"COMPONENT_AT_PI_RAIL",
	"COMPONENT_AT_PI_FLSH_02",
	"COMPONENT_AT_PI_COMP",
	"COMPONENT_PISTOL_MK2_CAMO",
	"COMPONENT_PISTOL_MK2_CAMO_02",
	"COMPONENT_PISTOL_MK2_CAMO_03",
	"COMPONENT_PISTOL_MK2_CAMO_04",
	"COMPONENT_PISTOL_MK2_CAMO_05",
	"COMPONENT_PISTOL_MK2_CAMO_06",
	"COMPONENT_PISTOL_MK2_CAMO_07",
	"COMPONENT_PISTOL_MK2_CAMO_08",
	"COMPONENT_PISTOL_MK2_CAMO_09",
	"COMPONENT_PISTOL_MK2_CAMO_10",
	"COMPONENT_PISTOL_MK2_CAMO_IND_01",
	"COMPONENT_PISTOL_MK2_CAMO_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_02_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_03_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_04_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_05_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_06_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_07_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_08_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_09_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_10_SLIDE",
	"COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE",
	"COMPONENT_BULLPUPRIFLE_CLIP_02	",
	"COMPONENT_MILITARYRIFLE_CLIP_02",
	"COMPONENT_MILITARYRIFLE_SIGHT_01",
	"COMPONENT_COMPACTRIFLE_CLIP_02",
	"COMPONENT_COMPACTRIFLE_CLIP_03",
	"COMPONENT_CARBINERIFLE_MK2_CLIP_02",
	"COMPONENT_AT_CR_BARREL_02",
	"COMPONENT_CARBINERIFLE_MK2_CAMO",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_02",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_03",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_04",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_05",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_06",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_07",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_08",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_09",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_10",
	"COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01",
	"COMPONENT_CARBINERIFLE_VARMOD_LUXE",
	"COMPONENT_REVOLVER_VARMOD_BOSS",
	"COMPONENT_REVOLVER_VARMOD_GOON",
	"COMPONENT_SWITCHBLADE_VARMOD_VAR1",
	"COMPONENT_SWITCHBLADE_VARMOD_VAR2",
	"COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",
	"COMPONENT_AT_SCOPE_MACRO_02_MK2",
	"COMPONENT_AT_BP_BARREL_02",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_02",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_03",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_04",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_05",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_06",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_07",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_08",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_09",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_10",
	"COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01",
	"COMPONENT_CARBINERIFLE_CLIP_02",
	"COMPONENT_CARBINERIFLE_CLIP_03",
	"COMPONENT_AT_SCOPE_SMALL",
	"COMPONENT_AT_SR_SUPP",
	"COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER",
	"COMPONENT_SMG_MK2_CLIP_02",
	"COMPONENT_AT_SIGHTS_SMG",
	"COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
	"COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
	"COMPONENT_AT_SB_BARREL_02",
	"COMPONENT_SMG_MK2_CAM",
	"COMPONENT_SMG_MK2_CAMO_1",
	"COMPONENT_SMG_MK2_CAMO_IND_0",
	"COMPONENT_MG_CLIP_02",
	"COMPONENT_AT_SCOPE_SMALL_02",
	"COMPONENT_MG_VARMOD_LOWRIDER",
	"COMPONENT_AT_PI_COMP_03",
	"COMPONENT_REVOLVER_MK2_CAMO",
	"COMPONENT_REVOLVER_MK2_CAMO_02",
	"COMPONENT_REVOLVER_MK2_CAMO_03",
	"COMPONENT_REVOLVER_MK2_CAMO_04",
	"COMPONENT_REVOLVER_MK2_CAMO_05",
	"COMPONENT_REVOLVER_MK2_CAMO_06",
	"COMPONENT_REVOLVER_MK2_CAMO_07",
	"COMPONENT_REVOLVER_MK2_CAMO_08",
	"COMPONENT_REVOLVER_MK2_CAMO_09",
	"COMPONENT_REVOLVER_MK2_CAMO_10",
	"COMPONENT_REVOLVER_MK2_CAMO_IND_01",
	"COMPONENT_COMBATMG_MK2_CLIP_02",
	"COMPONENT_AT_SCOPE_SMALL_MK2",
	"COMPONENT_AT_MG_BARREL_02",
	"COMPONENT_COMBATMG_MK2_CAMO",
	"COMPONENT_COMBATMG_MK2_CAMO_02",
	"COMPONENT_COMBATMG_MK2_CAMO_03",
	"COMPONENT_COMBATMG_MK2_CAMO_04",
	"COMPONENT_COMBATMG_MK2_CAMO_05",
	"COMPONENT_COMBATMG_MK2_CAMO_06",
	"COMPONENT_COMBATMG_MK2_CAMO_07",
	"COMPONENT_COMBATMG_MK2_CAMO_08",
	"COMPONENT_COMBATMG_MK2_CAMO_09",
	"COMPONENT_COMBATMG_MK2_CAMO_10",
	"COMPONENT_COMBATMG_MK2_CAMO_IND_01",
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERT INIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("weapons:insertInit")
AddEventHandler("weapons:insertInit",function(weapList)
	weaponlist = weapList
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.updateWeapons()
	vRPS.updateWeapons(tvRP.getWeapons())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getWeapons()
	local ped = PlayerPedId()
	local weaponsUser = {}
	for k,v in pairs(weaponlist["List"]) do
		local weaponHash = GetHashKey(k)
		if HasPedGotWeapon(ped,weaponHash) then
			weaponsUser[k] = {}
			weaponsUser[k]["ammo"] = GetAmmoInPedWeapon(ped,weaponHash)

			
			weaponsUser[k]["components"] = {}
			for _k,_v in pairs(attachsList) do
				local componentHash = GetHashKey(_v)
				if HasPedGotWeaponComponent(ped,weaponHash,componentHash) then
					table.insert(weaponsUser[k]["components"],_v)
				end
			end

			weaponsUser[k]["color"] = GetPedWeaponTintIndex(ped,weaponHash)
		end
	end
	return weaponsUser
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPLACEWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.replaceWeapons()
	local old_weapons = tvRP.getWeapons()
	RemoveAllPedWeapons(PlayerPedId(),true)

	local weapons = {}
	for k,v in pairs(old_weapons) do
		if not weaponlist["List"][k]["police"] then
			async(function()
				weapons[k] = v
			end)
		end
	end
	return weapons
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.clearWeapons()
	RemoveAllPedWeapons(PlayerPedId(),true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.giveWeapons(weapons,clear_before)
	local ped = PlayerPedId()
	if clear_before then
		RemoveAllPedWeapons(ped,true)
	end

	for k,v in pairs(weapons) do
		GiveWeaponToPed(ped,GetHashKey(k),v["ammo"] or 0,false)
		
		if v["color"] then
			SetPedWeaponTintIndex(ped,GetHashKey(k),v["color"] or 0)
		end

		if v["components"] then
			for _,_v in pairs(v["components"]) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(_v))
			end
		end
	end

	vRPS.updateWeapons(tvRP.getWeapons())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGECHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.rechargeCheck(ammoType)
	local ped = PlayerPedId()
	if weaponlist["Ammo"][ammoType] then
		for k,v in pairs(weaponlist["Ammo"][ammoType]) do
			if HasPedGotWeapon(ped,v) then
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.rechargeWeapon(ammoType,ammoAmount)
	local ped = PlayerPedId()
	if weaponlist["Ammo"][ammoType] then
		for k,v in pairs(weaponlist["Ammo"][ammoType]) do
			if HasPedGotWeapon(ped,v) then
				AddAmmoToPed(ped,v,parseInt(ammoAmount))
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.weaponAttachs()
	local ped = PlayerPedId()
	if not IsPedArmed(ped,6) then
		return false
	end

	for k,v in pairs(weaponlist["List"]) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			for k2,v2 in pairs(v["components"]) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
			end
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOLSTER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 100
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 and not IsPedInAnyVehicle(ped) then
			if CheckWeapon(ped) then
				if not userHolster then
					timeDistance = 4
					if not IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then

                        local animDict = "rcmjosh4"
                        while not HasAnimDictLoaded(animDict) do
                            RequestAnimDict(animDict)
                            Wait(10)
                        end

						TaskPlayAnim(ped,"rcmjosh4","josh_leadout_cop2",3.0,2.0,-1,48,10,0,0,0)

						Wait(450)
						ClearPedTasks(ped)
					end
					userHolster = true
				end
			elseif not CheckWeapon(ped) then
				if userHolster then
					timeDistance = 4
					if not IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then

                        local animDict = "weapons@pistol@"
                        while not HasAnimDictLoaded(animDict) do
                            RequestAnimDict(animDict)
                            Wait(10)
                        end

						TaskPlayAnim(ped,"weapons@pistol@","aim_2_holster",3.0,2.0,-1,48,10,0,0,0)
						Wait(450)
						ClearPedTasks(ped)
					end
					userHolster = false
				end
			end
		end

		if GetEntityHealth(ped) <= 101 and holster then
			userHolster = false
			SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
		end
		Wait(timeDistance)
	end
end)

function CheckWeapon(ped)
	for i = 1,#weaponlist["Holster"] do
		if GetHashKey(weaponlist["Holster"][i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.putWeaponHands(weapon,ammo)
	tvRP.giveWeapons({[weapon] = { ammo = ammo }})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WCOMPONENTS
-----------------------------------------------------------------------------------------------------------------------------------------
local wComponents = {
	["WEAPON_PISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_HEAVYPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_PISTOL_MK2"] = {
		"COMPONENT_AT_PI_RAIL",
		"COMPONENT_AT_PI_FLSH_02",
		"COMPONENT_AT_PI_COMP"
	},
	["WEAPON_COMBATPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_APPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_MICROSMG"] = {
		"COMPONENT_AT_PI_FLSH",
		"COMPONENT_AT_SCOPE_MACRO"
	},
	["WEAPON_SMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02",
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTSMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_SUPP_02"
	},
	["WEAPON_COMBATPDW"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_AR_AFGRIP",
		"COMPONENT_AT_SCOPE_SMALL"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		"COMPONENT_AT_AR_FLSH"
	},
	["WEAPON_CARBINERIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_CARBINERIFLE_MK2"] = {
		"COMPONENT_AT_SIGHTS",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP_02",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_ASSAULTRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_MACHINEPISTOL"] = {
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		"COMPONENT_AT_AR_AFGRIP_02",
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SIGHTS",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_PISTOL50"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		"COMPONENT_AT_PI_FLSH_03",
		"COMPONENT_AT_PI_RAIL_02",
		"COMPONENT_AT_PI_COMP_02"
	},
	["WEAPON_SMG_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_BULLPUPRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_SMALL",
		"COMPONENT_AT_AR_SUPP"
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_SPECIALCARBINE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("attachs",function(source,args)
	local ped = PlayerPedId()
	for k,v in pairs(wComponents) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			for k2,v2 in pairs(v) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
			end
		end
	end
end)