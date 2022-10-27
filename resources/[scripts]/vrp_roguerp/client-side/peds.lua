-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local localPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local pedList = {
	{ -- Departament Store
		distance = 10,
		coords = { 24.9,-1346.8,29.49,269.3 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 2556.74,381.24,108.61,357.17 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1164.82,-323.65,69.2,96.38 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -706.15,-914.53,19.21,85.04 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -47.38,-1758.68,29.42,42.52 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 373.1,326.81,103.56,257.96 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { -3242.75,1000.46,12.82,354.34 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1728.47,6415.46,35.03,240.95 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1960.2,3740.68,32.33,297.64 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 2677.8,3280.04,55.23,331.66 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1697.31,4923.49,42.06,325.99 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { -1819.52,793.48,138.08,127.56 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 6,
		coords = { 1391.69,3605.97,34.98,198.43 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -2966.41,391.55,15.05,85.04 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -3039.54,584.79,7.9,14.18 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1134.33,-983.11,46.4,274.97 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 1165.28,2710.77,38.15,175.75 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -1486.72,-377.55,40.15,130.4 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -1221.45,-907.92,12.32,31.19 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 161.2,6641.66,31.69,223.94 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { 548.7,2670.73,42.16,96.38 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		distance = 10,
		coords = { -160.61,6320.88,31.58,314.65 },
		model = { 0x18CE57D0,"mp_m_shopkeep_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 1696.88,3758.39,34.69,133.23 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 248.17,-51.78,69.94,340.16 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 841.18,-1030.12,28.19,266.46 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -327.07,6082.22,31.46,130.4 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -659.18,-938.47,21.82,85.04 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -1309.43,-394.56,36.7,343.0 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -1113.41,2698.19,18.55,127.56 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 2564.83,297.46,108.73,269.3 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { -3168.32,1087.46,20.84,150.24 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 16.91,-1107.56,29.79,158.75 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		distance = 12,
		coords = { 814.84,-2155.14,29.62,357.17 },
		model = { 0x467415E9,"ig_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Premium Store
		distance = 20,
		coords = { -1083.15,-245.88,37.76,209.77 },
		model = { 0x2F8845A3,"ig_barry" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 30,
		coords = { -171.53,6386.55,31.49,133.23 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 30,
		coords = { 1690.07,3581.68,35.62,212.6 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 15,
		coords = { 326.5,-1074.43,29.47,0.0 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		distance = 15,
		coords = { 114.39,-4.85,67.82,204.1 },
		model = { 0x5244247D,"u_m_y_baygor" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central
		distance = 30,
		coords = { 46.67,-1749.79,29.62,48.19 },
		model = { 0xE6631195,"ig_cletus" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central
		distance = 30,
		coords = { 2747.29,3473.06,55.67,252.29 },
		model = { 0xE6631195,"ig_cletus" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling Sell
		distance = 15,
		coords = { -428.54,-1728.29,19.78,70.87 },
		model = { 0xEE75A00F,"s_m_y_garbage" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Bar
		distance = 15,
		coords = { 129.71,-1284.65,29.27,119.06 },
		model = { 0x780C01BD,"s_f_y_bartender_01" },
		anim = { "amb@prop_human_bum_shopping_cart@male@base","base" }
	},
	{ -- Bar
		distance = 15,
		coords = { -561.75,286.7,82.18,266.46 },
		model = { 0xE11A9FB4,"ig_josef" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Jewelry
		distance = 15,
		coords = { -622.25,-229.95,38.05,308.98 },
		model = { 0xC314F727,"cs_gurk" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Oxy Store
		distance = 30,
		coords = { -1636.74,-1092.17,13.08,320.32 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	--{ -- Moto Club
	--	distance = 12,
	--	coords = { 987.46,-95.61,74.85,226.78 },
	--	model = { 0x6CCFE08A,"ig_clay" },
	--	anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	--},
	{ -- Transportador
		distance = 30,
		coords = { 354.14,270.56,103.02,345.83 },
		model = { 0xE0FA2554,"ig_casey" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lenhador
		distance = 30,
		coords = { -840.64,5398.94,34.61,303.31 },
		model = { 0x1536D95A,"a_m_o_ktown_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lenhador
		distance = 30,
		coords = { -842.92,5403.49,34.61,300.48 },
		model = { 0x1C95CB0B,"u_m_m_markfost" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Minerador
		distance = 30,
		coords = { 2832.97,2797.6,57.46,99.22 },
		model = { 0xD7DA9E99,"s_m_y_construct_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mergulhador
		distance = 30,
		coords = { 2768.92,1391.19,24.53,82.21 },
		model = { 0xC79F6928,"a_f_y_beach_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Colheita
		distance = 30,
		coords = { 406.08,6526.17,27.75,87.88 },
		model = { 0x94562DD7,"a_m_m_farmer_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Jornaleiro
		distance = 30,
		coords = { -599.02,-933.59,23.86,87.88 },
		model = { 0x2A797197,"u_m_m_edtoh" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Motorista
		distance = 30,
		coords = { 452.97,-607.75,28.59,266.46 },
		model = { 0x2A797197,"u_m_m_edtoh" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lixeiro
		distance = 50,
		coords = { 82.98,-1553.55,29.59,51.03 },
		model = { 0xEE75A00F,"s_m_y_garbage" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		distance = 15,
		coords = { 73.96,-1393.01,29.37,274.97 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { 1324.38,-1650.09,52.27,127.56 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { -1152.27,-1423.81,4.95,124.73 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { 319.84,180.89,103.58,246.62 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { -3170.41,1073.06,20.83,334.49 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { 1862.58,3748.52,33.03,28.35 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		distance = 6,
		coords = { -292.02,6199.72,31.49,223.94 },
		model = { 0x1475B827,"a_f_y_hippie_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caminhoneiro
		distance = 30,
		coords = { 1239.87,-3257.2,7.09,274.97 },
		model = { 0x59511A6C,"s_m_m_trucker_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Taxista
		distance = 30,
		coords = { 894.9,-179.15,74.7,240.95 },
		model = { 0x24604B2B,"u_m_y_chip" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Piscineiro
		distance = 30,
		coords = { -1160.51,-228.72,37.94,318.06 },
		model = { 0x24604B2B,"u_m_y_chip" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja do Mergulhador
		distance = 50,
		coords = { 1522.7,3783.58,34.49,212.08},
		model = { 0x4A8E5536,"s_f_y_baywatch_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1112.46,228.33,-49.64,147.41 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1117.62,221.35,-49.44,65.2 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1117.24,220.07,-49.44,87.88 },
		model = { 0x1422D45B,"s_m_y_casino_01" },
		anim = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
		casino = "male"
	},
	{ -- Casino
		distance = 30,
		coords = { 1117.59,218.72,-49.44,107.72 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1111.85,209.98,-49.44,0.0 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1110.24,207.1,-49.44,127.56 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1113.6,207.06,-49.44,243.78 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" },
		casino = "female"
	},
	{ -- Casino - Loja de Roupas
		distance = 45,
		coords = { 1100.7,195.55,-49.44,317.49 },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1103.13,223.72,-49.0,323.15 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1096.98,216.23,-49.0,138.9 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 934.87,48.02,81.1,147.41 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 937.17,46.49,81.1,144.57 },
		model = { 0x35456A4,"ig_tomcasino" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Casino
		distance = 30,
		coords = { 1087.14,221.11,-49.2,181.42 },
		model = { 0xBC92BED5,"s_f_y_casino_01" },
		anim = { "anim@heists@prison_heiststation@cop_reactions","cop_b_idle" },
		casino = "female"
	},
	{ -- Casino
		distance = 30,
		coords = { 1088.6,221.11,-49.2,147.41 },
		model = { 0x1422D45B,"s_m_y_casino_01" },
		anim = { "anim@heists@prison_heiststation@cop_reactions","cop_b_idle" },
		casino = "male"
	},

	{ -- Feira
		distance = 6,
		coords = { -1253.58,-1444.63,4.38,29.26  },
		model = { 0x689C2A80,"a_f_y_epsilon_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},

	{ -- Pedreiro
		distance = 30,
		coords = {  -97.09,-1013.45,27.28,155.91  },
		model = { 0xD7DA9E99,"s_m_y_construct_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- COOLBEANS
		distance = 30,
		coords = { -1208.76,-1131.02,7.77,109.22 },
		model = { 0x0CE81655,"cs_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- COOLBEANS
		distance = 30,
		coords = { -1209.5,-1128.87,7.8,122.93 },
		model = { 0xD85E6D28,"s_m_m_movprem_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- CATCOFFE
		distance = 30,
		coords = { -573.1,-1071.67,22.33,182.08 },
		model = { 0x0CE81655,"cs_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- CATCOFFE
		distance = 30,
		coords = { -570.77,-1071.63,22.33,178.88 },
		model = { 0xD85E6D28,"s_m_m_movprem_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- PEARLS
		distance = 30,
		coords = { -1816.95,-1199.13,13.02,248.97 },
		model = { 0x0CE81655,"cs_dale" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- PEARLS
		distance = 30,
		coords = { -1818.0,-1200.99,13.02,248.97 },
		model = { 0xD85E6D28,"s_m_m_movprem_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(pedList) do
			local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
			if distance <= v["distance"] then
				if not IsPedInAnyVehicle(ped) then
					if localPeds[k] == nil then
						local mHash = GetHashKey(v["model"][2])

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							Citizen.Wait(1)
						end

						if HasModelLoaded(mHash) then
							localPeds[k] = CreatePed(4,v["model"][1],v["coords"][1],v["coords"][2],v["coords"][3] - 1,v["coords"][4],false,true)
							SetPedArmour(localPeds[k],100)
							SetEntityInvincible(localPeds[k],true)
							FreezeEntityPosition(localPeds[k],true)
							SetBlockingOfNonTemporaryEvents(localPeds[k],true)

							if v["casino"] then
								if v["casino"] == "male" then
									SetPedDefaultComponentVariation(localPeds[k])
									SetPedComponentVariation(localPeds[k],0,3,0,0)
									SetPedComponentVariation(localPeds[k],1,1,0,0)
									SetPedComponentVariation(localPeds[k],2,3,0,0)
									SetPedComponentVariation(localPeds[k],3,1,0,0)
									SetPedComponentVariation(localPeds[k],4,0,0,0)
									SetPedComponentVariation(localPeds[k],6,1,0,0)
									SetPedComponentVariation(localPeds[k],7,2,0,0)
									SetPedComponentVariation(localPeds[k],8,3,0,0)
									SetPedComponentVariation(localPeds[k],10,1,0,0)
									SetPedComponentVariation(localPeds[k],11,1,0,0)
								elseif v["casino"] == "female" then
									SetPedDefaultComponentVariation(localPeds[k])
									SetPedComponentVariation(localPeds[k],0,3,0,0)
									SetPedComponentVariation(localPeds[k],1,0,0,0)
									SetPedComponentVariation(localPeds[k],2,3,0,0)
									SetPedComponentVariation(localPeds[k],3,0,1,0)
									SetPedComponentVariation(localPeds[k],4,1,0,0)
									SetPedComponentVariation(localPeds[k],6,1,0,0)
									SetPedComponentVariation(localPeds[k],7,1,0,0)
									SetPedComponentVariation(localPeds[k],8,0,0,0)
									SetPedComponentVariation(localPeds[k],10,0,0,0)
									SetPedComponentVariation(localPeds[k],11,0,0,0)
									SetPedPropIndex(localPeds[k],1,0,0,false)
								end
							end

							SetModelAsNoLongerNeeded(mHash)

							if v["anim"][1] ~= nil then
								if v["anim"][1] == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
									TaskStartScenarioAtPosition(localPeds[k],"PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",v["coords"][1],v["coords"][2],v["coords"][3],v["coords"][4],-1,1,false)
								else
									RequestAnimDict(v["anim"][1])
									while not HasAnimDictLoaded(v["anim"][1]) do
										Citizen.Wait(1)
									end

									TaskPlayAnim(localPeds[k],v["anim"][1],v["anim"][2],8.0,0.0,-1,1,0,0,0,0)
								end
							end
						end
					end
				end
			else
				if localPeds[k] then
					DeleteEntity(localPeds[k])
					localPeds[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)