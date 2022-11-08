-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hiro = {}
Tunnel.bindInterface("doors",Hiro)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Doors"] = {
	[1] = { x = 441.25, y = -986.25, z = 30.78, hash = -96679321, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[2] = { x = 441.34, y = -977.74, z = 30.78, hash = -1406685646, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[3] = { x = 442.38, y = -998.57, z = 30.72, hash = -1547307588, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 4 },
	[4] = { x = 441.59, y = -998.8, z = 30.72, hash = -1547307588, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 3 },
	[5] = { x = 456.52, y = -972.63, z = 30.7, hash = -1547307588, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 6 },
	[6] = { x = 457.53, y = -972.09, z = 30.7, hash = -1547307588, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 5 },
	[7] = { x = 469.02, y = -1014.76, z = 26.4, hash = -692649124, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 8 },
	[8] = { x = 468.08, y = -1014.35, z = 26.42, hash = -692649124, lock = true, text = true, distance = 5, press = 2, perm = "Police", other = 7 },
	[10] = { x = 481.8, y = -1003.97, z = 26.32, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[11] = { x = 477.0, y = -1012.15, z = 26.32, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[12] = { x = 480.07, y = -1012.1, z = 26.32, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[13] = { x = 483.2, y = -1012.14, z = 26.32, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[14] = { x = 486.18, y = -1012.16, z = 26.32, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[15] = { x = 484.92, y = -1007.86, z = 26.32, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[16] = { x = 476.83, y = -1008.18, z = 26.27, hash = -53345114, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[17] = { x = 452.3, y = -1001.61, z = 26.81, hash = 2130672747, lock = true, text = true, distance = 10, press = 7, perm = "Police" },
	[18] = { x = 431.4, y = -1001.03, z = 26.75, hash = 2130672747, lock = true, text = true, distance = 10, press = 7, perm = "Police" },

	[24] = { x = 2507.77, y = 4096.95, z = 38.7, hash = 782767342, lock = true, text = true, distance = 5, press = 2, perm = "Municao02" },
	[25] = { x = 2521.11, y = 4123.62, z = 38.59, hash = 497665568, lock = true, text = true, distance = 7, press = 3, perm = "Municao02" },
	[26] = { x = 2519.77, y = 4107.36, z = 38.59, hash = -626684119, lock = true, text = true, distance = 5, press = 2, perm = "Municao02", other = 27 },
	[27] = { x = 2520.7, y = 4107.22, z = 38.59, hash = -626684119, lock = true, text = false, distance = 5, press = 2, perm = "Municao02", other = 26 },

	[29] = { x = 116.53, y = -1295.03, z = 29.27, hash = 390840000, lock = true, text = true, distance = 4, press = 2, perm = "Lavagem01" },
	[30] = { x = 113.53, y = -1297.02, z = 29.27, hash = 390840000, lock = true, text = true, distance = 4, press = 2, perm = "Lavagem01" },
	[31] = { x = 99.56, y = -1293.1, z = 29.27, hash = 390840000, lock = true, text = true, distance = 4, press = 2, perm = "Lavagem01" },
	[32] = { x = 95.58, y = -1285.14, z = 29.28, hash = 1695461688, lock = true, text = true, distance = 4, press = 2, perm = "Lavagem01" },

	[33] = { x = -580.99, y = -1069.38, z = 22.35, hash = 526179188, lock = true, text = true, distance = 5, press = 2, perm = "catCoffe", other = 34 },
	[34] = { x = -580.99, y = -1069.38, z = 22.35, hash = -69331849, lock = true, text = false, distance = 5, press = 2, perm = "catCoffe", other = 33 },
	[35] = { x = -601.01, y = -1055.92, z = 22.57, hash = 1099436502, lock = true, text = true, distance = 5, press = 2, perm = "catCoffe" },
	[36] = { x = -600.59, y = -1059.2, z = 22.53, hash = 522844070, lock = true, text = true, distance = 5, press = 2, perm = "catCoffe" },
	[38] = { x = -589.46, y = -1054.13, z = 22.37, hash = -60871655, lock = true, text = true, distance = 5, press = 2, perm = "catCoffe" },
	[39] = { x = -593.22, y = -1056.2, z = 22.37, hash = -60871655, lock = true, text = true, distance = 5, press = 2, perm = "catCoffe" },
	[40] = { x = -587.06, y = -1052.61, z = 22.35, hash = -1283712428, lock = true, text = true, distance = 5, press = 2, perm = "catCoffe" },
	
	[41] = { x = -772.07, y = -1205.7, z = 7.34, hash = -434783486, lock = true, text = true, distance = 5, press = 2, perm = "Paramedic", other = 42 },
	[42] = { x = -771.13, y = -1206.39, z = 7.34, hash = -1700911976, lock = true, text = false, distance = 5, press = 2, perm = "Paramedic", other = 41 }, 
	[43] = { x = -816.85, y = -1239.53, z = 7.34, hash = 854291622, lock = true, text = false, distance = 5, press = 2, perm = "Paramedic" },

	[44] = { x = 1846.049, y = 2604.733, z = 45.579, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Police" },
	[45] = { x = 1819.475, y = 2604.743, z = 45.577, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "Police" },
	[46] = { x = 1836.71, y = 2590.32, z = 46.20, hash = 539686410, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[47] = { x = 1769.52, y = 2498.92, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[48] = { x = 1766.34, y = 2497.09, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[49] = { x = 1763.20, y = 2495.26, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[50] = { x = 1756.89, y = 2491.66, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[51] = { x = 1753.75, y = 2489.85, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[52] = { x = 1750.61, y = 2488.02, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[53] = { x = 1757.14, y = 2474.87, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[54] = { x = 1760.26, y = 2476.71, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[55] = { x = 1763.44, y = 2478.50, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[56] = { x = 1766.54, y = 2480.33, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[57] = { x = 1769.73, y = 2482.13, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[58] = { x = 1772.83, y = 2483.97, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
	[59] = { x = 1776.00, y = 2485.77, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Police" },

	[60] = { x = -560.54, y = -234.61, z = 34.48, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Advogado" },	
	[61] = { x = -557.94, y = -233.11, z = 34.48, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "Advogado" },	
	[62] = { x = -562.68, y = -231.68, z = 34.38, hash = 1762042010, lock = true, text = true, distance = 5, press = 2, perm = "Advogado" },	
	[63] = { x = -568.55, y = -234.42, z = 34.36, hash = 830788581, lock = true, text = true, distance = 5, press = 2, perm = "Advogado", other = 64 },	
	[64] = { x = -567.48, y = -236.26, z = 34.36, hash = 297112647, lock = true, text = true, distance = 5, press = 2, perm = "Advogado", other = 63 },	

	[102] = { x = -1206.17, y = -1134.21, z = 7.84, hash = 1963114394, lock = true, text = true, distance = 5, press = 2, perm = "coolBeans", other = 103 },
	[103] = { x = -1206.13, y = -1133.77, z = 7.84, hash = 1963114394, lock = true, text = false, distance = 5, press = 2, perm = "coolBeans", other = 102 },
	[104] = { x = -1196.75, y = -1130.65, z = 7.84, hash = 1145438743, lock = true, text = true, distance = 5, press = 2, perm = "coolBeans", other = 105 },
	[105] = { x = -1196.65, y = -1130.08, z = 7.84, hash = 1145438743, lock = true, text = false, distance = 5, press = 2, perm = "coolBeans", other = 104 },
	[106] = { x = -1195.25, y = -1138.02, z = 7.84, hash = -470980178, lock = true, text = true, distance = 5, press = 2, perm = "coolBeans" },
	[107] = { x = -1196.49, y = -1140.35, z = 7.84, hash = -470980178, lock = true, text = true, distance = 5, press = 2, perm = "coolBeans" },
	[108] = { x = -1188.63, y = -1137.59, z = 7.84, hash = -470980178, lock = true, text = true, distance = 5, press = 2, perm = "coolBeans" },

	[109] = { x = 896.89, y = -2104.66, z = 34.89, hash = -88942360, lock = true, text = true, distance = 5, press = 2, perm = "Mechanic" },

	[110] = { x = 154.96, y = -3034.03, z = 8.04, hash = -456733639, lock = true, text = true, distance = 10, press = 4, perm = "Desmanche01" },
	[111] = { x = 155.39, y = -3024.29, z = 8.04, hash = -456733639, lock = true, text = true, distance = 10, press = 4, perm = "Desmanche01" },
	[112] = { x = 155.06, y = -3018.1, z = 7.05, hash = -2023754432, lock = true, text = true, distance = 5, press = 2, perm = "Desmanche01" },
	[113] = { x = 151.42, y = -3012.42, z = 7.24, hash = -1229046235, lock = true, text = true, distance = 5, press = 2, perm = "Desmanche01" },

	-- [114] = { x = 1406.89, y = 1128.49, z = 114.34, hash = 262671971, lock = true, text = true, distance = 5, press = 2, perm = "Lavagem03" },

	[126] = { x = -1558.63, y = -398.3, z = 41.99, hash = 1641308239, lock = true, text = true, distance = 5, press = 2, perm = "Municao01" },
	[127] = { x = -1568.06, y = -403.63, z = 42.39, hash = 657494824, lock = true, text = true, distance = 5, press = 2, perm = "Municao01" },
	[128] = { x = -1557.13, y = -382.97, z = 41.99, hash = -551608542, lock = true, text = true, distance = 5, press = 2, perm = "Municao01" },

	[129] = { x = -1387.58, y = -586.79, z = 30.32, hash = -131296141, lock = true, text = true, distance = 5, press = 2, perm = "Bahamas" },
	[130] = { x = -1388.63, y = -587.6, z = 30.32, hash = -131296141, lock = true, text = true, distance = 5, press = 2, perm = "Bahamas" },
	
	[131] = { x = -1816.59, y = -1194.7, z = 14.35, hash = 1994441020, lock = true, text = true, distance = 5, press = 2, perm = "Pearls", other = 132 },
	[132] = { x = -1817.22, y = -1194.17, z = 14.34, hash = -131296141, lock = true, text = false, distance = 5, press = 2, perm = "Pearls", other = 131 },
	[133] = { x = -1846.64, y = -1190.36, z = 14.34, hash = -1285189121, lock = true, text = true, distance = 5, press = 2, perm = "Pearls" },
	[134] = { x = -1817.18, y = -1193.87, z = 14.33, hash = 1994441020, lock = true, text = true, distance = 5, press = 2, perm = "Pearls" },
	[135] = { x = -1830.88, y = -1181.26, z = 14.33, hash = 1870406214, lock = true, text = true, distance = 5, press = 2, perm = "Pearls" },
	[136] = { x = -1842.25, y = -1198.38, z = 14.34, hash = 1994441020, lock = true, text = true, distance = 5, press = 2, perm = "Pearls" },
	[137] = { x = -1842.68, y = -1199.55, z = 14.31, hash = 1994441020, lock = true, text = true, distance = 5, press = 2, perm = "Pearls" },

	[138] = { x = -816.46, y = -178.2, z = 72.23, hash = 159994461, lock = true, text = true, distance = 5, press = 2, perm = "CasaBombeiros", other = 139 },
    [139] = { x = -816.46, y = -178.2, z = 72.23, hash = -1686014385, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros", other = 138 },
	[140] = { x = -795.65, y = 177.65, z = 72.84, hash = -1454760130, lock = true, text = true, distance = 5, press = 2, perm = "CasaBombeiros", other = 141 },
    [141] = { x = -795.65, y = 177.65, z = 72.84, hash = 1245831483, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros", other = 140 },
	[142] = { x = -793.72, y = 181.66, z = 72.84, hash = 1245831483, lock = true, text = true, distance = 5, press = 2, perm = "CasaBombeiros", other = 143 },
    [143] = { x = -793.72, y = 181.66, z = 72.84, hash = -1454760130, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros", other = 142 },
	[144] = { x = -803.3, y = 175.99, z = 76.75, hash = 1204471037, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros" },
	[145] = { x = -806.43, y = 173.34, z = 76.75, hash = -794543736, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros" },
	[146] = { x = -849.12, y = 178.65, z = 69.83, hash = -1568354151, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros" },
	[147] = { x = -844.05, y = 159.06, z = 66.8, hash = -2125423493, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros" },
	[148] = { x = -809.81, y = 177.46, z = 76.75, hash = -384976104, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros" },

	[149] = { x = -112.38, y = 986.24, z = 235.76, hash = -2146494197, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 168 },
	[168] = { x = -112.38, y = 986.24, z = 235.76, hash = -2146494197, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 149 },
	[150] = { x = -111.33, y = 999.19, z = 235.76, hash = -2146494197, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista" , other = 149 },
	[151] = { x = -98.31, y = 988.96, z = 235.76, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 152  },
	[152] = { x = -97.11, y = 989.66, z = 235.76, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 151 },
	[153] = { x = -105.43, y = 976.38, z = 235.76, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 153 },
	[154] = { x = -104.06, y = 976.94, z = 235.76, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 154 },
	[155] = { x = -66.92, y = 987.17, z = 234.4, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 155 },
	[156] = { x = -68.09, y = 988.01, z = 234.4, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 156 },
	[157] = { x = -111.87, y = 998.98, z = 235.76, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 158 },
	[158] = { x = -110.4, y = 999.32, z = 235.76, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 157 },
	[159] = { x = -71.31, y = 1009.36, z = 234.4, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 160 },
	[160] = { x = -70.23, y = 1008.29, z = 234.4, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 159 },
	[161] = { x = -62.49, y = 998.78, z = 234.41, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 162 },
	[162] = { x = -61.92, y = 998.23, z = 234.41, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 161 },

	[163] = { x = -815.25, y = 185.99, z = 72.48, hash = 30769481, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros" },
	[164] = { x = -102.41, y = 1010.77, z = 235.77, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 165 },
	[165] = { x = -102.74, y = 1011.88, z = 235.77, hash = -435821409, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 164 },
	[166] = { x = -61.84, y = 998.22, z = 234.41, hash = -2146494197, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 167 },
	[167] = { x = -62.53, y = 998.8, z = 234.41, hash = -2146494197, lock = true, text = false, distance = 5, press = 2, perm = "CasaSista", other = 166 },
    [169] = { x = 1250.73, y = -1583.26, z = 54.56, hash = -955445187, lock = true, text = false, distance = 5, press = 2, perm = "Municao02" },
	[170] = { x = 1252.62, y = -1568.84, z = 58.76, hash = -658590816, lock = true, text = false, distance = 5, press = 2, perm = "Municao02" },

	[171] = { x = -400.48, y = 4707.68, z = 264.75, hash = 1335309163, lock = true, text = false, distance = 5, press = 2, perm = "Admin" },

	[172] = { x = -816.44, y = 178.54, z = 72.23, hash = 159994461, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros", other = 173 },
	[173] = { x = -816.42, y = 177.98, z = 72.23, hash = -1686014385, lock = true, text = false, distance = 5, press = 2, perm = "CasaBombeiros", other = 172 },

	[175] = { x = 1400.0, y = 1128.31, z = 114.34, hash = -52575179, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 176 },
	[176] = { x = 1401.03, y = 1128.25, z = 114.34, hash = -1032171637, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 175 },
	[177] = { x = 1407.12, y = 1128.23, z = 114.34, hash = 262671971, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01" },
	[178] = { x = 1408.33, y = 1159.46, z = 114.34, hash = -1032171637, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 179 },
	[179] = { x = 1408.29, y = 1160.66, z = 114.34, hash = -52575179, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 178 },
	[180] = { x = 1408.33, y = 1164.31, z = 114.34, hash = -1032171637, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 181 },
	[181] = { x = 1408.2, y = 1165.25, z = 114.34, hash = -52575179, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 180 },
	[182] = { x = 1390.51, y = 1162.93, z = 114.34, hash = -52575179, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 183 },
	[183] = { x = 1390.21, y = 1161.88, z = 114.34, hash = -1032171637, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 182 },
	[184] = { x = 1395.79, y = 1142.2, z = 114.66, hash = 1504256620, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 185 },
	[185] = { x = 1395.88, y = 1141.36, z = 114.66, hash = 262671971, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 184 },
	[186] = { x = 1390.67, y = 1132.68, z = 114.34, hash = -52575179, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 187 },
	[187] = { x = 1390.64, y = 1131.81, z = 114.34, hash = -1032171637, lock = true, text = false, distance = 5, press = 2, perm = "Lavagem01", other = 186 },

	[188] = { x = 982.06, y = -125.15, z = 74.07, hash = -197537718, lock = true, text = false, distance = 5, press = 2, perm = "Municao03" },
	[189] = { x = 981.16, y = -103.25, z = 75.0, hash = 190770132, lock = true, text = false, distance = 5, press = 2, perm = "Municao03" },
	[190] = { x = -557.54, y = -232.7, z = 34.32, hash = 918828907, lock = true, text = false, distance = 5, press = 2, perm = "Advogado" },
	[191] = { x = -559.97, y = -234.29, z = 34.32, hash = 918828907, lock = true, text = false, distance = 5, press = 2, perm = "Advogado" }, 
	[192] = { x = -545.19, y = -203.15, z = 38.23, hash = 660342567, lock = true, text = false, distance = 5, press = 2, perm = "Advogado" , other = 193},
	[193] = { x = -545.81, y = -203.69, z = 38.22, hash = -1094765077, lock = true, text = false, distance = 5, press = 2, perm = "Advogado" , other = 192}
}
----------------------------------------------------------------------------------------------------------------------------------------- 
-- DOORSSTATISTICS
----------------------------------------------------------------------------------------------------------------------------------------- 
function Hiro.doorsStatistics(doorNumber,doorStatus)
	doorNumber = parseInt(doorNumber)

	local doors = GlobalState["Doors"]
	local secondDoor = doors[doorNumber].other
	if doors[doorNumber].exploded and doors[doorNumber].exploded > os.time() then
		local time = doors[doorNumber].exploded - os.time()
		TriggerClientEvent("Notify",source,"negado","Esta porta foi recentemente explodida! Aguarde <b>" .. time .. " segundos</b> para trancá-la novamente!")	
		return
	end
	if secondDoor and doors[secondDoor].exploded and doors[secondDoor].exploded > os.time() then
		local time = doors[secondDoor].exploded - os.time()
		TriggerClientEvent("Notify",source,"negado","Esta porta foi recentemente explodida! Aguarde <b>" .. time .. " segundos</b> para trancá-la novamente!")	
		return
	end

	doors[doorNumber].lock = doorStatus
	if secondDoor ~= nil then
		doors[secondDoor].lock = doorStatus
	end

	GlobalState["Doors"] = doors

	if not doors[doorNumber].noSound then
		TriggerClientEvent("sounds:Private", source, "doorlock", 0.1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("doors:doorsStatistics",function(doorNumber,doorStatus)
	doorNumber = parseInt(doorNumber)

	local doors = GlobalState["Doors"]
	doors[doorNumber].lock = doorStatus

	if doors[doorNumber].other ~= nil then
		local doorSecond = doors[doorNumber].other
		doors[doorSecond].lock = doorStatus
	end

	GlobalState["Doors"] = doors
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Hiro.doorsPermission(doorNumber)
	doorNumber = parseInt(doorNumber)

	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local doors = GlobalState["Doors"]
		local state = Player(source).state

		local permission = doors[doorNumber].perm
		if permission == "Police" then
			return permission == nil or (vRP.hasPermission(user_id, permission) or vRP.hasPermission(user_id, "wait" .. permission) or vRP.hasPermission(user_id, "action" .. permission) or vRP.hasRank(user_id,"Admin",40) )
		end
		return permission == nil or (vRP.hasPermission(user_id, permission) or vRP.hasPermission(user_id, "wait" .. permission) or vRP.hasRank(user_id,"Admin",40))
	end
	return false
end
