-----------------------------------------------------------------------------------------------------------------------------------------
-- IPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
local ipList = {
	{
		props = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		coords = { -1150.7,-1520.7,10.6 }
	},{
		props = {
			"csr_beforeMission",
			"csr_inMission"
		},
		coords = { -47.1,-1115.3,26.5 }
	},{
		props = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		coords = { -802.3,175.0,72.8 }
	},{
		props = {
            "bunker_style_b",
            "upgrade_bunker_set",
            "security_upgrade",
            "office_upgrade_set",
            "gun_wall_blocker",
            "gun_range_lights",
            "gun_locker_upgrade",
            "Gun_schematic_set"
		},
		coords = { 2623.802, 4649.49, -40.97773 }
	},{
		props = {
            "bunker_style_b",
            "upgrade_bunker_set",
            "security_upgrade",
            "office_upgrade_set",
            "gun_wall_blocker",
            "gun_range_lights",
            "gun_locker_upgrade",
            "Gun_schematic_set"
		},
		coords = { 115.5349, 2295.37, 26.91096 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADIPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	RequestIpl("vh_deco")  -- Decoração fora do Prédio ( Cadeiras de Rodas, Lixeira, Bancos ).
	RequestIpl("vh_flores") -- Flores que estão fora do prédio.
	RequestIpl("vh_heliponto") -- Heliponto acima do prédio.
	RequestIpl("pillbox_incost") -- Porta no Pillbox, impossibilitando entrar nele
	
	for _k,_v in pairs(ipList) do
		local interiorCoords = GetInteriorAtCoords(_v["coords"][1],_v["coords"][2],_v["coords"][3])
		LoadInterior(interiorCoords)

		if _v["props"] ~= nil then
			for k,v in pairs(_v["props"]) do
				EnableInteriorProp(interiorCoords,v)
				Wait(1)
			end
		end

		RefreshInterior(interiorCoords)
	end
end)